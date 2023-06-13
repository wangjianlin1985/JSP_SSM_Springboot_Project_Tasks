package com.chengxusheji.po;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.NotEmpty;
import org.json.JSONException;
import org.json.JSONObject;

public class Group {
    /*分组id*/
    private Integer groupId;
    public Integer getGroupId(){
        return groupId;
    }
    public void setGroupId(Integer groupId){
        this.groupId = groupId;
    }

    /*分组名称*/
    @NotEmpty(message="分组名称不能为空")
    private String groupName;
    public String getGroupName() {
        return groupName;
    }
    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public JSONObject getJsonObject() throws JSONException {
    	JSONObject jsonGroup=new JSONObject(); 
		jsonGroup.accumulate("groupId", this.getGroupId());
		jsonGroup.accumulate("groupName", this.getGroupName());
		return jsonGroup;
    }}