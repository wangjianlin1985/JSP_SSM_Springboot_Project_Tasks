package com.chengxusheji.controller;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import com.chengxusheji.utils.ExportExcelUtil;
import com.chengxusheji.utils.UserException;
import com.chengxusheji.service.JournalService;
import com.chengxusheji.po.Journal;
import com.chengxusheji.service.StudentService;
import com.chengxusheji.po.Student;

//Journal管理控制层
@Controller
@RequestMapping("/Journal")
public class JournalController extends BaseController {

    /*业务层对象*/
    @Resource JournalService journalService;

    @Resource StudentService studentService;
	@InitBinder("studentObj")
	public void initBinderstudentObj(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("studentObj.");
	}
	@InitBinder("journal")
	public void initBinderJournal(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("journal.");
	}
	/*跳转到添加Journal视图*/
	@RequestMapping(value = "/add", method = RequestMethod.GET)
	public String add(Model model,HttpServletRequest request) throws Exception {
		model.addAttribute(new Journal());
		/*查询所有的Student信息*/
		List<Student> studentList = studentService.queryAllStudent();
		request.setAttribute("studentList", studentList);
		return "Journal_add";
	}

	/*客户端ajax方式提交添加项目日志信息*/
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	public void add(@Validated Journal journal, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		String message = "";
		boolean success = false;
		if (br.hasErrors()) {
			message = "输入信息不符合要求！";
			writeJsonResponse(response, success, message);
			return ;
		}
        journalService.addJournal(journal);
        message = "项目日志添加成功!";
        success = true;
        writeJsonResponse(response, success, message);
	}
	
