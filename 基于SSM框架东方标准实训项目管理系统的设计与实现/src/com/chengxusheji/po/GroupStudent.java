package com.chengxusheji.po;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.NotEmpty;
import org.json.JSONException;
import org.json.JSONObject;

public class GroupStudent {
    /*成员id*/
    private Integer gsId;
    public Integer getGsId(){
        return gsId;
    }
    public void setGsId(Integer gsId){
        this.gsId = gsId;
    }

    /*所在分组*/
    private Group groupObj;
    public Group getGroupObj() {
        return groupObj;
    }
    public void setGroupObj(Group groupObj) {
        this.groupObj = groupObj;
    }

    /*学生*/
    private Student studentObj;
    public Student getStudentObj() {
        return studentObj;
    }
    public void setStudentObj(Student studentObj) {
        this.studentObj = studentObj;
    }

    public JSONObject getJsonObject() throws JSONException {
    	JSONObject jsonGroupStudent=new JSONObject(); 
		jsonGroupStudent.accumulate("gsId", this.getGsId());
		jsonGroupStudent.accumulate("groupObj", this.getGroupObj().getGroupName());
		jsonGroupStudent.accumulate("groupObjPri", this.getGroupObj().getGroupId());
		jsonGroupStudent.accumulate("studentObj", this.getStudentObj().getName());
		jsonGroupStudent.accumulate("studentObjPri", this.getStudentObj().getStudentNumber());
		return jsonGroupStudent;
    }}