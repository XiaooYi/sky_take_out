package com.sky.service;

import com.sky.dto.CategoryDTO;
import com.sky.dto.CategoryPageQueryDTO;
import com.sky.entity.Category;
import com.sky.result.PageResult;
import java.util.List;

public interface CategoryService {
    /**
     * 新增分类
     * @param categoryDTO
     */
    void add(CategoryDTO categoryDTO);

    /**
     * 分类分页查询
     * @param categoryPageQueryDTO
     * @return
     */
    PageResult queryCategoryByPage(CategoryPageQueryDTO categoryPageQueryDTO);

    void deleteById(Integer id);

    void updateCategory(CategoryDTO categoryDTO);

    void startOrStop(Integer status, Long id);

    List<Category> queryByType(Integer type);
}
