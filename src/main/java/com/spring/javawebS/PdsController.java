package com.spring.javawebS;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.javawebS.pagination.PageProcess;
import com.spring.javawebS.pagination.PageVO;
import com.spring.javawebS.service.PdsService;
import com.spring.javawebS.vo.PdsVO;

@Controller
@RequestMapping("/pds")
public class PdsController {
	
	@Autowired
	PdsService pdsService;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@RequestMapping(value = "/pdsList", method = RequestMethod.GET)
	public String pdsListGet(Model model,
			@RequestParam(name="pag", defaultValue = "1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue = "5", required=false) int pageSize,
			@RequestParam(name="part", defaultValue = "전체", required=false) String part) {
		
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "pds", part, "");
		List<PdsVO> vos = pdsService.getPdsList(pageVO.getStartIndexNo(), pageVO.getPageSize(), part);
		
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		
		return "pds/pdsList";
	}
	
	@RequestMapping(value = "/pdsInput", method = RequestMethod.GET)
	public String pdsInputGet(String part, Model model) {
		model.addAttribute("part", part);
		return "pds/pdsInput";
	}
	
	@RequestMapping(value = "/pdsInput", method = RequestMethod.POST)
	public String pdsInputPost(PdsVO vo, MultipartHttpServletRequest file) {
		String pwd = passwordEncoder.encode(vo.getPwd());
		vo.setPwd(pwd);
		System.out.println("vo : " + vo);
		int res = pdsService.setPdsInput(vo, file);
		System.out.println("res : " + res);
		
		if(res == 1) return "redirect:/message/pdsInputOk";
		else return "redirect:/message/pdsInputNo";
	}
	
	// 개별파일 다운로드 하기
	@ResponseBody
	@RequestMapping(value = "/pdsDownNumCheck", method = RequestMethod.POST)
	public String pdsDownNumCheckPost(int idx) {
		int res = pdsService.setPdsDownNumCheck(idx);
		return res + "";
	}
	
	// 자료실 삭제 : 파일도 함께 삭제하기
	@ResponseBody
	@RequestMapping(value = "/pdsDeleteCheck", method = RequestMethod.POST)
	public String pdsDeleteCheckPost(int idx, String pwd) {
		PdsVO vo = pdsService.getPdsIdxSearch(idx);
		if(!passwordEncoder.matches(pwd, vo.getPwd())) return "0";
		
		// 비밀번호가 일치하면 파일 삭제후 DB에서 내역을 삭제처리한다.
		pdsService.setPdsDelete(vo);
		return "1";
	}
	
	@RequestMapping(value = "/pdsContent", method = RequestMethod.GET)
	public String pdsContentGet(Model model,
			@RequestParam(name="idx", defaultValue = "0", required=false) int idx,
			@RequestParam(name="pag", defaultValue = "1", required=false) int pag,
			@RequestParam(name="part", defaultValue = "전체", required=false) String part) {
		PdsVO vo = pdsService.getPdsIdxSearch(idx);
		model.addAttribute("vo", vo);
		
		return "pds/pdsContent";
	}
	
	// 전체파일 다운로드하기
	@SuppressWarnings("deprecation")
	@RequestMapping(value = "/pdsTotalDown", method = RequestMethod.GET)
	public String pdsTotalDownGet(HttpServletRequest request, int idx) throws IOException {
		// 파일 다운로드횟수 증가
		pdsService.setPdsDownNumCheck(idx);
		
		// 여러개의 파일을 다운로드할 경우 하나의 파일(zip)로 압축(통합?)하여 다운로드한다. 압축될 파일명은 '제목.zip'으로 처리한다.
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/pds/");
		
		PdsVO vo = pdsService.getPdsIdxSearch(idx);
		
		String[] fNames = vo.getFName().split("/");
		String[] fSNames = vo.getFSName().split("/");
		
		String zipPath = realPath + "temp/";
		String zipName = vo.getTitle() + ".zip";
		
		FileInputStream fis = null;
		FileOutputStream fos = null;
		
		ZipOutputStream zout = new ZipOutputStream(new FileOutputStream(zipPath + zipName));
		
		byte[] buffer = new byte[2048];
		
		for(int i=0; i<fNames.length; i++) {
			fis = new FileInputStream(realPath + fSNames[i]);
			fos = new FileOutputStream(zipPath + fNames[i]);
			File moveAndRename = new File(zipPath + fNames[i]);
			
			// fos에 파일을 쓰기작업...
			int data;
			while((data = fis.read(buffer, 0, buffer.length)) != -1) {
				fos.write(buffer, 0, data);
			}
			fos.flush();
			fos.close();
			fis.close();
			
			// zip파일에 fos를 넣어준다.
			fis = new FileInputStream(moveAndRename);
			zout.putNextEntry(new ZipEntry(fNames[i]));
			while((data = fis.read(buffer, 0, buffer.length)) != -1) {
				zout.write(buffer, 0, data);
			}
			zout.flush();
			zout.closeEntry();
		}
		zout.close();
		
		return "redirect:/pds/pdsDownAction?file="+java.net.URLEncoder.encode(zipName);
	}
	
	@RequestMapping(value = "/pdsDownAction", method = RequestMethod.GET)
	public void pdsDownActionGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String file = request.getParameter("file");
		
		String downPathFile = request.getSession().getServletContext().getRealPath("/resources/data/pds/temp/") + file;
		
		File downFile = new File(downPathFile);
		
		String downFileName = new String(file.getBytes("UTF-8"), "8859_1");
		response.setHeader("Content-Disposition", "attachment;filename=" + downFileName);
		
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
		
		// 다운로드 완료후 temp폴더의 모든 파일들을 삭제처리한다.??????
		// downFile.delete();
	}
}
