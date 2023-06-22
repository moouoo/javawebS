package com.spring.javawebS.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javawebS.vo.MemberVO;
import com.spring.javawebS.vo.UserVO;

public interface StudyDAO {

	public MemberVO getMemberMidSearch(@Param("name") String name);

	public ArrayList<MemberVO> getMemberMidSearch2(@Param("name") String name);

	public int setUserInput(@Param("vo") UserVO vo);

	public ArrayList<UserVO> getUserList();

	public void setUserDelete(@Param("idx") int idx);

}
