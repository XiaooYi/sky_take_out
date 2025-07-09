package com.sky.service.impl;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.sky.constant.MessageConstant;
import com.sky.constant.StatusConstant;
import com.sky.dto.SetmealDTO;
import com.sky.dto.SetmealPageQueryDTO;
import com.sky.entity.Dish;
import com.sky.entity.Setmeal;
import com.sky.entity.SetmealDish;
import com.sky.exception.DeletionNotAllowedException;
import com.sky.exception.SetmealEnableFailedException;
import com.sky.mapper.DishMapper;
import com.sky.mapper.SetmealDishMapper;
import com.sky.mapper.SetmealMapper;
import com.sky.result.PageResult;
import com.sky.service.SetmealService;
import com.sky.vo.SetmealVO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;


@Service
public class SetmealServiceImpl implements SetmealService {

    @Autowired
    private SetmealMapper setmealMapper;

    @Autowired
    private SetmealDishMapper setmealDishMapper;

    @Autowired
    private DishMapper dishMapper;

    /**
     * 套餐的分页查询
     * @param queryDTO
     * @return
     */
    @Override
    public PageResult queryByPage(SetmealPageQueryDTO queryDTO) {
        PageHelper.startPage(queryDTO.getPage(),queryDTO.getPageSize());
        Page<SetmealVO> setmealPage =  setmealMapper.queryByPage(queryDTO);
        PageResult pageResult = new PageResult(setmealPage.getTotal(),setmealPage.getResult());
        return pageResult;
    }

    /**
     * 新增套餐，同时保存套餐和菜品的关联关系
     * @param setmealDTO
     */
    @Override
    @Transactional
    public void saveWithDish(SetmealDTO setmealDTO) {
        // 向套餐表插入数据
        Setmeal setmeal = new Setmeal();
        BeanUtils.copyProperties(setmealDTO,setmeal);
        setmealMapper.insert(setmeal);

        // 获取生成的套餐id
        Long setmealId = setmeal.getId();
        List<SetmealDish> setmealDishs = setmealDTO.getSetmealDishes();
        for(SetmealDish setmealDish : setmealDishs) {
            setmealDish.setSetmealId(setmealId);
        }

        // 保存套餐和菜品的关联关系
        setmealDishMapper.insertBatch(setmealDishs);

    }

    /**
     * 批量删除套餐
     * @param ids
     */
    @Override
    @Transactional
    public void deleteBatch(List<Long> ids) {
        // 在售状态的套餐不能删除
        Setmeal setmeal;
        for(Long id : ids)
        {
            setmeal = setmealMapper.getById(id);
            if(StatusConstant.ENABLE == setmeal.getStatus())
            {
                throw new DeletionNotAllowedException(MessageConstant.SETMEAL_ON_SALE);
            }
        }
        // 删除套餐的同时，也要将关联的套餐菜品表数据删除
        setmealMapper.deleteBatch(ids);
        setmealDishMapper.deleteBatchBySetmealIds(ids);

    }

    /**
     * 根据id查询套餐和关联的菜品数据
     * @param id
     * @return
     */
    @Override
    public SetmealVO getByIdwithDish(Long id) {
        Setmeal setmeal = setmealMapper.getById(id);
        List<SetmealDish> setmealDishs = setmealDishMapper.getBySetmealId(id);

        SetmealVO setmealVO = new SetmealVO();
        BeanUtils.copyProperties(setmeal,setmealVO);
        setmealVO.setSetmealDishes(setmealDishs);
        return setmealVO;
    }

    /**
     * 修改套餐
     * @param setmealDTO
     */
    @Override
    public void update(SetmealDTO setmealDTO) {
        // 更新套餐表数据
        Setmeal setmeal = new Setmeal();
        BeanUtils.copyProperties(setmealDTO,setmeal);
        setmealMapper.update(setmeal);

        // 更新套餐菜品关系表数据,先全部删除，再插入
        Long setmealId = setmealDTO.getId();
        List<Long> ids = new ArrayList<>();
        ids.add(setmealId);
        setmealDishMapper.deleteBatchBySetmealIds(ids);

        List<SetmealDish> setmealDishes = setmealDTO.getSetmealDishes();
        setmealDishes.forEach(setmealDish -> {
            setmealDish.setSetmealId(setmealId);
        });
        setmealDishMapper.insertBatch(setmealDishes);

    }

    /**
     * 套餐起售、停售
     * @param id
     * @param status
     */
    @Override
    @Transactional
    public void startOrStop(Long id, Integer status) {
        //        // 如果套餐内如果有停售菜品，则套餐无法起售
        //        if(StatusConstant.ENABLE == status)
        //        {
        //            List<Long> dishIds = setmealDishMapper.getDishIdsBySetmealId(id);
        //            dishIds.forEach(dishId -> {
        //                Dish dish = dishMapper.queryByIdIsLong(dishId);
        //                if(dish.getStatus() == StatusConstant.DISABLE)
        //                {
        //                    throw new SetmealEnableFailedException(MessageConstant.SETMEAL_ENABLE_FAILED);
        //                }
        //            });
        //        }
        // 方法二：多表查询
        if(StatusConstant.ENABLE == status)
        {
            // select d.*  from dish d left join setmeal_dish sd on d.id = sd.dish_id where sd.setmeal_id = ?
            List<Dish> dishList = dishMapper.getBySetmealId(id);
            if(dishList != null && dishList.size() > 0)
            {
                dishList.forEach(dish -> {
                    if(dish.getStatus() == StatusConstant.DISABLE)
                    {
                        throw new SetmealEnableFailedException(MessageConstant.SETMEAL_ENABLE_FAILED);
                    }
                });
            }
        }
        Setmeal setmeal = Setmeal.builder().id(id).status(status).build();
        setmealMapper.update(setmeal);
    }
}
