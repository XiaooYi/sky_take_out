package com.sky.controller.admin;

import com.sky.constant.MessageConstant;
import com.sky.result.Result;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;

@RestController(value = "adminShopController")
@Slf4j
@Api(tags = "店铺操作接口")
@RequestMapping("/admin/shop")
public class ShopController {

    @Autowired
    private RedisTemplate redisTemplate;

    /**
     * 获取店铺营业状态
     * @return
     */
    @GetMapping("/status")
    @ApiOperation("获取店铺状态")
    public Result getShopStatus()
    {
        Integer status = (Integer) redisTemplate.opsForValue().get(MessageConstant.KEY);
        log.info("查询店铺营业状态为：{}",status == 1 ? "营业中" : "打烊中");
        return Result.success(status);
    }

    /**
     * 设置店铺营业状态
     * @param status
     * @return
     */
    @PutMapping("/{status}")
    @ApiOperation("设置店铺状态")
    public Result setShopStatus(@PathVariable Integer status)
    {
        log.info("设置店铺状态：{}",status == 1 ? "营业" : "打烊");
        redisTemplate.opsForValue().set(MessageConstant.KEY,status);
        return Result.success();
    }
}
