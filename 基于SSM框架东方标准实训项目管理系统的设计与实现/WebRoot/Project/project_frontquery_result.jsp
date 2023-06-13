<%@ page language="java" import="java.util.*"  contentType="text/html;charset=UTF-8"%> 
<%@ page import="com.chengxusheji.po.Project" %>
<%@ page import="com.chengxusheji.po.Group" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    List<Project> projectList = (List<Project>)request.getAttribute("projectList");
    //获取所有的groupObj信息
    List<Group> groupList = (List<Group>)request.getAttribute("groupList");
    int currentPage =  (Integer)request.getAttribute("currentPage"); //当前页
    int totalPage =   (Integer)request.getAttribute("totalPage");  //一共多少页
    int recordNumber =   (Integer)request.getAttribute("recordNumber");  //一共多少记录
    String projectName = (String)request.getAttribute("projectName"); //项目名称查询关键字
    Group groupObj = (Group)request.getAttribute("groupObj");
    String startTime = (String)request.getAttribute("startTime"); //开始时间查询关键字
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1 , user-scalable=no">
<title>项目查询</title>
<link href="<%=basePath %>plugins/bootstrap.css" rel="stylesheet">
<link href="<%=basePath %>plugins/bootstrap-dashen.css" rel="stylesheet">
<link href="<%=basePath %>plugins/font-awesome.css" rel="stylesheet">
<link href="<%=basePath %>plugins/animate.css" rel="stylesheet">
<link href="<%=basePath %>plugins/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen">
</head>
<body style="margin-top:70px;">
<div class="container">
<jsp:include page="../header.jsp"></jsp:include>
	<div class="row"> 
		<div class="col-md-9 wow fadeInDown" data-wow-duration="0.5s">
			<div>
				<!-- Nav tabs -->
				<ul class="nav nav-tabs" role="tablist">
			    	<li><a href="<%=basePath %>index.jsp">首页</a></li>
			    	<li role="presentation" class="active"><a href="#projectListPanel" aria-controls="projectListPanel" role="tab" data-toggle="tab">项目列表</a></li>
			    	<li role="presentation" ><a href="<%=basePath %>Project/project_frontAdd.jsp" style="display:none;">添加项目</a></li>
				</ul>
			  	<!-- Tab panes -->
			  	<div class="tab-content">
				    <div role="tabpanel" class="tab-pane active" id="projectListPanel">
				    		<div class="row">
				    			<div class="col-md-12 top5">
				    				<div class="table-responsive">
				    				<table class="table table-condensed table-hover">
				    					<tr class="success bold"><td>序号</td><td>项目id</td><td>项目名称</td><td>项目任务组</td><td>项目任务文件</td><td>开始时间</td><td>完成周期</td><td>操作</td></tr>
				    					<% 
				    						/*计算起始序号*/
				    	            		int startIndex = (currentPage -1) * 5;
				    	            		/*遍历记录*/
				    	            		for(int i=0;i<projectList.size();i++) {
					    	            		int currentIndex = startIndex + i + 1; //当前记录的序号
					    	            		Project project = projectList.get(i); //获取到项目对象
 										%>
 										<tr>
 											<td><%=currentIndex %></td>
 											<td><%=project.getProjectId() %></td>
 											<td><%=project.getProjectName() %></td>
 											<td><%=project.getGroupObj().getGroupName() %></td>
 											<td><%=project.getProjectFile().equals("")?"暂无文件":"<a href='" + basePath + project.getProjectFile() + "' target='_blank'>" + project.getProjectFile() + "</a>"%>
 											<td><%=project.getStartTime() %></td>
 											<td><%=project.getDuration() %></td>
 											<td>
 												<a href="<%=basePath  %>Project/<%=project.getProjectId() %>/frontshow"><i class="fa fa-info"></i>&nbsp;查看</a>&nbsp;
 												<a href="#" onclick="projectEdit('<%=project.getProjectId() %>');" style="display:none;"><i class="fa fa-pencil fa-fw"></i>编辑</a>&nbsp;
 												<a href="#" onclick="projectDelete('<%=project.getProjectId() %>');" style="display:none;"><i class="fa fa-trash-o fa-fw"></i>删除</a>
 											</td> 
 										</tr>
 										<%}%>
				    				</table>
				    				</div>
				    			</div>
				    		</div>

				    		<div class="row">
					            <div class="col-md-12">
						            <nav class="pull-left">
						                <ul class="pagination">
						                    <li><a href="#" onclick="GoToPage(<%=currentPage-1 %>,<%=totalPage %>);" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>
						                     <%
						                    	int startPage = currentPage - 5;
						                    	int endPage = currentPage + 5;
						                    	if(startPage < 1) startPage=1;
						                    	if(endPage > totalPage) endPage = totalPage;
						                    	for(int i=startPage;i<=endPage;i++) {
						                    %>
						                    <li class="<%= currentPage==i?"active":"" %>"><a href="#"  onclick="GoToPage(<%=i %>,<%=totalPage %>);"><%=i %></a></li>
						                    <%  } %> 
						                    <li><a href="#" onclick="GoToPage(<%=currentPage+1 %>,<%=totalPage %>);"><span aria-hidden="true">&raquo;</span></a></li>
						                </ul>
						            </nav>
						            <div class="pull-right" style="line-height:75px;" >共有<%=recordNumber %>条记录，当前第 <%=currentPage %>/<%=totalPage %> 页</div>
					            </div>
				            </div> 
				    </div>
				</div>
			</div>
		</div>
	<div class="col-md-3 wow fadeInRight">
		<div class="page-header">
    		<h1>项目查询</h1>
		</div>
		<form name="projectQueryForm" id="projectQueryForm" action="<%=basePath %>Project/frontlist" class="mar_t15">
			<div class="form-group">
				<label for="projectName">项目名称:</label>
				<input type="text" id="projectName" name="projectName" value="<%=projectName %>" class="form-control" placeholder="请输入项目名称">
			</div>






            <div class="form-group">
            	<label for="groupObj_groupId">项目任务组：</label>
                <select id="groupObj_groupId" name="groupObj.groupId" class="form-control">
                	<option value="0">不限制</option>
	 				<%
	 				for(Group groupTemp:groupList) {
	 					String selected = "";
 					if(groupObj!=null && groupObj.getGroupId()!=null && groupObj.getGroupId().intValue()==groupTemp.getGroupId().intValue())
 						selected = "selected";
	 				%>
 				 <option value="<%=groupTemp.getGroupId() %>" <%=selected %>><%=groupTemp.getGroupName() %></option>
	 				<%
	 				}
	 				%>
 			</select>
            </div>
			<div class="form-group">
				<label for="startTime">开始时间:</label>
				<input type="text" id="startTime" name="startTime" class="form-control"  placeholder="请选择开始时间" value="<%=startTime %>" onclick="SelectDate(this,'yyyy-MM-dd')" />
			</div>
            <input type=hidden name=currentPage value="<%=currentPage %>" />
            <button type="submit" class="btn btn-primary">查询</button>
        </form>
	</div>

		</div>
	</div> 
