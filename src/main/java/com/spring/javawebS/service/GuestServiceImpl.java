package com.spring.javawebS.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javawebS.dao.GuestDAO;
import com.spring.javawebS.vo.GuestVO;

@Service
public class GuestServiceImpl implements GuestService {

	@Autowired
	GuestDAO guestDAO;

	@Override
	public List<GuestVO> getGuestList(int startIndexNo, int pageSize) {
		return guestDAO.getGuestList(startIndexNo, pageSize);
	}

	@Override
	public int setGuestInput(GuestVO vo) {
		return guestDAO.setGuestInput(vo);
	}

	@Override
	public int getAdminCheck(String mid, String pwd) {
		int res = 0;
		if(mid.equals("admin") && pwd.equals("1234")) res = 1;
		return res;
	}

	@Override
	public int totRecCnt() {
		return guestDAO.totRecCnt();
	}

	@Override
	public int setGuestDelete(int idx) {
		return guestDAO.setGuestDelete(idx);
	}
	
	
}
