package com.chengxusheji.mapper;

import java.util.ArrayList;
import org.apache.ibatis.annotations.Param;
import com.chengxusheji.po.Journal;

public interface JournalMapper {
	/*添加项目日志信息*/
	public void addJournal(Journal journal) throws Exception;

	/*按照查询条件分页查询项目日志记录*/
	public ArrayList<Journal> queryJournal(@Param("where") String where,@Param("startIndex") int startIndex,@Param("pageSize") int pageSize) throws Exception;

	/*按照查询条件查询所有项目日志记录*/
	public ArrayList<Journal> queryJournalList(@Param("where") String where) throws Exception;

	/*按照查询条件的项目日志记录数*/
	public int queryJournalCount(@Param("where") String where) throws Exception; 

	/*根据主键查询某条项目日志记录*/
	public Journal getJournal(int journalId) throws Exception;

	/*更新项目日志记录*/
	public void updateJournal(Journal journal) throws Exception;

	/*删除项目日志记录*/
	public void deleteJournal(int journalId) throws Exception;

}
