package com.spring.javawebS;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.javawebS.pagination.PageProcess;
import com.spring.javawebS.service.AdminService;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	PageProcess pageProcess;
	
	@RequestMapping(value = "/adminMain", method = RequestMethod.GET)
	public String adminMain() {
		return "admin/adminMain";
	}
	
	@RequestMapping(value = "/adminLeft", method = RequestMethod.GET)
	public String adminLeft() {
		return "admin/adminLeft";
	}
	
	@RequestMapping(value = "/adminContent", method = RequestMethod.GET)
	public String adminContent() {
		return "admin/adminContent";
	}

}
