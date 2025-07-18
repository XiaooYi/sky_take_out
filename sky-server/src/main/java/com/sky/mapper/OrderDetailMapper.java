package com.sky.mapper;

import com.sky.entity.OrderDetail;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface OrderDetailMapper {
    /**
     * 向订单明细表批量插入数
     * @param orderDetailList
     */
    void insertBatch(List<OrderDetail> orderDetailList);

    /**
     * 根据订单id查询订单明细表
     * @param ordersId
     * @return
     */
    @Select("select * from order_detail where order_id = #{ordersId}" )
    List<OrderDetail> getByOrderId(Long ordersId);

    /**
     * 根据订单id删除订单明细数据
     * @param id
     */
    @Delete("delete from order_detail where order_id = #{id}")
    void deleteByOrderId(Long id);
}
