package com.sky.controller.admin;


import com.sky.constant.MessageConstant;
import com.sky.result.Result;
import com.sky.utils.AliOssUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

/**
 * 通用接口
 */
@RestController
@Slf4j
@Api(tags = "通用接口")
@RequestMapping("/admin/common")
public class CommonController {

    @Autowired
    private AliOssUtil aliOssUtil;

    @PostMapping("/upload")
    @ApiOperation("文件上传")
    public Result upload(@RequestParam("file") MultipartFile multipartFile)
    {
        log.info("文件上传:{}",multipartFile);
        String url = null;

        try {
            // 原始文件名
            String originName = multipartFile.getOriginalFilename();
            // 构建原始文件的后缀
            String extension = originName.substring(originName.lastIndexOf("."));
            // 生成新文件的名称
            String newName = UUID.randomUUID().toString() + extension;
            // 构建文件的请求路径
            url = aliOssUtil.upload(multipartFile.getBytes(),newName);
            return Result.success(url);
        } catch (IOException e) {
            log.info("文件上传失败:{}",e);
        }
        return Result.error(MessageConstant.UPLOAD_FAILED);
    }

}
