package com.chengxusheji.service;

import java.util.ArrayList;
import javax.annotation.Resource; 
import org.springframework.stereotype.Service;
import com.chengxusheji.po.Group;

import com.chengxusheji.mapper.GroupMapper;
@Service
public class GroupService {

	@Resource GroupMapper groupMapper;
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

    /*添加分组记录*/
    public void addGroup(Group group) throws Exception {
    	groupMapper.addGroup(group);
    }

    /*按照查询条件分页查询分组记录*/
    public ArrayList<Group> queryGroup(int currentPage) throws Exception { 
     	String where = "where 1=1";
    	int startIndex = (currentPage-1) * this.rows;
    	return groupMapper.queryGroup(where, startIndex, this.rows);
    }

    /*按照查询条件查询所有记录*/
    public ArrayList<Group> queryGroup() throws Exception  { 
     	String where = "where 1=1";
    	return groupMapper.queryGroupList(where);
    }

    /*查询所有分组记录*/
    public ArrayList<Group> queryAllGroup()  throws Exception {
        return groupMapper.queryGroupList("where 1=1");
    }

    /*当前查询条件下计算总的页数和记录数*/
    public void queryTotalPageAndRecordNumber() throws Exception {
     	String where = "where 1=1";
        recordNumber = groupMapper.queryGroupCount(where);
        int mod = recordNumber % this.rows;
        totalPage = recordNumber / this.rows;
        if(mod != 0) totalPage++;
    }

    /*根据主键获取分组记录*/
    public Group getGroup(int groupId) throws Exception  {
        Group group = groupMapper.getGroup(groupId);
        return group;
    }

    /*更新分组记录*/
    public void updateGroup(Group group) throws Exception {
        groupMapper.updateGroup(group);
    }

    /*删除一条分组记录*/
    public void deleteGroup (int groupId) throws Exception {
        groupMapper.deleteGroup(groupId);
    }

    /*删除多条分组信息*/
    public int deleteGroups (String groupIds) throws Exception {
    	String _groupIds[] = groupIds.split(",");
    	for(String _groupId: _groupIds) {
    		groupMapper.deleteGroup(Integer.parseInt(_groupId));
    	}
    	return _groupIds.length;
    }
}
