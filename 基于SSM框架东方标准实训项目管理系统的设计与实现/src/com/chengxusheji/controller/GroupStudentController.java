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
import com.chengxusheji.service.GroupStudentService;
import com.chengxusheji.po.GroupStudent;
import com.chengxusheji.service.GroupService;
import com.chengxusheji.po.Group;
import com.chengxusheji.service.StudentService;
import com.chengxusheji.po.Student;

//GroupStudent管理控制层
@Controller
@RequestMapping("/GroupStudent")
public class GroupStudentController extends BaseController {

    /*业务层对象*/
    @Resource GroupStudentService groupStudentService;

    @Resource GroupService groupService;
    @Resource StudentService studentService;
	@InitBinder("groupObj")
	public void initBindergroupObj(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("groupObj.");
	}
	@InitBinder("studentObj")
	public void initBinderstudentObj(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("studentObj.");
	}
	@InitBinder("groupStudent")
	public void initBinderGroupStudent(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("groupStudent.");
	}
	/*跳转到添加GroupStudent视图*/
	@RequestMapping(value = "/add", method = RequestMethod.GET)
	public String add(Model model,HttpServletRequest request) throws Exception {
		model.addAttribute(new GroupStudent());
		/*查询所有的Group信息*/
		List<Group> groupList = groupService.queryAllGroup();
		request.setAttribute("groupList", groupList);
		/*查询所有的Student信息*/
		List<Student> studentList = studentService.queryAllStudent();
		request.setAttribute("studentList", studentList);
		return "GroupStudent_add";
	}

