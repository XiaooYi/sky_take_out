package com.sky.service.impl;


import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.sky.constant.MessageConstant;
import com.sky.constant.StatusConstant;
import com.sky.dto.DishDTO;
import com.sky.dto.DishPageQueryDTO;
import com.sky.entity.Dish;
import com.sky.entity.DishFlavor;
import com.sky.entity.Setmeal;
import com.sky.entity.SetmealDish;
import com.sky.exception.DeletionNotAllowedException;
import com.sky.mapper.DishFlavorMapper;
import com.sky.mapper.DishMapper;
import com.sky.mapper.SetmealDishMapper;
import com.sky.result.PageResult;
import com.sky.service.DishService;
import com.sky.vo.DishVO;
import io.swagger.models.auth.In;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Slf4j
public class DishServiceImpl implements DishService {

    @Autowired
    private DishMapper dishMapper;

    @Autowired
    private DishFlavorMapper dishFlavorMapper;

    @Autowired
    private SetmealDishMapper setmealDishMapper;

    /**
     * 新增菜品和对应的口味
     * @param dishDTO
     */
    @Override
    @Transactional // 操作涉及了两张表，需要确保原子性
    public void savewithFlavor(DishDTO dishDTO) {
        Dish dish = Dish.builder()
                .image(dishDTO.getImage())
                .name(dishDTO.getName())
                .price(dishDTO.getPrice())
                .status(0)
                .categoryId(dishDTO.getCategoryId())
                .description(dishDTO.getDescription())
                .build();

        dishMapper.insert(dish);

        // 获取insert语句生成的主键值
        Long dishId = dish.getId();

        // 获取口味
        List<DishFlavor> flavors = dishDTO.getFlavors();
        // 如果用户选择了口味
        if(flavors != null && flavors.size() > 0)
        {
            flavors.forEach(flavor -> {
                flavor.setDishId(dishId);
            });
        }

        // 插入dish_flavor表
        for(DishFlavor flavor : flavors)
        {
            dishFlavorMapper.insert(flavor);
        }





    }


    /**
     * 菜品分页查询
     * @param dishPageQueryDTO
     * @return
     */
    @Override
    public PageResult pageQuery(DishPageQueryDTO dishPageQueryDTO) {
        // 设置分页参数
        int page = dishPageQueryDTO.getPage();
        int pageSize = dishPageQueryDTO.getPageSize();
        PageHelper.startPage(page,pageSize);

        // 执行查询
        List<DishVO> dishs = dishMapper.pageQuery(dishPageQueryDTO);
        Page<DishVO> dishPage = (Page<DishVO>) dishs;

        // 封装PageResult对象
        PageResult result = new PageResult(dishPage.getTotal(),dishPage.getResult());
        return result;
    }

    /**
     * 批量删除
     * @param ids
     */
    @Override
    @Transactional
    public void delBatch(List<Integer> ids) {
        //  在售状态下，不可删除菜品
        for( Integer id : ids)
        {
            Dish dish = dishMapper.queryById(id);
            if(dish.getStatus() == StatusConstant.ENABLE){
                throw new DeletionNotAllowedException(MessageConstant.DISH_ON_SALE);
            }
        }

        // 被套餐关联的菜品不能删除
        for( Integer id : ids)
        {
            SetmealDish setmealDish = setmealDishMapper.queryByDishId(id);
            if(setmealDish != null)
            {
                throw new DeletionNotAllowedException(MessageConstant.DISH_BE_RELATED_BY_SETMEAL);
            }
        }


        // 删除菜品，同时删除关联的口味
        // 这样做需要进行多次sql查询，性能低
        //        for(Integer id : ids)
        //        {
        //            dishMapper.deleteById(id);
        //            Integer dishId = id;
        //            dishFlavorMapper.deleteById(dishId);
        //        }

        // 根据菜品id集合批量删除菜品数据
        dishMapper.deleteByIds(ids);

        // 根据菜品id集合批量删除关联的口味数据
        dishFlavorMapper.deleteByDishIds(ids);

    }

    /**
     * 修改菜品
     * @param dishDTO
     */
    @Override
    @Transactional
    public void updateDish(DishDTO dishDTO) {
        Dish dish = new Dish();
        BeanUtils.copyProperties(dishDTO,dish);

        // 修改菜品表
        dishMapper.update(dish);
        // 获取菜品的id
        Long dishId = dish.getId();

        // 直接进行update操作会覆盖同一个dishId的口味
        //        for(DishFlavor dishFlavor : dishFlavors)
        //        {
        //            dishFlavor.setDishId(dishId);
        //            dishFlavorMapper.update(dishFlavor);
        //        }

        // 删除原有的口味数据
        dishFlavorMapper.deleteById(dishId);

        // 重新插入口味数据
        List<DishFlavor> dishFlavors = dishDTO.getFlavors();
        for(DishFlavor dishFlavor : dishFlavors)
        {
            dishFlavor.setDishId(dishId);
            dishFlavorMapper.insert(dishFlavor);
        }

    }

    /**
     * 根据菜品id查询菜品
     * @param id
     */
    @Override
    public DishVO getByIdwithFlavor(Integer id) {
        // 根据id查询菜品
        Dish dish = dishMapper.queryById(id);

        // 根据dishId查询口味
        List<DishFlavor> flavors = dishFlavorMapper.queryByDishId(id);

        // 封装DishVO对象返回
        DishVO dishVO = new DishVO();
        BeanUtils.copyProperties(dish,dishVO);
        dishVO.setFlavors(flavors);
        return dishVO;
    }
}
