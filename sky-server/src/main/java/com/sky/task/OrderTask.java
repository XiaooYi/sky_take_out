package com.sky.task;

import com.sky.entity.Orders;
import com.sky.mapper.OrderMapper;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.weaver.ast.Or;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 自定义定时任务，实现订单状态定时处理
 */
@Component
@Slf4j
public class OrderTask {

    @Autowired
    private OrderMapper orderMapper;

    /**
     * 处理支付超时订单
     */
    @Scheduled(cron = "0 * * * * ?")
    public void processTimeoutOrder(){
        log.info("处理支付超时订单：{}",LocalDateTime.now());
        LocalDateTime orderTime = LocalDateTime.now().plusMinutes(-15);
        // 查询未付款且超过15分钟的订单
        List<Orders> ordersList = orderMapper.getByStatusAndOrdertimeLT(Orders.PENDING_PAYMENT,orderTime);
        // 更改订单的状态
        if(ordersList != null && ordersList.size() > 0){
            ordersList.forEach(orders -> {
                orders.setStatus(Orders.CANCELLED);
                orders.setCancelTime(LocalDateTime.now());
                orders.setCancelReason("支付超时，取消订单");
                // 更新订单
                orderMapper.update(orders);
        });
    }}

    /**
     * 处理派送中（用户已收货，但管理端还未显示完成）状态的订单
     */
    @Scheduled(cron = "0 55 14 * * ?")
    public void processDeliveryOrder(){
        log.info("处理\"派送中\"的订单:{}",LocalDateTime.now());
        LocalDateTime orderTime = LocalDateTime.now().plusMinutes(-60);
        // 查询配送时间超过1h的订单（用户已经收货，但管理端未完成订单）
        List<Orders> ordersList = orderMapper.getByStatusAndOrdertimeLT(Orders.DELIVERY_IN_PROGRESS,orderTime);
        // 更改订单的状态
        if(ordersList != null && ordersList.size() > 0){
            ordersList.forEach(orders -> {
                orders.setStatus(Orders.COMPLETED);
                orders.setCancelReason("订单已经完成");
                // 更新订单
                orderMapper.update(orders);
            });

    }}

}
