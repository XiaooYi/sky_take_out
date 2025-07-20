package com.sky.mapper;

import com.sky.dto.GoodsSalesDTO;
import org.apache.ibatis.annotations.Mapper;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Mapper
public interface ReportMapper {
    /**
     * 计算每天的营业额
     * @param map
     * @return
     */
    Double sumByDay(Map map);

    /**
     * 计算用户的数量
     * @param map
     * @return
     */
    Integer sumUser(Map map);

    /**
     * 计算订单数量
     * @param map
     * @return
     */
    Integer countOrders(Map map);

    /**
     * 查询销量排名top10接口
     * @param beginTime
     * @param endTime
     */
    List<GoodsSalesDTO> getSalesTop10(LocalDateTime beginTime, LocalDateTime endTime);
}
