package com.chengxusheji.po;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.NotEmpty;
import org.json.JSONException;
import org.json.JSONObject;

public class ResourceInfo {
    /*资源id*/
    private Integer resourceId;
    public Integer getResourceId(){
        return resourceId;
    }
    public void setResourceId(Integer resourceId){
        this.resourceId = resourceId;
    }

    /*项目*/
    private Project projectObj;
    public Project getProjectObj() {
        return projectObj;
    }
    public void setProjectObj(Project projectObj) {
        this.projectObj = projectObj;
    }

    /*上传学员*/
    private Student studentObj;
    public Student getStudentObj() {
        return studentObj;
    }
    public void setStudentObj(Student studentObj) {
        this.studentObj = studentObj;
    }

    /*项目资源文件*/
    private String resourceFile;
    public String getResourceFile() {
        return resourceFile;
    }
    public void setResourceFile(String resourceFile) {
        this.resourceFile = resourceFile;
    }

    /*项目资源说明*/
    @NotEmpty(message="项目资源说明不能为空")
    private String resourceDesc;
    public String getResourceDesc() {
        return resourceDesc;
    }
    public void setResourceDesc(String resourceDesc) {
        this.resourceDesc = resourceDesc;
    }

    /*上传时间*/
    private String addTime;
    public String getAddTime() {
        return addTime;
    }
    public void setAddTime(String addTime) {
        this.addTime = addTime;
    }

    /*老师评语*/
    private String evaluateContent;
    public String getEvaluateContent() {
        return evaluateContent;
    }
    public void setEvaluateContent(String evaluateContent) {
        this.evaluateContent = evaluateContent;
    }

    public JSONObject getJsonObject() throws JSONException {
    	JSONObject jsonResourceInfo=new JSONObject(); 
		jsonResourceInfo.accumulate("resourceId", this.getResourceId());
		jsonResourceInfo.accumulate("projectObj", this.getProjectObj().getProjectName());
		jsonResourceInfo.accumulate("projectObjPri", this.getProjectObj().getProjectId());
		jsonResourceInfo.accumulate("studentObj", this.getStudentObj().getName());
		jsonResourceInfo.accumulate("studentObjPri", this.getStudentObj().getStudentNumber());
		jsonResourceInfo.accumulate("resourceFile", this.getResourceFile());
		jsonResourceInfo.accumulate("resourceDesc", this.getResourceDesc());
		jsonResourceInfo.accumulate("addTime", this.getAddTime().length()>19?this.getAddTime().substring(0,19):this.getAddTime());
		jsonResourceInfo.accumulate("evaluateContent", this.getEvaluateContent());
		return jsonResourceInfo;
    }}