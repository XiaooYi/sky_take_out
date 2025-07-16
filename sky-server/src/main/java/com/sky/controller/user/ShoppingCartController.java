package com.sky.controller.user;


import com.sky.dto.ShoppingCartDTO;
import com.sky.entity.ShoppingCart;
import com.sky.result.Result;
import com.sky.service.ShoppingCartService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.annotations.Delete;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Slf4j
@RequestMapping("/user/shoppingCart")
@Api(tags = "C端-购物车相关接口")
public class ShoppingCartController {

    @Autowired
    private ShoppingCartService shoppingCartService;


    /**
     * 添加购物车
     * @param shoppingCartDTO
     * @return
     */
    @PostMapping("/add")
    @ApiOperation("增加购物车")
    public Result<String> add(@RequestBody ShoppingCartDTO shoppingCartDTO)
    {
        log.info("添加购物车:{}",shoppingCartDTO);
        shoppingCartService.addShopCart(shoppingCartDTO);
        return Result.success();
    }


    /**
     * 查看购物车
     * @return
     */
    @GetMapping("/list")
    @ApiOperation("查看购物车")
    public Result<List<ShoppingCart>> list()
    {
        log.info("查看用户的购物车");
        List<ShoppingCart> shoppingCartList = shoppingCartService.list();
        return Result.success(shoppingCartList);
    }

    /**
     * 删除购物车中一个商品
     * @param shoppingCartDTO
     * @return
     */
    @PostMapping("/sub")
    @ApiOperation("删除购物车中一个商品")
    public Result<String> sub(@RequestBody ShoppingCartDTO shoppingCartDTO)
    {
        log.info("删除购物车中一个商品：{}",shoppingCartDTO);
        shoppingCartService.sub(shoppingCartDTO);
        return Result.success();
    }


    /**
     * 清空购物车
     * @param
     * @return
     */
    @DeleteMapping("/clean")
    @ApiOperation("清空购物车")
    public Result<String> cleanShoppingCart()
    {
        log.info("清空购物车");
        shoppingCartService.cleanShoppingCart();
        return Result.success();
    }


}
