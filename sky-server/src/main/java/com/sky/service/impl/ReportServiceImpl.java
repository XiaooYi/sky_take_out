package com.sky.service.impl;

import com.sky.dto.GoodsSalesDTO;
import com.sky.entity.Orders;
import com.sky.mapper.ReportMapper;
import com.sky.service.ReportService;
import com.sky.service.WorkspaceService;
import com.sky.vo.*;
import io.swagger.models.auth.In;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.util.StringUtil;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;


@Service
public class ReportServiceImpl implements ReportService {

    @Autowired
    private ReportMapper reportMapper;

    @Autowired
    private WorkspaceService workspaceService;

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

    /**导出近30天的运营数据报表
     * @param response
     **/
    public void exportBusinessData(HttpServletResponse response) {
        LocalDate begin = LocalDate.now().minusDays(30);
        LocalDate end = LocalDate.now().minusDays(1);
        //查询概览运营数据，提供给Excel模板文件
        BusinessDataVO businessData = workspaceService.getBusinessData(LocalDateTime.of(begin,LocalTime.MIN), LocalDateTime.of(end, LocalTime.MAX));
        InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("template/运营数据报表模板.xlsx");
        try {
            //基于提供好的模板文件创建一个新的Excel表格对象
            XSSFWorkbook excel = new XSSFWorkbook(inputStream);
            //获得Excel文件中的一个Sheet页
            XSSFSheet sheet = excel.getSheet("Sheet1");

            sheet.getRow(1).getCell(1).setCellValue(begin + "至" + end);
            //获得第4行
            XSSFRow row = sheet.getRow(3);
            //获取单元格
            row.getCell(2).setCellValue(businessData.getTurnover());
            row.getCell(4).setCellValue(businessData.getOrderCompletionRate());
            row.getCell(6).setCellValue(businessData.getNewUsers());
            row = sheet.getRow(4);
            row.getCell(2).setCellValue(businessData.getValidOrderCount());
            row.getCell(4).setCellValue(businessData.getUnitPrice());
            for (int i = 0; i < 30; i++) {
                LocalDate date = begin.plusDays(i);
                //准备明细数据
                businessData = workspaceService.getBusinessData(LocalDateTime.of(date,LocalTime.MIN), LocalDateTime.of(date, LocalTime.MAX));
                row = sheet.getRow(7 + i);
                row.getCell(1).setCellValue(date.toString());
                row.getCell(2).setCellValue(businessData.getTurnover());
                row.getCell(3).setCellValue(businessData.getValidOrderCount());
                row.getCell(4).setCellValue(businessData.getOrderCompletionRate());
                row.getCell(5).setCellValue(businessData.getUnitPrice());
                row.getCell(6).setCellValue(businessData.getNewUsers());
            }
            //通过输出流将文件下载到客户端浏览器中
            ServletOutputStream out = response.getOutputStream();
            excel.write(out);
            //关闭资源
            out.flush();
            out.close();
            excel.close();

        }catch (IOException e){
            e.printStackTrace();
        }
    }
}
