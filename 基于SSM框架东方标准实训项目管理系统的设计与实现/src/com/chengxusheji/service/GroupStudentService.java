package com.chengxusheji.service;

import java.util.ArrayList;
import javax.annotation.Resource; 
import org.springframework.stereotype.Service;
import com.chengxusheji.po.Group;
import com.chengxusheji.po.Student;
import com.chengxusheji.po.GroupStudent;

import com.chengxusheji.mapper.GroupStudentMapper;
@Service
public class GroupStudentService {

	@Resource GroupStudentMapper groupStudentMapper;
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

    /*添加分组成员记录*/
    public void addGroupStudent(GroupStudent groupStudent) throws Exception {
    	groupStudentMapper.addGroupStudent(groupStudent);
    }

    /*按照查询条件分页查询分组成员记录*/
    public ArrayList<GroupStudent> queryGroupStudent(Group groupObj,Student studentObj,int currentPage) throws Exception { 
     	String where = "where 1=1";
    	if(null != groupObj && groupObj.getGroupId()!= null && groupObj.getGroupId()!= 0)  where += " and t_groupStudent.groupObj=" + groupObj.getGroupId();
    	if(null != studentObj &&  studentObj.getStudentNumber() != null  && !studentObj.getStudentNumber().equals(""))  where += " and t_groupStudent.studentObj='" + studentObj.getStudentNumber() + "'";
    	int startIndex = (currentPage-1) * this.rows;
    	return groupStudentMapper.queryGroupStudent(where, startIndex, this.rows);
    }

    /*按照查询条件查询所有记录*/
    public ArrayList<GroupStudent> queryGroupStudent(Group groupObj,Student studentObj) throws Exception  { 
     	String where = "where 1=1";
    	if(null != groupObj && groupObj.getGroupId()!= null && groupObj.getGroupId()!= 0)  where += " and t_groupStudent.groupObj=" + groupObj.getGroupId();
    	if(null != studentObj &&  studentObj.getStudentNumber() != null && !studentObj.getStudentNumber().equals(""))  where += " and t_groupStudent.studentObj='" + studentObj.getStudentNumber() + "'";
    	return groupStudentMapper.queryGroupStudentList(where);
    }

    /*查询所有分组成员记录*/
    public ArrayList<GroupStudent> queryAllGroupStudent()  throws Exception {
        return groupStudentMapper.queryGroupStudentList("where 1=1");
    }

    /*当前查询条件下计算总的页数和记录数*/
    public void queryTotalPageAndRecordNumber(Group groupObj,Student studentObj) throws Exception {
     	String where = "where 1=1";
    	if(null != groupObj && groupObj.getGroupId()!= null && groupObj.getGroupId()!= 0)  where += " and t_groupStudent.groupObj=" + groupObj.getGroupId();
    	if(null != studentObj &&  studentObj.getStudentNumber() != null && !studentObj.getStudentNumber().equals(""))  where += " and t_groupStudent.studentObj='" + studentObj.getStudentNumber() + "'";
        recordNumber = groupStudentMapper.queryGroupStudentCount(where);
        int mod = recordNumber % this.rows;
        totalPage = recordNumber / this.rows;
        if(mod != 0) totalPage++;
    }

    /*根据主键获取分组成员记录*/
    public GroupStudent getGroupStudent(int gsId) throws Exception  {
        GroupStudent groupStudent = groupStudentMapper.getGroupStudent(gsId);
        return groupStudent;
    }

    /*更新分组成员记录*/
    public void updateGroupStudent(GroupStudent groupStudent) throws Exception {
        groupStudentMapper.updateGroupStudent(groupStudent);
    }

    /*删除一条分组成员记录*/
    public void deleteGroupStudent (int gsId) throws Exception {
        groupStudentMapper.deleteGroupStudent(gsId);
    }

    /*删除多条分组成员信息*/
    public int deleteGroupStudents (String gsIds) throws Exception {
    	String _gsIds[] = gsIds.split(",");
    	for(String _gsId: _gsIds) {
    		groupStudentMapper.deleteGroupStudent(Integer.parseInt(_gsId));
    	}
    	return _gsIds.length;
    }
}
