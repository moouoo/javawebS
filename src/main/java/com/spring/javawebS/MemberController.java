package com.spring.javawebS;

import java.util.List;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javawebS.pagination.PageProcess;
import com.spring.javawebS.pagination.PageVO;
import com.spring.javawebS.service.MemberService;
import com.spring.javawebS.vo.MemberVO;

@Controller
@RequestMapping("/member")
public class MemberController {

	@Autowired
	MemberService memberService;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	JavaMailSender mailSender;
	
	@Autowired
	PageProcess pageProcess;
	
	@RequestMapping(value = "/memberLogin", method = RequestMethod.GET)
	public String memberLoginGet(HttpServletRequest request) {
		Cookie[] cookies = request.getCookies();
		if(cookies != null) {
			for(int i=0; i<cookies.length; i++) {
				if(cookies[i].getName().equals("cMid")) {
					request.setAttribute("mid", cookies[i].getValue());
					break;
				}
			}
		}
		return "member/memberLogin";
	}
	
	@RequestMapping(value = "/memberLogin", method = RequestMethod.POST)
	public String memberLoginPost(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(name="mid", defaultValue = "", required=false) String mid,
			@RequestParam(name="pwd", defaultValue = "", required=false) String pwd,
			@RequestParam(name="idSave", defaultValue = "", required=false) String idSave,
			HttpSession session) {
		MemberVO vo = memberService.getMemberIdCheck(mid);
		
		if(vo != null && vo.getUserDel().equals("NO") && passwordEncoder.matches(pwd, vo.getPwd())) {
			// 회원 인증처리된 경우는? strLevel, session에 저장, 쿠키저장, 방문자수, 방문포인트증가....
			String strLevel = "";
			if(vo.getLevel() == 0) strLevel = "관리자";
			else if(vo.getLevel() == 1) strLevel = "우수회원";
			else if(vo.getLevel() == 2) strLevel = "정회원";
			else if(vo.getLevel() == 3) strLevel = "준회원";
			
			session.setAttribute("sLevel", vo.getLevel());
			session.setAttribute("strLevel", strLevel);
			session.setAttribute("sMid", vo.getMid());
			session.setAttribute("sNickName", vo.getNickName());
			
			if(idSave.equals("on")) {
				Cookie cookie = new Cookie("cMid", mid);
				cookie.setMaxAge(60*60*24*7);
				response.addCookie(cookie);
			}
			else {
				Cookie[] cookies = request.getCookies();
				for(int i=0; i<cookies.length; i++) {
					if(cookies[i].getName().equals("cMid")) {
						cookies[i].setMaxAge(0);
						response.addCookie(cookies[i]);
						break;
					}
				}
			}
			// 로그인한 사용자의 오늘 방문수와 방문포인트를 누적한다.
			memberService.setMemberVisitProcess(vo);
			return "redirect:/message/memberLoginOk?mid="+mid;
		}
		else {
			return "redirect:/message/memberLoginNo";
		}
	}
	
	@RequestMapping(value = "/memberLogout", method = RequestMethod.GET)
	public String memberLogoutGet(HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		
		session.invalidate();
		
		return "redirect:/message/memberLogout?mid="+mid;
	}
	
	@RequestMapping(value = "/memberJoin", method = RequestMethod.GET)
	public String memberJoinGet() {
		return "member/memberJoin";
	}
	
	@RequestMapping(value = "/memberJoin", method = RequestMethod.POST)
	public String memberJoinPost(MultipartFile fName, MemberVO vo) {
		// 아이디 중복 체크
		if(memberService.getMemberIdCheck(vo.getMid()) != null) return "redirect:/message/idCheckNo";
		if(memberService.getMemberNickCheck(vo.getNickName()) != null) return "redirect:/message/nickCheckNo";
		
		// 비밀번호 암호화
		vo.setPwd(passwordEncoder.encode(vo.getPwd()));
		
		// 사진파일이 업로드되었으면 사진파일을 서버 파일시스템에 저장시켜준다.(서비스객체에서 수행처리한다.)
		// 체크가 완료되면 vo에 담긴 자료를 DB에 저장시켜준다.(회원가입)
		int res = memberService.setMemberJoinOk(fName, vo);
		
		if(res == 1) return "redirect:/message/memberJoinOk";
		else return "redirect:/message/memberJoinNo";
	}
	
