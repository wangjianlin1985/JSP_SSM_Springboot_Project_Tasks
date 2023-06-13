package com.chengxusheji.service;

import java.util.ArrayList;
import javax.annotation.Resource; 
import org.springframework.stereotype.Service;
import com.chengxusheji.po.Project;
import com.chengxusheji.po.Student;
import com.chengxusheji.po.ResourceInfo;

import com.chengxusheji.mapper.ResourceInfoMapper;
@Service
public class ResourceInfoService {

	@Resource ResourceInfoMapper resourceInfoMapper;
    /*每页显示记录数目*/
    private int rows = 10;;
    public int getRows() {
		return rows;
	}
	public void setRows(int rows) {
		this.rows = rows;
	}

    /*保存查询后总的页数*/
    private int totalPage;
    public void setTotalPage(int totalPage) {
        this.totalPage = totalPage;
    }
    public int getTotalPage() {
        return totalPage;
    }

    /*保存查询到的总记录数*/
    private int recordNumber;
    public void setRecordNumber(int recordNumber) {
        this.recordNumber = recordNumber;
    }
    public int getRecordNumber() {
        return recordNumber;
    }

    /*添加资源记录*/
    public void addResourceInfo(ResourceInfo resourceInfo) throws Exception {
    	resourceInfoMapper.addResourceInfo(resourceInfo);
    }

    /*按照查询条件分页查询资源记录*/
    public ArrayList<ResourceInfo> queryResourceInfo(Project projectObj,Student studentObj,String addTime,int currentPage) throws Exception { 
     	String where = "where 1=1";
    	if(null != projectObj && projectObj.getProjectId()!= null && projectObj.getProjectId()!= 0)  where += " and t_resourceInfo.projectObj=" + projectObj.getProjectId();
    	if(null != studentObj &&  studentObj.getStudentNumber() != null  && !studentObj.getStudentNumber().equals(""))  where += " and t_resourceInfo.studentObj='" + studentObj.getStudentNumber() + "'";
    	if(!addTime.equals("")) where = where + " and t_resourceInfo.addTime like '%" + addTime + "%'";
    	int startIndex = (currentPage-1) * this.rows;
    	return resourceInfoMapper.queryResourceInfo(where, startIndex, this.rows);
    }

    /*按照查询条件查询所有记录*/
    public ArrayList<ResourceInfo> queryResourceInfo(Project projectObj,Student studentObj,String addTime) throws Exception  { 
     	String where = "where 1=1";
    	if(null != projectObj && projectObj.getProjectId()!= null && projectObj.getProjectId()!= 0)  where += " and t_resourceInfo.projectObj=" + projectObj.getProjectId();
    	if(null != studentObj &&  studentObj.getStudentNumber() != null && !studentObj.getStudentNumber().equals(""))  where += " and t_resourceInfo.studentObj='" + studentObj.getStudentNumber() + "'";
    	if(!addTime.equals("")) where = where + " and t_resourceInfo.addTime like '%" + addTime + "%'";
    	return resourceInfoMapper.queryResourceInfoList(where);
    }

    /*查询所有资源记录*/
    public ArrayList<ResourceInfo> queryAllResourceInfo()  throws Exception {
        return resourceInfoMapper.queryResourceInfoList("where 1=1");
    }

    /*当前查询条件下计算总的页数和记录数*/
    public void queryTotalPageAndRecordNumber(Project projectObj,Student studentObj,String addTime) throws Exception {
     	String where = "where 1=1";
    	if(null != projectObj && projectObj.getProjectId()!= null && projectObj.getProjectId()!= 0)  where += " and t_resourceInfo.projectObj=" + projectObj.getProjectId();
    	if(null != studentObj &&  studentObj.getStudentNumber() != null && !studentObj.getStudentNumber().equals(""))  where += " and t_resourceInfo.studentObj='" + studentObj.getStudentNumber() + "'";
    	if(!addTime.equals("")) where = where + " and t_resourceInfo.addTime like '%" + addTime + "%'";
        recordNumber = resourceInfoMapper.queryResourceInfoCount(where);
        int mod = recordNumber % this.rows;
        totalPage = recordNumber / this.rows;
        if(mod != 0) totalPage++;
    }

    /*根据主键获取资源记录*/
    public ResourceInfo getResourceInfo(int resourceId) throws Exception  {
        ResourceInfo resourceInfo = resourceInfoMapper.getResourceInfo(resourceId);
        return resourceInfo;
    }

    /*更新资源记录*/
    public void updateResourceInfo(ResourceInfo resourceInfo) throws Exception {
        resourceInfoMapper.updateResourceInfo(resourceInfo);
    }

    /*删除一条资源记录*/
    public void deleteResourceInfo (int resourceId) throws Exception {
        resourceInfoMapper.deleteResourceInfo(resourceId);
    }

    /*删除多条资源信息*/
    public int deleteResourceInfos (String resourceIds) throws Exception {
    	String _resourceIds[] = resourceIds.split(",");
    	for(String _resourceId: _resourceIds) {
    		resourceInfoMapper.deleteResourceInfo(Integer.parseInt(_resourceId));
    	}
    	return _resourceIds.length;
    }
}
