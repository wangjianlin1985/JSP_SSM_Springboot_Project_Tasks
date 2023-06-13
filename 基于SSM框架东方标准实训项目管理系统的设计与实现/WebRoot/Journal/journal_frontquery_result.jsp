<%@ page language="java" import="java.util.*"  contentType="text/html;charset=UTF-8"%> 
<%@ page import="com.chengxusheji.po.Journal" %>
<%@ page import="com.chengxusheji.po.Student" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    List<Journal> journalList = (List<Journal>)request.getAttribute("journalList");
    //获取所有的studentObj信息
    List<Student> studentList = (List<Student>)request.getAttribute("studentList");
    int currentPage =  (Integer)request.getAttribute("currentPage"); //当前页
    int totalPage =   (Integer)request.getAttribute("totalPage");  //一共多少页
    int recordNumber =   (Integer)request.getAttribute("recordNumber");  //一共多少记录
    String title = (String)request.getAttribute("title"); //日志标题查询关键字
    Student studentObj = (Student)request.getAttribute("studentObj");
    String addTime = (String)request.getAttribute("addTime"); //发布时间查询关键字
    String teacherNo = (String)request.getAttribute("teacherNo"); //审核老师查询关键字
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1 , user-scalable=no">
<title>项目日志查询</title>
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
			    	<li role="presentation" class="active"><a href="#journalListPanel" aria-controls="journalListPanel" role="tab" data-toggle="tab">项目日志列表</a></li>
			    	<li role="presentation" ><a href="<%=basePath %>Journal/journal_frontAdd.jsp" style="display:none;">添加项目日志</a></li>
				</ul>
			  	<!-- Tab panes -->
			  	<div class="tab-content">
				    <div role="tabpanel" class="tab-pane active" id="journalListPanel">
				    		<div class="row">
				    			<div class="col-md-12 top5">
				    				<div class="table-responsive">
				    				<table class="table table-condensed table-hover">
				    					<tr class="success bold"><td>序号</td><td>日志id</td><td>日志标题</td><td>发布学生</td><td>发布时间</td><td>审核老师</td><td>答复内容</td><td>答复时间</td><td>操作</td></tr>
				    					<% 
				    						/*计算起始序号*/
				    	            		int startIndex = (currentPage -1) * 5;
				    	            		/*遍历记录*/
				    	            		for(int i=0;i<journalList.size();i++) {
					    	            		int currentIndex = startIndex + i + 1; //当前记录的序号
					    	            		Journal journal = journalList.get(i); //获取到项目日志对象
 										%>
 										<tr>
 											<td><%=currentIndex %></td>
 											<td><%=journal.getJournalId() %></td>
 											<td><%=journal.getTitle() %></td>
 											<td><%=journal.getStudentObj().getName() %></td>
 											<td><%=journal.getAddTime() %></td>
 											<td><%=journal.getTeacherNo() %></td>
 											<td><%=journal.getReplyContent() %></td>
 											<td><%=journal.getReplyTime() %></td>
 											<td>
 												<a href="<%=basePath  %>Journal/<%=journal.getJournalId() %>/frontshow"><i class="fa fa-info"></i>&nbsp;查看</a>&nbsp;
 												<a href="#" onclick="journalEdit('<%=journal.getJournalId() %>');" style="display:none;"><i class="fa fa-pencil fa-fw"></i>编辑</a>&nbsp;
 												<a href="#" onclick="journalDelete('<%=journal.getJournalId() %>');" style="display:none;"><i class="fa fa-trash-o fa-fw"></i>删除</a>
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
    		<h1>项目日志查询</h1>
		</div>
		<form name="journalQueryForm" id="journalQueryForm" action="<%=basePath %>Journal/frontlist" class="mar_t15">
			<div class="form-group">
				<label for="title">日志标题:</label>
				<input type="text" id="title" name="title" value="<%=title %>" class="form-control" placeholder="请输入日志标题">
			</div>






            <div class="form-group">
            	<label for="studentObj_studentNumber">发布学生：</label>
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
				<label for="addTime">发布时间:</label>
				<input type="text" id="addTime" name="addTime" class="form-control"  placeholder="请选择发布时间" value="<%=addTime %>" onclick="SelectDate(this,'yyyy-MM-dd')" />
			</div>
			<div class="form-group">
				<label for="teacherNo">审核老师:</label>
				<input type="text" id="teacherNo" name="teacherNo" value="<%=teacherNo %>" class="form-control" placeholder="请输入审核老师">
			</div>






            <input type=hidden name=currentPage value="<%=currentPage %>" />
            <button type="submit" class="btn btn-primary">查询</button>
        </form>
	</div>

		</div>
	</div> 
<div id="journalEditDialog" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" style="width:900px;" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"><i class="fa fa-edit"></i>&nbsp;项目日志信息编辑</h4>
      </div>
      <div class="modal-body" style="height:450px; overflow: scroll;">
      	<form class="form-horizontal" name="journalEditForm" id="journalEditForm" enctype="multipart/form-data" method="post"  class="mar_t15">
		  <div class="form-group">
			 <label for="journal_journalId_edit" class="col-md-3 text-right">日志id:</label>
			 <div class="col-md-9"> 
			 	<input type="text" id="journal_journalId_edit" name="journal.journalId" class="form-control" placeholder="请输入日志id" readOnly>
			 </div>
		  </div> 
		  <div class="form-group">
		  	 <label for="journal_title_edit" class="col-md-3 text-right">日志标题:</label>
		  	 <div class="col-md-9">
			    <input type="text" id="journal_title_edit" name="journal.title" class="form-control" placeholder="请输入日志标题">
			 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="journal_content_edit" class="col-md-3 text-right">日志内容:</label>
		  	 <div class="col-md-9">
			 	<textarea name="journal.content" id="journal_content_edit" style="width:100%;height:500px;"></textarea>
			 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="journal_studentObj_studentNumber_edit" class="col-md-3 text-right">发布学生:</label>
		  	 <div class="col-md-9">
			    <select id="journal_studentObj_studentNumber_edit" name="journal.studentObj.studentNumber" class="form-control">
			    </select>
		  	 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="journal_addTime_edit" class="col-md-3 text-right">发布时间:</label>
		  	 <div class="col-md-9">
                <div class="input-group date journal_addTime_edit col-md-12" data-link-field="journal_addTime_edit">
                    <input class="form-control" id="journal_addTime_edit" name="journal.addTime" size="16" type="text" value="" placeholder="请选择发布时间" readonly>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                </div>
		  	 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="journal_teacherNo_edit" class="col-md-3 text-right">审核老师:</label>
		  	 <div class="col-md-9">
			    <input type="text" id="journal_teacherNo_edit" name="journal.teacherNo" class="form-control" placeholder="请输入审核老师">
			 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="journal_replyContent_edit" class="col-md-3 text-right">答复内容:</label>
		  	 <div class="col-md-9">
			    <textarea id="journal_replyContent_edit" name="journal.replyContent" rows="8" class="form-control" placeholder="请输入答复内容"></textarea>
			 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="journal_replyTime_edit" class="col-md-3 text-right">答复时间:</label>
		  	 <div class="col-md-9">
                <div class="input-group date journal_replyTime_edit col-md-12" data-link-field="journal_replyTime_edit">
                    <input class="form-control" id="journal_replyTime_edit" name="journal.replyTime" size="16" type="text" value="" placeholder="请选择答复时间" readonly>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                </div>
		  	 </div>
		  </div>
		</form> 
	    <style>#journalEditForm .form-group {margin-bottom:5px;}  </style>
      </div>
      <div class="modal-footer"> 
      	<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
      	<button type="button" class="btn btn-primary" onclick="ajaxJournalModify();">提交</button>
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
var journal_content_edit = UE.getEditor('journal_content_edit'); //日志内容编辑器
var basePath = "<%=basePath%>";
/*跳转到查询结果的某页*/
function GoToPage(currentPage,totalPage) {
    if(currentPage==0) return;
    if(currentPage>totalPage) return;
    document.journalQueryForm.currentPage.value = currentPage;
    document.journalQueryForm.submit();
}

/*可以直接跳转到某页*/
function changepage(totalPage)
{
    var pageValue=document.journalQueryForm.pageValue.value;
    if(pageValue>totalPage) {
        alert('你输入的页码超出了总页数!');
        return ;
    }
    document.journalQueryForm.currentPage.value = pageValue;
    documentjournalQueryForm.submit();
}

/*弹出修改项目日志界面并初始化数据*/
function journalEdit(journalId) {
	$.ajax({
		url :  basePath + "Journal/" + journalId + "/update",
		type : "get",
		dataType: "json",
		success : function (journal, response, status) {
			if (journal) {
				$("#journal_journalId_edit").val(journal.journalId);
				$("#journal_title_edit").val(journal.title);
				journal_content_edit.setContent(journal.content, false);
				$.ajax({
					url: basePath + "Student/listAll",
					type: "get",
					success: function(students,response,status) { 
						$("#journal_studentObj_studentNumber_edit").empty();
						var html="";
		        		$(students).each(function(i,student){
		        			html += "<option value='" + student.studentNumber + "'>" + student.name + "</option>";
		        		});
		        		$("#journal_studentObj_studentNumber_edit").html(html);
		        		$("#journal_studentObj_studentNumber_edit").val(journal.studentObjPri);
					}
				});
				$("#journal_addTime_edit").val(journal.addTime);
				$("#journal_teacherNo_edit").val(journal.teacherNo);
				$("#journal_replyContent_edit").val(journal.replyContent);
				$("#journal_replyTime_edit").val(journal.replyTime);
				$('#journalEditDialog').modal('show');
			} else {
				alert("获取信息失败！");
			}
		}
	});
}

/*删除项目日志信息*/
function journalDelete(journalId) {
	if(confirm("确认删除这个记录")) {
		$.ajax({
			type : "POST",
			url : basePath + "Journal/deletes",
			data : {
				journalIds : journalId,
			},
			success : function (obj) {
				if (obj.success) {
					alert("删除成功");
					$("#journalQueryForm").submit();
					//location.href= basePath + "Journal/frontlist";
				}
				else 
					alert(obj.message);
			},
		});
	}
}

/*ajax方式提交项目日志信息表单给服务器端修改*/
function ajaxJournalModify() {
	$.ajax({
		url :  basePath + "Journal/" + $("#journal_journalId_edit").val() + "/update",
		type : "post",
		dataType: "json",
		data: new FormData($("#journalEditForm")[0]),
		success : function (obj, response, status) {
            if(obj.success){
                alert("信息修改成功！");
                $("#journalQueryForm").submit();
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

    /*发布时间组件*/
    $('.journal_addTime_edit').datetimepicker({
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
    /*答复时间组件*/
    $('.journal_replyTime_edit').datetimepicker({
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

