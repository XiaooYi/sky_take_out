package com.sky.mapper;


import com.sky.dto.OrdersPageQueryDTO;
import com.sky.entity.Orders;
import com.sky.vo.OrderVO;
import org.apache.ibatis.annotations.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Mapper
public interface OrderMapper {
    /**
     * 向订单表插入数据
     * @param order
     */
    void insert(Orders order);

    /**
     * 根据订单号和用户id查询订单
     * @param orderNumber
     * @param userId
     */
    @Select("select * from orders where number = #{orderNumber} and user_id= #{userId}")
    Orders getByNumberAndUserId(String orderNumber, Long userId);

    /**
     * 修改订单信息
     * @param orders
     */
    void update(Orders orders);

    /**
     * 用于替换微信支付更新数据库状态的问题
     * @param orderStatus
     * @param orderPaidStatus
     */
    @Update("update orders set status = #{orderStatus},pay_status = #{orderPaidStatus} ,checkout_time = #{check_out_time} " +
            "where number = #{orderNumber}")
    void updateStatus(Integer orderStatus, Integer orderPaidStatus, LocalDateTime check_out_time, String orderNumber);


    /**
     * 根据订单分页dto查询订单数据
     * @param queryDTO
     * @return
     */
    @Options(useGeneratedKeys = true,keyProperty = "ids")
    List<Orders> pageQuery(OrdersPageQueryDTO queryDTO);

    /**
     * 根据id查询订单信息
     * @param id
     * @return
     */
    @Select("select * from orders where id = #{id}")
    Orders getById(Long id);

    /**
     * 根据id删除订单信息
     * @param id
     */
    @Delete("delete from orders where id = #{id}")
    void deleteById(Long id);


    /**
     * 根据订单状态查询订单数量
     * @param deliveryInProgress
     * @return
     */
    @Select("select count(id) from orders where status = #{status}")
    Integer countStatus(Integer deliveryInProgress);

    /**
     * 根据状态和下单时间查询订单
     * @param status
     * @param orderTime
     * @return
     */
    @Select("select * from orders where status = #{status} and order_time < #{orderTime}")
    List<Orders> getByStatusAndOrdertimeLT(Integer status,LocalDateTime orderTime);

    /**
     * 查询总订单数
     * @param map
     * @return
     */
    Integer countByMap(@Param("map") Map map);

    /**
     * 统计营业额
     * @param map
     * @return
     */
    Double sumByMap(@Param("map")Map map);
}