<div id="projectEditDialog" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" style="width:900px;" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"><i class="fa fa-edit"></i>&nbsp;项目信息编辑</h4>
      </div>
      <div class="modal-body" style="height:450px; overflow: scroll;">
      	<form class="form-horizontal" name="projectEditForm" id="projectEditForm" enctype="multipart/form-data" method="post"  class="mar_t15">
		  <div class="form-group">
			 <label for="project_projectId_edit" class="col-md-3 text-right">项目id:</label>
			 <div class="col-md-9"> 
			 	<input type="text" id="project_projectId_edit" name="project.projectId" class="form-control" placeholder="请输入项目id" readOnly>
			 </div>
		  </div> 
		  <div class="form-group">
		  	 <label for="project_projectName_edit" class="col-md-3 text-right">项目名称:</label>
		  	 <div class="col-md-9">
			    <input type="text" id="project_projectName_edit" name="project.projectName" class="form-control" placeholder="请输入项目名称">
			 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="project_projectContent_edit" class="col-md-3 text-right">项目内容:</label>
		  	 <div class="col-md-9">
			 	<textarea name="project.projectContent" id="project_projectContent_edit" style="width:100%;height:500px;"></textarea>
			 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="project_groupObj_groupId_edit" class="col-md-3 text-right">项目任务组:</label>
		  	 <div class="col-md-9">
			    <select id="project_groupObj_groupId_edit" name="project.groupObj.groupId" class="form-control">
			    </select>
		  	 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="project_projectFile_edit" class="col-md-3 text-right">项目任务文件:</label>
		  	 <div class="col-md-9">
			    <a id="project_projectFileImg" width="200px" border="0px"></a><br/>
			    <input type="hidden" id="project_projectFile" name="project.projectFile"/>
			    <input id="projectFileFile" name="projectFileFile" type="file" size="50" />
		  	 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="project_startTime_edit" class="col-md-3 text-right">开始时间:</label>
		  	 <div class="col-md-9">
                <div class="input-group date project_startTime_edit col-md-12" data-link-field="project_startTime_edit">
                    <input class="form-control" id="project_startTime_edit" name="project.startTime" size="16" type="text" value="" placeholder="请选择开始时间" readonly>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                </div>
		  	 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="project_duration_edit" class="col-md-3 text-right">完成周期:</label>
		  	 <div class="col-md-9">
			    <input type="text" id="project_duration_edit" name="project.duration" class="form-control" placeholder="请输入完成周期">
			 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="project_projectProgress_edit" class="col-md-3 text-right">项目进度报告:</label>
		  	 <div class="col-md-9">
			    <textarea id="project_projectProgress_edit" name="project.projectProgress" rows="8" class="form-control" placeholder="请输入项目进度报告"></textarea>
			 </div>
		  </div>
		</form> 
	    <style>#projectEditForm .form-group {margin-bottom:5px;}  </style>
      </div>
      <div class="modal-footer"> 
      	<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
      	<button type="button" class="btn btn-primary" onclick="ajaxProjectModify();">提交</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<jsp:include page="../footer.jsp"></jsp:include> 
