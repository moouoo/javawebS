package com.spring.javawebS.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javawebS.dao.AdminDAO;

@Service
public class AdminServiceImpl implements AdminService {
	@Autowired
	AdminDAO adminDAO;
	
}
