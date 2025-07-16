package com.sky.controller.user;

import com.sky.constant.MessageConstant;
import com.sky.result.Result;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;


@RestController(value = "userShopController")
@RequestMapping("/user/shop")
@Slf4j
@Api(tags = "C端-店铺操作接口")
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
}
