<%@ page language="java" import="java.util.*"  contentType="text/html;charset=UTF-8"%> 
<%@ page import="com.chengxusheji.po.GroupStudent" %>
<%@ page import="com.chengxusheji.po.Group" %>
<%@ page import="com.chengxusheji.po.Student" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    List<GroupStudent> groupStudentList = (List<GroupStudent>)request.getAttribute("groupStudentList");
    //获取所有的groupObj信息
    List<Group> groupList = (List<Group>)request.getAttribute("groupList");
    //获取所有的studentObj信息
    List<Student> studentList = (List<Student>)request.getAttribute("studentList");
    int currentPage =  (Integer)request.getAttribute("currentPage"); //当前页
    int totalPage =   (Integer)request.getAttribute("totalPage");  //一共多少页
    int recordNumber =   (Integer)request.getAttribute("recordNumber");  //一共多少记录
    Group groupObj = (Group)request.getAttribute("groupObj");
    Student studentObj = (Student)request.getAttribute("studentObj");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1 , user-scalable=no">
<title>分组成员查询</title>
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
			    	<li role="presentation" class="active"><a href="#groupStudentListPanel" aria-controls="groupStudentListPanel" role="tab" data-toggle="tab">分组成员列表</a></li>
			    	<li role="presentation" ><a href="<%=basePath %>GroupStudent/groupStudent_frontAdd.jsp" style="display:none;">添加分组成员</a></li>
				</ul>
			  	<!-- Tab panes -->
			  	<div class="tab-content">
				    <div role="tabpanel" class="tab-pane active" id="groupStudentListPanel">
				    		<div class="row">
				    			<div class="col-md-12 top5">
				    				<div class="table-responsive">
				    				<table class="table table-condensed table-hover">
				    					<tr class="success bold"><td>序号</td><td>成员id</td><td>所在分组</td><td>学生</td><td>操作</td></tr>
				    					<% 
				    						/*计算起始序号*/
				    	            		int startIndex = (currentPage -1) * 5;
				    	            		/*遍历记录*/
				    	            		for(int i=0;i<groupStudentList.size();i++) {
					    	            		int currentIndex = startIndex + i + 1; //当前记录的序号
					    	            		GroupStudent groupStudent = groupStudentList.get(i); //获取到分组成员对象
 										%>
 										<tr>
 											<td><%=currentIndex %></td>
 											<td><%=groupStudent.getGsId() %></td>
 											<td><%=groupStudent.getGroupObj().getGroupName() %></td>
 											<td><%=groupStudent.getStudentObj().getName() %></td>
 											<td>
 												<a href="<%=basePath  %>GroupStudent/<%=groupStudent.getGsId() %>/frontshow"><i class="fa fa-info"></i>&nbsp;查看</a>&nbsp;
 												<a href="#" onclick="groupStudentEdit('<%=groupStudent.getGsId() %>');" style="display:none;"><i class="fa fa-pencil fa-fw"></i>编辑</a>&nbsp;
 												<a href="#" onclick="groupStudentDelete('<%=groupStudent.getGsId() %>');" style="display:none;"><i class="fa fa-trash-o fa-fw"></i>删除</a>
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
    		<h1>分组成员查询</h1>
		</div>
		<form name="groupStudentQueryForm" id="groupStudentQueryForm" action="<%=basePath %>GroupStudent/frontlist" class="mar_t15">
            <div class="form-group">
            	<label for="groupObj_groupId">所在分组：</label>
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
            	<label for="studentObj_studentNumber">学生：</label>
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
            <input type=hidden name=currentPage value="<%=currentPage %>" />
            <button type="submit" class="btn btn-primary">查询</button>
        </form>
	</div>

		</div>
	</div> 
<div id="groupStudentEditDialog" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"><i class="fa fa-edit"></i>&nbsp;分组成员信息编辑</h4>
      </div>
      <div class="modal-body" style="height:450px; overflow: scroll;">
      	<form class="form-horizontal" name="groupStudentEditForm" id="groupStudentEditForm" enctype="multipart/form-data" method="post"  class="mar_t15">
		  <div class="form-group">
			 <label for="groupStudent_gsId_edit" class="col-md-3 text-right">成员id:</label>
			 <div class="col-md-9"> 
			 	<input type="text" id="groupStudent_gsId_edit" name="groupStudent.gsId" class="form-control" placeholder="请输入成员id" readOnly>
			 </div>
		  </div> 
		  <div class="form-group">
		  	 <label for="groupStudent_groupObj_groupId_edit" class="col-md-3 text-right">所在分组:</label>
		  	 <div class="col-md-9">
			    <select id="groupStudent_groupObj_groupId_edit" name="groupStudent.groupObj.groupId" class="form-control">
			    </select>
		  	 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="groupStudent_studentObj_studentNumber_edit" class="col-md-3 text-right">学生:</label>
		  	 <div class="col-md-9">
			    <select id="groupStudent_studentObj_studentNumber_edit" name="groupStudent.studentObj.studentNumber" class="form-control">
			    </select>
		  	 </div>
		  </div>
		</form> 
	    <style>#groupStudentEditForm .form-group {margin-bottom:5px;}  </style>
      </div>
      <div class="modal-footer"> 
      	<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
      	<button type="button" class="btn btn-primary" onclick="ajaxGroupStudentModify();">提交</button>
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
    document.groupStudentQueryForm.currentPage.value = currentPage;
    document.groupStudentQueryForm.submit();
}

