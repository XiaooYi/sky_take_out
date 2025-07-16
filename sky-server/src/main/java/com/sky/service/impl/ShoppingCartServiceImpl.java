package com.sky.service.impl;

import com.sky.context.BaseContext;
import com.sky.dto.ShoppingCartDTO;
import com.sky.entity.Dish;
import com.sky.entity.Setmeal;
import com.sky.entity.ShoppingCart;
import com.sky.mapper.DishMapper;
import com.sky.mapper.SetmealMapper;
import com.sky.mapper.ShoppingCartMapper;
import com.sky.service.ShoppingCartService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ShoppingCartServiceImpl implements ShoppingCartService {


    @Autowired
    private ShoppingCartMapper shoppingCartMapper;

    @Autowired
    private DishMapper dishMapper;

    @Autowired
    private SetmealMapper setmealMapper;

    /**
     * 添加购物车
     * @param shoppingCartDTO
     */
    @Override
    public void addShopCart(ShoppingCartDTO shoppingCartDTO) {
        ShoppingCart shoppingCart = new ShoppingCart();
        BeanUtils.copyProperties(shoppingCartDTO,shoppingCart);
        // 只能查询自己的购物车数据
        shoppingCart.setUserId(BaseContext.getCurrentId());
        // 判断当前商品是否在购物车中
        List<ShoppingCart> shoppingCartList = shoppingCartMapper.list(shoppingCart);

        //如果已经存在，就更新数量，数量加1
        if(shoppingCartList != null && shoppingCartList.size() == 1)
        {
            shoppingCart = shoppingCartList.get(0);
            shoppingCart.setNumber(shoppingCart.getNumber() + 1);
            shoppingCartMapper.updateNumberById(shoppingCart);
        }
        //如果不存在，插入数据，数量就是1
        else{
            //判断当前添加到购物车的是菜品还是套餐
            Long dishId = shoppingCartDTO.getDishId();
            if(dishId != null)
            {
                //添加到购物车的是菜品
                Dish dish = dishMapper.queryByIdIsLong(dishId);
                shoppingCart.setAmount(dish.getPrice());
                shoppingCart.setDishFlavor(shoppingCartDTO.getDishFlavor());
                shoppingCart.setName(dish.getName());
                shoppingCart.setImage(dish.getImage());
            }else{
                //添加到购物车的是套餐
                Setmeal setmeal = setmealMapper.getById(shoppingCartDTO.getSetmealId());
                shoppingCart.setAmount(setmeal.getPrice());
                shoppingCart.setName(setmeal.getName());
                shoppingCart.setImage(setmeal.getImage());
            }
            shoppingCart.setNumber(1);
            shoppingCart.setCreateTime(LocalDateTime.now());
            shoppingCartMapper.insert(shoppingCart);
        }


    }

    /**
     * 查看购物车
     * @return
     */
    @Override
    public List<ShoppingCart> list() {
        return shoppingCartMapper.list(ShoppingCart.builder().userId(BaseContext.getCurrentId()).build());
    }

    /**
     * 删除购物车中一个商品
     * @param shoppingCartDTO
     */
    @Override
    public void sub(ShoppingCartDTO shoppingCartDTO) {
        ShoppingCart shoppingCart = new ShoppingCart();
        BeanUtils.copyProperties(shoppingCartDTO,shoppingCart);
        //设置查询条件，查询当前登录用户的购物车数据
        shoppingCart.setUserId(BaseContext.getCurrentId());
        // 查询出购物车的商品数据
        List<ShoppingCart> shoppingCartList = shoppingCartMapper.list(shoppingCart);

        if(shoppingCartList != null && shoppingCartList.size() > 0) {
            ShoppingCart shoppingCart1 = shoppingCartList.get(0);

            Integer number = shoppingCart1.getNumber();
            if (number > 1) { // 如果商品数量大于1，数量减1
                shoppingCart1.setNumber(number - 1);
                shoppingCartMapper.updateNumberById(shoppingCart1);
            } else { // 商品数量为1，直接删除这条数据
                shoppingCartMapper.deleteById(shoppingCart1.getId());
            }
        }
    }

    /**
     * 清空购物车
     */
    @Override
    public void cleanShoppingCart() {
        Long userId = BaseContext.getCurrentId();
        shoppingCartMapper.cleanShoppingCart(userId);
    }
}
