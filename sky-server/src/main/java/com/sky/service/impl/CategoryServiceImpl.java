package com.sky.service.impl;


import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.sky.constant.MessageConstant;
import com.sky.constant.StatusConstant;
import com.sky.context.BaseContext;
import com.sky.dto.CategoryDTO;
import com.sky.dto.CategoryPageQueryDTO;
import com.sky.entity.Category;
import com.sky.exception.DeletionNotAllowedException;
import com.sky.mapper.CategoryMapper;
import com.sky.mapper.DishMapper;
import com.sky.mapper.SetmealMapper;
import com.sky.result.PageResult;
import com.sky.service.CategoryService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class CategoryServiceImpl implements CategoryService {

    @Autowired
    private CategoryMapper categoryMapper;

    @Autowired
    private DishMapper dishMapper;

    @Autowired
    private SetmealMapper setmealMapper;

    /**
     * 新增分类
     * @param categoryDTO
     */
    @Override
    public void add(CategoryDTO categoryDTO) {
        Category category = new Category();
        BeanUtils.copyProperties(categoryDTO,category);
        category.setStatus(StatusConstant.DISABLE);
//        category.setCreateTime(LocalDateTime.now());
//        category.setUpdateTime(LocalDateTime.now());
//        category.setCreateUser(BaseContext.getCurrentId());
//        category.setUpdateUser(BaseContext.getCurrentId());
        categoryMapper.add(category);
    }

    /**
     * 分类分页查询
     * @param categoryPageQueryDTO
     * @return
     */
    @Override
    public PageResult queryCategoryByPage(CategoryPageQueryDTO categoryPageQueryDTO) {
        int page = categoryPageQueryDTO.getPage();
        int pageSize = categoryPageQueryDTO.getPageSize();
        // 设置分页参数
        PageHelper.startPage(page,pageSize);

        // 执行查询
        List<Category> category = categoryMapper.queryCategoryByPage(categoryPageQueryDTO);
        Page<Category> categoryPage = (Page<Category>) category;

        // 封装PageResult对象
        PageResult result = new PageResult(categoryPage.getTotal(),categoryPage.getResult());
        return result;
    }

    /**
     * 根据id删除分类
     * @param id
     */
    @Override
    public void deleteById(Integer id) {
        // 判断当前分类id是否关联了菜品和套餐信息
        Integer count = dishMapper.countById(id);
        if(count > 0)
        {
            throw new DeletionNotAllowedException(MessageConstant.CATEGORY_BE_RELATED_BY_DISH);
        }
        count = setmealMapper.countById(id);
        if(count > 0)
        {
            throw new DeletionNotAllowedException(MessageConstant.CATEGORY_BE_RELATED_BY_SETMEAL);
        }
        categoryMapper.deleteById(id);
    }

    @Override
    public void updateCategory(CategoryDTO categoryDTO) {
        Category category = new Category();
        BeanUtils.copyProperties(categoryDTO,category);
//        category.setUpdateTime(LocalDateTime.now());
//        category.setUpdateUser(BaseContext.getCurrentId());
        categoryMapper.update(category);
    }

    @Override
    public void startOrStop(Integer status, Long id) {
        Category category = Category.builder()
                        .status(status)
                        .id(id).
                        build();
        categoryMapper.update(category);
    }

    @Override
    public List<Category> queryByType(Integer type) {
        return categoryMapper.queryByType(type);
    }


}
