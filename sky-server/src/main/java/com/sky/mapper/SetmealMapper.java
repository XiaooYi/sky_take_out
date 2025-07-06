package com.sky.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface SetmealMapper {

    /**
     * 根据id查询与分类id相关的记录数
     * @param id
     * @return
     */
    @Select("select count(*) from setmeal where category_id = #{id}")
    Integer countById(Integer id);
}