	/*客户端ajax方式提交添加项目日志信息*/
	@RequestMapping(value = "/stuAdd", method = RequestMethod.POST)
	public void stuAdd(Journal journal, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response,HttpSession session) throws Exception {
		String message = "";
		boolean success = false; 

		String studentNumber = (String)session.getAttribute("user_name").toString();
		Student student = new Student();
		student.setStudentNumber(studentNumber);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		
		journal.setAddTime(sdf.format(new java.util.Date()));
		journal.setReplyContent("--");
		journal.setReplyTime("--");
		journal.setStudentObj(student);
		journal.setTeacherNo("--");
        journalService.addJournal(journal);
        message = "项目日志添加成功!";
        success = true;
        writeJsonResponse(response, success, message);
	}
	
	
	/*ajax方式按照查询条件分页查询项目日志信息*/
	@RequestMapping(value = { "/list" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void list(String title,@ModelAttribute("studentObj") Student studentObj,String addTime,String teacherNo,Integer page,Integer rows, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		if (page==null || page == 0) page = 1;
		if (title == null) title = "";
		if (addTime == null) addTime = "";
		if (teacherNo == null) teacherNo = "";
		if(rows != 0)journalService.setRows(rows);
		List<Journal> journalList = journalService.queryJournal(title, studentObj, addTime, teacherNo, page);
	    /*计算总的页数和总的记录数*/
	    journalService.queryTotalPageAndRecordNumber(title, studentObj, addTime, teacherNo);
	    /*获取到总的页码数目*/
	    int totalPage = journalService.getTotalPage();
	    /*当前查询条件下总记录数*/
	    int recordNumber = journalService.getRecordNumber();
        response.setContentType("text/json;charset=UTF-8");
		PrintWriter out = response.getWriter();
		//将要被返回到客户端的对象
		JSONObject jsonObj=new JSONObject();
		jsonObj.accumulate("total", recordNumber);
		JSONArray jsonArray = new JSONArray();
		for(Journal journal:journalList) {
			JSONObject jsonJournal = journal.getJsonObject();
			jsonArray.put(jsonJournal);
		}
		jsonObj.accumulate("rows", jsonArray);
		out.println(jsonObj.toString());
		out.flush();
		out.close();
	}

	/*ajax方式按照查询条件分页查询项目日志信息*/
	@RequestMapping(value = { "/listAll" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void listAll(HttpServletResponse response) throws Exception {
		List<Journal> journalList = journalService.queryAllJournal();
        response.setContentType("text/json;charset=UTF-8"); 
		PrintWriter out = response.getWriter();
		JSONArray jsonArray = new JSONArray();
		for(Journal journal:journalList) {
			JSONObject jsonJournal = new JSONObject();
			jsonJournal.accumulate("journalId", journal.getJournalId());
			jsonJournal.accumulate("title", journal.getTitle());
			jsonArray.put(jsonJournal);
		}
		out.println(jsonArray.toString());
		out.flush();
		out.close();
	}

	/*前台按照查询条件分页查询项目日志信息*/
	@RequestMapping(value = { "/frontlist" }, method = {RequestMethod.GET,RequestMethod.POST})
	public String frontlist(String title,@ModelAttribute("studentObj") Student studentObj,String addTime,String teacherNo,Integer currentPage, Model model, HttpServletRequest request) throws Exception  {
		if (currentPage==null || currentPage == 0) currentPage = 1;
		if (title == null) title = "";
		if (addTime == null) addTime = "";
		if (teacherNo == null) teacherNo = "";
		List<Journal> journalList = journalService.queryJournal(title, studentObj, addTime, teacherNo, currentPage);
	    /*计算总的页数和总的记录数*/
	    journalService.queryTotalPageAndRecordNumber(title, studentObj, addTime, teacherNo);
	    /*获取到总的页码数目*/
	    int totalPage = journalService.getTotalPage();
	    /*当前查询条件下总记录数*/
	    int recordNumber = journalService.getRecordNumber();
	    request.setAttribute("journalList",  journalList);
	    request.setAttribute("totalPage", totalPage);
	    request.setAttribute("recordNumber", recordNumber);
	    request.setAttribute("currentPage", currentPage);
	    request.setAttribute("title", title);
	    request.setAttribute("studentObj", studentObj);
	    request.setAttribute("addTime", addTime);
	    request.setAttribute("teacherNo", teacherNo);
	    List<Student> studentList = studentService.queryAllStudent();
	    request.setAttribute("studentList", studentList);
		return "Journal/journal_frontquery_result"; 
	}
	
	
	
	/*学生前台按照查询条件分页查询项目日志信息*/
	@RequestMapping(value = { "/stuFrontlist" }, method = {RequestMethod.GET,RequestMethod.POST})
	public String stuFrontlist(String title,@ModelAttribute("studentObj") Student studentObj,String addTime,String teacherNo,Integer currentPage, Model model, HttpServletRequest request,HttpSession session) throws Exception  {
		if (currentPage==null || currentPage == 0) currentPage = 1;
		if (title == null) title = "";
		if (addTime == null) addTime = "";
		if (teacherNo == null) teacherNo = "";
		studentObj = new Student();
		studentObj.setStudentNumber(session.getAttribute("user_name").toString());
		List<Journal> journalList = journalService.queryJournal(title, studentObj, addTime, teacherNo, currentPage);
	    /*计算总的页数和总的记录数*/
	    journalService.queryTotalPageAndRecordNumber(title, studentObj, addTime, teacherNo);
	    /*获取到总的页码数目*/
	    int totalPage = journalService.getTotalPage();
	    /*当前查询条件下总记录数*/
	    int recordNumber = journalService.getRecordNumber();
	    request.setAttribute("journalList",  journalList);
	    request.setAttribute("totalPage", totalPage);
	    request.setAttribute("recordNumber", recordNumber);
	    request.setAttribute("currentPage", currentPage);
	    request.setAttribute("title", title);
	    request.setAttribute("studentObj", studentObj);
	    request.setAttribute("addTime", addTime);
	    request.setAttribute("teacherNo", teacherNo);
	    List<Student> studentList = studentService.queryAllStudent();
	    request.setAttribute("studentList", studentList);
		return "Journal/journal_stuFrontquery_result"; 
	}
	
	

     /*前台查询Journal信息*/
	@RequestMapping(value="/{journalId}/frontshow",method=RequestMethod.GET)
	public String frontshow(@PathVariable Integer journalId,Model model,HttpServletRequest request) throws Exception {
		/*根据主键journalId获取Journal对象*/
        Journal journal = journalService.getJournal(journalId);

        List<Student> studentList = studentService.queryAllStudent();
        request.setAttribute("studentList", studentList);
        request.setAttribute("journal",  journal);
        return "Journal/journal_frontshow";
	}

	/*ajax方式显示项目日志修改jsp视图页*/
	@RequestMapping(value="/{journalId}/update",method=RequestMethod.GET)
	public void update(@PathVariable Integer journalId,Model model,HttpServletRequest request,HttpServletResponse response) throws Exception {
        /*根据主键journalId获取Journal对象*/
        Journal journal = journalService.getJournal(journalId);

        response.setContentType("text/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
		//将要被返回到客户端的对象 
		JSONObject jsonJournal = journal.getJsonObject();
		out.println(jsonJournal.toString());
		out.flush();
		out.close();
	}

	/*ajax方式更新项目日志信息*/
	@RequestMapping(value = "/{journalId}/update", method = RequestMethod.POST)
	public void update(@Validated Journal journal, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		String message = "";
    	boolean success = false;
		if (br.hasErrors()) { 
			message = "输入的信息有错误！";
			writeJsonResponse(response, success, message);
			return;
		}
		try {
			journalService.updateJournal(journal);
			message = "项目日志更新成功!";
			success = true;
			writeJsonResponse(response, success, message);
		} catch (Exception e) {
			e.printStackTrace();
			message = "项目日志更新失败!";
			writeJsonResponse(response, success, message); 
		}
	}
	
	/*ajax方式更新项目日志信息*/
	@RequestMapping(value = "/{journalId}/teacherUpdate", method = RequestMethod.POST)
	public void teacherUpdate(Journal journal, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response,HttpSession session) throws Exception {
		String message = "";
    	boolean success = false;
		
    	journal.setTeacherNo(session.getAttribute("username").toString());
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	journal.setReplyTime(sdf.format(new java.util.Date()));
    	
		try {
			journalService.updateJournal(journal);
			message = "项目日志更新成功!";
			success = true;
			writeJsonResponse(response, success, message);
		} catch (Exception e) {
			e.printStackTrace();
			message = "项目日志更新失败!";
			writeJsonResponse(response, success, message); 
		}
	}
	
	
    /*删除项目日志信息*/
	@RequestMapping(value="/{journalId}/delete",method=RequestMethod.GET)
	public String delete(@PathVariable Integer journalId,HttpServletRequest request) throws UnsupportedEncodingException {
		  try {
			  journalService.deleteJournal(journalId);
	            request.setAttribute("message", "项目日志删除成功!");
	            return "message";
	        } catch (Exception e) { 
	            e.printStackTrace();
	            request.setAttribute("error", "项目日志删除失败!");
				return "error";

	        }

	}

	/*ajax方式删除多条项目日志记录*/
	@RequestMapping(value="/deletes",method=RequestMethod.POST)
	public void delete(String journalIds,HttpServletRequest request,HttpServletResponse response) throws IOException, JSONException {
		String message = "";
    	boolean success = false;
        try { 
        	int count = journalService.deleteJournals(journalIds);
        	success = true;
        	message = count + "条记录删除成功";
        	writeJsonResponse(response, success, message);
        } catch (Exception e) { 
            //e.printStackTrace();
            message = "有记录存在外键约束,删除失败";
            writeJsonResponse(response, success, message);
        }
	}

	/*按照查询条件导出项目日志信息到Excel*/
	@RequestMapping(value = { "/OutToExcel" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void OutToExcel(String title,@ModelAttribute("studentObj") Student studentObj,String addTime,String teacherNo, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
        if(title == null) title = "";
        if(addTime == null) addTime = "";
        if(teacherNo == null) teacherNo = "";
        List<Journal> journalList = journalService.queryJournal(title,studentObj,addTime,teacherNo);
        ExportExcelUtil ex = new ExportExcelUtil();
        String _title = "Journal信息记录"; 
        String[] headers = { "日志id","日志标题","发布学生","发布时间","审核老师","答复内容","答复时间"};
        List<String[]> dataset = new ArrayList<String[]>(); 
        for(int i=0;i<journalList.size();i++) {
        	Journal journal = journalList.get(i); 
        	dataset.add(new String[]{journal.getJournalId() + "",journal.getTitle(),journal.getStudentObj().getName(),journal.getAddTime(),journal.getTeacherNo(),journal.getReplyContent(),journal.getReplyTime()});
        }
        /*
        OutputStream out = null;
		try {
			out = new FileOutputStream("C://output.xls");
			ex.exportExcel(title,headers, dataset, out);
		    out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		*/
		OutputStream out = null;//创建一个输出流对象 
		try { 
			out = response.getOutputStream();//
			response.setHeader("Content-disposition","attachment; filename="+"Journal.xls");//filename是下载的xls的名，建议最好用英文 
			response.setContentType("application/msexcel;charset=UTF-8");//设置类型 
			response.setHeader("Pragma","No-cache");//设置头 
			response.setHeader("Cache-Control","no-cache");//设置头 
			response.setDateHeader("Expires", 0);//设置日期头  
			String rootPath = request.getSession().getServletContext().getRealPath("/");
			ex.exportExcel(rootPath,_title,headers, dataset, out);
			out.flush();
		} catch (IOException e) { 
			e.printStackTrace(); 
		}finally{
			try{
				if(out!=null){ 
					out.close(); 
				}
			}catch(IOException e){ 
				e.printStackTrace(); 
			} 
		}
    }
}
