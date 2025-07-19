package com.sky.service;

import com.sky.dto.*;
import com.sky.result.PageResult;
import com.sky.vo.*;

/**
 * 用户订单模块
 */
public interface OrderService {
    /**
     * 用户提交订单
     * @param ordersSubmitDTO
     * @return
     */
    OrderSubmitVO submitOrder(OrdersSubmitDTO ordersSubmitDTO);

    /**
     * 订单支付
     * @param ordersPaymentDTO
     * @return
     */
    OrderPaymentVO payment(OrdersPaymentDTO ordersPaymentDTO) throws Exception;

    /**
     * 支付成功，修改订单状态
     * @param outTradeNo
     */
    void paySuccess(String outTradeNo);

    /**
     * 历史订单查询
     * @param page
     * @param pageSize
     * @param status
     * @return
     */
    PageResult getHistoryOrders(int page,int pageSize,Integer status);

    /**
     * 根据订单id查询订单明细
     * @param id
     * @return
     */
    OrderVO getOrderDetailByOrderId(Long id);

    /**
     * 取消订单
     * @param id
     */
    void userCancelById(Long id) throws Exception;

    /**
     * 用户再来一单
     * @param id
     */
    void repetition(Long id);

    /**
     * 管理端--订单搜索
     * @param pageQueryDTO
     * @return
     */
    PageResult conditionSearch(OrdersPageQueryDTO pageQueryDTO);

    /**
     *  管理端--商家接单
     * @param ordersConfirmDTO
     */
    void confirm(OrdersConfirmDTO ordersConfirmDTO);

    /**
     *  管理端--商家拒单
     * @param ordersRejectionDTO
     */
    void rejection(OrdersRejectionDTO ordersRejectionDTO) throws Exception;

    /**
     *  管理端--各个状态的订单数量统计
     * @return
     */
    OrderStatisticsVO statistics();

    /**
     *  管理端--商家取消订单
     * @param ordersCancelDTO
     */
    void merchantCancel(OrdersCancelDTO ordersCancelDTO) throws Exception;

    /**
     * 派送订单
     * @param id
     */
    void deliveryById(Long id);

    /**
     * 完成订单
     * @param id
     */
    void completeById(Long id);

    /**
     * 用户催单
     * @param id
     */
    void reminder(Long id);
}
