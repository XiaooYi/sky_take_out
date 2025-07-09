package com.sky.mapper;

import com.sky.entity.SetmealDish;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface SetmealDishMapper {

    /**
     * 根据dishId查询套餐菜品关系表
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

    /**
     * 根据setmealId获取dishIds
     * @param id
     * @return
     */
    @Select("select dish_id from setmeal_dish where setmeal_id = #{id}")
    List<Long> getDishIdsBySetmealId(Long id);

    /**
     * 套餐菜品关系表批量新增数据
     * @param setmealDishs
     */
    void insertBatch(List<SetmealDish> setmealDishs);

    /**
     * 根据套餐ids批量删除套餐菜品关系表的数据
     * @param ids
     */
    void deleteBatchBySetmealIds(List<Long> ids);

    /**
     * 根据套餐id查询套餐关系表的数据
     * @param id
     * @return
     */
    @Select("select * from setmeal_dish where setmeal_id = #{id}")
    List<SetmealDish> getBySetmealId(Long id);

}
