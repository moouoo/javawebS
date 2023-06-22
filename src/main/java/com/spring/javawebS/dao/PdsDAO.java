package com.spring.javawebS.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.javawebS.vo.PdsVO;

public interface PdsDAO {
	
	public int totRecCnt(@Param("part") String part);

	public List<PdsVO> getPdsList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("part") String part);

	public int setPdsInput(@Param("vo") PdsVO vo);

	public int setPdsDownNumCheck(@Param("idx") int idx);

	public PdsVO getPdsIdxSearch(@Param("idx") int idx);

	public void setPdsDelete(@Param("idx") int idx);

}
