package com.sky.service.impl;

import com.sky.dto.GoodsSalesDTO;
import com.sky.entity.Orders;
import com.sky.mapper.ReportMapper;
import com.sky.service.ReportService;
import com.sky.vo.OrderReportVO;
import com.sky.vo.SalesTop10ReportVO;
import com.sky.vo.TurnoverReportVO;
import com.sky.vo.UserReportVO;
import io.swagger.models.auth.In;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;


@Service
public class ReportServiceImpl implements ReportService {

    @Autowired
    private ReportMapper reportMapper;

    /**
     * 根据时间区间统计营业额
     * @param begin
     * @param end
     * @return
     */
    @Override
    public TurnoverReportVO turnoverReport(LocalDate begin, LocalDate end) {
        List<LocalDate> localDates = new ArrayList<>();
        localDates.add(begin);

        // 获得日期列表
        LocalDate beginCopy = begin;
        while (!beginCopy.equals(end)){ // 使用equals比较的是对象的内容，==比较的是地址
            beginCopy = beginCopy.plusDays(1);
            localDates.add(beginCopy);
        }


        List<Double> salesMoneyList = new ArrayList<>();
        // 遍历日期列表，统计每天的营业额
        for(LocalDate date : localDates){
            // 计算当天的最早和最晚时间
            LocalDateTime beginTime = LocalDateTime.of(date, LocalTime.MIN);
            LocalDateTime endTime = LocalDateTime.of(date, LocalTime.MAX);
            // 设置查询的参数
            Map map = new HashMap<>();
            map.put("status", Orders.COMPLETED);
            map.put("begin",beginTime);
            map.put("end",endTime);
            // 调用mapper方法，计算当天已经完成订单的营业额
            Double money = reportMapper.sumByDay(map);

            salesMoneyList.add(money);
        }
        // 构造返回值
        TurnoverReportVO reportVO = TurnoverReportVO.builder()
                .dateList(StringUtils.join(localDates,","))
                .turnoverList(StringUtils.join(salesMoneyList,","))
                .build();


        return reportVO;
    }

    /**
     * 用户统计接口
     * @param begin
     * @param end
     * @return
     */
    @Override
    public UserReportVO userStatistics(LocalDate begin, LocalDate end) {
        List<LocalDate> localDates = new ArrayList<>();
        localDates.add(begin);

        // 获得日期列表
        LocalDate beginCopy = begin;
        while (!beginCopy.equals(end)){ // 使用equals比较的是对象的内容，==比较的是地址
            beginCopy = beginCopy.plusDays(1);
            localDates.add(beginCopy);
        }

        List<Integer> newUserList = new ArrayList<>();
        List<Integer> allUserList = new ArrayList<>();

        for(LocalDate date : localDates){
            // 计算当天的最早和最晚时间
            LocalDateTime beginTime = LocalDateTime.of(date, LocalTime.MIN);
            LocalDateTime endTime = LocalDateTime.of(date, LocalTime.MAX);
            // 设置查询的参数
            Map map = new HashMap<>();
            map.put("begin",beginTime);
            map.put("end",endTime);
            // 计算每天新增的用户列表
            Integer newUserNum = reportMapper.sumUser(map);
            newUserList.add(newUserNum);

            // 设置查询的参数
            Map allMap = new HashMap<>();
            // allMap.put("begin",LocalDateTime.MIN); // 超过mysql的DATETIME类型的最小值
            allMap.put("begin",null);
            allMap.put("end",endTime);
            // 计算截止当天的用户数量
            Integer allUserNum = reportMapper.sumUser(allMap);
            allUserList.add(allUserNum);
        }

        UserReportVO userReportVO = UserReportVO.builder()
                .dateList(StringUtils.join(localDates,","))
                .newUserList(StringUtils.join(newUserList,","))
                .totalUserList(StringUtils.join(allUserList,","))
                .build();
        return userReportVO;
    }

    /**
     * 订单统计接口
     * @param begin
     * @param end
     * @return
     */
    @Override
    public OrderReportVO ordersStatistics(LocalDate begin, LocalDate end) {
        List<LocalDate> localDates = new ArrayList<>();
        localDates.add(begin);

        // 获得日期列表
        LocalDate beginCopy = begin;
        while (!beginCopy.equals(end)){ // 使用equals比较的是对象的内容，==比较的是地址
            beginCopy = beginCopy.plusDays(1);
            localDates.add(beginCopy);
        }

        List<Integer> validOrderList = new ArrayList<>();
        List<Integer> allOrderList = new ArrayList<>();

        // 总订单数和有效订单数量
        Integer allOrderNums = 0,validOrderNums = 0;

        for(LocalDate date : localDates){
            // 计算当天的最早和最晚时间
            LocalDateTime beginTime = LocalDateTime.of(date, LocalTime.MIN);
            LocalDateTime endTime = LocalDateTime.of(date, LocalTime.MAX);
            // 设置查询的参数
            Map map = new HashMap<>();
            map.put("begin",beginTime);
            map.put("end",endTime);
            map.put("status",Orders.COMPLETED);
            // 计算当天有效订单数量
            Integer validOrderNum = reportMapper.countOrders(map);
            validOrderList.add(validOrderNum);
            validOrderNums += validOrderNum;

            // 设置查询的参数
            Map allMap = new HashMap<>();
            allMap.put("begin",beginTime);
            allMap.put("end",endTime);
            // 计算当天总的订单数量
            Integer allOrderNum = reportMapper.countOrders(allMap);
            allOrderList.add(allOrderNum);
            allOrderNums += allOrderNum;
        }

        OrderReportVO reportVO = OrderReportVO.builder()
                .dateList(StringUtils.join(localDates,","))
                .validOrderCount(validOrderNums)
                .validOrderCountList(StringUtils.join(validOrderList,","))
                .totalOrderCount(allOrderNums)
                .orderCountList(StringUtils.join(allOrderList,","))
                .orderCompletionRate((double) validOrderNums / allOrderNums)
                .build();
        return reportVO;
    }

    /**
     * 查询销量排名top10接口
     * @param begin
     * @param end
     * @return
     */
    @Override
    public SalesTop10ReportVO salesTop10(LocalDate begin, LocalDate end) {

        LocalDateTime beginTime = LocalDateTime.of(begin, LocalTime.MIN);
        LocalDateTime endTime = LocalDateTime.of(end, LocalTime.MAX);

        List<GoodsSalesDTO> goodsSalesDTOList = reportMapper.getSalesTop10(beginTime,endTime);

        //  String nameList = StringUtils.join(goodsSalesDTOList.stream().map(GoodsSalesDTO::getName).collect(Collectors.toList()),",");
        //  String numberList = StringUtils.join(goodsSalesDTOList.stream().map(GoodsSalesDTO::getNumber).collect(Collectors.toList()),",");
        List<String> stringNameList = new ArrayList<>();
        List<Integer> integerNumberList = new ArrayList<>();
        for(GoodsSalesDTO dto : goodsSalesDTOList){
            stringNameList.add(dto.getName());
            integerNumberList.add(dto.getNumber());
        }

        String nameList = StringUtils.join(stringNameList,",");
        String numberList = StringUtils.join(integerNumberList,",");

        return SalesTop10ReportVO.builder()
                .nameList(nameList)
                .numberList(numberList)
                .build();
    }
}