<script src="<%=basePath %>plugins/jquery.min.js"></script>
<script src="<%=basePath %>plugins/bootstrap.js"></script>
<script src="<%=basePath %>plugins/wow.min.js"></script>
<script src="<%=basePath %>plugins/bootstrap-datetimepicker.min.js"></script>
<script src="<%=basePath %>plugins/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=basePath %>js/jsdate.js"></script>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/ueditor1_4_3/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/ueditor1_4_3/ueditor.all.min.js"> </script>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/ueditor1_4_3/lang/zh-cn/zh-cn.js"></script>
<script>
//实例化编辑器
var project_projectContent_edit = UE.getEditor('project_projectContent_edit'); //项目内容编辑器
var basePath = "<%=basePath%>";
/*跳转到查询结果的某页*/
function GoToPage(currentPage,totalPage) {
    if(currentPage==0) return;
    if(currentPage>totalPage) return;
    document.projectQueryForm.currentPage.value = currentPage;
    document.projectQueryForm.submit();
}

/*可以直接跳转到某页*/
function changepage(totalPage)
{
    var pageValue=document.projectQueryForm.pageValue.value;
    if(pageValue>totalPage) {
        alert('你输入的页码超出了总页数!');
        return ;
    }
    document.projectQueryForm.currentPage.value = pageValue;
    documentprojectQueryForm.submit();
}

/*弹出修改项目界面并初始化数据*/
function projectEdit(projectId) {
	$.ajax({
		url :  basePath + "Project/" + projectId + "/update",
		type : "get",
		dataType: "json",
		success : function (project, response, status) {
			if (project) {
				$("#project_projectId_edit").val(project.projectId);
				$("#project_projectName_edit").val(project.projectName);
				project_projectContent_edit.setContent(project.projectContent, false);
				$.ajax({
					url: basePath + "Group/listAll",
					type: "get",
					success: function(groups,response,status) { 
						$("#project_groupObj_groupId_edit").empty();
						var html="";
		        		$(groups).each(function(i,group){
		        			html += "<option value='" + group.groupId + "'>" + group.groupName + "</option>";
		        		});
		        		$("#project_groupObj_groupId_edit").html(html);
		        		$("#project_groupObj_groupId_edit").val(project.groupObjPri);
					}
				});
				$("#project_projectFileA").val(project.projectFile);
				$("#project_projectFileA").attr("href", basePath +　project.projectFile);
				$("#project_startTime_edit").val(project.startTime);
				$("#project_duration_edit").val(project.duration);
				$("#project_projectProgress_edit").val(project.projectProgress);
				$('#projectEditDialog').modal('show');
			} else {
				alert("获取信息失败！");
			}
		}
	});
}

/*删除项目信息*/
function projectDelete(projectId) {
	if(confirm("确认删除这个记录")) {
		$.ajax({
			type : "POST",
			url : basePath + "Project/deletes",
			data : {
				projectIds : projectId,
			},
			success : function (obj) {
				if (obj.success) {
					alert("删除成功");
					$("#projectQueryForm").submit();
					//location.href= basePath + "Project/frontlist";
				}
				else 
					alert(obj.message);
			},
		});
	}
}

/*ajax方式提交项目信息表单给服务器端修改*/
function ajaxProjectModify() {
	$.ajax({
		url :  basePath + "Project/" + $("#project_projectId_edit").val() + "/update",
		type : "post",
		dataType: "json",
		data: new FormData($("#projectEditForm")[0]),
		success : function (obj, response, status) {
            if(obj.success){
                alert("信息修改成功！");
                $("#projectQueryForm").submit();
            }else{
                alert(obj.message);
            } 
		},
		processData: false,
		contentType: false,
	});
}

$(function(){
	/*小屏幕导航点击关闭菜单*/
    $('.navbar-collapse a').click(function(){
        $('.navbar-collapse').collapse('hide');
    });
    new WOW().init();

    /*开始时间组件*/
    $('.project_startTime_edit').datetimepicker({
    	language:  'zh-CN',  //语言
    	format: 'yyyy-mm-dd hh:ii:ss',
    	weekStart: 1,
    	todayBtn:  1,
    	autoclose: 1,
    	minuteStep: 1,
    	todayHighlight: 1,
    	startView: 2,
    	forceParse: 0
    });
})
</script>
</body>
</html>

