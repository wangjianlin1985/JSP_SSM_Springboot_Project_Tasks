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
import com.chengxusheji.service.ResourceInfoService;
import com.chengxusheji.po.ResourceInfo;
import com.chengxusheji.service.ProjectService;
import com.chengxusheji.po.Project;
import com.chengxusheji.service.StudentService;
import com.chengxusheji.po.Student;

//ResourceInfo管理控制层
@Controller
@RequestMapping("/ResourceInfo")
public class ResourceInfoController extends BaseController {

    /*业务层对象*/
    @Resource ResourceInfoService resourceInfoService;

    @Resource ProjectService projectService;
    @Resource StudentService studentService;
	@InitBinder("projectObj")
	public void initBinderprojectObj(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("projectObj.");
	}
	@InitBinder("studentObj")
	public void initBinderstudentObj(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("studentObj.");
	}
	@InitBinder("resourceInfo")
	public void initBinderResourceInfo(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("resourceInfo.");
	}
	/*跳转到添加ResourceInfo视图*/
	@RequestMapping(value = "/add", method = RequestMethod.GET)
	public String add(Model model,HttpServletRequest request) throws Exception {
		model.addAttribute(new ResourceInfo());
		/*查询所有的Project信息*/
		List<Project> projectList = projectService.queryAllProject();
		request.setAttribute("projectList", projectList);
		/*查询所有的Student信息*/
		List<Student> studentList = studentService.queryAllStudent();
		request.setAttribute("studentList", studentList);
		return "ResourceInfo_add";
	}

	/*客户端ajax方式提交添加资源信息*/
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	public void add(@Validated ResourceInfo resourceInfo, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		String message = "";
		boolean success = false;
		if (br.hasErrors()) {
			message = "输入信息不符合要求！";
			writeJsonResponse(response, success, message);
			return ;
		}
		resourceInfo.setResourceFile(this.handleFileUpload(request, "resourceFileFile"));
        resourceInfoService.addResourceInfo(resourceInfo);
        message = "资源添加成功!";
        success = true;
        writeJsonResponse(response, success, message);
	}
	
	
	/*学生前台客户端ajax方式提交添加资源信息*/
	@RequestMapping(value = "/stuAdd", method = RequestMethod.POST)
	public void studAdd(ResourceInfo resourceInfo, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response,HttpSession session) throws Exception {
		String message = "";
		boolean success = false;
		String studentNumber = session.getAttribute("user_name").toString();
		Student student = new Student();
		student.setStudentNumber(studentNumber);
		 
		resourceInfo.setResourceFile(this.handleFileUpload(request, "resourceFileFile"));

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		resourceInfo.setAddTime(sdf.format(new java.util.Date()));
		resourceInfo.setEvaluateContent("--");
		resourceInfo.setStudentObj(student);
		
        resourceInfoService.addResourceInfo(resourceInfo);
        message = "资源添加成功!";
        success = true;
        writeJsonResponse(response, success, message);
	}
	
	
	
