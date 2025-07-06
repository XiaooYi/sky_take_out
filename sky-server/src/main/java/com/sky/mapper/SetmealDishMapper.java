package com.sky.mapper;

import com.sky.entity.SetmealDish;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface SetmealDishMapper {

    /**
     * 根据dishId查询套餐
     * @param id
     * @return
     */
    @Select("select * from setmeal_dish where dish_id = #{id}")
    SetmealDish queryByDishId(Integer id);
}
