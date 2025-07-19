package com.sky.mapper;

import org.apache.ibatis.annotations.Mapper;

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

}
