package com.sky.aspect;

import com.sky.annotation.AutoFill;
import com.sky.constant.AutoFillConstant;
import com.sky.context.BaseContext;
import com.sky.enumeration.OperationType;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.time.LocalDateTime;


/**
 * 自定义切面类，统一为公共字段赋值
 */
@Aspect
@Slf4j
@Component
public class AutoFillAspect {

    /**
     * 切入点
     */
    @Pointcut("execution(* com.sky.mapper.*.*(..)) && @annotation(com.sky.annotation.AutoFill)")
    public void pt(){}

    /**
     * 自动填充公共字段
     * @param joinPoint
     */
    @Before("pt()")
    public void autoFill(JoinPoint joinPoint){
        log.info("公共字段自动填充...");

        // 获得方法签名对象
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        // 获得方法上的注解
        AutoFill autoFill = signature.getMethod().getAnnotation(AutoFill.class);
        // 获得注解中的操作类型signature = {MethodInvocationProceedingJoinPoint$MethodSignatureImpl@9621} "void com.sky.mapper.CategoryMapper.update(Category)"
        OperationType operationType = autoFill.value();
        // 获取当前目标方法的参数
        Object[] args = joinPoint.getArgs();
        if(args == null || args.length == 0)
        {
            return ;
        }

        // 实体对象
        Object entity = args[0];

        // 准备赋值的数据
        LocalDateTime time = LocalDateTime.now();
        Long empId = BaseContext.getCurrentId();

        try {
            if(operationType == OperationType.INSERT)
            {
                // 获得set方法对象--Method
                Method setCreateTime = entity.getClass().getDeclaredMethod(AutoFillConstant.SET_CREATE_TIME,LocalDateTime.class);
                Method setUpdateTime = entity.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATE_TIME,LocalDateTime.class);
                Method setCreateUser = entity.getClass().getDeclaredMethod(AutoFillConstant.SET_CREATE_USER,Long.class);
                Method setUpdateUser = entity.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATE_USER,Long.class);

                // 通过反射调用目标对象的方法
                setCreateTime.invoke(entity,time);
                setUpdateTime.invoke(entity,time);
                setCreateUser.invoke(entity,empId);
                setUpdateUser.invoke(entity,empId);
            }else if (operationType == OperationType.UPDATE)
            {
                // 获得set方法对象--Method
                Method setUpdateTime = entity.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATE_TIME,LocalDateTime.class);
                Method setUpdateUser = entity.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATE_USER,Long.class);

                // 通过反射调用目标对象的方法
                setUpdateTime.invoke(entity,time);
                setUpdateUser.invoke(entity,empId);
            }
        } catch (NoSuchMethodException e) {
            log.info("公共字段填充失败:{}",e.getMessage());
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            log.info("公共字段填充失败:{}",e.getMessage());
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            log.info("公共字段填充失败:{}",e.getMessage());
            e.printStackTrace();
        }


    }
}
