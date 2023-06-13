package com.chengxusheji.mapper;

import java.util.ArrayList;
import org.apache.ibatis.annotations.Param;
import com.chengxusheji.po.ResourceInfo;

public interface ResourceInfoMapper {
	/*添加资源信息*/
	public void addResourceInfo(ResourceInfo resourceInfo) throws Exception;

	/*按照查询条件分页查询资源记录*/
	public ArrayList<ResourceInfo> queryResourceInfo(@Param("where") String where,@Param("startIndex") int startIndex,@Param("pageSize") int pageSize) throws Exception;

	/*按照查询条件查询所有资源记录*/
	public ArrayList<ResourceInfo> queryResourceInfoList(@Param("where") String where) throws Exception;

	/*按照查询条件的资源记录数*/
	public int queryResourceInfoCount(@Param("where") String where) throws Exception; 

	/*根据主键查询某条资源记录*/
	public ResourceInfo getResourceInfo(int resourceId) throws Exception;

	/*更新资源记录*/
	public void updateResourceInfo(ResourceInfo resourceInfo) throws Exception;

	/*删除资源记录*/
	public void deleteResourceInfo(int resourceId) throws Exception;

}
