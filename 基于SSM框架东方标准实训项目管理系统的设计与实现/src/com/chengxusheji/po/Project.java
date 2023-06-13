package com.chengxusheji.po;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.NotEmpty;
import org.json.JSONException;
import org.json.JSONObject;

public class Project {
    /*项目id*/
    private Integer projectId;
    public Integer getProjectId(){
        return projectId;
    }
    public void setProjectId(Integer projectId){
        this.projectId = projectId;
    }

    /*项目名称*/
    @NotEmpty(message="项目名称不能为空")
    private String projectName;
    public String getProjectName() {
        return projectName;
    }
    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    /*项目内容*/
    @NotEmpty(message="项目内容不能为空")
    private String projectContent;
    public String getProjectContent() {
        return projectContent;
    }
    public void setProjectContent(String projectContent) {
        this.projectContent = projectContent;
    }

    /*项目任务组*/
    private Group groupObj;
    public Group getGroupObj() {
        return groupObj;
    }
    public void setGroupObj(Group groupObj) {
        this.groupObj = groupObj;
    }

    /*项目任务文件*/
    private String projectFile;
    public String getProjectFile() {
        return projectFile;
    }
    public void setProjectFile(String projectFile) {
        this.projectFile = projectFile;
    }

    /*开始时间*/
    @NotEmpty(message="开始时间不能为空")
    private String startTime;
    public String getStartTime() {
        return startTime;
    }
    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    /*完成周期*/
    @NotEmpty(message="完成周期不能为空")
    private String duration;
    public String getDuration() {
        return duration;
    }
    public void setDuration(String duration) {
        this.duration = duration;
    }

    /*项目进度报告*/
    @NotEmpty(message="项目进度报告不能为空")
    private String projectProgress;
    public String getProjectProgress() {
        return projectProgress;
    }
    public void setProjectProgress(String projectProgress) {
        this.projectProgress = projectProgress;
    }

    public JSONObject getJsonObject() throws JSONException {
    	JSONObject jsonProject=new JSONObject(); 
		jsonProject.accumulate("projectId", this.getProjectId());
		jsonProject.accumulate("projectName", this.getProjectName());
		jsonProject.accumulate("projectContent", this.getProjectContent());
		jsonProject.accumulate("groupObj", this.getGroupObj().getGroupName());
		jsonProject.accumulate("groupObjPri", this.getGroupObj().getGroupId());
		jsonProject.accumulate("projectFile", this.getProjectFile());
		jsonProject.accumulate("startTime", this.getStartTime().length()>19?this.getStartTime().substring(0,19):this.getStartTime());
		jsonProject.accumulate("duration", this.getDuration());
		jsonProject.accumulate("projectProgress", this.getProjectProgress());
		return jsonProject;
    }}