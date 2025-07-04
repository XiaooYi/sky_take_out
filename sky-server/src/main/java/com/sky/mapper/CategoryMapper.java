package com.sky.mapper;

import com.sky.annotation.AutoFill;
import com.sky.dto.CategoryPageQueryDTO;
import com.sky.entity.Category;
import com.sky.enumeration.OperationType;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CategoryMapper {

    @AutoFill(value = OperationType.INSERT)
    @Insert("insert into category(id, type, name, sort, status, create_time, update_time, create_user, update_user) "
    + "values(#{id},#{type},#{name},#{sort},#{status},#{createTime},#{updateTime},#{createUser},#{updateUser})")
    void add(Category category);

    List<Category> queryCategoryByPage(CategoryPageQueryDTO categoryPageQueryDTO);

    @Delete("delete from category where id = #{id}")
    void deleteById(Integer id);


    @AutoFill(value = OperationType.UPDATE)
    void update(Category category);

    List<Category> queryByType(Integer type);
}