/*可以直接跳转到某页*/
function changepage(totalPage)
{
    var pageValue=document.groupStudentQueryForm.pageValue.value;
    if(pageValue>totalPage) {
        alert('你输入的页码超出了总页数!');
        return ;
    }
    document.groupStudentQueryForm.currentPage.value = pageValue;
    documentgroupStudentQueryForm.submit();
}

/*弹出修改分组成员界面并初始化数据*/
function groupStudentEdit(gsId) {
	$.ajax({
		url :  basePath + "GroupStudent/" + gsId + "/update",
		type : "get",
		dataType: "json",
		success : function (groupStudent, response, status) {
			if (groupStudent) {
				$("#groupStudent_gsId_edit").val(groupStudent.gsId);
				$.ajax({
					url: basePath + "Group/listAll",
					type: "get",
					success: function(groups,response,status) { 
						$("#groupStudent_groupObj_groupId_edit").empty();
						var html="";
		        		$(groups).each(function(i,group){
		        			html += "<option value='" + group.groupId + "'>" + group.groupName + "</option>";
		        		});
		        		$("#groupStudent_groupObj_groupId_edit").html(html);
		        		$("#groupStudent_groupObj_groupId_edit").val(groupStudent.groupObjPri);
					}
				});
				$.ajax({
					url: basePath + "Student/listAll",
					type: "get",
					success: function(students,response,status) { 
						$("#groupStudent_studentObj_studentNumber_edit").empty();
						var html="";
		        		$(students).each(function(i,student){
		        			html += "<option value='" + student.studentNumber + "'>" + student.name + "</option>";
		        		});
		        		$("#groupStudent_studentObj_studentNumber_edit").html(html);
		        		$("#groupStudent_studentObj_studentNumber_edit").val(groupStudent.studentObjPri);
					}
				});
				$('#groupStudentEditDialog').modal('show');
			} else {
				alert("获取信息失败！");
			}
		}
	});
}

/*删除分组成员信息*/
function groupStudentDelete(gsId) {
	if(confirm("确认删除这个记录")) {
		$.ajax({
			type : "POST",
			url : basePath + "GroupStudent/deletes",
			data : {
				gsIds : gsId,
			},
			success : function (obj) {
				if (obj.success) {
					alert("删除成功");
					$("#groupStudentQueryForm").submit();
					//location.href= basePath + "GroupStudent/frontlist";
				}
				else 
					alert(obj.message);
			},
		});
	}
}

/*ajax方式提交分组成员信息表单给服务器端修改*/
function ajaxGroupStudentModify() {
	$.ajax({
		url :  basePath + "GroupStudent/" + $("#groupStudent_gsId_edit").val() + "/update",
		type : "post",
		dataType: "json",
		data: new FormData($("#groupStudentEditForm")[0]),
		success : function (obj, response, status) {
            if(obj.success){
                alert("信息修改成功！");
                $("#groupStudentQueryForm").submit();
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

})
</script>
</body>
</html>