	// 아이디 중복체크
	@ResponseBody
	@RequestMapping(value = "/memberIdCheck", method = RequestMethod.POST)
	public String memberIdCheckPost(String mid) {
		MemberVO vo = memberService.getMemberIdCheck(mid);
		
		if(vo != null ) return "1";
		else return "0";
	}
	
	// 닉네임 중복체크
	@ResponseBody
	@RequestMapping(value = "/memberNickCheck", method = RequestMethod.POST)
	public String memberNickCheckPost(String nickName) {
		MemberVO vo = memberService.getMemberNickCheck(nickName);
		
		if(vo != null ) return "1";
		else return "0";
	}
	
	@RequestMapping(value = "/memberMain", method = RequestMethod.GET)
	public String memberMainGet(Model model, HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		MemberVO vo = memberService.getMemberIdCheck(mid);
		
		model.addAttribute("vo", vo);
		
		return "member/memberMain";
	}
	
	@RequestMapping(value = "/memberPwdFind", method = RequestMethod.GET)
	public String memberPwdFindGet() {
		return "member/memberPwdFind";
	}
	
	@RequestMapping(value = "/memberPwdFind", method = RequestMethod.POST)
	public String memberPwdFindPost(String mid, String toMail, HttpServletRequest request) throws MessagingException {
		MemberVO vo = memberService.getMemberIdCheck(mid);
		if(vo != null) {
			if(vo.getEmail().equals(toMail)) {
				// 회원정보가 맞다면 임시비밀번호를 발급받는다.(8자리)
				UUID uid = UUID.randomUUID();
				String pwd = uid.toString().substring(0,8);
				
				// 회원이 임시비밀번호를 변경처리할 수 있도록 유도하기위해 임시세션1개를 생성해준다.
				HttpSession session = request.getSession();
				session.setAttribute("sImsiPwd", pwd);
				
				// 발급받은 임시비밀번호를 암호화처리시켜서 DB에 저장한다.
				memberService.setMemberPwdUpdate(mid, passwordEncoder.encode(pwd));
				
				// 저정된 임시비밀번호를 메일로 전송처리한다.
				String content = pwd;
				int res = mailSend(toMail, content);
				
				if(res == 1) return "redirect:/message/memberImsiPwdOk";
				else return "redirect:/message/memberImsiPwdNo";
			}
			else {
				return "redirect:/message/memberEmailCheckNo";
			}
		}
		else {
			return "redirect:/message/memberIdCheckNo";
		}
	}

	// 임시비밀번호를 메일로 전송처리한다.
	private int mailSend(String toMail, String content) throws MessagingException {
		String title = "임시 비밀번호를 발급하였습니다.";
		
		// 메일 전송을 위한 객체 : MimeMessage(), MimeMessageHelper()
		MimeMessage message = mailSender.createMimeMessage();
		MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
		
		// 메일보관함에 회원이 보내온 메세지들의 정보를 모두 저장시킨후 작업처리하자...
		messageHelper.setTo(toMail);
		messageHelper.setSubject(title);
		messageHelper.setText(content);
		
		// 메세지 보관함의 내용(content)에 필요한 정보를 추가로 담아서 전송시킬수 있도록 한다.
	
		content = "<br><hr><h3>임시 비밀번호는 <font color='red'>"+content+"</font></h3><hr><br>";
		content += "<p><img src=\"cid:main.jpg\" width='500px'></p>";
		content += "<p>방문하기 : <a href='http://49.142.157.251:9090/cjgreen/'>CJ Green프로젝트</a></p>";
		content += "<hr>";
		messageHelper.setText(content, true);
		
		// 본문에 기재된 그림파일의 경로를 별도로 표시시켜준다. 그런후, 다시 보관함에 담아준다.
		FileSystemResource file = new FileSystemResource("D:\\javaweb\\springframework\\works\\javawebS\\src\\main\\webapp\\resources\\images\\main.jpg");
		messageHelper.addInline("main.jpg", file);

		// 메일 전송하기
		mailSender.send(message);
		
		return 1;
	}
	
