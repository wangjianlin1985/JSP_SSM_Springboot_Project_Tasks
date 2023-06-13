/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50051
Source Host           : localhost:3306
Source Database       : product_db

Target Server Type    : MYSQL
Target Server Version : 50051
File Encoding         : 65001

Date: 2017-12-21 02:04:01
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `admin`
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `username` varchar(20) NOT NULL default '',
  `password` varchar(32) default NULL,
  PRIMARY KEY  (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('a', 'a');

-- ----------------------------
-- Table structure for `t_comment`
-- ----------------------------
DROP TABLE IF EXISTS `t_comment`;
CREATE TABLE `t_comment` (
  `commentId` int(11) NOT NULL auto_increment COMMENT '评论id',
  `productObj` int(11) NOT NULL COMMENT '被评商品',
  `content` varchar(1000) NOT NULL COMMENT '评论内容',
  `userObj` varchar(30) NOT NULL COMMENT '评论用户',
  `commentTime` varchar(20) default NULL COMMENT '评论时间',
  PRIMARY KEY  (`commentId`),
  KEY `productObj` (`productObj`),
  KEY `userObj` (`userObj`),
  CONSTRAINT `t_comment_ibfk_1` FOREIGN KEY (`productObj`) REFERENCES `t_product` (`productId`),
  CONSTRAINT `t_comment_ibfk_2` FOREIGN KEY (`userObj`) REFERENCES `t_userinfo` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_comment
-- ----------------------------
INSERT INTO `t_comment` VALUES ('1', '1', '非常好看的手机', 'user2', '2017-12-20 14:15:13');
INSERT INTO `t_comment` VALUES ('2', '1', '我下次还会来买的！', 'user2', '2017-12-20 23:34:04');

-- ----------------------------
-- Table structure for `t_notice`
-- ----------------------------
DROP TABLE IF EXISTS `t_notice`;
CREATE TABLE `t_notice` (
  `noticeId` int(11) NOT NULL auto_increment COMMENT '公告id',
  `title` varchar(80) NOT NULL COMMENT '标题',
  `content` varchar(5000) NOT NULL COMMENT '公告内容',
  `publishDate` varchar(20) default NULL COMMENT '发布时间',
  PRIMARY KEY  (`noticeId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_notice
-- ----------------------------
INSERT INTO `t_notice` VALUES ('1', '二手购物网站成立了', '<p>以后同学们可以来这里淘到你们心意的宝贝了！</p>', '2017-12-20 00:31:10');

-- ----------------------------
-- Table structure for `t_orderinfo`
-- ----------------------------
DROP TABLE IF EXISTS `t_orderinfo`;
CREATE TABLE `t_orderinfo` (
  `orderNo` varchar(30) NOT NULL COMMENT 'orderNo',
  `userObj` varchar(30) NOT NULL COMMENT '下单用户',
  `totalMoney` float NOT NULL COMMENT '订单总金额',
  `payWay` varchar(20) NOT NULL COMMENT '支付方式',
  `orderStateObj` varchar(20) NOT NULL COMMENT '订单状态',
  `orderTime` varchar(20) default NULL COMMENT '下单时间',
  `receiveName` varchar(20) NOT NULL COMMENT '收货人',
  `telephone` varchar(20) NOT NULL COMMENT '收货人电话',
  `address` varchar(80) NOT NULL COMMENT '收货地址',
  `orderMemo` varchar(500) default NULL COMMENT '订单备注',
  `sellObj` varchar(30) NOT NULL COMMENT '商家',
  PRIMARY KEY  (`orderNo`),
  KEY `userObj` (`userObj`),
  KEY `sellObj` (`sellObj`),
  CONSTRAINT `t_orderinfo_ibfk_1` FOREIGN KEY (`userObj`) REFERENCES `t_userinfo` (`user_name`),
  CONSTRAINT `t_orderinfo_ibfk_2` FOREIGN KEY (`sellObj`) REFERENCES `t_userinfo` (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_orderinfo
-- ----------------------------
INSERT INTO `t_orderinfo` VALUES ('user2201712210141291', 'user2', '3373', '支付宝', '待付款', '2017-12-21 01:41:29', '李倩', '13589834234', '福建福州滨海路', '尽快发货吧！', 'user1');
INSERT INTO `t_orderinfo` VALUES ('user2201712210141292', 'user2', '1299', '支付宝', '待付款', '2017-12-21 01:41:29', '李倩', '13589834234', '福建福州滨海路', '尽快发货吧！', 'user3');

-- ----------------------------
-- Table structure for `t_orderitem`
-- ----------------------------
DROP TABLE IF EXISTS `t_orderitem`;
CREATE TABLE `t_orderitem` (
  `itemId` int(11) NOT NULL auto_increment COMMENT '条目id',
  `orderObj` varchar(30) NOT NULL COMMENT '所属订单',
  `productObj` int(11) NOT NULL COMMENT '订单商品',
  `price` float NOT NULL COMMENT '商品单价',
  `orderNumer` int(11) NOT NULL COMMENT '购买数量',
  PRIMARY KEY  (`itemId`),
  KEY `orderObj` (`orderObj`),
  KEY `productObj` (`productObj`),
  CONSTRAINT `t_orderitem_ibfk_1` FOREIGN KEY (`orderObj`) REFERENCES `t_orderinfo` (`orderNo`),
  CONSTRAINT `t_orderitem_ibfk_2` FOREIGN KEY (`productObj`) REFERENCES `t_product` (`productId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_orderitem
-- ----------------------------
INSERT INTO `t_orderitem` VALUES ('2', 'user2201712210141291', '1', '800', '2');
INSERT INTO `t_orderitem` VALUES ('3', 'user2201712210141291', '4', '1773', '1');
INSERT INTO `t_orderitem` VALUES ('4', 'user2201712210141292', '2', '1299', '1');

-- ----------------------------
-- Table structure for `t_product`
-- ----------------------------
DROP TABLE IF EXISTS `t_product`;
CREATE TABLE `t_product` (
  `productId` int(11) NOT NULL auto_increment COMMENT '商品编号',
  `productClassObj` int(11) NOT NULL COMMENT '商品类别',
  `productName` varchar(50) NOT NULL COMMENT '商品名称',
  `mainPhoto` varchar(60) NOT NULL COMMENT '商品主图',
  `price` float NOT NULL COMMENT '商品价格',
  `productDesc` varchar(5000) NOT NULL COMMENT '商品描述',
  `userObj` varchar(30) NOT NULL COMMENT '发布用户',
  `addTime` varchar(20) default NULL COMMENT '发布时间',
  PRIMARY KEY  (`productId`),
  KEY `productClassObj` (`productClassObj`),
  KEY `userObj` (`userObj`),
  CONSTRAINT `t_product_ibfk_1` FOREIGN KEY (`productClassObj`) REFERENCES `t_productclass` (`classId`),
  CONSTRAINT `t_product_ibfk_2` FOREIGN KEY (`userObj`) REFERENCES `t_userinfo` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_product
-- ----------------------------
INSERT INTO `t_product` VALUES ('1', '1', '9成新苹果5s', 'upload/049477b5-1fcb-419c-8df2-5813acea0423.jpg', '800', '<p>品牌名称：Apple/苹果</p><p>更多参数产品参数：</p><p>证书编号：2013011606639987证书状态：有效申请人名称：美国苹果公司制造商名称：美国苹果公司产品名称：TD-LTE 数字移动电话机3C产品型号：A1530（电源适配器：A1443,输出:5.0VDC,1.0A）（电源适配器为可选部件）3C规格型号：A1530（电源适配器：A1443,输出:5.0VDC,1.0A）（电源适配器为可选部件）产品名称：Apple/苹果 iPhone 5sCPU型号: A7Apple型号: iPhone 5s机身颜色: 金色运行内存RAM: 1GB存储容量: 16GB网络模式: 单卡多模</p><p><br/></p>', 'user1', '2017-12-20 00:11:18');
INSERT INTO `t_product` VALUES ('2', '1', '小米5X 变焦双摄拍照智能手机', 'upload/b0169c8b-4851-41eb-97c2-2b0fda10cba8.jpg', '1299', '<p>证书编号：2017011606972569证书状态：有效产品名称：TD-LTE数字移动电话机3C规格型号：MDE2（电源适配器：MDY-08-EV 输出：5VDC 2.0A）产品名称：Xiaomi/小米 小米5XCPU型号: 骁龙625 型号: 小米5X机身颜色: 金色 玫瑰金 黑色 红色运行内存RAM: 4GB存储容量: 32GB 64GB网络模式: 双卡多模</p>', 'user3', '2017-12-20 23:54:05');
INSERT INTO `t_product` VALUES ('3', '2', 'Dell/戴尔 成就Vostro 15.6英寸四核笔记本', 'upload/e3e514fa-6eab-4892-8f0e-b36ec69a6015.jpg', '2599', '<p>证书编号：2015010902754843证书状态：有效申请人名称：仁宝电脑工业股份有限公司制造商名称：戴尔(中国)有限公司产品名称：便携式计算机3C产品型号：P64G;P51F;P65G;P52F;P64G...;P51F...;P65G...;P52F.....3C规格型号：P64G;P51F;P65G;P52F;P64G...;P51F...;P65G...;P52F.....产品名称：Dell/戴尔 成就Vostro 15品牌: Dell/戴尔型号: 15屏幕尺寸: 15.6英寸CPU: 英特尔 赛扬 N3450显卡类型: AMD Radeon HD显存容量: 2G机械硬盘容量: 1TB内存容量: 4G操作系统: windows 10</p>', 'user3', '2017-12-21 00:08:14');
INSERT INTO `t_product` VALUES ('4', '3', 'Canon/佳能 入门单反数码', 'upload/1a825f55-1637-45cc-bb32-54eef87a96c9.jpg', '1773', '<p>产品名称: Canon/佳能 EOS 1300D套机(18-55mm)单反级别: 入门级是否支持机身防抖: 机身不防抖屏幕尺寸: 3英寸及以上像素: 1800万储存介质: SD卡成色: 全新电池类型: 锂电池售后服务: 店铺三包上市时间: 2015年颜色分类: 1300D单机标配不带镜头有带配件 佳能18-55Ⅲ套机 佳能50 1.8STM套机 佳能18-135mm STM套机 单机+腾龙18-200VC防抖镜头 佳能18-55Ⅲ+55-250IS双头套机 佳能18-55STM套机 ★套餐6+1元换购套餐八★套餐: 官方标配 套餐一 套餐二 套餐三 套餐四 套餐五 套餐六 套餐七 套餐八单反画幅: APS-C画幅感光元件类型: CMOS对焦点数: 9点重量: 401g(含)-500g(含)取景器类型: 光学取景器是否支持外接闪光灯: 支持是否支持机身除尘: 支持是否支持机身马达: 不支持反光装置: 五面镜传感器尺寸: 22.3mmx14.9mm品牌: Canon/佳能佳能单反系列: EOS 1300D套机(18-55m</p>', 'user1', '2017-12-21 00:17:54');

-- ----------------------------
-- Table structure for `t_productclass`
-- ----------------------------
DROP TABLE IF EXISTS `t_productclass`;
CREATE TABLE `t_productclass` (
  `classId` int(11) NOT NULL auto_increment COMMENT '类别id',
  `className` varchar(20) NOT NULL COMMENT '类别名称',
  `classDesc` varchar(500) NOT NULL COMMENT '类别描述',
  PRIMARY KEY  (`classId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_productclass
-- ----------------------------
INSERT INTO `t_productclass` VALUES ('1', '手机相关', '卖所有的手机');
INSERT INTO `t_productclass` VALUES ('2', '电脑相关', '所有的电脑产品');
INSERT INTO `t_productclass` VALUES ('3', '数码产品', '各种数码产品');

-- ----------------------------
-- Table structure for `t_shopcart`
-- ----------------------------
DROP TABLE IF EXISTS `t_shopcart`;
CREATE TABLE `t_shopcart` (
  `cartId` int(11) NOT NULL auto_increment COMMENT '购物车id',
  `productObj` int(11) NOT NULL COMMENT '商品',
  `userObj` varchar(30) NOT NULL COMMENT '用户',
  `price` float NOT NULL COMMENT '单价',
  `buyNum` int(11) NOT NULL COMMENT '购买数量',
  PRIMARY KEY  (`cartId`),
  KEY `productObj` (`productObj`),
  KEY `userObj` (`userObj`),
  CONSTRAINT `t_shopcart_ibfk_1` FOREIGN KEY (`productObj`) REFERENCES `t_product` (`productId`),
  CONSTRAINT `t_shopcart_ibfk_2` FOREIGN KEY (`userObj`) REFERENCES `t_userinfo` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_shopcart
-- ----------------------------
INSERT INTO `t_shopcart` VALUES ('1', '1', 'user1', '800', '2');

-- ----------------------------
-- Table structure for `t_userinfo`
-- ----------------------------
DROP TABLE IF EXISTS `t_userinfo`;
CREATE TABLE `t_userinfo` (
  `user_name` varchar(30) NOT NULL COMMENT 'user_name',
  `password` varchar(30) NOT NULL COMMENT '登录密码',
  `name` varchar(20) NOT NULL COMMENT '姓名',
  `gender` varchar(4) NOT NULL COMMENT '性别',
  `birthDate` varchar(20) default NULL COMMENT '出生日期',
  `userPhoto` varchar(60) NOT NULL COMMENT '用户照片',
  `telephone` varchar(20) NOT NULL COMMENT '联系电话',
  `email` varchar(50) NOT NULL COMMENT '邮箱',
  `address` varchar(80) default NULL COMMENT '家庭地址',
  `regTime` varchar(20) default NULL COMMENT '注册时间',
  PRIMARY KEY  (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_userinfo
-- ----------------------------
INSERT INTO `t_userinfo` VALUES ('user1', '123', '双鱼林', '男', '2017-12-20', 'upload/a228f73f-3fe2-47ec-b4cc-94d4db00ff5a.jpg', '13589834234', 'syl@163.com', '四川成都红星路', '2017-12-20 00:07:40');
INSERT INTO `t_userinfo` VALUES ('user2', '123', '李倩', '女', '2017-12-07', 'upload/7c1e05b9-764e-4f1a-9002-6cce6ac9aab2.jpg', '13589834234', '2141412@qq.com', '福建福州滨海路', '2017-12-20 00:11:56');
INSERT INTO `t_userinfo` VALUES ('user3', '123', '王正', '男', '2017-12-01', 'upload/29814801-afee-45f6-9ccf-aa1b0205f72f.jpg', '13398439834', 'wangzheng@163.com', '四川南充', '2017-12-20 23:51:27');
