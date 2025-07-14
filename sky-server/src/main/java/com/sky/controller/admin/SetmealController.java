package com.sky.controller.admin;


import com.sky.constant.StatusConstant;
import com.sky.dto.SetmealDTO;
import com.sky.dto.SetmealPageQueryDTO;
import com.sky.entity.Setmeal;
import com.sky.result.PageResult;
import com.sky.result.Result;
import com.sky.service.SetmealService;
import com.sky.vo.DishItemVO;
import com.sky.vo.SetmealVO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Slf4j
@RequestMapping("/admin/setmeal")
@Api(tags = "套餐相关接口")
public class SetmealController {

    @Autowired
    private SetmealService setmealService;

    /**
     * 套餐的分页查询
     * @param queryDTO
     * @return
     */
    @GetMapping("/page")
    @ApiOperation("分页查询")
    public Result queryByPage(SetmealPageQueryDTO queryDTO)
    {
        log.info("套餐分页查询：{}",queryDTO);
        PageResult result = setmealService.queryByPage(queryDTO);
        return Result.success(result);
    }

    /**
     * 新增套餐
     * @param setmealDTO
     * @return
     */
    @PostMapping
    @ApiOperation("新增套餐")
    public Result add(@RequestBody SetmealDTO setmealDTO)
    {
        log.info("新增套餐：{}",setmealDTO);
        setmealService.saveWithDish(setmealDTO);
        return Result.success();
    }

    /**
     * 批量删除套餐
     * @param ids
     * @return
     */
    @DeleteMapping
    @ApiOperation(value = "删除套餐")
    // 集合参数，需要使用@RequestParam进行映射
    public Result deleteBatch(@RequestParam List<Long> ids)
    {
        log.info("批量删除套餐,id为{}:",ids);
        setmealService.deleteBatch(ids);
        return Result.success();
    }


    /**
     * 根据id查询套餐和关联的菜品数据
     * @param id
     * @return
     */
    @GetMapping("/{id}")
    @ApiOperation(value = "根据id查询套餐和关联的菜品数据")
    public Result getById(@PathVariable Long id)
    {
        log.info("根据id{}查询套餐",id);
        SetmealVO setmealVO = setmealService.getByIdwithDish(id);
        return Result.success(setmealVO);
    }

    /**
     * 修改套餐
     * @param setmealDTO
     * @return
     */
    @PutMapping
    @ApiOperation("修改套餐")
    public Result update(@RequestBody SetmealDTO setmealDTO)
    {
        log.info("修改套餐：{}",setmealDTO);
        setmealService.update(setmealDTO);
        return Result.success();
    }

    /**
     * 套餐起售、停售
     * @param status
     * @param id
     * @return
     */
    @PostMapping("/status/{status}")
    @ApiOperation("套餐起售、停售")
    public Result startOrStop(@PathVariable Integer status,Long id)
    {
        log.info("套餐{}起售、停售：{}",id,status);
        setmealService.startOrStop(id,status);
        return Result.success();
    }

}
