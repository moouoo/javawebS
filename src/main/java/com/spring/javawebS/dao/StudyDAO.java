package com.spring.javawebS.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.javawebS.vo.ChartVO;
import com.spring.javawebS.vo.KakaoAddressVO;
import com.spring.javawebS.vo.MemberVO;
import com.spring.javawebS.vo.QrCodeVO;
import com.spring.javawebS.vo.TransactionVO;
import com.spring.javawebS.vo.UserVO;

public interface StudyDAO {

	public MemberVO getMemberMidSearch(@Param("name") String name);

	public ArrayList<MemberVO> getMemberMidSearch2(@Param("name") String name);

	public int setUserInput(@Param("vo") UserVO vo);

	public ArrayList<UserVO> getUserList();

	public void setUserDelete(@Param("idx") int idx);

	public KakaoAddressVO getKakaoAddressName(@Param("address") String address);

	public void setKakaoAddressInput(@Param("vo") KakaoAddressVO vo);

	public List<KakaoAddressVO> getKakaoAddressList();

	public void setKakaoAddressDelete(@Param("address") String address);

	public void setQrCreateDB(@Param("vo") QrCodeVO vo);

	public QrCodeVO getQrCodeSearch(@Param("qrCode") String qrCode);

	public void setTransactionUserInput1(@Param("vo") TransactionVO vo);

	public void setTransactionUserInput2(@Param("vo") TransactionVO vo);

	public void setTransactionUserInput(@Param("vo") TransactionVO vo);

	public List<TransactionVO> setTransactionUserList(@Param("userSelect") String userSelect);

	public List<ChartVO> getRecentlyVisitCount(@Param("i") int i);

}
