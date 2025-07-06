package com.sky.mapper;

import com.sky.entity.DishFlavor;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface DishFlavorMapper {


    /**
     * 新增口味
     * @param dishFlavor
     */
    void insert(DishFlavor dishFlavor);

    /**
     * 根据id删除口味
     * @param dishId
     */
    @Delete("delete from dish_flavor where dish_id = #{dishId}")
    void deleteById(Long dishId);

    /**
     * 根据菜品id集合批量删除口味数据
     * @param ids
     */
    void deleteByDishIds(List<Integer> ids);

    /**
     * 修改口味
     * @param dishFlavor
     */
    void update(DishFlavor dishFlavor);

    /**
     * 根据dishId查询口味
     * @param id
     * @return
     */
    @Select("select * from dish_flavor where dish_id = #{id}")
    List<DishFlavor> queryByDishId(Integer id);
}