	/*ajax方式按照查询条件分页查询资源信息*/
	@RequestMapping(value = { "/list" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void list(@ModelAttribute("projectObj") Project projectObj,@ModelAttribute("studentObj") Student studentObj,String addTime,Integer page,Integer rows, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		if (page==null || page == 0) page = 1;
		if (addTime == null) addTime = "";
		if(rows != 0)resourceInfoService.setRows(rows);
		List<ResourceInfo> resourceInfoList = resourceInfoService.queryResourceInfo(projectObj, studentObj, addTime, page);
	    /*计算总的页数和总的记录数*/
	    resourceInfoService.queryTotalPageAndRecordNumber(projectObj, studentObj, addTime);
	    /*获取到总的页码数目*/
	    int totalPage = resourceInfoService.getTotalPage();
	    /*当前查询条件下总记录数*/
	    int recordNumber = resourceInfoService.getRecordNumber();
        response.setContentType("text/json;charset=UTF-8");
		PrintWriter out = response.getWriter();
		//将要被返回到客户端的对象
		JSONObject jsonObj=new JSONObject();
		jsonObj.accumulate("total", recordNumber);
		JSONArray jsonArray = new JSONArray();
		for(ResourceInfo resourceInfo:resourceInfoList) {
			JSONObject jsonResourceInfo = resourceInfo.getJsonObject();
			jsonArray.put(jsonResourceInfo);
		}
		jsonObj.accumulate("rows", jsonArray);
		out.println(jsonObj.toString());
		out.flush();
		out.close();
	}

	/*ajax方式按照查询条件分页查询资源信息*/
	@RequestMapping(value = { "/listAll" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void listAll(HttpServletResponse response) throws Exception {
		List<ResourceInfo> resourceInfoList = resourceInfoService.queryAllResourceInfo();
        response.setContentType("text/json;charset=UTF-8"); 
		PrintWriter out = response.getWriter();
		JSONArray jsonArray = new JSONArray();
		for(ResourceInfo resourceInfo:resourceInfoList) {
			JSONObject jsonResourceInfo = new JSONObject();
			jsonResourceInfo.accumulate("resourceId", resourceInfo.getResourceId());
			jsonArray.put(jsonResourceInfo);
		}
		out.println(jsonArray.toString());
		out.flush();
		out.close();
	}

	/*前台按照查询条件分页查询资源信息*/
	@RequestMapping(value = { "/frontlist" }, method = {RequestMethod.GET,RequestMethod.POST})
	public String frontlist(@ModelAttribute("projectObj") Project projectObj,@ModelAttribute("studentObj") Student studentObj,String addTime,Integer currentPage, Model model, HttpServletRequest request) throws Exception  {
		if (currentPage==null || currentPage == 0) currentPage = 1;
		if (addTime == null) addTime = "";
		List<ResourceInfo> resourceInfoList = resourceInfoService.queryResourceInfo(projectObj, studentObj, addTime, currentPage);
	    /*计算总的页数和总的记录数*/
	    resourceInfoService.queryTotalPageAndRecordNumber(projectObj, studentObj, addTime);
	    /*获取到总的页码数目*/
	    int totalPage = resourceInfoService.getTotalPage();
	    /*当前查询条件下总记录数*/
	    int recordNumber = resourceInfoService.getRecordNumber();
	    request.setAttribute("resourceInfoList",  resourceInfoList);
	    request.setAttribute("totalPage", totalPage);
	    request.setAttribute("recordNumber", recordNumber);
	    request.setAttribute("currentPage", currentPage);
	    request.setAttribute("projectObj", projectObj);
	    request.setAttribute("studentObj", studentObj);
	    request.setAttribute("addTime", addTime);
	    List<Project> projectList = projectService.queryAllProject();
	    request.setAttribute("projectList", projectList);
	    List<Student> studentList = studentService.queryAllStudent();
	    request.setAttribute("studentList", studentList);
		return "ResourceInfo/resourceInfo_frontquery_result"; 
	}
	
	
	/*学生前台按照查询条件分页查询资源信息*/
	@RequestMapping(value = { "/stuFrontlist" }, method = {RequestMethod.GET,RequestMethod.POST})
	public String stuFrontlist(@ModelAttribute("projectObj") Project projectObj,@ModelAttribute("studentObj") Student studentObj,String addTime,Integer currentPage, Model model, HttpServletRequest request,HttpSession session) throws Exception  {
		if (currentPage==null || currentPage == 0) currentPage = 1;
		if (addTime == null) addTime = "";
		studentObj = new Student();
		studentObj.setStudentNumber(session.getAttribute("user_name").toString());
		List<ResourceInfo> resourceInfoList = resourceInfoService.queryResourceInfo(projectObj, studentObj, addTime, currentPage);
	    /*计算总的页数和总的记录数*/
	    resourceInfoService.queryTotalPageAndRecordNumber(projectObj, studentObj, addTime);
	    /*获取到总的页码数目*/
	    int totalPage = resourceInfoService.getTotalPage();
	    /*当前查询条件下总记录数*/
	    int recordNumber = resourceInfoService.getRecordNumber();
	    request.setAttribute("resourceInfoList",  resourceInfoList);
	    request.setAttribute("totalPage", totalPage);
	    request.setAttribute("recordNumber", recordNumber);
	    request.setAttribute("currentPage", currentPage);
	    request.setAttribute("projectObj", projectObj);
	    request.setAttribute("studentObj", studentObj);
	    request.setAttribute("addTime", addTime);
	    List<Project> projectList = projectService.queryAllProject();
	    request.setAttribute("projectList", projectList);
	    List<Student> studentList = studentService.queryAllStudent();
	    request.setAttribute("studentList", studentList);
		return "ResourceInfo/resourceInfo_stuFrontquery_result"; 
	}
	

     /*前台查询ResourceInfo信息*/
	@RequestMapping(value="/{resourceId}/frontshow",method=RequestMethod.GET)
	public String frontshow(@PathVariable Integer resourceId,Model model,HttpServletRequest request) throws Exception {
		/*根据主键resourceId获取ResourceInfo对象*/
        ResourceInfo resourceInfo = resourceInfoService.getResourceInfo(resourceId);

        List<Project> projectList = projectService.queryAllProject();
        request.setAttribute("projectList", projectList);
        List<Student> studentList = studentService.queryAllStudent();
        request.setAttribute("studentList", studentList);
        request.setAttribute("resourceInfo",  resourceInfo);
        return "ResourceInfo/resourceInfo_frontshow";
	}

	/*ajax方式显示资源修改jsp视图页*/
	@RequestMapping(value="/{resourceId}/update",method=RequestMethod.GET)
	public void update(@PathVariable Integer resourceId,Model model,HttpServletRequest request,HttpServletResponse response) throws Exception {
        /*根据主键resourceId获取ResourceInfo对象*/
        ResourceInfo resourceInfo = resourceInfoService.getResourceInfo(resourceId);

        response.setContentType("text/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
		//将要被返回到客户端的对象 
		JSONObject jsonResourceInfo = resourceInfo.getJsonObject();
		out.println(jsonResourceInfo.toString());
		out.flush();
		out.close();
	}

	/*ajax方式更新资源信息*/
	@RequestMapping(value = "/{resourceId}/update", method = RequestMethod.POST)
	public void update(@Validated ResourceInfo resourceInfo, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		String message = "";
    	boolean success = false;
		if (br.hasErrors()) { 
			message = "输入的信息有错误！";
			writeJsonResponse(response, success, message);
			return;
		}
		String resourceFileFileName = this.handleFileUpload(request, "resourceFileFile");
		if(!resourceFileFileName.equals(""))resourceInfo.setResourceFile(resourceFileFileName);
		try {
			resourceInfoService.updateResourceInfo(resourceInfo);
			message = "资源更新成功!";
			success = true;
			writeJsonResponse(response, success, message);
		} catch (Exception e) {
			e.printStackTrace();
			message = "资源更新失败!";
			writeJsonResponse(response, success, message); 
		}
	}
    /*删除资源信息*/
	@RequestMapping(value="/{resourceId}/delete",method=RequestMethod.GET)
	public String delete(@PathVariable Integer resourceId,HttpServletRequest request) throws UnsupportedEncodingException {
		  try {
			  resourceInfoService.deleteResourceInfo(resourceId);
	            request.setAttribute("message", "资源删除成功!");
	            return "message";
	        } catch (Exception e) { 
	            e.printStackTrace();
	            request.setAttribute("error", "资源删除失败!");
				return "error";

	        }

	}

	/*ajax方式删除多条资源记录*/
	@RequestMapping(value="/deletes",method=RequestMethod.POST)
	public void delete(String resourceIds,HttpServletRequest request,HttpServletResponse response) throws IOException, JSONException {
		String message = "";
    	boolean success = false;
        try { 
        	int count = resourceInfoService.deleteResourceInfos(resourceIds);
        	success = true;
        	message = count + "条记录删除成功";
        	writeJsonResponse(response, success, message);
        } catch (Exception e) { 
            //e.printStackTrace();
            message = "有记录存在外键约束,删除失败";
            writeJsonResponse(response, success, message);
        }
	}

	/*按照查询条件导出资源信息到Excel*/
	@RequestMapping(value = { "/OutToExcel" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void OutToExcel(@ModelAttribute("projectObj") Project projectObj,@ModelAttribute("studentObj") Student studentObj,String addTime, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
        if(addTime == null) addTime = "";
        List<ResourceInfo> resourceInfoList = resourceInfoService.queryResourceInfo(projectObj,studentObj,addTime);
        ExportExcelUtil ex = new ExportExcelUtil();
        String _title = "ResourceInfo信息记录"; 
        String[] headers = { "资源id","项目","上传学员","上传时间","老师评语"};
        List<String[]> dataset = new ArrayList<String[]>(); 
        for(int i=0;i<resourceInfoList.size();i++) {
        	ResourceInfo resourceInfo = resourceInfoList.get(i); 
        	dataset.add(new String[]{resourceInfo.getResourceId() + "",resourceInfo.getProjectObj().getProjectName(),resourceInfo.getStudentObj().getName(),resourceInfo.getAddTime(),resourceInfo.getEvaluateContent()});
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
			response.setHeader("Content-disposition","attachment; filename="+"ResourceInfo.xls");//filename是下载的xls的名，建议最好用英文 
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
