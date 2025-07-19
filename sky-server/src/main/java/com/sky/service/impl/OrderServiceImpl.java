package com.sky.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.sky.constant.MessageConstant;
import com.sky.context.BaseContext;
import com.sky.dto.*;
import com.sky.entity.*;
import com.sky.exception.OrderBusinessException;
import com.sky.exception.ShoppingCartBusinessException;
import com.sky.mapper.*;
import com.sky.result.PageResult;
import com.sky.service.OrderService;
import com.sky.utils.HttpClientUtil;
import com.sky.utils.WeChatPayUtil;
import com.sky.vo.*;
import com.sky.websocket.WebSocketServer;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.bridge.Message;
import org.aspectj.weaver.ast.Or;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;


@Service
@Slf4j
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private OrderDetailMapper orderDetailMapper;

    @Autowired
    private AddressBookMapper addressBookMapper;

    @Autowired
    private ShoppingCartMapper shoppingCartMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private WeChatPayUtil weChatPayUtil;

    @Autowired
    private HttpClientUtil httpClientUtil;

    @Autowired
    private WebSocketServer webSocketServer;


    // 注入商家地址和高德地图开发key
    @Value("${sky.shop.address}")
    private String shopAddress;

    @Value("${sky.gaode.Key}")
    private String Key;

    /**
     * 用户提交订单
     * @param ordersSubmitDTO
     * @return
     */
    @Override
    public OrderSubmitVO submitOrder(OrdersSubmitDTO ordersSubmitDTO) {
        // 异常情况的处理（收货地址为空、购物车为空）
        AddressBook addressBook = addressBookMapper.getById(ordersSubmitDTO.getAddressBookId());
        if(addressBook == null){
            throw new OrderBusinessException(MessageConstant.ADDRESS_BOOK_IS_NULL);
        }

        // 检查用户的收货地址是否超过配送范围
        checkOutOfRange(addressBook.getCityName() + addressBook.getDistrictName()
        + addressBook.getDetail());

        // 如果购物车为空，不能下单
        Long userId = BaseContext.getCurrentId();
        ShoppingCart shoppingCart = ShoppingCart.builder().userId(userId).build();
        List<ShoppingCart> cartList = shoppingCartMapper.list(shoppingCart);
        if(cartList == null || cartList.size() <= 0){
            throw new ShoppingCartBusinessException(MessageConstant.SHOPPING_CART_IS_NULL);
        }

        //构造订单数据
        Orders order = new Orders();
        BeanUtils.copyProperties(ordersSubmitDTO,order);
        order.setPhone(addressBook.getPhone());
        order.setAddress(addressBook.getDetail());
        order.setConsignee(addressBook.getConsignee());
        order.setNumber(String.valueOf(System.currentTimeMillis()));
        order.setUserId(userId);
        order.setStatus(Orders.PENDING_PAYMENT);
        order.setPayStatus(Orders.UN_PAID);
        order.setOrderTime(LocalDateTime.now());

        //向订单表插入1条数据
        orderMapper.insert(order);

        //订单明细数据
        Long orderId = order.getId();
        List<OrderDetail> orderDetailList = new ArrayList<>();
        for(ShoppingCart cart : cartList){
            OrderDetail orderDetail = new OrderDetail();
            BeanUtils.copyProperties(cart,orderDetail);
            orderDetail.setOrderId(orderId);
            orderDetailList.add(orderDetail);
        }
        //向明细表插入n条数据
        orderDetailMapper.insertBatch(orderDetailList);

        //清理购物车中的数据
        shoppingCartMapper.cleanShoppingCart(userId);

        //封装返回结果
        OrderSubmitVO orderSubmitVO = new OrderSubmitVO();
        orderSubmitVO.setId(orderId);
        orderSubmitVO.setOrderTime(order.getOrderTime());
        orderSubmitVO.setOrderAmount(order.getAmount());
        orderSubmitVO.setOrderNumber(order.getNumber());

        return orderSubmitVO;
    }

    /**
     * 订单支付
     *
     * @param ordersPaymentDTO
     * @return
     */
    public OrderPaymentVO payment(OrdersPaymentDTO ordersPaymentDTO) throws Exception {
        // 当前登录用户id
        Long userId = BaseContext.getCurrentId();
        User user = userMapper.getById(userId);

        //调用微信支付接口，生成预支付交易单
        /*JSONObject jsonObject = weChatPayUtil.pay(
                ordersPaymentDTO.getOrderNumber(), //商户订单号
                new BigDecimal(0.01), //支付金额，单位 元
                "苍穹外卖订单", //商品描述
                user.getOpenid() //微信用户的openid
        );

        if (jsonObject.getString("code") != null && jsonObject.getString("code").equals("ORDERPAID")) {
            throw new OrderBusinessException("该订单已支付");
        }*/

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code", "ORDERPAID");
        OrderPaymentVO vo = jsonObject.toJavaObject(OrderPaymentVO.class);
        vo.setPackageStr(jsonObject.getString("package"));

        //为替代微信支付成功后的数据库订单状态更新，多定义一个方法进行修改
        Integer OrderPaidStatus = Orders.PAID; //支付状态，已支付
        Integer OrderStatus = Orders.TO_BE_CONFIRMED;  //订单状态，待接单

        //发现没有将支付时间 check_out属性赋值，所以在这里更新
        LocalDateTime check_out_time = LocalDateTime.now();

        //获取订单号码
        String orderNumber = ordersPaymentDTO.getOrderNumber();

        log.info("调用updateStatus，用于替换微信支付更新数据库状态的问题");
        orderMapper.updateStatus(OrderStatus, OrderPaidStatus, check_out_time, orderNumber);

        return vo;
    }

    /**
     * 支付成功，修改订单状态
     *
     * @param outTradeNo
     */
    public void paySuccess(String outTradeNo) {
        // 当前登录用户id
        Long userId = BaseContext.getCurrentId();

        // 根据订单号查询当前用户的订单
        Orders ordersDB = orderMapper.getByNumberAndUserId(outTradeNo, userId);

        // 根据订单id更新订单的状态、支付方式、支付状态、结账时间
        Orders orders = Orders.builder()
                .id(ordersDB.getId())
                .status(Orders.TO_BE_CONFIRMED)
                .payStatus(Orders.PAID)
                .checkoutTime(LocalDateTime.now())
                .build();

        orderMapper.update(orders);

        ////////////////////////////////////////////////////////
        Map map = new HashMap();
        map.put("type",1); // 消息类型，1表示来单提醒
        map.put("orderId",orders.getId());
        map.put("content","订单号" + outTradeNo);
        webSocketServer.sendToAllClient(JSON.toJSONString(map));
        ////////////////////////////////////////////////////////
    }

    /**
     * 历史订单查询
     * @param page
     * @param pageSize
     * @param status
     * @return
     */
    @Override
    public PageResult getHistoryOrders(int page,int pageSize,Integer status) {
        // 设置分页查询参数
        PageHelper.startPage(page,pageSize);
        Long userId = BaseContext.getCurrentId();
        // 构造订单分页查询对象
        OrdersPageQueryDTO queryDTO = new OrdersPageQueryDTO();
        queryDTO.setUserId(userId);
        queryDTO.setStatus(status);

        // 执行查询
        List<Orders> ordersList = orderMapper.pageQuery(queryDTO);
        Page<Orders> pageList = (Page<Orders>) ordersList;

        // 声明订单vo集合对象
        List<OrderVO> orderVOList = new ArrayList<>();

        // 查询订单明细，并封装进orderVO进行响应
        for(Orders orders : pageList)
        {
            Long ordersId = orders.getId();
            // 查询订单明细
            List<OrderDetail> orderDetailList = orderDetailMapper.getByOrderId(ordersId);

            OrderVO orderVO = new OrderVO();
            BeanUtils.copyProperties(orders,orderVO);
            orderVO.setOrderDetailList(orderDetailList);

            orderVOList.add(orderVO);
        }
        return new PageResult(pageList.getTotal(),orderVOList);
    }

    /**
     * 根据订单id查询订单明细
     * @param id
     * @return
     */
    @Override
    public OrderVO getOrderDetailByOrderId(Long id) {
        // 查询订单
        Orders orders = orderMapper.getById(id);
        OrderVO orderVO = new OrderVO();
        BeanUtils.copyProperties(orders,orderVO);

        // 查询订单明细
        List<OrderDetail> orderDetailList = orderDetailMapper.getByOrderId(id);
        // 设置订单明细
        orderVO.setOrderDetailList(orderDetailList);
        return orderVO;

    }

    /**
     * 取消订单
     * @param id
     */
    @Override
    @Transactional
    public void userCancelById(Long id) throws Exception{
        // 根据id查询订单，校验订单是否存在
        Orders orders = orderMapper.getById(id);
        if(orders == null){
            throw new OrderBusinessException(MessageConstant.ORDER_NOT_FOUND);
        }
        // 如果订单状态大于2，也不能取消，订单状态 1待付款 2待接单 3已接单 4派送中 5已完成 6已取消
        if(orders.getStatus() > 2){
            throw new OrderBusinessException(MessageConstant.ORDER_STATUS_ERROR);
        }

        // 新建一个订单对象，用于更新数据库
        Orders ordersPar  = new Orders();
        ordersPar.setId(orders.getId());

        // 如果用户已经支付，需要退款
        if(orders.getPayStatus() == Orders.PAID){
            //                        weChatPayUtil.refund(orders.getNumber()
            //                        ,orders.getNumber()
            //                        ,orders.getAmount()
            //                        ,orders.getAmount());
            // 支付状态修改
            ordersPar.setPayStatus(Orders.REFUND);
        }
        // 如果用户未付款，设置取消原因,取消时间等信息
        ordersPar.setCancelTime(LocalDateTime.now());
        ordersPar.setCancelReason("用户取消");
        ordersPar.setStatus(Orders.CANCELLED);
        // 更新订单表
        orderMapper.update(ordersPar);

    }

    /**
     * 再来一单
     * @param id
     */
    @Override
    public void repetition(Long id) {
        // 查询订单明细信息
        List<OrderDetail> detailList = orderDetailMapper.getByOrderId(id);

        List<ShoppingCart> cartList = new ArrayList<>();
        // 加入购物车
        for(OrderDetail detail : detailList){
            ShoppingCart cart = new ShoppingCart();
            BeanUtils.copyProperties(detail,cart);
            cart.setUserId(BaseContext.getCurrentId());
            cart.setCreateTime(LocalDateTime.now());

            cartList.add(cart);
        }
        // 购物车批量新增数据
        shoppingCartMapper.insertBatch(cartList);
    }

    /**
     *
     * 以下是管理端模块
     *
     *
     */
    /**
     * 管理端--订单搜索
     * @param pageQueryDTO
     * @return
     */
    @Override
    public PageResult conditionSearch(OrdersPageQueryDTO pageQueryDTO) {
        // 设置分页参数
        int page = pageQueryDTO.getPage();
        int pageSize = pageQueryDTO.getPageSize();
        PageHelper.startPage(page,pageSize);

        // 查询订单信息
        List<Orders> ordersList = orderMapper.pageQuery(pageQueryDTO);
        Page<Orders> ordersPage = (Page<Orders>) ordersList;
        // 获取ordervolist返回
        List<OrderVO> orderVOList = getOrderVOList(ordersList);
        return new PageResult(ordersPage.getTotal(),orderVOList);

    }

    private List<OrderVO> getOrderVOList(List<Orders> ordersList){
        // 封装订单信息和订单包含的菜品，以OrderVO形式
        List<OrderVO> orderVOList = new ArrayList<>();
        for(Orders orders : ordersList){
            // 构造orderVO对象，并且赋值
            OrderVO orderVO = new OrderVO();
            BeanUtils.copyProperties(orders,orderVO);

            // 获取订单包含的菜品，字符串形式展示
            String orderDetailesStr = getOrderDetailesStr(orders);
            orderVO.setOrderDishes(orderDetailesStr);

            // 加入orderVO集合里面
            orderVOList.add(orderVO);
        }
        return orderVOList;
    }

    private String getOrderDetailesStr(Orders orders){
        // 查询订单菜品详情信息（订单中的菜品和数量）
        Long ordersId = orders.getId();
        List<OrderDetail> orderDetailList = orderDetailMapper.getByOrderId(ordersId);

        // 将每一条订单菜品信息拼接为字符串（格式：宫保鸡丁*3；）
        List<String> orderDishList = orderDetailList.stream().map(x -> {
            String orderDish = x.getName() + "*" + x.getNumber() + ";";
            return orderDish;
        }).collect(Collectors.toList());
        return String.join("",orderDishList);
    }

    /**
     * 管理端--商家接单
     * @param ordersConfirmDTO
     */
    @Override
    public void confirm(OrdersConfirmDTO ordersConfirmDTO) {
        Orders orders = orderMapper.getById(ordersConfirmDTO.getId());
        orders.setStatus(Orders.CONFIRMED);
        orderMapper.update(orders);
    }

    /**
     * 商家拒单
     * @param ordersRejectionDTO
     */
    @Override
    public void rejection(OrdersRejectionDTO ordersRejectionDTO) throws Exception {
        // 根据id查询对象
        Orders ordersDB = orderMapper.getById(ordersRejectionDTO.getId());
        //  订单只有存在且状态为2（待接单）才可以拒单
        if(ordersDB == null || ordersDB.getStatus() != Orders.TO_BE_CONFIRMED){
            throw new OrderBusinessException(MessageConstant.ORDER_STATUS_ERROR);
        }

        Orders orders = new Orders();
        orders.setId(ordersDB.getId());

        // 支付状态
        Integer payStatus = ordersDB.getPayStatus();
        if(payStatus == Orders.PAID){
            // 用户已经付款，需要退款
            //             weChatPayUtil.refund(
            //                    ordersDB.getNumber(),
            //                    ordersDB.getNumber(),
            //                    new BigDecimal(0.01),
            //                    new BigDecimal(0.01));
            log.info("商家退款");
            orders.setPayStatus(Orders.REFUND);
        }
        // 拒单需要退款，根据订单id更新订单状态、拒单原因、取消时间
        orders.setStatus(Orders.CANCELLED);
        orders.setRejectionReason(ordersRejectionDTO.getRejectionReason());
        orders.setCancelTime(LocalDateTime.now());
        orderMapper.update(orders);
    }

    /**
     * 各个状态的订单数量统计
     * @return
     */
    @Override
    public OrderStatisticsVO statistics() {
        // 查询待接单数量
        Integer toBeConfirmNum = orderMapper.countStatus(Orders.TO_BE_CONFIRMED);
        // 查询待派送数量
        Integer confirmNum = orderMapper.countStatus(Orders.CONFIRMED);
        // 查询派送中数量
        Integer deliveryInProgressNum = orderMapper.countStatus(Orders.DELIVERY_IN_PROGRESS);

        OrderStatisticsVO orderStatisticsVO = OrderStatisticsVO.builder()
                .toBeConfirmed(toBeConfirmNum)
                .confirmed(confirmNum)
                .deliveryInProgress(deliveryInProgressNum)
                .build();
        return orderStatisticsVO;
    }

    /**
     * 商家取消订单
     * @param ordersCancelDTO
     */
    @Override
    public void merchantCancel(OrdersCancelDTO ordersCancelDTO) throws Exception {

        // 根据id查询订单
        Orders ordersDB = orderMapper.getById(ordersCancelDTO.getId());

        // 新建orders对象，用于更新数据库
        Orders orders = new Orders();
        orders.setId(ordersDB.getId());

        // 支付状态
        Integer payStatus = ordersDB.getPayStatus();
        // 用户已经支付，需要退款
        if(payStatus == Orders.PAID){
            //            String refund = weChatPayUtil.refund(
            //                    ordersDB.getNumber(),
            //                    ordersDB.getNumber(),
            //                    new BigDecimal(0.01),
            //                    new BigDecimal(0.01));
            orders.setPayStatus(Orders.REFUND);
            log.info("商家退款了");
        }

        // 管理端取消订单需要退款，根据订单id更新订单状态、取消原因、取消时间
        orders.setId(ordersDB.getId());
        orders.setCancelTime(LocalDateTime.now());
        orders.setCancelReason(ordersCancelDTO.getCancelReason());
        orders.setStatus(Orders.CANCELLED);

        orderMapper.update(orders);
    }

    /**
     * 派送订单
     * @param id
     */
    @Override
    public void deliveryById(Long id) {
        Orders ordersDB = orderMapper.getById(id);
        // 校验订单是否存在，并且状态为3
        if(ordersDB == null || ordersDB.getStatus() != Orders.CONFIRMED){
            throw new OrderBusinessException(MessageConstant.ORDER_STATUS_ERROR);
        }

        Orders orders = new Orders();
        orders.setId(ordersDB.getId());
        // 更新订单状态,状态转为派送中
        orders.setStatus(Orders.DELIVERY_IN_PROGRESS);
        orderMapper.update(orders);
    }

    /**
     * 完成订单
     * @param id
     */
    @Override
    public void completeById(Long id) {
        // 根据id查询订单对象
        Orders ordersDB = orderMapper.getById(id);
        if(ordersDB == null || ordersDB.getStatus() != Orders.DELIVERY_IN_PROGRESS){
            throw new OrderBusinessException(MessageConstant.ORDER_STATUS_ERROR);
        }

        Orders orders = new Orders();
        orders.setId(ordersDB.getId());

        // 更新订单状态，状态转为完成
        orders.setStatus(Orders.COMPLETED);
        orders.setDeliveryTime(LocalDateTime.now());
        orderMapper.update(orders);
    }

    /**
     * 用户催单
     * @param id
     */
    @Override
    public void reminder(Long id) {
        // 查询订单是否存在
        Orders orders = orderMapper.getById(id);
        if(orders == null){
            throw new OrderBusinessException(MessageConstant.ORDER_NOT_FOUND);
        }

        // 使用websocket向客户端发送催单消息
        Map map = new HashMap();
        map.put("type",2); // 2表示用户催单
        map.put("orderId",orders.getId());
        map.put("content","订单号" + orders.getNumber());
        webSocketServer.sendToAllClient(JSON.toJSONString(map));

    }

    /**
     * 检查客户的收货地址是否超出配送范围
     * @param address
     */
    public void checkOutOfRange(String address){
        // 1. 获取店铺经纬度
        String shopCoordinate = getCoordinate(shopAddress);
        if (shopCoordinate == null) {
            throw new OrderBusinessException("店铺地址解析失败");
        }
        String[] shopLocation = shopCoordinate.split(",");
        double shopLng = Double.parseDouble(shopLocation[0]);
        double shopLat = Double.parseDouble(shopLocation[1]);
        log.info("店铺经纬度为：{}，{}",shopLng,shopLat);

        // 2. 获取用户地址经纬度
        String userCoordinate = getCoordinate(address);
        if (userCoordinate == null) {
            throw new OrderBusinessException("收货地址解析失败");
        }
        String[] userLocation = userCoordinate.split(",");
        double userLng = Double.parseDouble(userLocation[0]);
        double userLat = Double.parseDouble(userLocation[1]);

        // 3. 计算直线距离（单位：米）
        double distance = calculateDistance(shopLng, shopLat, userLng, userLat);

        // 4. 判断距离（示例设定5公里为配送范围）
        if (distance > 5000) {
            throw new OrderBusinessException("超出配送范围：距您" + (distance / 1000) + "公里");
        }
    }

    /**
     * 调用高德API获取地址的经纬度
     * @param address 需要解析的地址
     * @return 经纬度字符串（格式："经度,纬度"）
     */
    private String getCoordinate(String address) {
        Map<String, String> params = new HashMap<>();
        params.put("address", address);
        params.put("key", Key);

        try {
            String response = httpClientUtil.doGet("https://restapi.amap.com/v3/geocode/geo", params);
            JSONObject jsonObject = JSON.parseObject(response);

            if ("1".equals(jsonObject.getString("status"))) {
                return jsonObject.getJSONArray("geocodes")
                        .getJSONObject(0)
                        .getString("location");
            }
        } catch (Exception e) {
            log.error("地理编码API调用异常：{}", e.getMessage());
        }
        return null;
    }

    /**
     * 计算两个经纬度间的直线距离（Haversine公式）
     * @param lng1 点1经度
     * @param lat1 点1纬度
     * @param lng2 点2经度
     * @param lat2 点2纬度
     * @return 距离（米）
     */
    private double calculateDistance(double lng1, double lat1, double lng2, double lat2) {
        // 地球半径（米）
        final double R = 6371000;

        // 角度转弧度
        double radLat1 = Math.toRadians(lat1);
        double radLat2 = Math.toRadians(lat2);
        double deltaLat = Math.toRadians(lat2 - lat1);
        double deltaLng = Math.toRadians(lng2 - lng1);

        // Haversine公式
        double a = Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
                Math.cos(radLat1) * Math.cos(radLat2) *
                        Math.sin(deltaLng / 2) * Math.sin(deltaLng / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return R * c;
    }

}
