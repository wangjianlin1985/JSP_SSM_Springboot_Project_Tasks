package com.chengxusheji.mapper;

import java.util.ArrayList;
import org.apache.ibatis.annotations.Param;
import com.chengxusheji.po.Group;

public interface GroupMapper {
	/*添加分组信息*/
	public void addGroup(Group group) throws Exception;

	/*按照查询条件分页查询分组记录*/
	public ArrayList<Group> queryGroup(@Param("where") String where,@Param("startIndex") int startIndex,@Param("pageSize") int pageSize) throws Exception;

	/*按照查询条件查询所有分组记录*/
	public ArrayList<Group> queryGroupList(@Param("where") String where) throws Exception;

	/*按照查询条件的分组记录数*/
	public int queryGroupCount(@Param("where") String where) throws Exception; 

	/*根据主键查询某条分组记录*/
	public Group getGroup(int groupId) throws Exception;

	/*更新分组记录*/
	public void updateGroup(Group group) throws Exception;

	/*删除分组记录*/
	public void deleteGroup(int groupId) throws Exception;

}
