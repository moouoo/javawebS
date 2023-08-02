package com.spring.javawebS;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/errorPage")
public class ErrorController {

	// 에러 연습폼...
	@RequestMapping(value = "/errorMain", method = RequestMethod.GET)
	public String errorMainGet() {
		return "errorPage/errorMain";
	}
	
	// 에러 발생폼 호출...
	@RequestMapping(value = "/error1", method = RequestMethod.GET)
	public String error1Get() {
		return "errorPage/error1";
	}
	
	// 404에러 발생폼 호출...
	@RequestMapping(value = "/error404", method = RequestMethod.GET)
	public String error404Get() {
		return "errorPage/error404";
	}
	
	// 500에러 발생폼 호출...
	@RequestMapping(value = "/error500", method = RequestMethod.GET)
	public String error500Get() {
		return "errorPage/error500";
	}
	
	// 500에러 발생폼 호출...
	@RequestMapping(value = "/error500Check", method = RequestMethod.GET)
	public String error500CheckGet(HttpSession session) {
		String mid = (String) session.getAttribute("ssMid");
		int su = 100 + Integer.parseInt(mid);
		System.out.println("su : " + su);
		return "";
	}
	
}
