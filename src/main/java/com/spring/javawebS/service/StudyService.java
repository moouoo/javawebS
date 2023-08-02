package com.spring.javawebS.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javawebS.vo.ChartVO;
import com.spring.javawebS.vo.KakaoAddressVO;
import com.spring.javawebS.vo.MemberVO;
import com.spring.javawebS.vo.QrCodeVO;
import com.spring.javawebS.vo.TransactionVO;
import com.spring.javawebS.vo.UserVO;

public interface StudyService {

	public String[] getCityStringArray(String dodo);

	public ArrayList<String> getCityArrayList(String dodo);

	public MemberVO getMemberMidSearch(String name);

	public ArrayList<MemberVO> getMemberMidSearch2(String name);

	public int fileUpload(MultipartFile fName, String mid);

	public int setUserInput(UserVO vo);

	public ArrayList<UserVO> getUserList();

	public void setUserDelete(int idx);

	public KakaoAddressVO getKakaoAddressName(String address);

	public void setKakaoAddressInput(KakaoAddressVO vo);

	public List<KakaoAddressVO> getKakaoAddressList();

	public void setKakaoAddressDelete(String address);

	public String qrCreate(QrCodeVO vo, String realPath);

	public String qrCreate2(QrCodeVO vo, String realPath);

	public String qrCreate3(QrCodeVO vo, String realPath);

	public String qrCreate4(QrCodeVO vo, String realPath);

	public QrCodeVO getQrCodeSearch(String qrCode);

	public int thumbnailCreate(MultipartFile file);

	public void setTransactionUserInput1(TransactionVO vo);

	public void setTransactionUserInput2(TransactionVO vo);

	public void setTransactionUserInput(TransactionVO vo);

	public List<TransactionVO> setTransactionUserList(String userSelect);

	public List<ChartVO> getRecentlyVisitCount(int i);

}
