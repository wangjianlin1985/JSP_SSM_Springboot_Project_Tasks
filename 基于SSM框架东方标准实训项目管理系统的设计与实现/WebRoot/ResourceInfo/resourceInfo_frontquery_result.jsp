<%@ page language="java" import="java.util.*"  contentType="text/html;charset=UTF-8"%> 
<%@ page import="com.chengxusheji.po.ResourceInfo" %>
<%@ page import="com.chengxusheji.po.Project" %>
<%@ page import="com.chengxusheji.po.Student" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    List<ResourceInfo> resourceInfoList = (List<ResourceInfo>)request.getAttribute("resourceInfoList");
    //获取所有的projectObj信息
    List<Project> projectList = (List<Project>)request.getAttribute("projectList");
    //获取所有的studentObj信息
    List<Student> studentList = (List<Student>)request.getAttribute("studentList");
    int currentPage =  (Integer)request.getAttribute("currentPage"); //当前页
    int totalPage =   (Integer)request.getAttribute("totalPage");  //一共多少页
    int recordNumber =   (Integer)request.getAttribute("recordNumber");  //一共多少记录
    Project projectObj = (Project)request.getAttribute("projectObj");
    Student studentObj = (Student)request.getAttribute("studentObj");
    String addTime = (String)request.getAttribute("addTime"); //上传时间查询关键字
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1 , user-scalable=no">
<title>资源查询</title>
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
			    	<li role="presentation" class="active"><a href="#resourceInfoListPanel" aria-controls="resourceInfoListPanel" role="tab" data-toggle="tab">资源列表</a></li>
			    	<li role="presentation" ><a href="<%=basePath %>ResourceInfo/resourceInfo_frontAdd.jsp" style="display:none;">添加资源</a></li>
				</ul>
			  	<!-- Tab panes -->
			  	<div class="tab-content">
				    <div role="tabpanel" class="tab-pane active" id="resourceInfoListPanel">
				    		<div class="row">
				    			<div class="col-md-12 top5">
				    				<div class="table-responsive">
				    				<table class="table table-condensed table-hover">
				    					<tr class="success bold"><td>序号</td><td>资源id</td><td>项目</td><td>上传学员</td><td>项目资源文件</td><td>上传时间</td><td>老师评语</td><td>操作</td></tr>
				    					<% 
				    						/*计算起始序号*/
				    	            		int startIndex = (currentPage -1) * 5;
				    	            		/*遍历记录*/
				    	            		for(int i=0;i<resourceInfoList.size();i++) {
					    	            		int currentIndex = startIndex + i + 1; //当前记录的序号
					    	            		ResourceInfo resourceInfo = resourceInfoList.get(i); //获取到资源对象
 										%>
 										<tr>
 											<td><%=currentIndex %></td>
 											<td><%=resourceInfo.getResourceId() %></td>
 											<td><%=resourceInfo.getProjectObj().getProjectName() %></td>
 											<td><%=resourceInfo.getStudentObj().getName() %></td>
 											<td><%=resourceInfo.getResourceFile().equals("")?"暂无文件":"<a href='" + basePath + resourceInfo.getResourceFile() + "' target='_blank'>" + resourceInfo.getResourceFile() + "</a>"%>
 											<td><%=resourceInfo.getAddTime() %></td>
 											<td><%=resourceInfo.getEvaluateContent() %></td>
 											<td>
 												<a href="<%=basePath  %>ResourceInfo/<%=resourceInfo.getResourceId() %>/frontshow"><i class="fa fa-info"></i>&nbsp;查看</a>&nbsp;
 												<a href="#" onclick="resourceInfoEdit('<%=resourceInfo.getResourceId() %>');" style="display:none;"><i class="fa fa-pencil fa-fw"></i>编辑</a>&nbsp;
 												<a href="#" onclick="resourceInfoDelete('<%=resourceInfo.getResourceId() %>');" style="display:none;"><i class="fa fa-trash-o fa-fw"></i>删除</a>
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
    		<h1>资源查询</h1>
		</div>
		<form name="resourceInfoQueryForm" id="resourceInfoQueryForm" action="<%=basePath %>ResourceInfo/frontlist" class="mar_t15">
            <div class="form-group">
            	<label for="projectObj_projectId">项目：</label>
                <select id="projectObj_projectId" name="projectObj.projectId" class="form-control">
                	<option value="0">不限制</option>
	 				<%
	 				for(Project projectTemp:projectList) {
	 					String selected = "";
 					if(projectObj!=null && projectObj.getProjectId()!=null && projectObj.getProjectId().intValue()==projectTemp.getProjectId().intValue())
 						selected = "selected";
	 				%>
 				 <option value="<%=projectTemp.getProjectId() %>" <%=selected %>><%=projectTemp.getProjectName() %></option>
	 				<%
	 				}
	 				%>
 			</select>
            </div>
            <div class="form-group">
            	<label for="studentObj_studentNumber">上传学员：</label>
                <select id="studentObj_studentNumber" name="studentObj.studentNumber" class="form-control">
                	<option value="">不限制</option>
	 				<%
	 				for(Student studentTemp:studentList) {
	 					String selected = "";
 					if(studentObj!=null && studentObj.getStudentNumber()!=null && studentObj.getStudentNumber().equals(studentTemp.getStudentNumber()))
 						selected = "selected";
	 				%>
 				 <option value="<%=studentTemp.getStudentNumber() %>" <%=selected %>><%=studentTemp.getName() %></option>
	 				<%
	 				}
	 				%>
 			</select>
            </div>
			<div class="form-group">
				<label for="addTime">上传时间:</label>
				<input type="text" id="addTime" name="addTime" class="form-control"  placeholder="请选择上传时间" value="<%=addTime %>" onclick="SelectDate(this,'yyyy-MM-dd')" />
			</div>
            <input type=hidden name=currentPage value="<%=currentPage %>" />
            <button type="submit" class="btn btn-primary">查询</button>
        </form>
	</div>

		</div>
	</div> 
<div id="resourceInfoEditDialog" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"><i class="fa fa-edit"></i>&nbsp;资源信息编辑</h4>
      </div>
      <div class="modal-body" style="height:450px; overflow: scroll;">
      	<form class="form-horizontal" name="resourceInfoEditForm" id="resourceInfoEditForm" enctype="multipart/form-data" method="post"  class="mar_t15">
		  <div class="form-group">
			 <label for="resourceInfo_resourceId_edit" class="col-md-3 text-right">资源id:</label>
			 <div class="col-md-9"> 
			 	<input type="text" id="resourceInfo_resourceId_edit" name="resourceInfo.resourceId" class="form-control" placeholder="请输入资源id" readOnly>
			 </div>
		  </div> 
		  <div class="form-group">
		  	 <label for="resourceInfo_projectObj_projectId_edit" class="col-md-3 text-right">项目:</label>
		  	 <div class="col-md-9">
			    <select id="resourceInfo_projectObj_projectId_edit" name="resourceInfo.projectObj.projectId" class="form-control">
			    </select>
		  	 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="resourceInfo_studentObj_studentNumber_edit" class="col-md-3 text-right">上传学员:</label>
		  	 <div class="col-md-9">
			    <select id="resourceInfo_studentObj_studentNumber_edit" name="resourceInfo.studentObj.studentNumber" class="form-control">
			    </select>
		  	 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="resourceInfo_resourceFile_edit" class="col-md-3 text-right">项目资源文件:</label>
		  	 <div class="col-md-9">
			    <a id="resourceInfo_resourceFileImg" width="200px" border="0px"></a><br/>
			    <input type="hidden" id="resourceInfo_resourceFile" name="resourceInfo.resourceFile"/>
			    <input id="resourceFileFile" name="resourceFileFile" type="file" size="50" />
		  	 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="resourceInfo_resourceDesc_edit" class="col-md-3 text-right">项目资源说明:</label>
		  	 <div class="col-md-9">
			    <textarea id="resourceInfo_resourceDesc_edit" name="resourceInfo.resourceDesc" rows="8" class="form-control" placeholder="请输入项目资源说明"></textarea>
			 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="resourceInfo_addTime_edit" class="col-md-3 text-right">上传时间:</label>
		  	 <div class="col-md-9">
                <div class="input-group date resourceInfo_addTime_edit col-md-12" data-link-field="resourceInfo_addTime_edit">
                    <input class="form-control" id="resourceInfo_addTime_edit" name="resourceInfo.addTime" size="16" type="text" value="" placeholder="请选择上传时间" readonly>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                </div>
		  	 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="resourceInfo_evaluateContent_edit" class="col-md-3 text-right">老师评语:</label>
		  	 <div class="col-md-9">
			    <textarea id="resourceInfo_evaluateContent_edit" name="resourceInfo.evaluateContent" rows="8" class="form-control" placeholder="请输入老师评语"></textarea>
			 </div>
		  </div>
		</form> 
	    <style>#resourceInfoEditForm .form-group {margin-bottom:5px;}  </style>
      </div>
      <div class="modal-footer"> 
      	<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
      	<button type="button" class="btn btn-primary" onclick="ajaxResourceInfoModify();">提交</button>
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
<script>
var basePath = "<%=basePath%>";
/*跳转到查询结果的某页*/
function GoToPage(currentPage,totalPage) {
    if(currentPage==0) return;
    if(currentPage>totalPage) return;
    document.resourceInfoQueryForm.currentPage.value = currentPage;
    document.resourceInfoQueryForm.submit();
}

/*可以直接跳转到某页*/
function changepage(totalPage)
{
    var pageValue=document.resourceInfoQueryForm.pageValue.value;
    if(pageValue>totalPage) {
        alert('你输入的页码超出了总页数!');
        return ;
    }
    document.resourceInfoQueryForm.currentPage.value = pageValue;
    documentresourceInfoQueryForm.submit();
}

/*弹出修改资源界面并初始化数据*/
function resourceInfoEdit(resourceId) {
	$.ajax({
		url :  basePath + "ResourceInfo/" + resourceId + "/update",
		type : "get",
		dataType: "json",
		success : function (resourceInfo, response, status) {
			if (resourceInfo) {
				$("#resourceInfo_resourceId_edit").val(resourceInfo.resourceId);
				$.ajax({
					url: basePath + "Project/listAll",
					type: "get",
					success: function(projects,response,status) { 
						$("#resourceInfo_projectObj_projectId_edit").empty();
						var html="";
		        		$(projects).each(function(i,project){
		        			html += "<option value='" + project.projectId + "'>" + project.projectName + "</option>";
		        		});
		        		$("#resourceInfo_projectObj_projectId_edit").html(html);
		        		$("#resourceInfo_projectObj_projectId_edit").val(resourceInfo.projectObjPri);
					}
				});
				$.ajax({
					url: basePath + "Student/listAll",
					type: "get",
					success: function(students,response,status) { 
						$("#resourceInfo_studentObj_studentNumber_edit").empty();
						var html="";
		        		$(students).each(function(i,student){
		        			html += "<option value='" + student.studentNumber + "'>" + student.name + "</option>";
		        		});
		        		$("#resourceInfo_studentObj_studentNumber_edit").html(html);
		        		$("#resourceInfo_studentObj_studentNumber_edit").val(resourceInfo.studentObjPri);
					}
				});
				$("#resourceInfo_resourceFileA").val(resourceInfo.resourceFile);
				$("#resourceInfo_resourceFileA").attr("href", basePath +　resourceInfo.resourceFile);
				$("#resourceInfo_resourceDesc_edit").val(resourceInfo.resourceDesc);
				$("#resourceInfo_addTime_edit").val(resourceInfo.addTime);
				$("#resourceInfo_evaluateContent_edit").val(resourceInfo.evaluateContent);
				$('#resourceInfoEditDialog').modal('show');
			} else {
				alert("获取信息失败！");
			}
		}
	});
}

/*删除资源信息*/
function resourceInfoDelete(resourceId) {
	if(confirm("确认删除这个记录")) {
		$.ajax({
			type : "POST",
			url : basePath + "ResourceInfo/deletes",
			data : {
				resourceIds : resourceId,
			},
			success : function (obj) {
				if (obj.success) {
					alert("删除成功");
					$("#resourceInfoQueryForm").submit();
					//location.href= basePath + "ResourceInfo/frontlist";
				}
				else 
					alert(obj.message);
			},
		});
	}
}

/*ajax方式提交资源信息表单给服务器端修改*/
function ajaxResourceInfoModify() {
	$.ajax({
		url :  basePath + "ResourceInfo/" + $("#resourceInfo_resourceId_edit").val() + "/update",
		type : "post",
		dataType: "json",
		data: new FormData($("#resourceInfoEditForm")[0]),
		success : function (obj, response, status) {
            if(obj.success){
                alert("信息修改成功！");
                $("#resourceInfoQueryForm").submit();
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

    /*上传时间组件*/
    $('.resourceInfo_addTime_edit').datetimepicker({
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

