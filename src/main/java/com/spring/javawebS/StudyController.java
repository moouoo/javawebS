package com.spring.javawebS;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.font.FontRenderContext;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javawebS.common.ARIAUtil;
import com.spring.javawebS.common.SecurityUtil;
import com.spring.javawebS.service.MemberService;
import com.spring.javawebS.service.StudyService;
import com.spring.javawebS.vo.ChartVO;
import com.spring.javawebS.vo.DbPayMentVO;
import com.spring.javawebS.vo.KakaoAddressVO;
import com.spring.javawebS.vo.MailVO;
import com.spring.javawebS.vo.MemberVO;
import com.spring.javawebS.vo.QrCodeVO;
import com.spring.javawebS.vo.TransactionVO;
import com.spring.javawebS.vo.UserVO;

@Controller
@RequestMapping("/study")
public class StudyController {
	
	@Autowired
	StudyService studyService;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	JavaMailSender mailSender;
	
	@Autowired
	MemberService memberService;
	
	// 암호화연습(sha256)
	@RequestMapping(value = "/password/sha256", method = RequestMethod.GET)
	public String sha256Get() {
		return "study/password/sha256";
	}
	
	// 암호화연습(sha256) : 결과처리
	@ResponseBody
	@RequestMapping(value = "/password/sha256", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String sha256Post(String pwd) {
		SecurityUtil security = new SecurityUtil();
		String encPwd = security.encryptSHA256(pwd);
		pwd = "원본 비밀번호 : " + pwd + " / 암호화된 비밀번호 : " + encPwd;
		return pwd;
	}
	
  // 암호화연습(ARIA)
	@RequestMapping(value = "/password/aria", method = RequestMethod.GET)
	public String ariaGet() {
		return "study/password/aria";
	}
	
	// 암호화연습(ARIA) : 결과처리
	@ResponseBody
	@RequestMapping(value = "/password/aria", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String ariaPost(String pwd) throws InvalidKeyException, UnsupportedEncodingException {
		String encPwd = "";
		String decPwd = "";
		
		encPwd = ARIAUtil.ariaEncrypt(pwd);
		decPwd = ARIAUtil.ariaDecrypt(encPwd);
		
		pwd = "원본 비밀번호 : " + pwd + " / 암호화된 비밀번호 : " + encPwd + " / 복호화된 비밀번호 : " + decPwd;
		
		return pwd;
	}
	
	// 암호화연습(bCryptPasswordEncoder방식)
	@RequestMapping(value = "/password/bCryptPassword", method = RequestMethod.GET)
	public String bCryptPasswordGet() {
		return "study/password/bCryptPassword";
	}
	
	// 암호화연습(bCryptPasswordEncoder) : 결과처리
	@ResponseBody
	@RequestMapping(value = "/password/bCryptPassword", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String bCryptPasswordPost(String pwd) {
		String encPwd = "";
		encPwd = passwordEncoder.encode(pwd);
		
		pwd = "원본 비밀번호 : " + pwd + " / 암호화된 비밀번호 : " + encPwd;
		
		return pwd;
	}
	
	// 메일 연습 폼
	@RequestMapping(value = "/mail/mailForm", method = RequestMethod.GET)
	public String mailFormGet() {
		return "study/mail/mailForm";
	}
	
	// 메일 전송하기
	@RequestMapping(value = "/mail/mailForm", method = RequestMethod.POST)
	public String mailFormPost(MailVO vo, HttpServletRequest request) throws MessagingException {
		String toMail = vo.getToMail();
		String title = vo.getTitle();
		String content = vo.getContent();
		
		// 메일 전송을 위한 객체 : MimeMessage(), MimeMessageHelper()
		MimeMessage message = mailSender.createMimeMessage();
		MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
		
		// 메일보관함에 회원이 보내온 메세지들의 정보를 모두 저장시킨후 작업처리하자...
		messageHelper.setTo(toMail);
		messageHelper.setSubject(title);
		messageHelper.setText(content);
		
		// 메세지 보관함의 내용(content)에 필요한 정보를 추가로 담아서 전송시킬수 있도록 한다.
		content = content.replace("\n", "<br>");
		content += "<br><hr><h3>CJ Green에서 보냅니다.</h3><hr><br>";
		content += "<p><img src=\"cid:main.jpg\" width='500px'></p>";
		content += "<p>방문하기 : <a href='http://49.142.157.251:9090/cjgreen/'>CJ Green프로젝트</a></p>";
		content += "<hr>";
		messageHelper.setText(content, true);
		
		// 본문에 기재된 그림파일의 경로를 별도로 표시시켜준다. 그런후, 다시 보관함에 담아준다.
		FileSystemResource file = new FileSystemResource("D:\\javaweb\\springframework\\works\\javawebS\\src\\main\\webapp\\resources\\images\\main.jpg");
		messageHelper.addInline("main.jpg", file);
		
		// 첨부파일 보내기(서버 파일시스템에 존재하는 파일을 보내기)
		file = new FileSystemResource("D:\\javaweb\\springframework\\works\\javawebS\\src\\main\\webapp\\resources\\images\\chicago.jpg");
		messageHelper.addAttachment("chicago.jpg", file);
		
		file = new FileSystemResource("D:\\javaweb\\springframework\\works\\javawebS\\src\\main\\webapp\\resources\\images\\main.zip");
		messageHelper.addAttachment("main.zip", file);
		
//		ServletContext application = request.getSession();
//		String realPath = request.getRealPath("경로");
		
		// 파일시스템에 설계한 파일이 저장된 실제경로(realPath)를 이용한 설정.
		// file = new FileSystemResource(request.getRealPath("/resources/images/paris.jpg"));
		file = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images/paris.jpg"));
		messageHelper.addAttachment("paris.jpg", file);
		
		// 메일 전송하기
		mailSender.send(message);
		
		return "redirect:/message/mailSendOk";
	}
	
	// 메일 연습 폼2
	@RequestMapping(value = "/mail/mailForm2", method = RequestMethod.GET)
	public String mailForm2Get(Model model, String email) {
		ArrayList<MemberVO> vos = memberService.getMemberList(0, 1000, "");
		model.addAttribute("vos", vos);
		model.addAttribute("cnt", vos.size());
		model.addAttribute("email", email);
		
		return "study/mail/mailForm2";
	}
	
	// 메일 전송하기2(주소록을 활용한 다중메일 전송하기)
	@RequestMapping(value = "/mail/mailForm2", method = RequestMethod.POST)
	public String mailForm2Post(MailVO vo, HttpServletRequest request) throws MessagingException {
		String toMail = vo.getToMail();
		String title = vo.getTitle();
		String content = vo.getContent();
		
		// 메일 전송을 위한 객체 : MimeMessage(), MimeMessageHelper()
		MimeMessage message = mailSender.createMimeMessage();
		MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
		
		// 메일보관함에 회원이 보내온 메세지들의 정보를 모두 저장시킨후 작업처리하자...
  	// 두개 이상의 메일이 전송될때는 ';'으로 구분되어 받아진다. 따라서 배열로 받아서 처리하면 된다.
		String[] toMails = toMail.split(";");
		messageHelper.setTo(toMails);
		messageHelper.setSubject(title);
		messageHelper.setText(content);
		
		// 메세지 보관함의 내용(content)에 필요한 정보를 추가로 담아서 전송시킬수 있도록 한다.
		content = content.replace("\n", "<br>");
		content += "<br><hr><h3>CJ Green에서 보냅니다.</h3><hr><br>";
		content += "<p><img src=\"cid:main.jpg\" width='500px'></p>";
		content += "<p>방문하기 : <a href='http://49.142.157.251:9090/cjgreen/'>CJ Green프로젝트</a></p>";
		content += "<hr>";
		messageHelper.setText(content, true);
		
		// 본문에 기재된 그림파일의 경로를 별도로 표시시켜준다. 그런후, 다시 보관함에 담아준다.
		FileSystemResource file = new FileSystemResource("D:\\javaweb\\springframework\\works\\javawebS\\src\\main\\webapp\\resources\\images\\main.jpg");
		messageHelper.addInline("main.jpg", file);
		
		// 첨부파일 보내기(서버 파일시스템에 존재하는 파일을 보내기)
		file = new FileSystemResource("D:\\javaweb\\springframework\\works\\javawebS\\src\\main\\webapp\\resources\\images\\chicago.jpg");
		messageHelper.addAttachment("chicago.jpg", file);
		
		file = new FileSystemResource("D:\\javaweb\\springframework\\works\\javawebS\\src\\main\\webapp\\resources\\images\\main.zip");
		messageHelper.addAttachment("main.zip", file);
		
		// 파일시스템에 설계한 파일이 저장된 실제경로(realPath)를 이용한 설정.
		// file = new FileSystemResource(request.getRealPath("/resources/images/paris.jpg"));
		file = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images/paris.jpg"));
		messageHelper.addAttachment("paris.jpg", file);
		
		// 메일 전송하기
		mailSender.send(message);
		
		return "redirect:/message/mailSendOk2";
	}
	
	@RequestMapping(value = "/uuid/uuidForm", method = RequestMethod.GET)
	public String uuidFormGet() {
		return "study/uuid/uuidForm";
	}
	
	@ResponseBody
	@RequestMapping(value = "/uuid/uuidForm", method = RequestMethod.POST)
	public String uuidFormPost() {
		UUID uid = UUID.randomUUID();
		return uid.toString();
	}
	
	@RequestMapping(value = "/ajax/ajaxForm", method = RequestMethod.GET)
	public String ajaxFormGet() {
		return "study/ajax/ajaxForm";
	}
	
	@ResponseBody
	@RequestMapping(value = "/ajax/ajaxTest1", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String ajaxTest1Post(int idx) {
		idx = (int)(Math.random()*idx) + 1;
		return idx + " : Have a Good Time!!!(안녕하세요)";
	}
	
	@RequestMapping(value = "/ajax/ajaxTest2_1", method = RequestMethod.GET)
	public String ajaxTest2_1Get() {
		return "study/ajax/ajaxTest2_1";
	}
	
	// 일반 배열값의 전달
	@ResponseBody
	@RequestMapping(value = "/ajax/ajaxTest2_1", method = RequestMethod.POST)
	public String[] ajaxTest2_1Posst(String dodo) {
//		String[] strArray = new String[100];
//		strArray = studyService.getCityStringArray(dodo);
//		return strArray;
		return studyService.getCityStringArray(dodo);
	}
	
	// 객체배열(ArrayList)값의 전달 폼
	@RequestMapping(value = "/ajax/ajaxTest2_2", method = RequestMethod.GET)
	public String ajaxTest2_2Get() {
		return "study/ajax/ajaxTest2_2";
	}
	
  // 객체배열(ArrayList)값의 전달
	@ResponseBody
	@RequestMapping(value = "/ajax/ajaxTest2_2", method=RequestMethod.POST)
	public ArrayList<String> ajaxTest2_2Post(String dodo) {
		return studyService.getCityArrayList(dodo);
	}
	
	// Map(HashMap<k,v>)값의 전달 폼
	@RequestMapping(value = "/ajax/ajaxTest2_3", method = RequestMethod.GET)
	public String ajaxTest2_3Get() {
		return "study/ajax/ajaxTest2_3";
	}
	
  // Map(HashMap<k,v>)값의 전달
	@ResponseBody
	@RequestMapping(value = "/ajax/ajaxTest2_3", method=RequestMethod.POST)
	public HashMap<Object, Object> ajaxTest2_3Post(String dodo) {
		ArrayList<String> vos = new ArrayList<String>();
		vos = studyService.getCityArrayList(dodo);
		
		HashMap<Object, Object> map = new HashMap<Object, Object>();
		map.put("city", vos);
		return map;
	}
	
	// DB를 활용한 값의 전달 폼
	@RequestMapping(value = "/ajax/ajaxTest3", method = RequestMethod.GET)
	public String ajaxTest3Get() {
		return "study/ajax/ajaxTest3";
	}
	
	// DB를 활용한 값의 전달 폼(vo사용)
	@ResponseBody
	@RequestMapping(value = "/ajax/ajaxTest3_1", method = RequestMethod.POST)
	public MemberVO ajaxTest3_1Post(String name) {
		return studyService.getMemberMidSearch(name);
	}
	
	// DB를 활용한 값의 전달 폼(vos사용)
	@ResponseBody
	@RequestMapping(value = "/ajax/ajaxTest3_2", method = RequestMethod.POST)
	public ArrayList<MemberVO> ajaxTest3_2Post(String name) {
		return studyService.getMemberMidSearch2(name);
	}
	
	// 파일 업로드 폼
	/*
	@RequestMapping(value = "/fileUpload/fileUploadForm", method = RequestMethod.GET)
	public String fileUploadGet() {
		return "study/fileUpload/fileUploadForm";
	}
	*/
	@RequestMapping(value = "/fileUpload/fileUploadForm", method = RequestMethod.GET)
	public String fileUploadGet(HttpServletRequest request, Model model) {
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/study");
		
		String[] files = new File(realPath).list();
		
//		for(String file : files) {
//			System.out.println("file : " + file);
//		}
		
		model.addAttribute("files", files);
		model.addAttribute("fileCount", files.length);		
		
		return "study/fileUpload/fileUploadForm";
	}
	
	// 파일 업로드 처리
	@RequestMapping(value = "/fileUpload/fileUploadForm", method = RequestMethod.POST)
	public String fileUploadPost(MultipartFile fName, String mid) {
//		System.out.println("fName : " + fName);
//		System.out.println("mid : " + mid);
		
		int res = studyService.fileUpload(fName, mid);
		
		if(res == 1) return "redirect:/message/fileUploadOk";
		else return "redirect:/message/fileUploadNo";
	}
	
	// 파일 삭제처리
	@ResponseBody
	@RequestMapping(value = "/fileUpload/fileDelete", method = RequestMethod.POST)
	public String fileDeletePost(
			@RequestParam(name="file", defaultValue = "", required=false) String fName,
			HttpServletRequest request) {
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/study/");
		
		String res = "0";
		File file = new File(realPath + fName);
		
		if(file.exists()) {
			file.delete();
			res = "1";
		}
		return res;
	}
	
	// 파일 다운로드 메소드.....
	@RequestMapping(value="/fileUpload/fileDownAction", method=RequestMethod.GET)
	public void fileDownActionGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String file = request.getParameter("file");
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/study/");
		
		File downFile = new File(realPath + file);
		
		String downFileName = new String(file.getBytes("UTF-8"), "8859_1");
		response.setHeader("Content-Disposition", "attachment:filename=" + downFileName);
		
		FileInputStream fis = new FileInputStream(downFile);
		ServletOutputStream sos = response.getOutputStream();
		
		byte[] buffer = new byte[2048];
		int data = 0;
		while((data = fis.read(buffer, 0, buffer.length)) != -1) {
			sos.write(buffer, 0, data);
		}
		sos.flush();
		sos.close();
		fis.close();
		
		//return "study/fileUpload/fileUploadForm";
	}
	
	// validator를 이용한 Backend 유효성 검사하기
	@RequestMapping(value = "/validator/validatorForm", method = RequestMethod.GET)
	public String validatorFormGet() {
		return "study/validator/validatorForm";
	}
	
	/*
	// validator를 이용한 Backend 유효성 검사하기 - 자료 검사후 DB에 저장하기
	@RequestMapping(value = "/validator/validatorForm", method = RequestMethod.POST)
	public String validatorFormPost(UserVO vo) {
		System.out.println("vo : " + vo);
		
		if(vo.getMid().equals("") || vo.getName().equals("") || vo.getMid().length() < 3 || vo.getAge() < 18) {
			return "redirect:/message/userCheckNo";
		}
		
		int res = studyService.setUserInput(vo);
		if(res == 1) return "redirect:/message/userInputOk";
		else return "redirect:/message/userInputNo";
	}
	*/	
	// validator를 이용한 Backend 유효성 검사하기 - 자료 검사후 DB에 저장하기
	@RequestMapping(value = "/validator/validatorForm", method = RequestMethod.POST)
	public String validatorFormPost(Model model,
			@Validated UserVO vo, BindingResult bindingResult			
			) {
		System.out.println("vo : " + vo);
		
		System.out.println("error : " + bindingResult.hasErrors());
		
		if(bindingResult.hasFieldErrors()) {	// bindingResult.hasFieldErrors() 결과값이 true가 나오면 오류가 있다는 것이다.
			List<ObjectError> list = bindingResult.getAllErrors();
			System.out.println("~~~~~~~~~~~~~~~~~~~~~~~");
			
			String temp = "";
			for(ObjectError e : list) {
				System.out.println("메세지 : " + e.getDefaultMessage());
				temp = e.getDefaultMessage().substring(e.getDefaultMessage().indexOf("/")+1);
				if(temp.equals("midEmpty") || temp.equals("midSizeNo") || temp.equals("nameEmpty") || temp.equals("nameSizeNo") || temp.equals("ageRangeNo")) break;
			}
			System.out.println("temp : " + temp);
			System.out.println("~~~~~~~~~~~~~~~~~~~~~~~");
			model.addAttribute("temp", temp);
			return "redirect:/message/validatorError";
		}
		
		int res = studyService.setUserInput(vo);
		if(res == 1) return "redirect:/message/userInputOk";
		else return "redirect:/message/userInputNo";
	}
	
	// user리스트 보여주기
	@RequestMapping(value = "/validator/validatorList", method = RequestMethod.GET)
	public String validatorListGet(Model model) {
		ArrayList<UserVO> vos = studyService.getUserList();
		model.addAttribute("vos", vos);
		
		return "study/validator/validatorList";
	}
	
	// user 삭제하기
	@RequestMapping(value = "/validator/validatorDelete", method = RequestMethod.GET)
	public String validatorDeleteGet(int idx) {
		studyService.setUserDelete(idx);
		
		return "redirect:/message/validatorDeleteOk";
	}
	
	// kakaomap Form 보기
	@RequestMapping(value = "/kakaomap/kakaomap", method = RequestMethod.GET)
	public String kakaomapGet() {
		return "study/kakaomap/kakaomap";
	}
	
	// kakaomap 클릭한 위치에 마커표시하기
	@RequestMapping(value = "/kakaomap/kakaoEx1", method = RequestMethod.GET)
	public String kakaoEx1Get() {
		return "study/kakaomap/kakaoEx1";
	}
	
	// kakaomap 클릭한 위치에 마커표시하기(DB저장)
	@ResponseBody
	@RequestMapping(value = "/kakaomap/kakaoEx1", method = RequestMethod.POST)
	public String kakaoEx1Post(KakaoAddressVO vo) {
		KakaoAddressVO searchVO = studyService.getKakaoAddressName(vo.getAddress());
		if(searchVO != null) return "0";
		studyService.setKakaoAddressInput(vo);
		return "1";
	}
	
	// kakaomap DB에 저장된 지명 검색하기
	@RequestMapping(value = "/kakaomap/kakaoEx2", method = RequestMethod.GET)
	public String kakaoEx2Get(Model model,
			@RequestParam(name="address", defaultValue = "그린컴퓨터", required=false) String address) {
		KakaoAddressVO vo = studyService.getKakaoAddressName(address);
		List<KakaoAddressVO> vos = studyService.getKakaoAddressList();
		
		model.addAttribute("vo", vo);
		model.addAttribute("vos", vos);
		model.addAttribute("address", address);
		
		return "study/kakaomap/kakaoEx2";
	}
	
	// kakaomap DB에 저장된 주소 삭제처리
	@ResponseBody
	@RequestMapping(value = "/kakaomap/kakaoAddressDelete", method = RequestMethod.POST)
	public String kakaoAddressDeletePost(String address) {
		studyService.setKakaoAddressDelete(address);
		return "";
	}
	
	// kakaomap Kakao데이터베이스에 들어있는 지명으로 검색하후 내DB에 저장하기
	@RequestMapping(value = "/kakaomap/kakaoEx3", method = RequestMethod.GET)
	public String kakaoEx3Get(Model model,
			@RequestParam(name="address", defaultValue = "청주시청", required=false) String address) {
		model.addAttribute("address", address);
		return "study/kakaomap/kakaoEx3";
	}
	
	// kakaomap 주변검색처리
	@RequestMapping(value = "/kakaomap/kakaoEx4", method = RequestMethod.GET)
	public String kakaoEx4Get(Model model,
			@RequestParam(name="address", defaultValue = "청주시청", required=false) String address) {
		model.addAttribute("address", address);
		return "study/kakaomap/kakaoEx4";
	}
	
	// QR코드 폼
	@RequestMapping(value = "/qrCode/qrCodeForm", method = RequestMethod.GET)
	public String qrcodeFormGet() {
		return "study/qrCode/qrCodeForm";
	}
	
	// QR코드 폼(개인정보등록)
	@RequestMapping(value = "/qrCode/qrCodeEx1", method = RequestMethod.GET)
	public String qrcodeEx1Get() {
		return "study/qrCode/qrCodeEx1";
	}
	
	// QR코드 폼(개인정보등록)
	@ResponseBody
	@RequestMapping(value = "/qrCode/qrCodeEx1", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String qrcodeEx1Post(QrCodeVO vo, HttpServletRequest request) {
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/qrCode/");
		String qrCodeName = studyService.qrCreate(vo, realPath);
		return qrCodeName;
	}
	
	// QR코드 폼(정보 사이트 등록)
	@RequestMapping(value = "/qrCode/qrCodeEx2", method = RequestMethod.GET)
	public String qrcodeEx2Get() {
		return "study/qrCode/qrCodeEx2";
	}
	
	// QR코드 폼(정보 사이트 등록)
	@ResponseBody
	@RequestMapping(value = "/qrCode/qrCodeEx2", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String qrcodeEx2Post(QrCodeVO vo, HttpServletRequest request) {
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/qrCode/");
		String qrCodeName = studyService.qrCreate2(vo, realPath);
		return qrCodeName;
	}
	
	// QR코드 폼(영화예매하기)
	@RequestMapping(value = "/qrCode/qrCodeEx3", method = RequestMethod.GET)
	public String qrcodeEx3Get() {
		return "study/qrCode/qrCodeEx3";
	}
	
	// QR코드 폼(영화예매하기)
	@ResponseBody
	@RequestMapping(value = "/qrCode/qrCodeEx3", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String qrcodeEx3Post(QrCodeVO vo, HttpServletRequest request) {
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/qrCode/");
		String qrCodeName = studyService.qrCreate3(vo, realPath);
		return qrCodeName;
	}
	
	// QR코드 폼(영화예매하기) - DB저장/확인
	@RequestMapping(value = "/qrCode/qrCodeEx4", method = RequestMethod.GET)
	public String qrcodeEx4Get() {
		return "study/qrCode/qrCodeEx4";
	}
	
	// QR코드 폼(영화예매하기) - DB저장/확인
	@ResponseBody
	@RequestMapping(value = "/qrCode/qrCodeEx4", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String qrcodeEx4Post(QrCodeVO vo, HttpServletRequest request) {
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/qrCode/");
		String qrCodeName = studyService.qrCreate4(vo, realPath);
		return qrCodeName;
	}
	
	// QR코드 폼(영화예매하기) - DB검색
	/*
	@ResponseBody
	@RequestMapping(value = "/qrCode/qrCodeSearch", method = RequestMethod.POST, produces="application/text; charset=utf8")
	public String qrCodeSearchPost(String qrCode) {
		QrCodeVO vo = studyService.getQrCodeSearch(qrCode);
		
		String str = "";
		str += "아이디 : " + vo.getMid()+ ",";
		str += "성명 : " + vo.getName()+ ",";
		str += "이메일 : " + vo.getEmail()+ ",";
		str += "영화제목 : " + vo.getMovieName()+ ",";
		str += "상영일자 : " + vo.getMovieDate()+ ",";
		str += "상영시간 : " + vo.getMovieTime()+ ",";
		str += "성인수 : " + vo.getMovieAdult()+ ",";
		str += "어린이수 : " + vo.getMovieChild()+ ",";
		str += "티켓구매일자 : " + vo.getPublishNow();
		
		return str;
	}
	*/
	@ResponseBody
	@RequestMapping(value = "/qrCode/qrCodeSearch", method = RequestMethod.POST)
	public QrCodeVO qrCodeSearchPost(String qrCode) {
		return studyService.getQrCodeSearch(qrCode);
	}
	
	// 캡차 연습폼...
	@RequestMapping(value = "/captcha/captchaForm", method = RequestMethod.GET)
	public String captchaFormGet() {
		return "study/captcha/captchaForm";
	}
	
	// 캡차 이미지 생성하기(랜덤...)
	@ResponseBody
	@RequestMapping(value = "/captcha/captchaImage", method = RequestMethod.POST)
	public String captchaImagePost(HttpServletRequest request, HttpServletResponse response) {
		try {
			// 알파벳과 숫자가 섞인 5글자 문자열을 랜덤하게 생성...
			String randomString = RandomStringUtils.randomAlphanumeric(5);
			System.out.println("randomString : " + randomString);
			
			// 랜덤하게 생성된 문자를 세션에 저장한다.
		  request.getSession().setAttribute("CAPTCHA", randomString);
		  
		  // 시스템에 등록된 폰트들의 목록(이름)을 확인
//		  Font[] fontList = GraphicsEnvironment.getLocalGraphicsEnvironment().getAllFonts();
//		  for(Font f : fontList) {
//		  	System.out.println(f.getName());
//		  }
		  Font font = new Font("Jokerman", Font.ITALIC, 30);
		  FontRenderContext frc = new FontRenderContext(null, true, true);
		  Rectangle2D bounds = font.getStringBounds(randomString, frc);
		  int w = (int) bounds.getWidth();
		  int h = (int) bounds.getHeight();
		  
		  // 이미지로 생성
		  BufferedImage image = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
		  Graphics2D g = image.createGraphics();
		  // g.setColor(Color.WHITE);
		  g.fillRect(0, 0, w, h);
		  g.setColor(new Color(0, 156, 240));
		  g.setFont(font);
		  g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
		  g.setRenderingHint(RenderingHints.KEY_FRACTIONALMETRICS, RenderingHints.VALUE_FRACTIONALMETRICS_ON);
		  g.drawString(randomString, (float)bounds.getX(), (float)-bounds.getY());
		  g.dispose();
		  
		  String realPath = request.getSession().getServletContext().getRealPath("/resources/images/");
		  ImageIO.write(image, "png", new File(realPath + "captcha.png"));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return "study/captcha/captchaForm";
	}
	
	// 캡차 비교
	@ResponseBody
	@RequestMapping(value = "/captcha/captchaForm", method = RequestMethod.POST)
	public String captchaPost(HttpSession session, String strCaptcha) {
		if(strCaptcha.equals(session.getAttribute("CAPTCHA").toString())) return "1";
		else return "0";
	}
	
	// 썸네일 이미지 연습폼
	@RequestMapping(value = "/thumbnail/thumbnailForm", method = RequestMethod.GET)
	public String thumbnailFormGet() {
		return "study/thumbnail/thumbnailForm";
	}
	
	// 썸네일 이미지 생성 하기
	@RequestMapping(value = "/thumbnail/thumbnailForm", method = RequestMethod.POST)
	public String thumbnailFormPost(MultipartFile file) {
		int res = studyService.thumbnailCreate(file);
		if(res == 1) return "redirect:/message/thumbnailCreateOk";
		else return "redirect:/message/thumbnailCreateNo";
	}
	
	// 썸네일 결과 보기
	@RequestMapping(value = "/thumbnail/thumbnailResult", method = RequestMethod.GET)
	public String thumbnailResultGet(HttpServletRequest request, Model model) {
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/thumbnail/");
		String[] files = new File(realPath).list();		
		model.addAttribute("files", files);
		model.addAttribute("cnt", (files.length / 2));
		
		return "study/thumbnail/thumbnailResult";
	}
	
	// 썸네일 이미지 삭제하기
	@ResponseBody
	@RequestMapping(value = "/thumbnail/thumbnailDelete", method = RequestMethod.POST)
	public String thumbnailDeletePost(HttpServletRequest request, String file, String thumbnailFile) {
//		System.out.println("file : " + file);
//		System.out.println("thumbnailFile : " + thumbnailFile);
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/thumbnail/");
		new File(realPath + file).delete();		
		new File(realPath + thumbnailFile).delete();		
		
		return "1";
	}
	
	// 결제할 내역을 입력할 창 호출하기
	@RequestMapping(value="/merchant/merchant", method=RequestMethod.GET)
	public String merchantGet() {
		return "study/merchant/merchant";
	}
	
	// 결제창 호출하기
	@RequestMapping(value="/merchant/merchant", method=RequestMethod.POST)
	public String merchantPost(DbPayMentVO vo, Model model, HttpSession session) {
		session.setAttribute("sDbPayMentVO", vo);
		model.addAttribute("vo", vo);
		return "study/merchant/sample";
	}
	
	// 결제할 내역을 입력할 창 호출하기
	@RequestMapping(value="/merchant/merchantOk", method=RequestMethod.GET)
	public String merchantOkGet(Model model, HttpSession session) {
		DbPayMentVO vo = (DbPayMentVO) session.getAttribute("sDbPayMentVO");
		model.addAttribute("vo", vo);
		session.removeAttribute("sDbPayMentVO");
		return "study/merchant/merchantOk";
	}
	
	// 트랜잭션 연습폼 호출
	@RequestMapping(value="/transaction/transaction", method=RequestMethod.GET)
	public String transactionGet(Model model, HttpSession session) {
		return "study/transaction/transaction";
	}
	
	// 트랜잭션 개별 입력처리 
	@Transactional
	@RequestMapping(value="/transaction/input1", method=RequestMethod.GET)
	public String input1Get(TransactionVO vo) {
		studyService.setTransactionUserInput1(vo);
		studyService.setTransactionUserInput2(vo);
		return "redirect:/message/transactionInput1Ok";
	}
	
	// 트랜잭션 일괄 입력처리 
	@RequestMapping(value="/transaction/input2", method=RequestMethod.GET)
	public String input2Get(TransactionVO vo) {
		studyService.setTransactionUserInput(vo);
		// 이곳은 기타 처리가 들어가는 영역......
		
		return "redirect:/message/transactionInput2Ok";
	}
	
	// 회원(user) 전체 리스트 보기
	@RequestMapping(value="/transaction/transactionList", method=RequestMethod.GET)
	public String transactionListGet(Model model,
			@RequestParam(name="userSelect", defaultValue="user", required=false) String userSelect) {
		List<TransactionVO> vos = studyService.setTransactionUserList(userSelect);
		model.addAttribute("vos", vos);
		model.addAttribute("userSelect", userSelect);
		return "study/transaction/transactionList";
	}
	
	// Google Chart 연습
	@RequestMapping(value="/chart/chart", method=RequestMethod.GET)
	public String chartGet(Model model,
			@RequestParam(name="part", defaultValue="barV", required=false) String part) {
		model.addAttribute("part", part);
		return "study/chart/chart";
	}
	
	// Google Chart2 연습
	@RequestMapping(value="/chart2/chart", method=RequestMethod.GET)
	public String chart2Get(Model model) {
		return "study/chart2/chart";
	}
	
	// Google Chart2 연습
	@RequestMapping(value="/chart2/chart2", method=RequestMethod.POST)
	public String chart2Post(Model model, ChartVO vo) {
		System.out.println("vo : " + vo);
		model.addAttribute("vo", vo);
		return "study/chart2/chart";
	}
	
	// 최근 방문자수 차트로 표시하기
	@RequestMapping(value="/chart2/chart2Recently", method=RequestMethod.GET)
	public String googleChart2RecentlyGet(Model model,
			@RequestParam(name="part", defaultValue="line", required=false) String part) {
		System.out.println("part : " + part);
		List<ChartVO> vos = null;
		if(part.equals("lineChartVisitCount")) {
			vos = studyService.getRecentlyVisitCount(1);
			String[] visitDates = new String[7];
			int[] visitDays = new int[7];	// line차트는 x축과 y축이 모두 숫자가 와야하기에 날짜중에서 '일'만 담기로 한다.(정수타입으로)
			int[] visitCounts = new int[7];
			for(int i=0; i<7; i++) {
				visitDates[i] = vos.get(i).getVisitDate().replaceAll("-", "").substring(4);
				visitDays[i] = Integer.parseInt(vos.get(i).getVisitDate().toString().substring(8));
				visitCounts[i] = vos.get(i).getVisitCount();
			}
			
			model.addAttribute("title", "최근 7일간 방문횟수");
			model.addAttribute("subTitle", "최근 7일동안 방문한 해당일자 방문자 총수를 표시합니다.");
			model.addAttribute("visitCount", "방문횟수");
			model.addAttribute("legend", "일일 방문 총횟수");
			model.addAttribute("topTitle", "방문날짜");
			model.addAttribute("xTitle", "방문날짜");
			model.addAttribute("part", part);
			model.addAttribute("visitDates", visitDates);
			model.addAttribute("visitDays", visitDays);
			model.addAttribute("visitCounts", visitCounts);
		}
		
		return "study/chart2/chart";
	}
	
	// 많이찾은 방문자 7명 차트로 표시하기
	@RequestMapping(value="/chart2/chart2Recently2", method=RequestMethod.GET)
	public String googleChart2Recently2Get(Model model,
			@RequestParam(name="part", defaultValue="line", required=false) String part) {
		List<ChartVO> vos = null;
		if(part.equals("lineChartVisitCount2")) {
			vos = studyService.getRecentlyVisitCount(2);
			String[] visitDates = new String[7];
			int[] visitDays = new int[7];	// line차트는 x축과 y축이 모두 숫자가 와야하기에 날짜중에서 '일'만 담기로 한다.(정수타입으로)
			int[] visitCounts = new int[7];
			for(int i=0; i<7; i++) {
				visitDates[i] = vos.get(i).getVisitDate().toString();
				visitDays[i] = 7 - i;
				visitCounts[i] = vos.get(i).getVisitCount();
			}
			
			model.addAttribute("title", "많이 방문한 회원 7명");
			model.addAttribute("subTitle", "가장 많이 방문한 방문자 7인을 표시합니다.");
			model.addAttribute("visitCount", "방문횟수");
			model.addAttribute("legend", "방문 총횟수");
			model.addAttribute("topTitle", "회원아이디");
			model.addAttribute("xTitle", "회원아이디");
			model.addAttribute("part", part);
			model.addAttribute("visitDates", visitDates);
			model.addAttribute("visitDays", visitDays);
			model.addAttribute("visitCounts", visitCounts);
		}
		
		return "study/chart2/chart";
	}
	
}
