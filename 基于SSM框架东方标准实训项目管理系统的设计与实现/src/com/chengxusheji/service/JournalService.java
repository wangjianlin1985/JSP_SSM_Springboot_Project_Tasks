package com.chengxusheji.service;

import java.util.ArrayList;
import javax.annotation.Resource; 
import org.springframework.stereotype.Service;
import com.chengxusheji.po.Student;
import com.chengxusheji.po.Journal;

import com.chengxusheji.mapper.JournalMapper;
@Service
public class JournalService {

	@Resource JournalMapper journalMapper;
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

    /*添加项目日志记录*/
    public void addJournal(Journal journal) throws Exception {
    	journalMapper.addJournal(journal);
    }

    /*按照查询条件分页查询项目日志记录*/
    public ArrayList<Journal> queryJournal(String title,Student studentObj,String addTime,String teacherNo,int currentPage) throws Exception { 
     	String where = "where 1=1";
    	if(!title.equals("")) where = where + " and t_journal.title like '%" + title + "%'";
    	if(null != studentObj &&  studentObj.getStudentNumber() != null  && !studentObj.getStudentNumber().equals(""))  where += " and t_journal.studentObj='" + studentObj.getStudentNumber() + "'";
    	if(!addTime.equals("")) where = where + " and t_journal.addTime like '%" + addTime + "%'";
    	if(!teacherNo.equals("")) where = where + " and t_journal.teacherNo like '%" + teacherNo + "%'";
    	int startIndex = (currentPage-1) * this.rows;
    	return journalMapper.queryJournal(where, startIndex, this.rows);
    }

    /*按照查询条件查询所有记录*/
    public ArrayList<Journal> queryJournal(String title,Student studentObj,String addTime,String teacherNo) throws Exception  { 
     	String where = "where 1=1";
    	if(!title.equals("")) where = where + " and t_journal.title like '%" + title + "%'";
    	if(null != studentObj &&  studentObj.getStudentNumber() != null && !studentObj.getStudentNumber().equals(""))  where += " and t_journal.studentObj='" + studentObj.getStudentNumber() + "'";
    	if(!addTime.equals("")) where = where + " and t_journal.addTime like '%" + addTime + "%'";
    	if(!teacherNo.equals("")) where = where + " and t_journal.teacherNo like '%" + teacherNo + "%'";
    	return journalMapper.queryJournalList(where);
    }

    /*查询所有项目日志记录*/
    public ArrayList<Journal> queryAllJournal()  throws Exception {
        return journalMapper.queryJournalList("where 1=1");
    }

    /*当前查询条件下计算总的页数和记录数*/
    public void queryTotalPageAndRecordNumber(String title,Student studentObj,String addTime,String teacherNo) throws Exception {
     	String where = "where 1=1";
    	if(!title.equals("")) where = where + " and t_journal.title like '%" + title + "%'";
    	if(null != studentObj &&  studentObj.getStudentNumber() != null && !studentObj.getStudentNumber().equals(""))  where += " and t_journal.studentObj='" + studentObj.getStudentNumber() + "'";
    	if(!addTime.equals("")) where = where + " and t_journal.addTime like '%" + addTime + "%'";
    	if(!teacherNo.equals("")) where = where + " and t_journal.teacherNo like '%" + teacherNo + "%'";
        recordNumber = journalMapper.queryJournalCount(where);
        int mod = recordNumber % this.rows;
        totalPage = recordNumber / this.rows;
        if(mod != 0) totalPage++;
    }

    /*根据主键获取项目日志记录*/
    public Journal getJournal(int journalId) throws Exception  {
        Journal journal = journalMapper.getJournal(journalId);
        return journal;
    }

    /*更新项目日志记录*/
    public void updateJournal(Journal journal) throws Exception {
        journalMapper.updateJournal(journal);
    }

    /*删除一条项目日志记录*/
    public void deleteJournal (int journalId) throws Exception {
        journalMapper.deleteJournal(journalId);
    }

    /*删除多条项目日志信息*/
    public int deleteJournals (String journalIds) throws Exception {
    	String _journalIds[] = journalIds.split(",");
    	for(String _journalId: _journalIds) {
    		journalMapper.deleteJournal(Integer.parseInt(_journalId));
    	}
    	return _journalIds.length;
    }
}
