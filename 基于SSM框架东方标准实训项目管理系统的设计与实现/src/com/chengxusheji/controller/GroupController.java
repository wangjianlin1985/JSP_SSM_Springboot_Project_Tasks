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
import com.chengxusheji.service.GroupService;
import com.chengxusheji.service.GroupStudentService;
import com.chengxusheji.po.Group;
import com.chengxusheji.po.GroupStudent;

//Group管理控制层
@Controller
@RequestMapping("/Group")
public class GroupController extends BaseController {

    /*业务层对象*/
    @Resource GroupService groupService;
    @Resource GroupStudentService gsService;

	@InitBinder("group")
	public void initBinderGroup(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("group.");
	}
	/*跳转到添加Group视图*/
	@RequestMapping(value = "/add", method = RequestMethod.GET)
	public String add(Model model,HttpServletRequest request) throws Exception {
		model.addAttribute(new Group());
		return "Group_add";
	}

	/*客户端ajax方式提交添加分组信息*/
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	public void add(@Validated Group group, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		String message = "";
		boolean success = false;
		if (br.hasErrors()) {
			message = "输入信息不符合要求！";
			writeJsonResponse(response, success, message);
			return ;
		}
        groupService.addGroup(group);
        message = "分组添加成功!";
        success = true;
        writeJsonResponse(response, success, message);
	}
	/*ajax方式按照查询条件分页查询分组信息*/
	@RequestMapping(value = { "/list" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void list(Integer page,Integer rows, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		if (page==null || page == 0) page = 1;
		if(rows != 0)groupService.setRows(rows);
		List<Group> groupList = groupService.queryGroup(page);
	    /*计算总的页数和总的记录数*/
	    groupService.queryTotalPageAndRecordNumber();
	    /*获取到总的页码数目*/
	    int totalPage = groupService.getTotalPage();
	    /*当前查询条件下总记录数*/
	    int recordNumber = groupService.getRecordNumber();
        response.setContentType("text/json;charset=UTF-8");
		PrintWriter out = response.getWriter();
		//将要被返回到客户端的对象
		JSONObject jsonObj=new JSONObject();
		jsonObj.accumulate("total", recordNumber);
		JSONArray jsonArray = new JSONArray();
		for(Group group:groupList) {
			JSONObject jsonGroup = group.getJsonObject();
			jsonArray.put(jsonGroup);
		}
		jsonObj.accumulate("rows", jsonArray);
		out.println(jsonObj.toString());
		out.flush();
		out.close();
	}

	/*ajax方式按照查询条件分页查询分组信息*/
	@RequestMapping(value = { "/listAll" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void listAll(HttpServletResponse response) throws Exception {
		List<Group> groupList = groupService.queryAllGroup();
        response.setContentType("text/json;charset=UTF-8"); 
		PrintWriter out = response.getWriter();
		JSONArray jsonArray = new JSONArray();
		for(Group group:groupList) {
			JSONObject jsonGroup = new JSONObject();
			jsonGroup.accumulate("groupId", group.getGroupId());
			jsonGroup.accumulate("groupName", group.getGroupName());
			jsonArray.put(jsonGroup);
		}
		out.println(jsonArray.toString());
		out.flush();
		out.close();
	}

	/*前台按照查询条件分页查询分组信息*/
	@RequestMapping(value = { "/frontlist" }, method = {RequestMethod.GET,RequestMethod.POST})
	public String frontlist(Integer currentPage, Model model, HttpServletRequest request) throws Exception  {
		if (currentPage==null || currentPage == 0) currentPage = 1;
		List<Group> groupList = groupService.queryGroup(currentPage);
	    /*计算总的页数和总的记录数*/
	    groupService.queryTotalPageAndRecordNumber();
	    /*获取到总的页码数目*/
	    int totalPage = groupService.getTotalPage();
	    /*当前查询条件下总记录数*/
	    int recordNumber = groupService.getRecordNumber();
	    request.setAttribute("groupList",  groupList);
	    request.setAttribute("totalPage", totalPage);
	    request.setAttribute("recordNumber", recordNumber);
	    request.setAttribute("currentPage", currentPage);
		return "Group/group_frontquery_result"; 
	}

     /*前台查询Group信息*/
	@RequestMapping(value="/{groupId}/frontshow",method=RequestMethod.GET)
	public String frontshow(@PathVariable Integer groupId,Model model,HttpServletRequest request) throws Exception {
		/*根据主键groupId获取Group对象*/
        Group group = groupService.getGroup(groupId);
        ArrayList<GroupStudent> gsList = gsService.queryGroupStudent(group, null);
        
        request.setAttribute("group",  group);
        request.setAttribute("gsList", gsList);
        return "Group/group_frontshow";
	}

	/*ajax方式显示分组修改jsp视图页*/
	@RequestMapping(value="/{groupId}/update",method=RequestMethod.GET)
	public void update(@PathVariable Integer groupId,Model model,HttpServletRequest request,HttpServletResponse response) throws Exception {
        /*根据主键groupId获取Group对象*/
        Group group = groupService.getGroup(groupId);

        response.setContentType("text/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
		//将要被返回到客户端的对象 
		JSONObject jsonGroup = group.getJsonObject();
		out.println(jsonGroup.toString());
		out.flush();
		out.close();
	}

	/*ajax方式更新分组信息*/
	@RequestMapping(value = "/{groupId}/update", method = RequestMethod.POST)
	public void update(@Validated Group group, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		String message = "";
    	boolean success = false;
		if (br.hasErrors()) { 
			message = "输入的信息有错误！";
			writeJsonResponse(response, success, message);
			return;
		}
		try {
			groupService.updateGroup(group);
			message = "分组更新成功!";
			success = true;
			writeJsonResponse(response, success, message);
		} catch (Exception e) {
			e.printStackTrace();
			message = "分组更新失败!";
			writeJsonResponse(response, success, message); 
		}
	}
    /*删除分组信息*/
	@RequestMapping(value="/{groupId}/delete",method=RequestMethod.GET)
	public String delete(@PathVariable Integer groupId,HttpServletRequest request) throws UnsupportedEncodingException {
		  try {
			  groupService.deleteGroup(groupId);
	            request.setAttribute("message", "分组删除成功!");
	            return "message";
	        } catch (Exception e) { 
	            e.printStackTrace();
	            request.setAttribute("error", "分组删除失败!");
				return "error";

	        }

	}

	/*ajax方式删除多条分组记录*/
	@RequestMapping(value="/deletes",method=RequestMethod.POST)
	public void delete(String groupIds,HttpServletRequest request,HttpServletResponse response) throws IOException, JSONException {
		String message = "";
    	boolean success = false;
        try { 
        	int count = groupService.deleteGroups(groupIds);
        	success = true;
        	message = count + "条记录删除成功";
        	writeJsonResponse(response, success, message);
        } catch (Exception e) { 
            //e.printStackTrace();
            message = "有记录存在外键约束,删除失败";
            writeJsonResponse(response, success, message);
        }
	}

	/*按照查询条件导出分组信息到Excel*/
	@RequestMapping(value = { "/OutToExcel" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void OutToExcel( Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
        List<Group> groupList = groupService.queryGroup();
        ExportExcelUtil ex = new ExportExcelUtil();
        String _title = "Group信息记录"; 
        String[] headers = { "分组id","分组名称"};
        List<String[]> dataset = new ArrayList<String[]>(); 
        for(int i=0;i<groupList.size();i++) {
        	Group group = groupList.get(i); 
        	dataset.add(new String[]{group.getGroupId() + "",group.getGroupName()});
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
			response.setHeader("Content-disposition","attachment; filename="+"Group.xls");//filename是下载的xls的名，建议最好用英文 
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
