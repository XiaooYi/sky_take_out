/*
 Navicat Premium Data Transfer

 Source Server         : 本机连接
 Source Server Type    : MySQL
 Source Server Version : 80039
 Source Host           : localhost:3306
 Source Schema         : sky_take_out

 Target Server Type    : MySQL
 Target Server Version : 80039
 File Encoding         : 65001

 Date: 22/07/2025 16:18:45
*/

-- 导出 sky_take_out 的数据库结构
DROP DATABASE IF EXISTS `sky_take_out`;
CREATE DATABASE IF NOT EXISTS `sky_take_out` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `sky_take_out`;



-- ----------------------------
-- Table structure for address_book
-- ----------------------------
DROP TABLE IF EXISTS `address_book`;
CREATE TABLE `address_book`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `consignee` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '收货人',
  `sex` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '性别',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '手机号',
  `province_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '省级区划编号',
  `province_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '省级名称',
  `city_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '市级区划编号',
  `city_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '市级名称',
  `district_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区级区划编号',
  `district_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区级名称',
  `detail` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '详细地址',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '默认 0 否 1是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '地址簿' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of address_book
-- ----------------------------
INSERT INTO `address_book` VALUES (2, 4, '秦毅', '0', '16638281093', '23', '黑龙江省', '2301', '哈尔滨市', '230102', '道里区', '阳固镇', '2', 0);
INSERT INTO `address_book` VALUES (4, 4, '雷军', '0', '16638281093', '68', '澳门', '6801', '澳门半岛', '680101', '澳门半岛', '不知道', '1', 0);
INSERT INTO `address_book` VALUES (5, 4, '小明', '0', '16638281066', '11', '北京市', '1101', '市辖区', '110108', '海淀区', '上地十街12号', '1', 1);

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` int NULL DEFAULT NULL COMMENT '类型   1 菜品分类 2 套餐分类',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '分类名称',
  `sort` int NOT NULL DEFAULT 0 COMMENT '顺序',
  `status` int NULL DEFAULT NULL COMMENT '分类状态 0:禁用，1:启用',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint NULL DEFAULT NULL COMMENT '创建人',
  `update_user` bigint NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_category_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '菜品及套餐分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (11, 1, '酒水饮料', 10, 1, '2022-06-09 22:09:18', '2023-12-30 16:16:35', 1, 1);
INSERT INTO `category` VALUES (12, 1, '传统主食', 9, 1, '2022-06-09 22:09:32', '2023-12-30 16:06:39', 1, 1);
INSERT INTO `category` VALUES (15, 2, '商务套餐', 12, 1, '2022-06-09 22:14:10', '2023-12-30 16:11:34', 1, 1);
INSERT INTO `category` VALUES (17, 1, '蜀味牛蛙', 5, 1, '2022-06-09 22:16:14', '2023-12-30 16:06:39', 1, 1);
INSERT INTO `category` VALUES (18, 1, '特色蒸菜', 6, 1, '2022-06-09 22:17:42', '2023-12-30 16:06:39', 1, 1);
INSERT INTO `category` VALUES (19, 1, '新鲜时蔬', 7, 1, '2022-06-09 22:18:12', '2023-12-30 16:06:39', 1, 1);
INSERT INTO `category` VALUES (20, 1, '水煮鱼', 8, 1, '2022-06-09 22:22:29', '2023-12-30 16:06:39', 1, 1);
INSERT INTO `category` VALUES (21, 1, '汤类', 11, 1, '2022-06-10 10:51:47', '2023-12-30 16:06:39', 1, 1);
INSERT INTO `category` VALUES (24, 1, '水煮肉片', 1, 0, '2025-07-07 12:59:45', '2025-07-18 13:37:57', 1, 1);
INSERT INTO `category` VALUES (26, 1, '国外食品', 4, 1, '2025-07-07 17:51:02', '2025-07-07 17:51:49', 1, 1);
INSERT INTO `category` VALUES (27, 2, '美团团购套餐', 4, 1, '2025-07-15 16:44:43', '2025-07-15 16:47:07', 1, 1);

-- ----------------------------
-- Table structure for dish
-- ----------------------------
DROP TABLE IF EXISTS `dish`;
CREATE TABLE `dish`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '菜品名称',
  `category_id` bigint NOT NULL COMMENT '菜品分类id',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '菜品价格',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '图片',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '描述信息',
  `status` int NULL DEFAULT 1 COMMENT '0 停售 1 起售',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint NULL DEFAULT NULL COMMENT '创建人',
  `update_user` bigint NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_dish_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 89 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '菜品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dish
-- ----------------------------
INSERT INTO `dish` VALUES (47, '北冰洋', 11, 4.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/2f42346d-a997-4101-a957-107b0386e885.png', '还是小时候的味道', 1, '2022-06-10 09:18:49', '2025-07-16 18:27:25', 1, 1);
INSERT INTO `dish` VALUES (48, '雪花啤酒', 11, 4.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/b6876d0a-67ec-404b-b960-46c37a0292a8.png', '', 1, '2022-06-10 09:22:54', '2025-07-16 18:27:50', 1, 1);
INSERT INTO `dish` VALUES (49, '米饭', 12, 2.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/4e10b6be-af83-4b0f-a7f4-c6dce235afcb.png', '精选五常大米', 1, '2022-06-10 09:30:17', '2025-07-16 18:27:33', 1, 1);
INSERT INTO `dish` VALUES (50, '馒头', 12, 1.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/329855c2-7e87-4d08-aacf-e939a4d1c2ed.png', '优质面粉', 1, '2022-06-10 09:34:28', '2025-07-16 18:27:42', 1, 1);
INSERT INTO `dish` VALUES (51, '老坛酸菜鱼', 20, 56.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/652c37ca-67a2-466e-9969-22b4415e411e.png', '原料：汤，草鱼，酸菜', 1, '2022-06-10 09:40:51', '2025-07-16 18:28:01', 1, 1);
INSERT INTO `dish` VALUES (52, '经典酸菜鮰鱼', 20, 66.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/d220b677-0fc7-4442-816c-aaa8e3b84fb6.png', '原料：酸菜，江团，鮰鱼', 1, '2022-06-10 09:46:02', '2025-07-16 18:27:16', 1, 1);
INSERT INTO `dish` VALUES (53, '蜀味水煮草鱼', 20, 38.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/83ed6dd0-9f70-465f-adf2-ecdd69bbaf2d.png', '原料：草鱼，汤', 1, '2022-06-10 09:48:37', '2025-07-16 18:27:01', 1, 1);
INSERT INTO `dish` VALUES (54, '清炒小油菜', 19, 18.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/e0b6ca7e-012a-46bc-a894-1deddb83fb03.png', '原料：小油菜', 1, '2022-06-10 09:51:46', '2025-07-16 18:26:49', 1, 1);
INSERT INTO `dish` VALUES (55, '蒜蓉娃娃菜', 19, 18.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/6c5011e5-7e77-43c7-9002-9f50c24e2cf6.png', '原料：蒜，娃娃菜', 1, '2022-06-10 09:53:37', '2025-07-16 18:26:39', 1, 1);
INSERT INTO `dish` VALUES (56, '清炒西兰花', 19, 18.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/fd6f4ef6-8766-43dd-adad-8b63ab8867e9.png', '原料：西兰花', 1, '2022-06-10 09:55:44', '2025-07-16 18:26:28', 1, 1);
INSERT INTO `dish` VALUES (57, '炝炒圆白菜', 19, 18.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/e7fb52a5-23bf-40b5-9870-6bdbf123d057.png', '原料：圆白菜', 1, '2022-06-10 09:58:35', '2025-07-16 18:26:19', 1, 1);
INSERT INTO `dish` VALUES (58, '清蒸鲈鱼', 18, 98.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/3a68bd5e-adbe-4681-aa0d-7e6e606afc99.png', '原料：鲈鱼', 1, '2022-06-10 10:12:28', '2025-07-16 18:26:02', 1, 1);
INSERT INTO `dish` VALUES (59, '东坡肘子', 18, 138.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/1feaaa5a-d0ac-48a2-86ec-adcf2a4aa885.png', '原料：猪肘棒', 0, '2022-06-10 10:24:03', '2025-07-16 18:25:54', 1, 1);
INSERT INTO `dish` VALUES (60, '梅菜扣肉', 18, 58.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/2fbfb6f6-784d-4176-a13f-eb4b4305a8f9.png', '原料：猪肉，梅菜', 1, '2022-06-10 10:26:03', '2025-07-16 18:25:46', 1, 1);
INSERT INTO `dish` VALUES (61, '剁椒鱼头', 18, 66.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/71465921-9ca1-499b-8c22-991f5069cced.png', '原料：鲢鱼，剁椒', 1, '2022-06-10 10:28:54', '2025-07-16 18:25:34', 1, 1);
INSERT INTO `dish` VALUES (62, '金汤酸菜牛蛙', 17, 88.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/913862e9-3136-49b0-87f9-46ae4cf1e0b6.png', '原料：鲜活牛蛙，酸菜', 1, '2022-06-10 10:33:05', '2025-07-16 18:25:12', 1, 1);
INSERT INTO `dish` VALUES (63, '香锅牛蛙', 17, 66.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/faf5e8c6-1604-4f48-ac0c-61d447d09d5e.png', '配料：鲜活牛蛙，莲藕，青笋', 1, '2022-06-10 10:35:40', '2025-07-16 18:25:01', 1, 1);
INSERT INTO `dish` VALUES (64, '馋嘴牛蛙', 17, 88.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/e130a12a-1b4f-4951-b6cd-b11db1d216a9.png', '配料：鲜活牛蛙，丝瓜，黄豆芽', 1, '2022-06-10 10:37:52', '2025-07-16 18:24:54', 1, 1);
INSERT INTO `dish` VALUES (65, '草鱼2斤', 20, 68.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/3eb52acc-d8e5-45c0-b2c5-39a7b0742442.png', '原料：草鱼，黄豆芽，莲藕', 1, '2022-06-10 10:41:08', '2025-07-16 18:24:45', 1, 1);
INSERT INTO `dish` VALUES (66, '江团鱼2斤', 20, 119.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/4270315a-abd7-4faa-aa5d-6c62c59b7101.png', '配料：江团鱼，黄豆芽，莲藕', 1, '2022-06-10 10:42:42', '2025-07-16 18:24:34', 1, 1);
INSERT INTO `dish` VALUES (67, '鮰鱼2斤', 17, 72.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/a6b6ffc8-acc5-4add-8c96-41e20f76f03e.png', '原料：鮰鱼，黄豆芽，莲藕', 1, '2022-06-10 10:43:56', '2025-07-16 18:24:21', 1, 1);
INSERT INTO `dish` VALUES (68, '鸡蛋汤', 21, 6.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/71030fe4-401e-4aff-8603-ae839b722d05.png', '配料：鸡蛋，紫菜', 1, '2022-06-10 10:54:25', '2025-07-16 18:24:11', 1, 1);
INSERT INTO `dish` VALUES (69, '平菇豆腐汤', 21, 6.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/ffb39df7-c2bb-4bd0-a0e1-d19bd4f38a9f.png', '配料：豆腐，平菇', 1, '2022-06-10 10:55:02', '2025-07-16 18:24:01', 1, 1);
INSERT INTO `dish` VALUES (70, '西红柿炒鸡蛋', 12, 32.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/fdcb3181-23b7-4387-977f-90376d43c30a.png', '西红柿+鸡蛋', 1, '2023-12-30 23:23:48', '2025-07-16 18:23:51', 1, 1);
INSERT INTO `dish` VALUES (85, '薯条', 26, 7.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/37d68ff7-1b03-4e74-8e8b-2893ee5db571.png', '好吃的薯条', 1, '2025-07-07 17:53:27', '2025-07-08 14:18:50', 1, 1);
INSERT INTO `dish` VALUES (86, '鸡块', 26, 8.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/947428b3-b017-4125-aa0f-e735cec4537c.png', '8元4个鸡块', 1, '2025-07-07 17:54:02', '2025-07-08 14:21:56', 1, 1);
INSERT INTO `dish` VALUES (87, '茶颜悦色', 11, 16.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/1128f59f-484b-4f80-9cc1-400b232e8d22.png', '', 1, '2025-07-16 18:29:18', '2025-07-16 19:57:26', 1, 1);
INSERT INTO `dish` VALUES (88, '柠檬水', 11, 4.00, 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/b5f3e7b8-1598-45b7-a4cb-ba588a8d67ef.png', '', 1, '2025-07-16 18:31:22', '2025-07-16 19:57:24', 1, 1);

-- ----------------------------
-- Table structure for dish_flavor
-- ----------------------------
DROP TABLE IF EXISTS `dish_flavor`;
CREATE TABLE `dish_flavor`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dish_id` bigint NOT NULL COMMENT '菜品',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '口味名称',
  `value` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '口味数据list',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 128 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '菜品口味关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dish_flavor
