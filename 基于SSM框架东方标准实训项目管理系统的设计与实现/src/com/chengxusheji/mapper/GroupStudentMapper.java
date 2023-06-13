package com.chengxusheji.mapper;

import java.util.ArrayList;
import org.apache.ibatis.annotations.Param;
import com.chengxusheji.po.GroupStudent;

public interface GroupStudentMapper {
	/*添加分组成员信息*/
	public void addGroupStudent(GroupStudent groupStudent) throws Exception;

	/*按照查询条件分页查询分组成员记录*/
	public ArrayList<GroupStudent> queryGroupStudent(@Param("where") String where,@Param("startIndex") int startIndex,@Param("pageSize") int pageSize) throws Exception;

	/*按照查询条件查询所有分组成员记录*/
	public ArrayList<GroupStudent> queryGroupStudentList(@Param("where") String where) throws Exception;

	/*按照查询条件的分组成员记录数*/
	public int queryGroupStudentCount(@Param("where") String where) throws Exception; 

	/*根据主键查询某条分组成员记录*/
	public GroupStudent getGroupStudent(int gsId) throws Exception;

	/*更新分组成员记录*/
	public void updateGroupStudent(GroupStudent groupStudent) throws Exception;

	/*删除分组成员记录*/
	public void deleteGroupStudent(int gsId) throws Exception;

}