	@RequestMapping(value = "/memberPwdUpdate", method = RequestMethod.GET)
	public String memberPwdUpdateGet() {
		return "member/memberPwdUpdate";
	}
	
	@RequestMapping(value = "/memberPwdUpdate", method = RequestMethod.POST)
	public String memberPwdUpdatePost(
			@RequestParam(name="mid",defaultValue = "", required=false) String mid,
			@RequestParam(name="newPwd",defaultValue = "", required=false) String newPwd,
			HttpSession session) {
		newPwd = passwordEncoder.encode(newPwd);
		
		memberService.setMemberPwdUpdate(mid, newPwd);
		
		if(session.getAttribute("sImsiPwd") != null) session.removeAttribute("sImsiPwd");
		
		return "redirect:/message/memberPwdUpdateOk";
	}
	
	@RequestMapping(value = "/memberPwdCheck", method = RequestMethod.GET)
	public String memberPwdCheckGet() {
		return "member/memberPwdCheck";
	}
	
	@RequestMapping(value = "/memberPwdCheck", method = RequestMethod.POST)
	public String memberPwdCheckPost(String mid, String pwd, Model model) {
		MemberVO vo = memberService.getMemberIdCheck(mid);
		if(vo != null && passwordEncoder.matches(pwd, vo.getPwd())) {
			model.addAttribute("vo", vo);
			return "member/memberUpdate";
		}
		else {
		  return "redirect:/message/memberPwdCheckNo";
		}
	}
	
	@RequestMapping(value = "/memberUpdate", method = RequestMethod.GET)
	public String memberUpdateGet(Model model, HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		MemberVO vo = memberService.getMemberIdCheck(mid);
		model.addAttribute("vo", vo);
		
		return "member/memberUpdate";
	}
	
	@RequestMapping(value = "/memberUpdateOk", method = RequestMethod.POST)
	public String memberUpdateOkPost(MemberVO vo, MultipartFile fName, HttpSession session) {
		// 닉네임 체크
		String nickName = (String) session.getAttribute("sNickName");
		if(memberService.getMemberNickCheck(vo.getNickName()) != null && !nickName.equals(vo.getNickName())) {
			return "redirect:/message/memberNickCheckNo";
		}
		
		int res = memberService.setMemberUpdateOk(fName, vo);
		
		if(res == 1) {
			session.setAttribute("sNickName", vo.getNickName());
			return "redirect:/message/memberUpdateOk";
		}
		else {
			return "redirect:/message/memberUpdateNo";
		}
	}
	
	// 회원 탈퇴처리(userDel = 'OK')
	@RequestMapping(value = "/memberDelete", method = RequestMethod.GET)
	public String memberDelete(HttpSession session, Model model) {
		String mid = (String) session.getAttribute("sMid");
		memberService.setMemberDeleteOk(mid);
		
		session.invalidate();
		
		model.addAttribute("mid", mid);
		
		return "redirect:/message/memberDeleteOk";
	}
	
	@RequestMapping(value = "/memberList", method = RequestMethod.GET)
	public String memberListGet(Model model,
			@RequestParam(name="mid", defaultValue = "", required = false) String mid,
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "3", required = false) int pageSize) {
		
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "member", "", mid);
		
		List<MemberVO> vos = memberService.getMemberList(pageVO.getStartIndexNo(), pageSize, mid);
		
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		
		model.addAttribute("mid", mid);
		
		return "member/memberList";
	}
}
