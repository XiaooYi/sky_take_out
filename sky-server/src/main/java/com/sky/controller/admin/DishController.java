package com.sky.controller.admin;

import com.sky.dto.DishDTO;
import com.sky.dto.DishPageQueryDTO;
import com.sky.entity.Dish;
import com.sky.result.PageResult;
import com.sky.result.Result;
import com.sky.service.DishService;
import com.sky.vo.DishVO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;


@RestController
@Slf4j
@RequestMapping("/admin/dish")
@Api(tags = "菜品相关接口")
public class DishController {

    @Autowired
    private DishService dishService;

    @Autowired
    private RedisTemplate redisTemplate;

    /**
     * 新增菜品
     * @param dishDTO
     * @return
     */
    @PostMapping
    @ApiOperation("新增菜品")
    public Result add(@RequestBody DishDTO dishDTO)
    {
        log.info("新增菜品:{}",dishDTO);
        dishService.savewithFlavor(dishDTO);

        // 清除当前菜品关联的缓存
        String key = "dish_" + dishDTO.getCategoryId();
        cleanCache(key);

        return Result.success();
    }


    @GetMapping("/page")
    @ApiOperation("分页查询")
    public Result pageQuery(DishPageQueryDTO dishPageQueryDTO)
    {
        log.info("菜品分页查询:{}",dishPageQueryDTO);
        PageResult pageResult = dishService.pageQuery(dishPageQueryDTO);
        return Result.success(pageResult);
    }

    @DeleteMapping
    @ApiOperation("删除菜品")
    public Result delBatch(@RequestParam List<Integer> ids)
    {
        log.info("删除菜品：{}",ids);
        dishService.delBatch(ids);
        // 将所有的菜品缓存数据清理掉，删除所有以dish_开头的key
        cleanCache("dish_*");
        return Result.success();
    }

    @GetMapping("/{id}")
    @ApiOperation("根据id查询菜品")
    public Result getById(@PathVariable Integer id)
    {
        log.info("根据id{}查询菜品",id);
        DishVO dishVO = dishService.getByIdwithFlavor(id);
        return Result.success(dishVO);
    }


    @GetMapping("/list")
    @ApiOperation("根据分类id查询菜品")
    public Result getByCategoryId(Long categoryId)
    {
        log.info("根据分类categoryId：{}查询菜品",categoryId);
        List<Dish> dishs = dishService.getByCategoryId(categoryId);
        return Result.success(dishs);
    }

    @PostMapping("/status/{status}")
    @ApiOperation("禁售、启售")
    public Result startOrStop(@PathVariable Integer status,Long id)
    {
        dishService.startOrStop(status,id);
        // 将所有的菜品缓存数据清理掉，删除所有以dish_开头的key
        cleanCache("dish_*");
        return Result.success();
    }

    @PutMapping
    @ApiOperation("修改菜品")
    public Result update(@RequestBody DishDTO dishDTO)
    {
        log.info("修改菜品:{}",dishDTO);
        dishService.updateDish(dishDTO);
        // 将所有的菜品缓存数据清理掉，删除所有以dish_开头的key
        cleanCache("dish_*");
        return Result.success();
    }

    private void cleanCache(String pattern){
        Set keys = redisTemplate.keys(pattern);
        redisTemplate.delete(keys);
    }

}