	/*客户端ajax方式提交添加分组成员信息*/
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	public void add(@Validated GroupStudent groupStudent, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		String message = "";
		boolean success = false;
		if (br.hasErrors()) {
			message = "输入信息不符合要求！";
			writeJsonResponse(response, success, message);
			return ;
		}
        groupStudentService.addGroupStudent(groupStudent);
        message = "分组成员添加成功!";
        success = true;
        writeJsonResponse(response, success, message);
	}
	/*ajax方式按照查询条件分页查询分组成员信息*/
	@RequestMapping(value = { "/list" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void list(@ModelAttribute("groupObj") Group groupObj,@ModelAttribute("studentObj") Student studentObj,Integer page,Integer rows, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		if (page==null || page == 0) page = 1;
		if(rows != 0)groupStudentService.setRows(rows);
		List<GroupStudent> groupStudentList = groupStudentService.queryGroupStudent(groupObj, studentObj, page);
	    /*计算总的页数和总的记录数*/
	    groupStudentService.queryTotalPageAndRecordNumber(groupObj, studentObj);
	    /*获取到总的页码数目*/
	    int totalPage = groupStudentService.getTotalPage();
	    /*当前查询条件下总记录数*/
	    int recordNumber = groupStudentService.getRecordNumber();
        response.setContentType("text/json;charset=UTF-8");
		PrintWriter out = response.getWriter();
		//将要被返回到客户端的对象
		JSONObject jsonObj=new JSONObject();
		jsonObj.accumulate("total", recordNumber);
		JSONArray jsonArray = new JSONArray();
		for(GroupStudent groupStudent:groupStudentList) {
			JSONObject jsonGroupStudent = groupStudent.getJsonObject();
			jsonArray.put(jsonGroupStudent);
		}
		jsonObj.accumulate("rows", jsonArray);
		out.println(jsonObj.toString());
		out.flush();
		out.close();
	}

	/*ajax方式按照查询条件分页查询分组成员信息*/
	@RequestMapping(value = { "/listAll" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void listAll(HttpServletResponse response) throws Exception {
		List<GroupStudent> groupStudentList = groupStudentService.queryAllGroupStudent();
        response.setContentType("text/json;charset=UTF-8"); 
		PrintWriter out = response.getWriter();
		JSONArray jsonArray = new JSONArray();
		for(GroupStudent groupStudent:groupStudentList) {
			JSONObject jsonGroupStudent = new JSONObject();
			jsonGroupStudent.accumulate("gsId", groupStudent.getGsId());
			jsonArray.put(jsonGroupStudent);
		}
		out.println(jsonArray.toString());
		out.flush();
		out.close();
	}

	/*前台按照查询条件分页查询分组成员信息*/
	@RequestMapping(value = { "/frontlist" }, method = {RequestMethod.GET,RequestMethod.POST})
	public String frontlist(@ModelAttribute("groupObj") Group groupObj,@ModelAttribute("studentObj") Student studentObj,Integer currentPage, Model model, HttpServletRequest request) throws Exception  {
		if (currentPage==null || currentPage == 0) currentPage = 1;
		List<GroupStudent> groupStudentList = groupStudentService.queryGroupStudent(groupObj, studentObj, currentPage);
	    /*计算总的页数和总的记录数*/
	    groupStudentService.queryTotalPageAndRecordNumber(groupObj, studentObj);
	    /*获取到总的页码数目*/
	    int totalPage = groupStudentService.getTotalPage();
	    /*当前查询条件下总记录数*/
	    int recordNumber = groupStudentService.getRecordNumber();
	    request.setAttribute("groupStudentList",  groupStudentList);
	    request.setAttribute("totalPage", totalPage);
	    request.setAttribute("recordNumber", recordNumber);
	    request.setAttribute("currentPage", currentPage);
	    request.setAttribute("groupObj", groupObj);
	    request.setAttribute("studentObj", studentObj);
	    List<Group> groupList = groupService.queryAllGroup();
	    request.setAttribute("groupList", groupList);
	    List<Student> studentList = studentService.queryAllStudent();
	    request.setAttribute("studentList", studentList);
		return "GroupStudent/groupStudent_frontquery_result"; 
	}

     /*前台查询GroupStudent信息*/
	@RequestMapping(value="/{gsId}/frontshow",method=RequestMethod.GET)
	public String frontshow(@PathVariable Integer gsId,Model model,HttpServletRequest request) throws Exception {
		/*根据主键gsId获取GroupStudent对象*/
        GroupStudent groupStudent = groupStudentService.getGroupStudent(gsId);

        List<Group> groupList = groupService.queryAllGroup();
        request.setAttribute("groupList", groupList);
        List<Student> studentList = studentService.queryAllStudent();
        request.setAttribute("studentList", studentList);
        request.setAttribute("groupStudent",  groupStudent);
        return "GroupStudent/groupStudent_frontshow";
	}

	/*ajax方式显示分组成员修改jsp视图页*/
	@RequestMapping(value="/{gsId}/update",method=RequestMethod.GET)
	public void update(@PathVariable Integer gsId,Model model,HttpServletRequest request,HttpServletResponse response) throws Exception {
        /*根据主键gsId获取GroupStudent对象*/
        GroupStudent groupStudent = groupStudentService.getGroupStudent(gsId);

        response.setContentType("text/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
		//将要被返回到客户端的对象 
		JSONObject jsonGroupStudent = groupStudent.getJsonObject();
		out.println(jsonGroupStudent.toString());
		out.flush();
		out.close();
	}

	/*ajax方式更新分组成员信息*/
	@RequestMapping(value = "/{gsId}/update", method = RequestMethod.POST)
	public void update(@Validated GroupStudent groupStudent, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		String message = "";
    	boolean success = false;
		if (br.hasErrors()) { 
			message = "输入的信息有错误！";
			writeJsonResponse(response, success, message);
			return;
		}
		try {
			groupStudentService.updateGroupStudent(groupStudent);
			message = "分组成员更新成功!";
			success = true;
			writeJsonResponse(response, success, message);
		} catch (Exception e) {
			e.printStackTrace();
			message = "分组成员更新失败!";
			writeJsonResponse(response, success, message); 
		}
	}
    /*删除分组成员信息*/
	@RequestMapping(value="/{gsId}/delete",method=RequestMethod.GET)
	public String delete(@PathVariable Integer gsId,HttpServletRequest request) throws UnsupportedEncodingException {
		  try {
			  groupStudentService.deleteGroupStudent(gsId);
	            request.setAttribute("message", "分组成员删除成功!");
	            return "message";
	        } catch (Exception e) { 
	            e.printStackTrace();
	            request.setAttribute("error", "分组成员删除失败!");
				return "error";

	        }

	}

	/*ajax方式删除多条分组成员记录*/
	@RequestMapping(value="/deletes",method=RequestMethod.POST)
	public void delete(String gsIds,HttpServletRequest request,HttpServletResponse response) throws IOException, JSONException {
		String message = "";
    	boolean success = false;
        try { 
        	int count = groupStudentService.deleteGroupStudents(gsIds);
        	success = true;
        	message = count + "条记录删除成功";
        	writeJsonResponse(response, success, message);
        } catch (Exception e) { 
            //e.printStackTrace();
            message = "有记录存在外键约束,删除失败";
            writeJsonResponse(response, success, message);
        }
	}

	/*按照查询条件导出分组成员信息到Excel*/
	@RequestMapping(value = { "/OutToExcel" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void OutToExcel(@ModelAttribute("groupObj") Group groupObj,@ModelAttribute("studentObj") Student studentObj, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
        List<GroupStudent> groupStudentList = groupStudentService.queryGroupStudent(groupObj,studentObj);
        ExportExcelUtil ex = new ExportExcelUtil();
        String _title = "GroupStudent信息记录"; 
        String[] headers = { "成员id","所在分组","学生"};
        List<String[]> dataset = new ArrayList<String[]>(); 
        for(int i=0;i<groupStudentList.size();i++) {
        	GroupStudent groupStudent = groupStudentList.get(i); 
        	dataset.add(new String[]{groupStudent.getGsId() + "",groupStudent.getGroupObj().getGroupName(),groupStudent.getStudentObj().getName()});
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
			response.setHeader("Content-disposition","attachment; filename="+"GroupStudent.xls");//filename是下载的xls的名，建议最好用英文 
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