-- ----------------------------
INSERT INTO `dish_flavor` VALUES (41, 7, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (42, 7, '温度', '[\"热饮\",\"常温\",\"去冰\",\"少冰\",\"多冰\"]');
INSERT INTO `dish_flavor` VALUES (47, 5, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (48, 5, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` VALUES (49, 2, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` VALUES (50, 4, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` VALUES (51, 3, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` VALUES (52, 3, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (104, 11, '', '');
INSERT INTO `dish_flavor` VALUES (105, 6, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (107, 46, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` VALUES (113, 85, '辣度', '[\"不辣\"]');
INSERT INTO `dish_flavor` VALUES (114, 86, '温度', '[\"常温\"]');
INSERT INTO `dish_flavor` VALUES (115, 67, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (116, 66, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (117, 65, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (118, 60, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (119, 57, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (120, 56, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (121, 54, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\"]');
INSERT INTO `dish_flavor` VALUES (122, 53, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (123, 53, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (124, 52, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (125, 52, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (126, 51, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (127, 51, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (128, 87, '', '[]');

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '姓名',
  `username` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '用户名',
  `password` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '密码',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '手机号',
  `sex` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '性别',
  `id_number` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '身份证号',
  `status` int NOT NULL DEFAULT 1 COMMENT '状态 0:禁用，1:启用',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint NULL DEFAULT NULL COMMENT '创建人',
  `update_user` bigint NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '员工信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of employee
-- ----------------------------
INSERT INTO `employee` VALUES (1, '管理员', 'admin', 'e10adc3949ba59abbe56e057f20f883e', '13812312312', '1', '110101199001010047', 1, '2022-02-15 15:51:20', '2022-02-17 09:16:20', 10, 1);
INSERT INTO `employee` VALUES (2, '秦毅', 'qinyi', 'e10adc3949ba59abbe56e057f20f883e', '16638281095', '1', '410221200306150016', 1, NULL, '2025-07-18 16:55:17', NULL, 3);
INSERT INTO `employee` VALUES (3, '小红', 'xiaohong', 'e10adc3949ba59abbe56e057f20f883e', '16638281093', '0', '410221200306150016', 1, '2025-07-04 11:53:02', '2025-07-04 11:53:02', 1, 1);

-- ----------------------------
-- Table structure for order_detail
-- ----------------------------
DROP TABLE IF EXISTS `order_detail`;
CREATE TABLE `order_detail`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '名字',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '图片',
  `order_id` bigint NOT NULL COMMENT '订单id',
  `dish_id` bigint NULL DEFAULT NULL COMMENT '菜品id',
  `setmeal_id` bigint NULL DEFAULT NULL COMMENT '套餐id',
  `dish_flavor` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '口味',
  `number` int NOT NULL DEFAULT 1 COMMENT '数量',
  `amount` decimal(10, 2) NOT NULL COMMENT '金额',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 137 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '订单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_detail
-- ----------------------------
INSERT INTO `order_detail` VALUES (5, 'KFC简易套餐', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/a28f7b2d-ba99-4cf0-9674-7fa00471e189.png', 4, NULL, 42, NULL, 1, 15.00);
INSERT INTO `order_detail` VALUES (6, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 4, NULL, 43, NULL, 1, 28.00);
INSERT INTO `order_detail` VALUES (7, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 5, NULL, 43, NULL, 1, 28.00);
INSERT INTO `order_detail` VALUES (8, '馒头', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/329855c2-7e87-4d08-aacf-e939a4d1c2ed.png', 6, 50, NULL, NULL, 1, 1.00);
INSERT INTO `order_detail` VALUES (9, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 7, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (10, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 8, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (11, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 9, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (12, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 10, NULL, 43, NULL, 1, 28.00);
INSERT INTO `order_detail` VALUES (13, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 10, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (14, '馋嘴牛蛙', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/e130a12a-1b4f-4951-b6cd-b11db1d216a9.png', 11, 64, NULL, NULL, 1, 88.00);
INSERT INTO `order_detail` VALUES (15, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 11, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (16, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 12, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (17, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 13, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (19, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 15, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (20, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 16, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (21, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 17, NULL, 43, NULL, 1, 28.00);
INSERT INTO `order_detail` VALUES (22, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 18, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (23, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 19, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (24, '老坛酸菜鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/652c37ca-67a2-466e-9969-22b4415e411e.png', 20, 51, NULL, '不要葱,中辣', 1, 56.00);
INSERT INTO `order_detail` VALUES (25, '经典酸菜鮰鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/d220b677-0fc7-4442-816c-aaa8e3b84fb6.png', 20, 52, NULL, '不要葱,不辣', 1, 66.00);
INSERT INTO `order_detail` VALUES (26, '剁椒鱼头', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/71465921-9ca1-499b-8c22-991f5069cced.png', 20, 61, NULL, NULL, 1, 66.00);
INSERT INTO `order_detail` VALUES (27, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 20, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (28, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 21, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (29, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 22, NULL, 43, NULL, 2, 28.00);
INSERT INTO `order_detail` VALUES (30, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 22, NULL, 44, NULL, 3, 5.00);
INSERT INTO `order_detail` VALUES (31, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 23, NULL, 43, NULL, 2, 28.00);
INSERT INTO `order_detail` VALUES (32, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 23, NULL, 44, NULL, 3, 5.00);
INSERT INTO `order_detail` VALUES (33, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 24, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (34, '清蒸鲈鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/3a68bd5e-adbe-4681-aa0d-7e6e606afc99.png', 25, 58, NULL, NULL, 2, 98.00);
INSERT INTO `order_detail` VALUES (35, '剁椒鱼头', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/71465921-9ca1-499b-8c22-991f5069cced.png', 25, 61, NULL, NULL, 3, 66.00);
INSERT INTO `order_detail` VALUES (36, '北冰洋', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/2f42346d-a997-4101-a957-107b0386e885.png', 26, 47, NULL, NULL, 1, 4.00);
INSERT INTO `order_detail` VALUES (37, '雪花啤酒', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/b6876d0a-67ec-404b-b960-46c37a0292a8.png', 26, 48, NULL, NULL, 1, 4.00);
INSERT INTO `order_detail` VALUES (38, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/1128f59f-484b-4f80-9cc1-400b232e8d22.png', 26, 87, NULL, NULL, 1, 16.00);
INSERT INTO `order_detail` VALUES (39, '柠檬水', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/b5f3e7b8-1598-45b7-a4cb-ba588a8d67ef.png', 26, 88, NULL, NULL, 1, 4.00);
INSERT INTO `order_detail` VALUES (40, '金汤酸菜牛蛙', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/913862e9-3136-49b0-87f9-46ae4cf1e0b6.png', 26, 62, NULL, NULL, 1, 88.00);
INSERT INTO `order_detail` VALUES (41, '馋嘴牛蛙', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/e130a12a-1b4f-4951-b6cd-b11db1d216a9.png', 26, 64, NULL, NULL, 1, 88.00);
INSERT INTO `order_detail` VALUES (42, '香锅牛蛙', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/faf5e8c6-1604-4f48-ac0c-61d447d09d5e.png', 26, 63, NULL, NULL, 1, 66.00);
INSERT INTO `order_detail` VALUES (43, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 26, NULL, 43, NULL, 1, 28.00);
INSERT INTO `order_detail` VALUES (44, '老坛酸菜鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/652c37ca-67a2-466e-9969-22b4415e411e.png', 26, 51, NULL, '不要葱,中辣', 1, 56.00);
INSERT INTO `order_detail` VALUES (45, '经典酸菜鮰鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/d220b677-0fc7-4442-816c-aaa8e3b84fb6.png', 26, 52, NULL, '不要葱,不辣', 1, 66.00);
INSERT INTO `order_detail` VALUES (46, '剁椒鱼头', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/71465921-9ca1-499b-8c22-991f5069cced.png', 26, 61, NULL, NULL, 1, 66.00);
INSERT INTO `order_detail` VALUES (47, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 26, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (48, '雪花啤酒', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/b6876d0a-67ec-404b-b960-46c37a0292a8.png', 27, 48, NULL, NULL, 3, 4.00);
INSERT INTO `order_detail` VALUES (49, '北冰洋', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/2f42346d-a997-4101-a957-107b0386e885.png', 27, 47, NULL, NULL, 4, 4.00);
INSERT INTO `order_detail` VALUES (50, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/1128f59f-484b-4f80-9cc1-400b232e8d22.png', 27, 87, NULL, NULL, 1, 16.00);
INSERT INTO `order_detail` VALUES (51, '柠檬水', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/b5f3e7b8-1598-45b7-a4cb-ba588a8d67ef.png', 27, 88, NULL, NULL, 1, 4.00);
INSERT INTO `order_detail` VALUES (52, '鸡蛋汤', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/71030fe4-401e-4aff-8603-ae839b722d05.png', 27, 68, NULL, NULL, 1, 6.00);
INSERT INTO `order_detail` VALUES (53, '平菇豆腐汤', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/ffb39df7-c2bb-4bd0-a0e1-d19bd4f38a9f.png', 27, 69, NULL, NULL, 1, 6.00);
INSERT INTO `order_detail` VALUES (54, '江团鱼2斤', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/4270315a-abd7-4faa-aa5d-6c62c59b7101.png', 27, 66, NULL, '不辣', 1, 119.00);
INSERT INTO `order_detail` VALUES (55, '草鱼2斤', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/3eb52acc-d8e5-45c0-b2c5-39a7b0742442.png', 27, 65, NULL, '不辣', 1, 68.00);
INSERT INTO `order_detail` VALUES (56, '蜀味水煮草鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/83ed6dd0-9f70-465f-adf2-ecdd69bbaf2d.png', 27, 53, NULL, '不要葱,不辣', 1, 38.00);
INSERT INTO `order_detail` VALUES (57, '炝炒圆白菜', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/e7fb52a5-23bf-40b5-9870-6bdbf123d057.png', 27, 57, NULL, '不要香菜', 1, 18.00);
INSERT INTO `order_detail` VALUES (58, '清炒小油菜', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/e0b6ca7e-012a-46bc-a894-1deddb83fb03.png', 27, 54, NULL, '不要葱', 1, 18.00);
INSERT INTO `order_detail` VALUES (59, '蒜蓉娃娃菜', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/6c5011e5-7e77-43c7-9002-9f50c24e2cf6.png', 27, 55, NULL, NULL, 1, 18.00);
INSERT INTO `order_detail` VALUES (60, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 27, NULL, 43, NULL, 1, 28.00);
INSERT INTO `order_detail` VALUES (61, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 27, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (62, '雪花啤酒', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/b6876d0a-67ec-404b-b960-46c37a0292a8.png', 28, 48, NULL, NULL, 3, 4.00);
INSERT INTO `order_detail` VALUES (63, '北冰洋', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/2f42346d-a997-4101-a957-107b0386e885.png', 28, 47, NULL, NULL, 4, 4.00);
INSERT INTO `order_detail` VALUES (64, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/1128f59f-484b-4f80-9cc1-400b232e8d22.png', 28, 87, NULL, NULL, 1, 16.00);
INSERT INTO `order_detail` VALUES (65, '柠檬水', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/b5f3e7b8-1598-45b7-a4cb-ba588a8d67ef.png', 28, 88, NULL, NULL, 1, 4.00);
INSERT INTO `order_detail` VALUES (66, '鸡蛋汤', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/71030fe4-401e-4aff-8603-ae839b722d05.png', 28, 68, NULL, NULL, 1, 6.00);
INSERT INTO `order_detail` VALUES (67, '平菇豆腐汤', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/ffb39df7-c2bb-4bd0-a0e1-d19bd4f38a9f.png', 28, 69, NULL, NULL, 1, 6.00);
INSERT INTO `order_detail` VALUES (68, '江团鱼2斤', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/4270315a-abd7-4faa-aa5d-6c62c59b7101.png', 28, 66, NULL, '不辣', 1, 119.00);
INSERT INTO `order_detail` VALUES (69, '草鱼2斤', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/3eb52acc-d8e5-45c0-b2c5-39a7b0742442.png', 28, 65, NULL, '不辣', 1, 68.00);
INSERT INTO `order_detail` VALUES (70, '蜀味水煮草鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/83ed6dd0-9f70-465f-adf2-ecdd69bbaf2d.png', 28, 53, NULL, '不要葱,不辣', 1, 38.00);
INSERT INTO `order_detail` VALUES (71, '炝炒圆白菜', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/e7fb52a5-23bf-40b5-9870-6bdbf123d057.png', 28, 57, NULL, '不要香菜', 1, 18.00);
INSERT INTO `order_detail` VALUES (72, '清炒小油菜', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/e0b6ca7e-012a-46bc-a894-1deddb83fb03.png', 28, 54, NULL, '不要葱', 1, 18.00);
INSERT INTO `order_detail` VALUES (73, '蒜蓉娃娃菜', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/6c5011e5-7e77-43c7-9002-9f50c24e2cf6.png', 28, 55, NULL, NULL, 1, 18.00);
INSERT INTO `order_detail` VALUES (74, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 28, NULL, 43, NULL, 1, 28.00);
INSERT INTO `order_detail` VALUES (75, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 28, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (76, '清蒸鲈鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/3a68bd5e-adbe-4681-aa0d-7e6e606afc99.png', 29, 58, NULL, NULL, 2, 98.00);
INSERT INTO `order_detail` VALUES (77, '剁椒鱼头', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/71465921-9ca1-499b-8c22-991f5069cced.png', 29, 61, NULL, NULL, 3, 66.00);
INSERT INTO `order_detail` VALUES (78, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 30, NULL, 43, NULL, 2, 28.00);
INSERT INTO `order_detail` VALUES (79, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 30, NULL, 44, NULL, 3, 5.00);
INSERT INTO `order_detail` VALUES (80, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 31, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (81, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 32, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (82, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 33, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (83, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 34, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (84, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 35, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (85, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 36, NULL, 43, NULL, 1, 28.00);
INSERT INTO `order_detail` VALUES (86, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 36, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (87, '金汤酸菜牛蛙', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/913862e9-3136-49b0-87f9-46ae4cf1e0b6.png', 37, 62, NULL, NULL, 1, 88.00);
INSERT INTO `order_detail` VALUES (88, '馋嘴牛蛙', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/e130a12a-1b4f-4951-b6cd-b11db1d216a9.png', 37, 64, NULL, NULL, 1, 88.00);
INSERT INTO `order_detail` VALUES (89, '香锅牛蛙', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/faf5e8c6-1604-4f48-ac0c-61d447d09d5e.png', 37, 63, NULL, NULL, 1, 66.00);
INSERT INTO `order_detail` VALUES (90, '蒜蓉娃娃菜', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/6c5011e5-7e77-43c7-9002-9f50c24e2cf6.png', 37, 55, NULL, NULL, 1, 18.00);
INSERT INTO `order_detail` VALUES (91, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 37, NULL, 43, NULL, 1, 28.00);
INSERT INTO `order_detail` VALUES (92, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 37, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (93, '金汤酸菜牛蛙', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/913862e9-3136-49b0-87f9-46ae4cf1e0b6.png', 38, 62, NULL, NULL, 1, 88.00);
INSERT INTO `order_detail` VALUES (94, '馋嘴牛蛙', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/e130a12a-1b4f-4951-b6cd-b11db1d216a9.png', 38, 64, NULL, NULL, 1, 88.00);
INSERT INTO `order_detail` VALUES (95, '香锅牛蛙', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/faf5e8c6-1604-4f48-ac0c-61d447d09d5e.png', 38, 63, NULL, NULL, 1, 66.00);
INSERT INTO `order_detail` VALUES (96, '蒜蓉娃娃菜', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/6c5011e5-7e77-43c7-9002-9f50c24e2cf6.png', 38, 55, NULL, NULL, 1, 18.00);
INSERT INTO `order_detail` VALUES (97, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 38, NULL, 43, NULL, 1, 28.00);
INSERT INTO `order_detail` VALUES (98, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 38, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (99, '经典酸菜鮰鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/d220b677-0fc7-4442-816c-aaa8e3b84fb6.png', 39, 52, NULL, '不要葱,不辣', 1, 66.00);
INSERT INTO `order_detail` VALUES (100, '蜀味水煮草鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/83ed6dd0-9f70-465f-adf2-ecdd69bbaf2d.png', 39, 53, NULL, '不要葱,不辣', 1, 38.00);
INSERT INTO `order_detail` VALUES (101, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 39, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (102, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 39, NULL, 43, NULL, 1, 28.00);
INSERT INTO `order_detail` VALUES (103, '米饭', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/4e10b6be-af83-4b0f-a7f4-c6dce235afcb.png', 40, 49, NULL, NULL, 2, 2.00);
INSERT INTO `order_detail` VALUES (104, '馒头', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/329855c2-7e87-4d08-aacf-e939a4d1c2ed.png', 40, 50, NULL, NULL, 1, 1.00);
INSERT INTO `order_detail` VALUES (105, '西红柿炒鸡蛋', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/fdcb3181-23b7-4387-977f-90376d43c30a.png', 40, 70, NULL, NULL, 1, 32.00);
INSERT INTO `order_detail` VALUES (106, '经典酸菜鮰鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/d220b677-0fc7-4442-816c-aaa8e3b84fb6.png', 40, 52, NULL, '不要葱,不辣', 1, 66.00);
INSERT INTO `order_detail` VALUES (107, '蜀味水煮草鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/83ed6dd0-9f70-465f-adf2-ecdd69bbaf2d.png', 40, 53, NULL, '不要葱,不辣', 1, 38.00);
INSERT INTO `order_detail` VALUES (108, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 40, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (109, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 40, NULL, 43, NULL, 1, 28.00);
INSERT INTO `order_detail` VALUES (110, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/1128f59f-484b-4f80-9cc1-400b232e8d22.png', 41, 87, NULL, NULL, 5, 16.00);
INSERT INTO `order_detail` VALUES (111, '米饭', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/4e10b6be-af83-4b0f-a7f4-c6dce235afcb.png', 41, 49, NULL, NULL, 2, 2.00);
INSERT INTO `order_detail` VALUES (112, '馒头', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/329855c2-7e87-4d08-aacf-e939a4d1c2ed.png', 41, 50, NULL, NULL, 1, 1.00);
INSERT INTO `order_detail` VALUES (113, '西红柿炒鸡蛋', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/fdcb3181-23b7-4387-977f-90376d43c30a.png', 41, 70, NULL, NULL, 1, 32.00);
INSERT INTO `order_detail` VALUES (114, '经典酸菜鮰鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/d220b677-0fc7-4442-816c-aaa8e3b84fb6.png', 41, 52, NULL, '不要葱,不辣', 1, 66.00);
INSERT INTO `order_detail` VALUES (115, '蜀味水煮草鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/83ed6dd0-9f70-465f-adf2-ecdd69bbaf2d.png', 41, 53, NULL, '不要葱,不辣', 1, 38.00);
INSERT INTO `order_detail` VALUES (116, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 41, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (117, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 41, NULL, 43, NULL, 1, 28.00);
INSERT INTO `order_detail` VALUES (118, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 42, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (119, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 43, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (120, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 44, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (121, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 45, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (122, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 46, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (123, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 47, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (124, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 48, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (125, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 49, NULL, 44, NULL, 1, 5.00);
INSERT INTO `order_detail` VALUES (126, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 50, NULL, 43, NULL, 3, 28.00);
INSERT INTO `order_detail` VALUES (127, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 50, NULL, 44, NULL, 4, 5.00);
INSERT INTO `order_detail` VALUES (128, '清蒸鲈鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/3a68bd5e-adbe-4681-aa0d-7e6e606afc99.png', 51, 58, NULL, NULL, 3, 98.00);
INSERT INTO `order_detail` VALUES (129, '剁椒鱼头', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/71465921-9ca1-499b-8c22-991f5069cced.png', 51, 61, NULL, NULL, 2, 66.00);
INSERT INTO `order_detail` VALUES (130, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 51, NULL, 43, NULL, 3, 28.00);
INSERT INTO `order_detail` VALUES (131, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 51, NULL, 44, NULL, 4, 5.00);
INSERT INTO `order_detail` VALUES (132, '蒜蓉娃娃菜', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/6c5011e5-7e77-43c7-9002-9f50c24e2cf6.png', 52, 55, NULL, NULL, 4, 18.00);
INSERT INTO `order_detail` VALUES (133, '清蒸鲈鱼', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/3a68bd5e-adbe-4681-aa0d-7e6e606afc99.png', 52, 58, NULL, NULL, 3, 98.00);
INSERT INTO `order_detail` VALUES (134, '剁椒鱼头', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/71465921-9ca1-499b-8c22-991f5069cced.png', 52, 61, NULL, NULL, 2, 66.00);
INSERT INTO `order_detail` VALUES (135, '茶颜悦色', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', 52, NULL, 43, NULL, 3, 28.00);
INSERT INTO `order_detail` VALUES (136, '蜜雪冰城', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', 52, NULL, 44, NULL, 4, 5.00);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `number` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '订单号',
  `status` int NOT NULL DEFAULT 1 COMMENT '订单状态 1待付款 2待接单 3已接单 4派送中 5已完成 6已取消 7退款',
  `user_id` bigint NOT NULL COMMENT '下单用户',
  `address_book_id` bigint NOT NULL COMMENT '地址id',
  `order_time` datetime NOT NULL COMMENT '下单时间',
  `checkout_time` datetime NULL DEFAULT NULL COMMENT '结账时间',
  `pay_method` int NOT NULL DEFAULT 1 COMMENT '支付方式 1微信,2支付宝',
  `pay_status` tinyint NOT NULL DEFAULT 0 COMMENT '支付状态 0未支付 1已支付 2退款',
  `amount` decimal(10, 2) NOT NULL COMMENT '实收金额',
  `remark` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '备注',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '手机号',
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '地址',
  `user_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '用户名称',
  `consignee` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '收货人',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '订单取消原因',
  `rejection_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '订单拒绝原因',
  `cancel_time` datetime NULL DEFAULT NULL COMMENT '订单取消时间',
  `estimated_delivery_time` datetime NULL DEFAULT NULL COMMENT '预计送达时间',
  `delivery_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '配送状态  1立即送出  0选择具体时间',
  `delivery_time` datetime NULL DEFAULT NULL COMMENT '送达时间',
  `pack_amount` int NULL DEFAULT NULL COMMENT '打包费',
  `tableware_number` int NULL DEFAULT NULL COMMENT '餐具数量',
  `tableware_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '餐具数量状态  1按餐量提供  0选择具体数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 53 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (4, '1752727069635', 5, 4, 4, '2025-07-16 12:37:50', NULL, 1, 0, 51.00, '', '16638281093', '不知道', NULL, '雷军', '支付超时，取消订单', NULL, '2025-07-19 14:59:00', '2025-07-17 13:37:00', 0, NULL, 2, 0, 0);
INSERT INTO `orders` VALUES (5, '1752727090434', 5, 4, 4, '2025-07-16 12:38:10', NULL, 1, 0, 35.00, '', '16638281093', '不知道', NULL, '雷军', '支付超时，取消订单', NULL, '2025-07-19 14:59:00', '2025-07-17 13:38:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (6, '1752727177867', 5, 4, 4, '2025-07-15 12:39:38', NULL, 1, 0, 8.00, '', '16638281093', '不知道', NULL, '雷军', '支付超时，取消订单', NULL, '2025-07-19 14:59:00', '2025-07-17 13:38:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (7, '1752735099460', 5, 4, 2, '2025-07-15 14:51:39', NULL, 1, 0, 12.00, '', '16638281093', '阳固镇', NULL, '秦毅', '支付超时，取消订单', NULL, '2025-07-19 14:59:00', '2025-07-17 15:51:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (8, '1752735128513', 5, 4, 2, '2025-07-14 14:52:09', NULL, 1, 0, 12.00, '', '16638281093', '阳固镇', NULL, '秦毅', '支付超时，取消订单', NULL, '2025-07-19 14:59:00', '2025-07-17 15:52:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (9, '1752746707849', 5, 4, 2, '2025-07-14 18:05:08', '2025-07-17 18:05:12', 1, 1, 12.00, '', '16638281093', '阳固镇', NULL, '秦毅', '不送了', NULL, '2025-07-18 19:47:01', '2025-07-17 19:05:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (10, '1752746735000', 5, 4, 2, '2025-07-13 18:05:35', '2025-07-17 18:05:37', 1, 1, 41.00, '', '16638281093', '阳固镇', NULL, '秦毅', '客户电话取消', NULL, '2025-07-18 19:51:09', '2025-07-17 19:05:00', 0, NULL, 2, 0, 0);
INSERT INTO `orders` VALUES (11, '1752752086170', 5, 4, 2, '2025-07-13 19:34:46', '2025-07-17 19:34:51', 1, 1, 101.00, '', '16638281093', '阳固镇', NULL, '秦毅', NULL, NULL, NULL, '2025-07-17 20:34:00', 0, '2025-07-18 20:16:01', 2, 0, 0);
INSERT INTO `orders` VALUES (12, '1752753606880', 5, 4, 2, '2025-07-12 20:00:07', '2025-07-17 20:00:09', 1, 1, 12.00, '', '16638281093', '阳固镇', NULL, '秦毅', '订单量较多，暂时无法接单', NULL, '2025-07-18 19:47:24', '2025-07-17 21:00:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (13, '1752756051245', 5, 4, 2, '2025-07-12 20:40:51', '2025-07-17 20:40:53', 1, 2, 12.00, '', '16638281093', '阳固镇', NULL, '秦毅', '不送了', NULL, '2025-07-18 20:34:44', '2025-07-17 21:40:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (16, '1752819146388', 5, 4, 2, '2025-07-17 14:12:26', '2025-07-18 14:12:28', 1, 1, 12.00, '', '16638281093', '阳固镇', NULL, '秦毅', '菜品已销售完，暂时无法接单', NULL, '2025-07-18 19:25:34', '2025-07-18 15:12:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (17, '1752821165017', 5, 4, 2, '2025-07-17 14:46:05', '2025-07-18 14:46:07', 1, 1, 35.00, '', '16638281093', '阳固镇', NULL, '秦毅', '用户取消', NULL, '2025-07-18 14:46:13', '2025-07-18 15:46:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (18, '1752821281344', 5, 4, 2, '2025-07-18 14:48:01', '2025-07-18 14:48:03', 1, 1, 12.00, '', '16638281093', '阳固镇', NULL, '秦毅', '用户取消', NULL, '2025-07-18 14:48:07', '2025-07-18 15:48:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (19, '1752822513375', 5, 4, 2, '2025-07-18 15:08:33', '2025-07-18 15:08:35', 1, 1, 12.00, '', '16638281093', '阳固镇', NULL, '秦毅', '骑手不足无法配送', NULL, '2025-07-18 19:25:30', '2025-07-18 16:08:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (20, '1752826441411', 5, 4, 2, '2025-07-18 16:14:01', '2025-07-18 16:14:03', 1, 1, 203.00, '', '16638281093', '阳固镇', NULL, '秦毅', '客户电话取消', NULL, '2025-07-18 19:26:17', '2025-07-18 17:13:00', 0, NULL, 4, 0, 0);
INSERT INTO `orders` VALUES (21, '1752835951702', 5, 4, 2, '2025-07-18 18:52:32', '2025-07-18 18:52:34', 1, 1, 12.00, '', '16638281093', '阳固镇', NULL, '秦毅', NULL, '黑名单商家', NULL, '2025-07-18 19:52:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (22, '1752835968126', 5, 4, 2, '2025-07-18 18:52:48', '2025-07-18 18:52:50', 1, 1, 82.00, '', '16638281093', '阳固镇', NULL, '秦毅', NULL, '订单量较多，暂时无法接单', NULL, '2025-07-18 19:52:00', 0, NULL, 5, 0, 0);
INSERT INTO `orders` VALUES (23, '1752835977222', 5, 4, 2, '2025-07-18 18:52:57', '2025-07-18 18:52:59', 1, 1, 82.00, '', '16638281093', '阳固镇', NULL, '秦毅', '用户取消', NULL, '2025-07-18 18:53:21', '2025-07-18 19:52:00', 0, NULL, 5, 0, 0);
INSERT INTO `orders` VALUES (24, '1752836244698', 5, 4, 2, '2025-07-18 18:57:25', '2025-07-18 18:57:26', 1, 1, 12.00, '', '16638281093', '阳固镇', NULL, '秦毅', NULL, NULL, NULL, '2025-07-18 19:57:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (25, '1752836309406', 5, 4, 2, '2025-07-18 18:58:29', '2025-07-18 18:58:31', 1, 1, 405.00, '不要打电话，直接放门口', '16638281093', '阳固镇', NULL, '秦毅', '店铺有急事，望理解', NULL, '2025-07-18 19:25:10', '2025-07-18 19:58:00', 0, NULL, 5, 1, 0);
INSERT INTO `orders` VALUES (26, '1752838004200', 5, 4, 2, '2025-07-18 19:26:44', NULL, 1, 0, 509.00, '', '16638281093', '阳固镇', NULL, '秦毅', '支付超时，取消订单', NULL, '2025-07-19 14:59:00', '2025-07-18 20:26:00', 0, NULL, 12, 0, 0);
INSERT INTO `orders` VALUES (27, '1752838027836', 5, 4, 2, '2025-07-18 19:27:08', '2025-07-18 19:27:09', 1, 1, 397.00, '', '16638281093', '阳固镇', NULL, '秦毅', NULL, '订单量较多，暂时无法接单', NULL, '2025-07-18 20:27:00', 0, NULL, 19, 0, 0);
INSERT INTO `orders` VALUES (28, '1752840981730', 5, 4, 2, '2025-07-18 20:16:22', '2025-07-18 20:16:23', 1, 1, 397.00, '', '16638281093', '阳固镇', NULL, '秦毅', '支付超时，取消订单', NULL, '2025-07-19 12:07:05', '2025-07-18 21:16:00', 0, NULL, 19, 0, 0);
INSERT INTO `orders` VALUES (29, '1752840992851', 5, 4, 2, '2025-07-18 20:16:33', '2025-07-18 20:16:34', 1, 1, 405.00, '', '16638281093', '阳固镇', NULL, '秦毅', '支付超时，取消订单', NULL, '2025-07-19 12:07:05', '2025-07-18 21:16:00', 0, NULL, 5, 0, 0);
INSERT INTO `orders` VALUES (30, '1752841002510', 5, 4, 2, '2025-07-18 20:16:43', '2025-07-18 20:16:44', 1, 1, 82.00, '', '16638281093', '阳固镇', NULL, '秦毅', NULL, '菜品已销售完，暂时无法接单', '2025-07-18 20:20:06', '2025-07-18 21:16:00', 0, NULL, 5, 0, 0);
INSERT INTO `orders` VALUES (31, '1752841636853', 5, 4, 2, '2025-07-18 20:27:17', '2025-07-18 20:27:18', 1, 1, 12.00, '放门口', '16638281093', '阳固镇', NULL, '秦毅', '用户取消', NULL, '2025-07-18 20:30:07', '2025-07-18 21:27:00', 0, NULL, 1, 3, 0);
INSERT INTO `orders` VALUES (32, '1752841966082', 5, 4, 2, '2025-07-18 20:32:46', '2025-07-18 20:32:48', 1, 2, 12.00, '', '16638281093', '阳固镇', NULL, '秦毅', NULL, '不送了', '2025-07-18 20:34:54', '2025-07-18 21:32:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (33, '1752851290994', 5, 4, 2, '2025-07-18 23:08:11', NULL, 1, 0, 12.00, '', '16638281093', '阳固镇', NULL, '秦毅', '支付超时，取消订单', NULL, '2025-07-19 14:59:00', '2025-07-18 00:08:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (34, '1752851475398', 5, 4, 5, '2025-07-18 23:11:15', '2025-07-18 23:12:09', 1, 1, 12.00, '', '16638281066', '上地十街12号', NULL, '小明', '支付超时，取消订单', NULL, '2025-07-19 12:07:05', '2025-07-18 00:11:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (35, '1752898045367', 5, 4, 5, '2025-07-19 12:07:25', NULL, 1, 0, 12.00, '', '16638281066', '上地十街12号', NULL, '小明', '支付超时，取消订单', NULL, '2025-07-19 14:59:00', '2025-07-19 13:07:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (36, '1752898055772', 5, 4, 5, '2025-07-19 12:07:36', '2025-07-19 12:07:42', 1, 1, 41.00, '', '16638281066', '上地十街12号', NULL, '小明', NULL, NULL, NULL, '2025-07-19 13:07:00', 0, '2025-07-20 16:05:10', 2, 0, 0);
INSERT INTO `orders` VALUES (37, '1752898080330', 5, 4, 5, '2025-07-19 12:08:00', '2025-07-19 12:08:02', 1, 1, 305.00, '', '16638281066', '上地十街12号', NULL, '小明', '订单已经完成', NULL, NULL, '2025-07-19 13:07:00', 0, NULL, 6, 0, 0);
INSERT INTO `orders` VALUES (38, '1752898142152', 6, 4, 5, '2025-07-19 12:09:02', NULL, 1, 0, 305.00, '', '16638281066', '上地十街12号', NULL, '小明', '支付超时，取消订单', NULL, '2025-07-19 14:59:00', '2025-07-19 13:09:00', 0, NULL, 6, 0, 0);
INSERT INTO `orders` VALUES (39, '1752898152115', 5, 4, 5, '2025-07-19 12:09:12', '2025-07-19 12:09:14', 1, 1, 147.00, '', '16638281066', '上地十街12号', NULL, '小明', '订单已经完成', NULL, NULL, '2025-07-19 13:09:00', 0, NULL, 4, 0, 0);
INSERT INTO `orders` VALUES (40, '1752898161758', 5, 4, 5, '2025-07-19 12:09:22', '2025-07-19 12:09:23', 1, 1, 188.00, '', '16638281066', '上地十街12号', NULL, '小明', '订单已经完成', NULL, NULL, '2025-07-19 13:09:00', 0, NULL, 8, 0, 0);
INSERT INTO `orders` VALUES (41, '1752898171181', 5, 4, 5, '2025-07-19 12:09:31', '2025-07-19 12:09:33', 1, 1, 273.00, '', '16638281066', '上地十街12号', NULL, '小明', '订单已经完成', NULL, NULL, '2025-07-19 13:09:00', 0, NULL, 13, 0, 0);
INSERT INTO `orders` VALUES (42, '1752908235601', 6, 4, 5, '2025-07-19 14:57:16', NULL, 1, 0, 12.00, '', '16638281066', '上地十街12号', NULL, '小明', '支付超时，取消订单', NULL, '2025-07-19 15:13:00', '2025-07-19 15:57:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (43, '1752915468259', 5, 4, 5, '2025-07-19 16:57:48', '2025-07-19 16:57:53', 1, 1, 12.00, '', '16638281066', '上地十街12号', NULL, '小明', NULL, NULL, NULL, '2025-07-19 17:57:00', 0, '2025-07-20 16:05:10', 1, 0, 0);
INSERT INTO `orders` VALUES (44, '1752915518202', 5, 4, 5, '2025-07-19 16:58:38', '2025-07-19 16:58:48', 1, 1, 12.00, '', '16638281066', '上地十街12号', NULL, '小明', NULL, NULL, NULL, '2025-07-19 17:58:00', 0, '2025-07-20 16:05:10', 1, 0, 0);
INSERT INTO `orders` VALUES (45, '1752918193686', 5, 4, 5, '2025-07-19 17:43:14', '2025-07-19 17:43:15', 1, 1, 12.00, '', '16638281066', '上地十街12号', NULL, '小明', NULL, NULL, NULL, '2025-07-19 18:43:00', 0, '2025-07-20 16:05:09', 1, 0, 0);
INSERT INTO `orders` VALUES (46, '1752918220943', 5, 4, 5, '2025-07-19 17:43:41', '2025-07-19 17:43:43', 1, 1, 12.00, '', '16638281066', '上地十街12号', NULL, '小明', NULL, NULL, NULL, '2025-07-19 18:43:00', 0, '2025-07-20 16:05:09', 1, 0, 0);
INSERT INTO `orders` VALUES (47, '1752918338869', 5, 4, 5, '2025-07-19 17:45:39', '2025-07-19 17:45:41', 1, 1, 12.00, '', '16638281066', '上地十街12号', NULL, '小明', NULL, NULL, NULL, '2025-07-19 18:45:00', 0, '2025-07-20 16:05:09', 1, 0, 0);
INSERT INTO `orders` VALUES (48, '1752918500310', 5, 4, 5, '2025-07-19 17:48:20', '2025-07-19 17:48:31', 1, 1, 12.00, '', '16638281066', '上地十街12号', NULL, '小明', NULL, NULL, NULL, '2025-07-19 18:48:00', 0, '2025-07-20 16:05:09', 1, 0, 0);
INSERT INTO `orders` VALUES (49, '1752918647456', 5, 4, 5, '2025-07-19 17:50:47', '2025-07-19 17:50:49', 1, 1, 12.00, '', '16638281066', '上地十街12号', NULL, '小明', '订单已经完成', NULL, NULL, '2025-07-19 18:50:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (50, '1752997945747', 5, 4, 5, '2025-07-20 15:52:26', '2025-07-20 15:52:27', 1, 1, 117.00, '', '16638281066', '上地十街12号', NULL, '小明', NULL, NULL, NULL, '2025-07-20 16:52:00', 0, '2025-07-20 16:05:08', 7, 0, 0);
INSERT INTO `orders` VALUES (51, '1752997955945', 5, 4, 5, '2025-07-20 15:52:36', '2025-07-20 15:52:38', 1, 1, 548.00, '', '16638281066', '上地十街12号', NULL, '小明', NULL, NULL, NULL, '2025-07-20 16:52:00', 0, '2025-07-20 16:05:08', 12, 0, 0);
INSERT INTO `orders` VALUES (52, '1752997993761', 5, 4, 5, '2025-07-20 15:53:14', '2025-07-20 15:53:15', 1, 1, 624.00, '', '16638281066', '上地十街12号', NULL, '小明', NULL, NULL, NULL, '2025-07-20 16:53:00', 0, '2025-07-20 16:05:07', 16, 0, 0);

-- ----------------------------
-- Table structure for setmeal
-- ----------------------------
DROP TABLE IF EXISTS `setmeal`;
CREATE TABLE `setmeal`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `category_id` bigint NOT NULL COMMENT '菜品分类id',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '套餐名称',
  `price` decimal(10, 2) NOT NULL COMMENT '套餐价格',
  `status` int NULL DEFAULT 1 COMMENT '售卖状态 0:停售 1:起售',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '描述信息',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '图片',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint NULL DEFAULT NULL COMMENT '创建人',
  `update_user` bigint NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_setmeal_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '套餐' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of setmeal
-- ----------------------------
INSERT INTO `setmeal` VALUES (42, 15, 'KFC简易套餐', 15.00, 1, '', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/a28f7b2d-ba99-4cf0-9674-7fa00471e189.png', '2025-07-15 16:41:13', '2025-07-15 16:41:13', 1, 1);
INSERT INTO `setmeal` VALUES (43, 27, '茶颜悦色', 28.00, 1, '', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/956723ef-fd0e-4bd4-ba99-ee33a9c4d27f.png', '2025-07-15 16:47:41', '2025-07-15 16:47:41', 1, 1);
INSERT INTO `setmeal` VALUES (44, 27, '蜜雪冰城', 5.00, 1, '', 'https://sky-take-out-single.oss-cn-beijing.aliyuncs.com/c01334c3-a29d-4ae9-83e8-0339ccbcd555.png', '2025-07-16 18:31:03', '2025-07-16 18:31:03', 1, 1);

-- ----------------------------
-- Table structure for setmeal_dish
-- ----------------------------
DROP TABLE IF EXISTS `setmeal_dish`;
CREATE TABLE `setmeal_dish`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `setmeal_id` bigint NULL DEFAULT NULL COMMENT '套餐id',
  `dish_id` bigint NULL DEFAULT NULL COMMENT '菜品id',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '菜品名称 （冗余字段）',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '菜品单价（冗余字段）',
  `copies` int NULL DEFAULT NULL COMMENT '菜品份数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '套餐菜品关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of setmeal_dish
-- ----------------------------
INSERT INTO `setmeal_dish` VALUES (54, NULL, 49, '米饭', 2.00, 1);
INSERT INTO `setmeal_dish` VALUES (55, NULL, 66, '江团鱼2斤', 119.00, 1);
INSERT INTO `setmeal_dish` VALUES (56, NULL, 65, '草鱼2斤', 68.00, 1);
INSERT INTO `setmeal_dish` VALUES (57, NULL, 60, '梅菜扣肉', 58.00, 1);
INSERT INTO `setmeal_dish` VALUES (58, NULL, 61, '剁椒鱼头', 66.00, 1);
INSERT INTO `setmeal_dish` VALUES (59, NULL, 66, '江团鱼2斤', 119.00, 1);
INSERT INTO `setmeal_dish` VALUES (60, NULL, 67, '鮰鱼2斤', 72.00, 1);
INSERT INTO `setmeal_dish` VALUES (61, NULL, 47, '北冰洋', 4.00, 1);
INSERT INTO `setmeal_dish` VALUES (62, NULL, 48, '雪花啤酒', 4.00, 1);
INSERT INTO `setmeal_dish` VALUES (65, 34, 64, '馋嘴牛蛙', 88.00, 1);
INSERT INTO `setmeal_dish` VALUES (66, 34, 62, '金汤酸菜牛蛙', 88.00, 1);
INSERT INTO `setmeal_dish` VALUES (67, 34, 63, '香锅牛蛙', 88.00, 1);
INSERT INTO `setmeal_dish` VALUES (71, NULL, 36, '鸡块', 8.00, 1);
INSERT INTO `setmeal_dish` VALUES (72, NULL, 36, '薯条', 7.00, 1);
INSERT INTO `setmeal_dish` VALUES (73, NULL, 37, '鸡块', 8.00, 1);
INSERT INTO `setmeal_dish` VALUES (74, NULL, 37, '薯条', 7.00, 1);
INSERT INTO `setmeal_dish` VALUES (77, 41, 86, '鸡块', 8.00, 1);
INSERT INTO `setmeal_dish` VALUES (78, 41, 85, '薯条', 7.00, 1);
INSERT INTO `setmeal_dish` VALUES (95, 42, 85, '薯条', 7.00, 1);
INSERT INTO `setmeal_dish` VALUES (96, 42, 86, '鸡块', 8.00, 1);
INSERT INTO `setmeal_dish` VALUES (98, 44, 88, '柠檬水', 4.00, 2);
INSERT INTO `setmeal_dish` VALUES (99, 43, 88, '柠檬水', 4.00, 2);
INSERT INTO `setmeal_dish` VALUES (100, 43, 87, '茶颜悦色', 16.00, 2);

-- ----------------------------
-- Table structure for shopping_cart
-- ----------------------------
DROP TABLE IF EXISTS `shopping_cart`;
CREATE TABLE `shopping_cart`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '商品名称',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '图片',
  `user_id` bigint NOT NULL COMMENT '主键',
  `dish_id` bigint NULL DEFAULT NULL COMMENT '菜品id',
  `setmeal_id` bigint NULL DEFAULT NULL COMMENT '套餐id',
  `dish_flavor` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '口味',
  `number` int NOT NULL DEFAULT 1 COMMENT '数量',
  `amount` decimal(10, 2) NOT NULL COMMENT '金额',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 165 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '购物车' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shopping_cart
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `openid` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '微信用户唯一标识',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '姓名',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '手机号',
  `sex` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '性别',
  `id_number` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '身份证号',
  `avatar` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '头像',
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '用户信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (4, 'osLZHvgP5o-vMrOs5pVgYKQ3OOoI', NULL, NULL, NULL, NULL, NULL, '2025-07-14 15:03:44');
INSERT INTO `user` VALUES (5, '1111111', NULL, NULL, NULL, NULL, NULL, '2025-07-12 21:17:40');
INSERT INTO `user` VALUES (6, 'osLZHvgP5o-vMrOs5pVgYKQ3OO99', '张三', '13800138001', '男', '110101199001011234', 'https://avatar.com/1.jpg', '2025-07-12 09:15:22');
INSERT INTO `user` VALUES (7, 'osLZHvgP5o-vMrOs5pVgYKQ3OOo2', '李四', '13800138002', '男', '110101199002021235', 'https://avatar.com/2.jpg', '2025-07-12 11:30:45');
INSERT INTO `user` VALUES (8, 'osLZHvgP5o-vMrOs5pVgYKQ3OOo3', '王五', '13800138003', '男', '110101199003031236', 'https://avatar.com/3.jpg', '2025-07-12 14:45:18');
INSERT INTO `user` VALUES (9, 'osLZHvgP5o-vMrOs5pVgYKQ3OOo4', '赵六', '13800138004', '男', '110101199004041237', 'https://avatar.com/4.jpg', '2025-07-12 16:20:33');
INSERT INTO `user` VALUES (10, 'osLZHvgP5o-vMrOs5pVgYKQ3OOo5', '钱七', '13800138005', '女', '110101199005051238', 'https://avatar.com/5.jpg', '2025-07-12 18:55:07');
INSERT INTO `user` VALUES (11, '1111111', '孙八', '13800138006', '女', '110101199006061239', 'https://avatar.com/6.jpg', '2025-07-12 21:17:40');
INSERT INTO `user` VALUES (12, 'osLZHvgP5o-vMrOs5pVgYKQ3OOo7', '周九', '13800138007', '男', '110101199007071240', 'https://avatar.com/7.jpg', '2025-07-13 08:12:19');
INSERT INTO `user` VALUES (13, 'osLZHvgP5o-vMrOs5pVgYKQ3OOo8', '吴十', '13800138008', '男', '110101199008081241', 'https://avatar.com/8.jpg', '2025-07-13 10:25:42');
INSERT INTO `user` VALUES (14, 'osLZHvgP5o-vMrOs5pVgYKQ3OOo9', '郑十一', '13800138009', '女', '110101199009091242', 'https://avatar.com/9.jpg', '2025-07-13 13:40:15');
INSERT INTO `user` VALUES (15, 'osLZHvgP5o-vMrOs5pVgYKQ3OO10', '王十二', '13800138010', '女', '110101199010101243', 'https://avatar.com/10.jpg', '2025-07-13 15:05:28');
INSERT INTO `user` VALUES (16, 'osLZHvgP5o-vMrOs5pVgYKQ3OO11', '李十三', '13800138011', '男', '110101199011111244', 'https://avatar.com/11.jpg', '2025-07-13 17:30:51');
INSERT INTO `user` VALUES (17, 'osLZHvgP5o-vMrOs5pVgYKQ3OO12', '赵十四', '13800138012', '女', '110101199012121245', 'https://avatar.com/12.jpg', '2025-07-13 20:45:34');
INSERT INTO `user` VALUES (18, 'osLZHvgP5o-vMrOs5pVgYKQ3OO13', '钱十五', '13800138013', '男', '110101199001011246', 'https://avatar.com/13.jpg', '2025-07-14 07:22:13');
INSERT INTO `user` VALUES (19, 'osLZHvgP5o-vMrOs5pVgYKQ3OO14', '孙十六', '13800138014', '女', '110101199002021247', 'https://avatar.com/14.jpg', '2025-07-14 09:35:46');
INSERT INTO `user` VALUES (20, 'osLZHvgP5o-vMrOs5pVgYKQ3OO15', '周十七', '13800138015', '男', '110101199003031248', 'https://avatar.com/15.jpg', '2025-07-14 12:50:29');
INSERT INTO `user` VALUES (21, 'osLZHvgP5o-vMrOs5pVgYKQ3OO16', '吴十八', '13800138016', '女', '110101199004041249', 'https://avatar.com/16.jpg', '2025-07-14 14:15:32');
INSERT INTO `user` VALUES (22, 'osLZHvgP5o-vMrOs5pVgYKQ3OO17', '郑十九', '13800138017', '男', '110101199005051250', 'https://avatar.com/17.jpg', '2025-07-14 16:40:55');
INSERT INTO `user` VALUES (23, 'osLZHvgP5o-vMrOs5pVgYKQ3OO18', '王二十', '13800138018', '女', '110101199006061251', 'https://avatar.com/18.jpg', '2025-07-14 19:05:38');
INSERT INTO `user` VALUES (24, 'osLZHvgP5o-vMrOs5pVgYKQ3OO19', '李二十一', '13800138019', '男', '110101199007071252', 'https://avatar.com/19.jpg', '2025-07-15 08:32:14');
INSERT INTO `user` VALUES (25, 'osLZHvgP5o-vMrOs5pVgYKQ3OO20', '赵二十二', '13800138020', '女', '110101199008081253', 'https://avatar.com/20.jpg', '2025-07-15 10:45:47');
INSERT INTO `user` VALUES (26, 'osLZHvgP5o-vMrOs5pVgYKQ3OO21', '钱二十三', '13800138021', '男', '110101199009091254', 'https://avatar.com/21.jpg', '2025-07-15 13:00:20');
INSERT INTO `user` VALUES (27, 'osLZHvgP5o-vMrOs5pVgYKQ3OO22', '孙二十四', '13800138022', '女', '110101199010101255', 'https://avatar.com/22.jpg', '2025-07-15 15:25:43');
INSERT INTO `user` VALUES (28, 'osLZHvgP5o-vMrOs5pVgYKQ3OO23', '周二十五', '13800138023', '男', '110101199011111256', 'https://avatar.com/23.jpg', '2025-07-15 17:50:16');
INSERT INTO `user` VALUES (29, 'osLZHvgP5o-vMrOs5pVgYKQ3OO24', '吴二十六', '13800138024', '女', '110101199012121257', 'https://avatar.com/24.jpg', '2025-07-15 20:15:39');
INSERT INTO `user` VALUES (30, 'osLZHvgP5o-vMrOs5pVgYKQ3OO25', '郑二十七', '13800138025', '男', '110101199001011258', 'https://avatar.com/25.jpg', '2025-07-16 07:42:15');
INSERT INTO `user` VALUES (31, 'osLZHvgP5o-vMrOs5pVgYKQ3OO26', '王二十八', '13800138026', '女', '110101199002021259', 'https://avatar.com/26.jpg', '2025-07-16 09:55:48');
INSERT INTO `user` VALUES (32, 'osLZHvgP5o-vMrOs5pVgYKQ3OO27', '李二十九', '13800138027', '男', '110101199003031260', 'https://avatar.com/27.jpg', '2025-07-16 12:10:21');
INSERT INTO `user` VALUES (33, 'osLZHvgP5o-vMrOs5pVgYKQ3OO28', '赵三十', '13800138028', '女', '110101199004041261', 'https://avatar.com/28.jpg', '2025-07-16 14:35:44');
INSERT INTO `user` VALUES (34, 'osLZHvgP5o-vMrOs5pVgYKQ3OO29', '钱三十一', '13800138029', '男', '110101199005051262', 'https://avatar.com/29.jpg', '2025-07-16 17:00:17');
INSERT INTO `user` VALUES (35, 'osLZHvgP5o-vMrOs5pVgYKQ3OO30', '孙三十二', '13800138030', '女', '110101199006061263', 'https://avatar.com/30.jpg', '2025-07-16 19:25:40');
INSERT INTO `user` VALUES (36, 'osLZHvgP5o-vMrOs5pVgYKQ3OO31', '周三十三', '13800138031', '男', '110101199007071264', 'https://avatar.com/31.jpg', '2025-07-17 08:52:16');
INSERT INTO `user` VALUES (37, 'osLZHvgP5o-vMrOs5pVgYKQ3OO32', '吴三十四', '13800138032', '女', '110101199008081265', 'https://avatar.com/32.jpg', '2025-07-17 11:05:49');
INSERT INTO `user` VALUES (38, 'osLZHvgP5o-vMrOs5pVgYKQ3OO33', '郑三十五', '13800138033', '男', '110101199009091266', 'https://avatar.com/33.jpg', '2025-07-17 13:20:22');
INSERT INTO `user` VALUES (39, 'osLZHvgP5o-vMrOs5pVgYKQ3OO34', '王三十六', '13800138034', '女', '110101199010101267', 'https://avatar.com/34.jpg', '2025-07-17 15:45:45');
INSERT INTO `user` VALUES (40, 'osLZHvgP5o-vMrOs5pVgYKQ3OO35', '李三十七', '13800138035', '男', '110101199011111268', 'https://avatar.com/35.jpg', '2025-07-17 18:10:18');
INSERT INTO `user` VALUES (41, 'osLZHvgP5o-vMrOs5pVgYKQ3OO36', '赵三十八', '13800138036', '女', '110101199012121269', 'https://avatar.com/36.jpg', '2025-07-18 07:32:14');
INSERT INTO `user` VALUES (42, 'osLZHvgP5o-vMrOs5pVgYKQ3OO37', '钱三十九', '13800138037', '男', '110101199001011270', 'https://avatar.com/37.jpg', '2025-07-18 09:45:47');
INSERT INTO `user` VALUES (43, 'osLZHvgP5o-vMrOs5pVgYKQ3OO38', '孙四十', '13800138038', '女', '110101199002021271', 'https://avatar.com/38.jpg', '2025-07-20 12:00:20');
INSERT INTO `user` VALUES (44, 'osLZHvgP5o-vMrOs5pVgYKQ3OO39', '周四十一', '13800138039', '男', '110101199003031272', 'https://avatar.com/39.jpg', '2025-07-18 14:25:43');
INSERT INTO `user` VALUES (45, 'osLZHvgP5o-vMrOs5pVgYKQ3OO40', '吴四十二', '13800138040', '女', '110101199004041273', 'https://avatar.com/40.jpg', '2025-07-18 16:50:16');

SET FOREIGN_KEY_CHECKS = 1;
