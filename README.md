# JSP_SSM_Springboot_Project_Tasks
JSP基于SSM实训项目管理任务作业批改系统可升级SpringBoot毕业源码案例设计
## 程序开发环境：myEclipse/Eclipse/Idea都可以 + mysql数据库
## 前台技术框架： Bootstrap  后台架构框架: SSM

  1.研究情况：现今在我国随着教育IT公司学员数量的日益增加，企业管理学员的实训项目日志的难度与日俱增，企业管理平台的功能存在不足，开发和优化日志管理系统已成为公司管理的主流趋势。
  
  2.目的意义：实训日志管理系统主要是实现企业老师可以随时对学生提出来问题的反馈进行审批以及答复，提供学员与老师之间的交互沟通。
  
  3.题目研究的主要内容：
  
  教师管理：包括教师的权限分配。
  
  项目管理：包括项目的时间，教师和学员等人员的分配；项目进度报告管理。
  
  资源管理：包括共享项目代码，项目文件，提供上传下载功能。
  
  学员管理：包括对学员班级的管理。
  
  日志的管理：包括学员日志的提交，教师对日志的审批与答复。
## 实体ER属性：
班级: 班级编号,班级名称,成立日期,班主任,备注

教师: 教师编号,登录密码,姓名,性别,出生日期,教师照片,教师介绍

分组: 分组id,分组名称

学员: 学号,登录密码,所在班级,姓名,性别,学生照片,出生日期,联系电话,邮箱,家庭地址,注册时间

分组成员: 成员id,所在分组,学生

项目: 项目id,项目名称,项目内容,项目任务组,项目任务文件,开始时间,完成周期,项目进度报告

资源: 资源id,项目,上传学员,项目资源文件,项目资源说明,上传时间,老师评语

项目日志: 日志id,日志标题,日志内容,发布学生,发布时间,审核老师,答复内容,答复时间
