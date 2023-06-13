/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50051
Source Host           : localhost:3306
Source Database       : journal_db

Target Server Type    : MYSQL
Target Server Version : 50051
File Encoding         : 65001

Date: 2017-12-22 19:18:12
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
-- Table structure for `t_classinfo`
-- ----------------------------
DROP TABLE IF EXISTS `t_classinfo`;
CREATE TABLE `t_classinfo` (
  `classNo` varchar(20) NOT NULL COMMENT 'classNo',
  `className` varchar(20) NOT NULL COMMENT '班级名称',
  `bornDate` varchar(20) default NULL COMMENT '成立日期',
  `mainTeacher` varchar(20) NOT NULL COMMENT '班主任',
  `classMemo` varchar(500) default NULL COMMENT '备注',
  PRIMARY KEY  (`classNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_classinfo
-- ----------------------------
INSERT INTO `t_classinfo` VALUES ('BJ001', 'java开发速成班', '2017-12-01', '宋大业', '本班级主攻java开发');
INSERT INTO `t_classinfo` VALUES ('BJ002', '安卓开发速成班', '2017-12-02', '李明才', '学习开发智能手机程序');

-- ----------------------------
-- Table structure for `t_group`
-- ----------------------------
DROP TABLE IF EXISTS `t_group`;
CREATE TABLE `t_group` (
  `groupId` int(11) NOT NULL auto_increment COMMENT '分组id',
  `groupName` varchar(20) NOT NULL COMMENT '分组名称',
  PRIMARY KEY  (`groupId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_group
-- ----------------------------
INSERT INTO `t_group` VALUES ('1', '第一项目组');
INSERT INTO `t_group` VALUES ('2', '第二项目组');

-- ----------------------------
-- Table structure for `t_groupstudent`
-- ----------------------------
DROP TABLE IF EXISTS `t_groupstudent`;
CREATE TABLE `t_groupstudent` (
  `gsId` int(11) NOT NULL auto_increment COMMENT '成员id',
  `groupObj` int(11) NOT NULL COMMENT '所在分组',
  `studentObj` varchar(30) NOT NULL COMMENT '学生',
  PRIMARY KEY  (`gsId`),
  KEY `groupObj` (`groupObj`),
  KEY `studentObj` (`studentObj`),
  CONSTRAINT `t_groupstudent_ibfk_1` FOREIGN KEY (`groupObj`) REFERENCES `t_group` (`groupId`),
  CONSTRAINT `t_groupstudent_ibfk_2` FOREIGN KEY (`studentObj`) REFERENCES `t_student` (`studentNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_groupstudent
-- ----------------------------
INSERT INTO `t_groupstudent` VALUES ('1', '1', 'STU001');

-- ----------------------------
-- Table structure for `t_journal`
-- ----------------------------
DROP TABLE IF EXISTS `t_journal`;
CREATE TABLE `t_journal` (
  `journalId` int(11) NOT NULL auto_increment COMMENT '日志id',
  `title` varchar(20) NOT NULL COMMENT '日志标题',
  `content` varchar(5000) NOT NULL COMMENT '日志内容',
  `studentObj` varchar(30) NOT NULL COMMENT '发布学生',
  `addTime` varchar(20) default NULL COMMENT '发布时间',
  `teacherNo` varchar(30) default NULL COMMENT '审核老师',
  `replyContent` varchar(500) default NULL COMMENT '答复内容',
  `replyTime` varchar(20) default NULL COMMENT '答复时间',
  PRIMARY KEY  (`journalId`),
  KEY `studentObj` (`studentObj`),
  CONSTRAINT `t_journal_ibfk_1` FOREIGN KEY (`studentObj`) REFERENCES `t_student` (`studentNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_journal
-- ----------------------------
INSERT INTO `t_journal` VALUES ('1', '今天刚完成了数据库设计', '<p>老师给我们组分配了一个购物网站设计，我完成了其中的数据库设计！</p>', 'STU001', '2017-12-22 04:09:25', 'TH001', '做得很好', '2017-12-22 19:15:42');
INSERT INTO `t_journal` VALUES ('2', '11', '<p>22<br/></p>', 'STU001', '2017-12-22 17:43:20', '--', '--', '--');

-- ----------------------------
-- Table structure for `t_project`
-- ----------------------------
DROP TABLE IF EXISTS `t_project`;
CREATE TABLE `t_project` (
  `projectId` int(11) NOT NULL auto_increment COMMENT '项目id',
  `projectName` varchar(20) NOT NULL COMMENT '项目名称',
  `projectContent` varchar(5000) NOT NULL COMMENT '项目内容',
  `groupObj` int(11) NOT NULL COMMENT '项目任务组',
  `projectFile` varchar(60) NOT NULL COMMENT '项目任务文件',
  `startTime` varchar(20) default NULL COMMENT '开始时间',
  `duration` varchar(20) NOT NULL COMMENT '完成周期',
  `projectProgress` varchar(500) NOT NULL COMMENT '项目进度报告',
  PRIMARY KEY  (`projectId`),
  KEY `groupObj` (`groupObj`),
  CONSTRAINT `t_project_ibfk_1` FOREIGN KEY (`groupObj`) REFERENCES `t_group` (`groupId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_project
-- ----------------------------
INSERT INTO `t_project` VALUES ('1', '基于SSM电子商城购物网站设计', '<p>开发一个基于SSM框架的购物网站，实现商品的查询，添加到购物车，提交订单等常见功能！</p>', '1', 'upload/09119b46-4258-48df-b6a7-91485979f795.doc', '2017-12-22 03:59:18', '2周', '2017-12-22 晚上刚把项目任务布置完成');

-- ----------------------------
-- Table structure for `t_resourceinfo`
-- ----------------------------
DROP TABLE IF EXISTS `t_resourceinfo`;
CREATE TABLE `t_resourceinfo` (
  `resourceId` int(11) NOT NULL auto_increment COMMENT '资源id',
  `projectObj` int(11) NOT NULL COMMENT '项目',
  `studentObj` varchar(30) NOT NULL COMMENT '上传学员',
  `resourceFile` varchar(60) NOT NULL COMMENT '项目资源文件',
  `resourceDesc` varchar(600) NOT NULL COMMENT '项目资源说明',
  `addTime` varchar(20) default NULL COMMENT '上传时间',
  `evaluateContent` varchar(500) default NULL COMMENT '老师评语',
  PRIMARY KEY  (`resourceId`),
  KEY `projectObj` (`projectObj`),
  KEY `studentObj` (`studentObj`),
  CONSTRAINT `t_resourceinfo_ibfk_1` FOREIGN KEY (`projectObj`) REFERENCES `t_project` (`projectId`),
  CONSTRAINT `t_resourceinfo_ibfk_2` FOREIGN KEY (`studentObj`) REFERENCES `t_student` (`studentNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_resourceinfo
-- ----------------------------
INSERT INTO `t_resourceinfo` VALUES ('1', '1', 'STU001', 'upload/41027321-48f7-4845-a1b6-a840791a1e5a.sql', '这是我根据需求设计的数据库表，麻烦老师查阅下！', '2017-12-22 04:26:08', '做得非常好哦！');

-- ----------------------------
-- Table structure for `t_student`
-- ----------------------------
DROP TABLE IF EXISTS `t_student`;
CREATE TABLE `t_student` (
  `studentNumber` varchar(30) NOT NULL COMMENT 'studentNumber',
  `password` varchar(30) NOT NULL COMMENT '登录密码',
  `classObj` varchar(20) default NULL,
  `name` varchar(20) NOT NULL COMMENT '姓名',
  `gender` varchar(4) NOT NULL COMMENT '性别',
  `userPhoto` varchar(60) NOT NULL COMMENT '学生照片',
  `birthDate` varchar(20) default NULL COMMENT '出生日期',
  `telephone` varchar(20) NOT NULL COMMENT '联系电话',
  `email` varchar(50) NOT NULL COMMENT '邮箱',
  `address` varchar(80) default NULL COMMENT '家庭地址',
  `regTime` varchar(20) default NULL COMMENT '注册时间',
  PRIMARY KEY  (`studentNumber`),
  KEY `classObj` (`classObj`),
  CONSTRAINT `t_student_ibfk_1` FOREIGN KEY (`classObj`) REFERENCES `t_classinfo` (`classNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_student
-- ----------------------------
INSERT INTO `t_student` VALUES ('STU001', '123', 'BJ001', '双鱼林', '男', 'upload/c0482296-2bf7-4fdc-98ef-89a6c4c175e1.jpg', '2017-12-05', '13598340834', 'syl@163.com', '四川成都红星路', '2017-12-22 03:55:48');
INSERT INTO `t_student` VALUES ('STU002', '123', 'BJ001', '王茜茜', '女', 'upload/NoImage.jpg', '2017-12-06', '13539842343', 'wangxixi@163.com', '福建福州', '2017-12-22 16:13:28');

-- ----------------------------
-- Table structure for `t_teacher`
-- ----------------------------
DROP TABLE IF EXISTS `t_teacher`;
CREATE TABLE `t_teacher` (
  `teacherNo` varchar(20) NOT NULL COMMENT 'teacherNo',
  `password` varchar(20) NOT NULL COMMENT '登录密码',
  `name` varchar(20) NOT NULL COMMENT '姓名',
  `sex` varchar(4) NOT NULL COMMENT '性别',
  `bornDate` varchar(20) default NULL COMMENT '出生日期',
  `teacherPhoto` varchar(60) NOT NULL COMMENT '教师照片',
  `teacherDesc` varchar(5000) NOT NULL COMMENT '教师介绍',
  PRIMARY KEY  (`teacherNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_teacher
-- ----------------------------
INSERT INTO `t_teacher` VALUES ('TH001', '123', '王达丽', '女', '2017-12-05', 'upload/8eb8c78d-2fd0-45d9-8417-5ce8031fd276.jpg', '<p>老师主要精通java开发</p>');
