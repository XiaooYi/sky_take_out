package com.sky.mapper;

import com.sky.annotation.AutoFill;
import com.sky.dto.DishPageQueryDTO;
import com.sky.entity.Dish;
import com.sky.enumeration.OperationType;
import com.sky.vo.DishVO;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface DishMapper {

    /**
     * 根据id查询和分类id相关的记录数
     * @param id
     * @return
     */
    @Select("select count(*) from dish where category_id = #{id}")
    Integer countById(Integer id);

    /**
     * 新增菜品
     * @param dish
     */
    @AutoFill(value = OperationType.INSERT)
    @Options(useGeneratedKeys = true,keyProperty = "id") // 会自动将生成的主键值，赋值给emp对象的id属性
    @Insert("insert into dish(name, category_id, price, image, description, status, create_time, update_time, create_user, update_user)"
            + "values (#{name},#{categoryId},#{price},#{image},#{description},#{status},#{createTime},#{updateTime},#{createUser},#{updateUser})"
    )
    void insert(Dish dish);

    /**
     * 菜品分页查询
     * @param dishPageQueryDTO
     * @return
     */
    List<DishVO> pageQuery(DishPageQueryDTO dishPageQueryDTO);

    /**
     * 根据id查询菜品对象
     * @param id
     * @return
     */
    @Select("select * from dish where id = #{id}")
    Dish queryById(Integer id);

    /**
     * 根据id查询菜品对象
     * @param id
     * @return
     */
    @Select("select * from dish where id = #{id}")
    Dish queryByIdIsLong(Long id);

    //    /**
    //     * 根据id删除菜品
    //     * @param id
    //     */
    //    @Delete("delete from dish where id = #{id}")
    //    void deleteById(Integer id);

    /**
     * 根据id集合批量删除菜品
     * @param ids
     */
    void deleteByIds(List<Integer> ids);

    /**
     * 修改菜品表
     * @param dish
     */
    @AutoFill(value = OperationType.UPDATE)
    void update(Dish dish);

    /**
     * 根据分类id查询菜品
     * @param categoryId
     * @return
     */
    @Select("select * from dish where category_id = #{categoryId}")
    List<Dish> getByCategoryId(Long categoryId);

    /**
     * 根据套餐id获取菜品数据
     * @param id
     * @return
     */
    @Select("select a.* from dish a left join setmeal_dish b on a.id = b.dish_id where b.setmeal_id = #{id}")
    List<Dish> getBySetmealId(Long id);
}
