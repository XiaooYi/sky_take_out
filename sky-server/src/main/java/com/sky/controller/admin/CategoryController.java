package com.sky.controller.admin;


import com.sky.dto.CategoryDTO;
import com.sky.dto.CategoryPageQueryDTO;
import com.sky.entity.Category;
import com.sky.result.PageResult;
import com.sky.result.Result;
import com.sky.service.CategoryService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.models.auth.In;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 分类管理
 */
@RestController
@Slf4j
@RequestMapping("/admin/category")
@Api(tags = "分类相关接口")
public class CategoryController {
    @Autowired
    private CategoryService categoryService;


    /**
     * 新增分类
     * @param categoryDTO
     * @return
     */
    @PostMapping
    @ApiOperation("新增分类")
    public Result add(@RequestBody CategoryDTO categoryDTO)
    {
        log.info("新增分类：{}",categoryDTO);
        categoryService.add(categoryDTO);
        return Result.success();
    }

    @GetMapping("/page")
    @ApiOperation("分类分页查询")
    public Result<PageResult> queryCategoryByPage(CategoryPageQueryDTO categoryPageQueryDTO)
    {
        log.info("开始分页查询:{}",categoryPageQueryDTO);
        PageResult pageResult = categoryService.queryCategoryByPage(categoryPageQueryDTO);
        return Result.success(pageResult);
    }

    @DeleteMapping
    @ApiOperation("根据id删除分类")
    public Result deleteById(Integer id)
    {
        log.info("根据id：{}删除分类",id);
        categoryService.deleteById(id);
        return Result.success();
    }

    @PutMapping
    @ApiOperation("修改分类")
    public Result updateCategory(@RequestBody CategoryDTO categoryDTO)
    {
        log.info("修改分类:{} ",categoryDTO);
        categoryService.updateCategory(categoryDTO);
        return Result.success();
    }

    @PostMapping("/status/{status}")
    @ApiOperation("启用、禁用分类")
    public Result startOrStop(@PathVariable Integer status,Long id)
    {
        log.info("启用或者禁用分类status:{},id:{}",status,id);
        categoryService.startOrStop(status,id);
        return Result.success();
    }

    @GetMapping("/list")
    @ApiOperation("根据类型查询分类")
    // TODO 这个接口前端貌似没有使用到，前端使用的是分页查询的接口
    public Result queryByType(Integer type)
    {
        List<Category> category = categoryService.queryByType(type);
        return Result.success(category);
    }
}
