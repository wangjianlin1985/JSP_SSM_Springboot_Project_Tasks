<%@ page language="java" import="java.util.*"  contentType="text/html;charset=UTF-8"%> 
<%@ page import="com.chengxusheji.po.Group" %>
<%@ page import="com.chengxusheji.po.GroupStudent" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	Group group = (Group) request.getAttribute("group");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1 , user-scalable=no">
  <TITLE>查看分组详情</TITLE>
  <link href="<%=basePath%>plugins/bootstrap.css" rel="stylesheet">
  <link href="<%=basePath%>plugins/bootstrap-dashen.css" rel="stylesheet">
  <link href="<%=basePath%>plugins/font-awesome.css" rel="stylesheet">
  <link href="<%=basePath%>plugins/animate.css" rel="stylesheet"> 
</head>
<body style="margin-top:70px;"> 
<jsp:include page="../header.jsp"></jsp:include>
<div class="container">
	<ul class="breadcrumb">
  		<li><a href="<%=basePath%>index.jsp">首页</a></li>
  		<li><a href="<%=basePath%>Group/frontlist">分组信息</a></li>
  		<li class="active">详情查看</li>
	</ul>
	<div class="row bottom15"> 
		<div class="col-md-2 col-xs-4 text-right bold">分组id:</div>
		<div class="col-md-10 col-xs-6"><%=group.getGroupId()%></div>
	</div>
	<div class="row bottom15"> 
		<div class="col-md-2 col-xs-4 text-right bold">分组名称:</div>
		<div class="col-md-10 col-xs-6"><%=group.getGroupName()%></div>
	</div>
	
	
	<div class="row bottom15"> 
		<div class="col-md-2 col-xs-4 text-right bold">分组成员:</div>
		<div class="col-md-10 col-xs-6"> 
					<div class="row">
						<div class="col-md-12 top5">
							<div class="table-responsive">
								<table class="table table-condensed table-hover">
									<tr class="success bold">
										<td>
											序号
										</td> 
										<td>
											学生
										</td>
										 
									</tr>
									<%
										ArrayList<GroupStudent> gsList = (ArrayList<GroupStudent>)request.getAttribute("gsList");
										/*计算起始序号*/
										int startIndex = 0;
										/*遍历记录*/
										for (int i = 0; i < gsList.size(); i++) {
											int currentIndex = startIndex + i + 1; //当前记录的序号
											GroupStudent groupStudent = gsList.get(i); //获取到分组成员对象
									%>
									<tr>
										<td><%=currentIndex%></td>  
										<td><%=groupStudent.getStudentObj().getName()%></td>
										 
									</tr>
									<%
										}
									%>
								</table>
							</div>
						</div>
					</div>
				</div>
	</div>
	
	
	
	<div class="row bottom15">
		<div class="col-md-2 col-xs-4"></div>
		<div class="col-md-6 col-xs-6">
			<button onclick="history.back();" class="btn btn-primary">返回</button>
		</div>
	</div>
</div> 
<jsp:include page="../footer.jsp"></jsp:include>
<script src="<%=basePath%>plugins/jquery.min.js"></script>
<script src="<%=basePath%>plugins/bootstrap.js"></script>
<script src="<%=basePath%>plugins/wow.min.js"></script>
<script>
var basePath = "<%=basePath%>";
$(function(){
        /*小屏幕导航点击关闭菜单*/
        $('.navbar-collapse a').click(function(){
            $('.navbar-collapse').collapse('hide');
        });
        new WOW().init();
 })
 </script> 
</body>
</html>

