package com.sky.mapper;

import com.sky.entity.SetmealDish;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface SetmealDishMapper {

    /**
     * 根据dishId查询套餐
     * @param id
     * @return
     */
    @Select("select * from setmeal_dish where dish_id = #{id}")
    SetmealDish queryByDishId(Integer id);

    /**
     * 根据dishId获取setmealId
     * @param id
     * @return
     */
    @Select("select setmeal_id from setmeal_dish where dish_id = #{id}")
    List<Long> getSetmealIdByDishId(Long id);
}
