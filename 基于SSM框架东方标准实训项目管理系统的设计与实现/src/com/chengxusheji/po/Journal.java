package com.chengxusheji.po;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.NotEmpty;
import org.json.JSONException;
import org.json.JSONObject;

public class Journal {
    /*日志id*/
    private Integer journalId;
    public Integer getJournalId(){
        return journalId;
    }
    public void setJournalId(Integer journalId){
        this.journalId = journalId;
    }

    /*日志标题*/
    @NotEmpty(message="日志标题不能为空")
    private String title;
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    /*日志内容*/
    @NotEmpty(message="日志内容不能为空")
    private String content;
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }

    /*发布学生*/
    private Student studentObj;
    public Student getStudentObj() {
        return studentObj;
    }
    public void setStudentObj(Student studentObj) {
        this.studentObj = studentObj;
    }

    /*发布时间*/
    private String addTime;
    public String getAddTime() {
        return addTime;
    }
    public void setAddTime(String addTime) {
        this.addTime = addTime;
    }

    /*审核老师*/
    private String teacherNo;
    public String getTeacherNo() {
        return teacherNo;
    }
    public void setTeacherNo(String teacherNo) {
        this.teacherNo = teacherNo;
    }

    /*答复内容*/
    private String replyContent;
    public String getReplyContent() {
        return replyContent;
    }
    public void setReplyContent(String replyContent) {
        this.replyContent = replyContent;
    }

    /*答复时间*/
    private String replyTime;
    public String getReplyTime() {
        return replyTime;
    }
    public void setReplyTime(String replyTime) {
        this.replyTime = replyTime;
    }

    public JSONObject getJsonObject() throws JSONException {
    	JSONObject jsonJournal=new JSONObject(); 
		jsonJournal.accumulate("journalId", this.getJournalId());
		jsonJournal.accumulate("title", this.getTitle());
		jsonJournal.accumulate("content", this.getContent());
		jsonJournal.accumulate("studentObj", this.getStudentObj().getName());
		jsonJournal.accumulate("studentObjPri", this.getStudentObj().getStudentNumber());
		jsonJournal.accumulate("addTime", this.getAddTime().length()>19?this.getAddTime().substring(0,19):this.getAddTime());
		jsonJournal.accumulate("teacherNo", this.getTeacherNo());
		jsonJournal.accumulate("replyContent", this.getReplyContent());
		jsonJournal.accumulate("replyTime", this.getReplyTime().length()>19?this.getReplyTime().substring(0,19):this.getReplyTime());
		return jsonJournal;
    }}