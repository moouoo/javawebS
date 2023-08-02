package com.spring.javawebS;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javawebS.pagination.PageProcess;
import com.spring.javawebS.pagination.PageVO;
import com.spring.javawebS.service.DbShopService;
import com.spring.javawebS.service.MemberService;
import com.spring.javawebS.vo.DbBaesongVO;
import com.spring.javawebS.vo.DbCartVO;
import com.spring.javawebS.vo.DbOptionVO;
import com.spring.javawebS.vo.DbOrderVO;
import com.spring.javawebS.vo.DbPayMentVO;
import com.spring.javawebS.vo.DbProductVO;
import com.spring.javawebS.vo.MemberVO;

@Controller
@RequestMapping("/dbShop")
public class DbShopController {
	
	@Autowired
	DbShopService dbShopService;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	MemberService memberService;

	/* 아래로 관리자에서의 처리부분들~~~~ */
	
	// 대/중/소분류 폼 보기
	@RequestMapping(value = "/dbCategory", method = RequestMethod.GET)
	public String dbCategoryGet(Model model) {
		List<DbProductVO> mainVOS = dbShopService.getCategoryMain();  // 대분류리스트
		List<DbProductVO> middleVOS = dbShopService.getCategoryMiddle();// 중분류리스트
		List<DbProductVO> subVOS = dbShopService.getCategorySub();// 소분류리스트
	
		model.addAttribute("mainVOS", mainVOS);
		model.addAttribute("middleVOS", middleVOS);
		model.addAttribute("subVOS", subVOS);
		
		return "admin/dbShop/dbCategory";
	}
	
	// 대분류 등록하기
	@ResponseBody
	@RequestMapping(value = "/categoryMainInput", method = RequestMethod.POST)
	public String categoryMainInputPost(DbProductVO vo) {
		// 기존에 같은 대분류명이 있는지 체크?
		DbProductVO productVO = dbShopService.getCategoryMainOne(vo.getCategoryMainCode(), vo.getCategoryMainName());
		
		if(productVO != null) return "0";
		dbShopService.setCategoryMainInput(vo);		// 대분류항목 저장
		return "1";
	}
	
	// 대분류 삭제하기
	@ResponseBody
	@RequestMapping(value = "/categoryMainDelete", method = RequestMethod.POST)
	public String categoryMainDeleteGet(DbProductVO vo) {
		// 현재 대분류가 속해있는 하위항목이 있는지를 체크한다.
		DbProductVO middleVO = dbShopService.getCategoryMiddleOne(vo);
		
		if(middleVO != null) return "0";
		dbShopService.setCategoryMainDelete(vo.getCategoryMainCode());  // 대분류항목 삭제
		
		return "1";
	}
	
	// 중분류 등록하기
	@ResponseBody
	@RequestMapping(value = "/categoryMiddleInput", method = RequestMethod.POST)
	public String categoryMiddleInputPost(DbProductVO vo) {
		// 기존에 같은 중분류명이 있는지 체크?
		DbProductVO productVO = dbShopService.getCategoryMiddleOne(vo);
		
		if(productVO != null) return "0";
		dbShopService.setCategoryMiddleInput(vo);		// 중분류항목 저장
		return "1";
	}
	
	// 대분류 선택시 중분류명 가져오기
	@ResponseBody
	@RequestMapping(value = "/categoryMiddleName", method = RequestMethod.POST)
	public List<DbProductVO> categoryMiddleNamePost(String categoryMainCode) {
//		List<DbProductVO> mainVOS = dbShopService.getCategoryMiddleName(categoryMainCode);
//		return mainVOS;
		return dbShopService.getCategoryMiddleName(categoryMainCode);
	}
	
	// 중분류 삭제하기
	@ResponseBody
	@RequestMapping(value = "/categoryMiddleDelete", method = RequestMethod.POST)
	public String categoryMiddleDeleteGet(DbProductVO vo) {
		// 현재 중분류가 속해있는 하위항목이 있는지를 체크한다.
		DbProductVO subVO = dbShopService.getCategorySubOne(vo);
		
		if(subVO != null) return "0";
		dbShopService.setCategoryMiddleDelete(vo.getCategoryMiddleCode());  // 소분류항목 삭제
		
		return "1";
	}
	
  // 소분류 등록하기
	@ResponseBody
	@RequestMapping(value = "/categorySubInput", method = RequestMethod.POST)
	public String categorySubInputPost(DbProductVO vo) {
		// 기존에 같은 소분류명이 있는지 체크?
		DbProductVO productVO = dbShopService.getCategorySubOne(vo);
		
		if(productVO != null) return "0";
		dbShopService.setCategorySubInput(vo);		// 중분류항목 저장
		return "1";
	}
	
	// 소분류 삭제하기
	@ResponseBody
	@RequestMapping(value = "/categorySubDelete", method = RequestMethod.POST)
	public String categorySubDeleteGet(DbProductVO vo) {
		// 현재 소분류가 속해있는 하위항목인 상품이 있는지를 체크한다.
		DbProductVO productVO = dbShopService.getDbProductOne(vo.getCategorySubCode());
		
		if(productVO != null) return "0";
		dbShopService.setCategorySubDelete(vo.getCategorySubCode());  // 소분류항목 삭제
		
		return "1";
	}
	
	// 상품 등록을 위한 등록폼 보여주기
	@RequestMapping(value = "/dbProduct", method = RequestMethod.GET)
	public String dbProducGet(Model model) {
		List<DbProductVO> mainVos = dbShopService.getCategoryMain();
		model.addAttribute("mainVos", mainVos);
		return "admin/dbShop/dbProduct";
	}
	
	// 중분류 선택시에 소분류항목들 가져오기
	@ResponseBody
	@RequestMapping(value = "/categorySubName", method = RequestMethod.POST)
	public List<DbProductVO> categorySubNamePost(String categoryMainCode, String categoryMiddleCode) {
		return dbShopService.getCategorySubName(categoryMainCode, categoryMiddleCode);
	}
	
	// 소분류 선택시에 상품명(모델명) 가져오기
	@ResponseBody
	@RequestMapping(value = "/categoryProductName", method = RequestMethod.POST)
	public List<DbProductVO> categoryProductNamePost(String categoryMainCode, String categoryMiddleCode, String categorySubCode) {
		return dbShopService.getCategoryProductName(categoryMainCode, categoryMiddleCode, categorySubCode);
	}
	
	// 관리자 상품등록시에 ckeditor에 그림을 올린다면 dbShop폴더에 저장되고, 저장된 파일을 브라우저 textarea상자에 보여준다. 
	@ResponseBody
	@RequestMapping("/imageUpload")
	public void imageUploadGet(HttpServletRequest request, HttpServletResponse response, @RequestParam MultipartFile upload) throws Exception {
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
		String originalFilename = upload.getOriginalFilename();
		
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss");
		originalFilename = sdf.format(date) + "_" + originalFilename;
		
		byte[] bytes = upload.getBytes();
		
		String uploadPath = request.getSession().getServletContext().getRealPath("/resources/data/dbShop/");
		OutputStream outStr = new FileOutputStream(new File(uploadPath + originalFilename));
		outStr.write(bytes);
		
		PrintWriter out = response.getWriter();
		String fileUrl = request.getContextPath() + "/data/dbShop/" + originalFilename;
		out.println("{\"originalFilename\":\""+originalFilename+"\",\"uploaded\":1,\"url\":\""+fileUrl+"\"}");
		
		out.flush();
		outStr.close();
	}
	
	// 상품 등록을 위한 등록시키기
	@RequestMapping(value = "/dbProduct", method = RequestMethod.POST)
	public String dbProducPost(MultipartFile file, DbProductVO vo) {
		// 이미지파일 업로드시에 ckeditor폴더에서 product폴더로 복사작업처리....(dbShop폴더에서 'dbShop/product'로)
		dbShopService.imgCheckProductInput(file, vo);
		
		return "redirect:/message/dbProductInputOk";
	}
	
	// 등록된 상품 모두 보여주기(관리자화면에서 보여주는 처리부분이다.) - 상품의 소분류명(subTitle)도 함께 출력시켜준다.
	@RequestMapping(value = "/dbShopList", method = RequestMethod.GET)
	public String dbShopListGet(Model model,
			@RequestParam(name="part", defaultValue = "전체", required = false) String part) {
		// 소분류명을 가져온다.
		List<DbProductVO> subTitleVOS = dbShopService.getSubTitle();
		model.addAttribute("subTitleVOS", subTitleVOS);
		model.addAttribute("part", part);
		
		// 전체 상품리스트 가져오기
		List<DbProductVO> productVOS = dbShopService.getDbShopList(part);
		model.addAttribute("productVOS", productVOS);
		
		return "admin/dbShop/dbShopList";
	}
	
	// 관리자에서 진열된 상품을 클릭하였을경우에 해당 상품의 상세내역 보여주기
	@RequestMapping(value="/dbShopContent", method=RequestMethod.GET)
	public String dbShopContentGet(Model model, int idx) {
		DbProductVO productVO = dbShopService.getDbShopProduct(idx);	   // 1건의 상품 정보를 불러온다.
		List<DbOptionVO> optionVOS = dbShopService.getDbShopOption(idx); // 해당 상품의 모든 옵션 정보를 가져온다.
		model.addAttribute("productVO", productVO);
		model.addAttribute("optionVOS", optionVOS);
		
		return "admin/dbShop/dbShopContent";
	}
	
	// 옵션 등록창 보여주기(관리자 왼쪽메뉴에서 선택시 처리)
	@RequestMapping(value = "/dbOption", method = RequestMethod.GET)
	public String dbOptionGet(Model model) {
		List<DbProductVO> mainVos = dbShopService.getCategoryMain();
		model.addAttribute("mainVos", mainVos);
		
		return "admin/dbShop/dbOption";
	}
	
	// 옵션 등록창 보여주기(관리자 상품상세보기에서 호출시 처리)
	@RequestMapping(value = "/dbOption2", method = RequestMethod.GET)
	public String dbOption2Get(Model model, String productName) {
		DbProductVO vo = dbShopService.getProductInfor(productName);
		List<DbOptionVO> optionVOS = dbShopService.getOptionList(vo.getIdx());
		model.addAttribute("vo", vo);
		model.addAttribute("optionVOS", optionVOS);
		
		return "admin/dbShop/dbOption2";
	}
	
	// 옵션 등록후 다시 옵션 등록창 보여주기(옵션을 1개씩 등록할때는 사용하면 편리하나, 여러개를 동적폼으로 만들었을때는 aJax를 사용하지 못한다.
	/*
	@ResponseBody
	@RequestMapping(value = "/dbOption2Input", method = RequestMethod.POST)
	public String dbOption2InputGet(DbOptionVO vo) {
		dbShopService.setDbOptionInput(vo);
		return "";
	}
	*/
	
	// 옵션 등록창에서, 상품을 선택하면 선택된 상품의 상세설명을 가져와서 뿌리기
	@ResponseBody
	@RequestMapping(value="/getProductInfor", method = RequestMethod.POST)
	public DbProductVO getProductInforPost(String productName) {
		return dbShopService.getProductInfor(productName);
	}
	
	// 옵션등록창에서 '옵셔보기'버튼클릭시에 해당 제품의 모든 옵션을 보여주기
	@ResponseBody
	@RequestMapping(value="/getOptionList", method = RequestMethod.POST)
	public List<DbOptionVO> getOptionListPost(int productIdx) {
		return dbShopService.getOptionList(productIdx);
	}
	
	// 옵션 기록사항들을 등록하기
	@RequestMapping(value="/dbOption", method=RequestMethod.POST)
	public String dbOptionPost(Model model, DbOptionVO vo, String[] optionName, int[] optionPrice,
			@RequestParam(name="flag", defaultValue = "", required=false) String flag) {
		for(int i=0; i<optionName.length; i++) {
			
			int optionCnt = dbShopService.getOptionSame(vo.getProductIdx(), optionName[i]);
			if(optionCnt != 0) continue;
			
			// 동일한 옵션이 없으면 vo에 set시킨후 옵션테이블에 등록시킨다.
			vo.setProductIdx(vo.getProductIdx());
			vo.setOptionName(optionName[i]);
			vo.setOptionPrice(optionPrice[i]);
			
			dbShopService.setDbOptionInput(vo);
		}
		if(!flag.equals("option2")) return "redirect:/message/dbOptionInputOk";
		else {
			model.addAttribute("temp", vo.getProductName());
			return "redirect:/message/dbOptionInput2Ok";
		}
	}
	
	// 옵션 등록창에서 옵션리스트를 확인후 필요없는 옵션항목을 삭제처리..
	@ResponseBody
	@RequestMapping(value="/optionDelete", method = RequestMethod.POST)
	public String optionDeletePost(int idx) {
		dbShopService.setOptionDelete(idx);
		return "";
	}
	
	// 주문관리.......
	
	
	
	
	
	
	
	// ---------------------------------------------------------------------------
	
	/* 아래로 사용자(고객)에서의 처리부분들~~~~ */
	
	// 등록된 상품 보여주기(사용자(고객)화면에서 보여주기)
	@RequestMapping(value="/dbProductList", method = RequestMethod.GET)
	public String dbProductListGet(
			@RequestParam(name="part", defaultValue="전체", required=false) String part,
			Model model) {
		List<DbProductVO> subTitleVos = dbShopService.getSubTitle();
		model.addAttribute("subTitleVos", subTitleVos);
		model.addAttribute("part", part);
		
		List<DbProductVO> productVos = dbShopService.getDbShopList(part);
		model.addAttribute("productVos", productVos);
		return "dbShop/dbProductList";
	}
	
  // 진열된 상품클릭시 해당상품의 상세정보 보여주기(사용자(고객)화면에서 보여주기)
	@RequestMapping(value="/dbProductContent", method=RequestMethod.GET)
	public String dbProductContentGet(int idx, Model model) {
		DbProductVO productVo = dbShopService.getDbShopProduct(idx);			// 상품의 상세정보 불러오기
		List<DbOptionVO> optionVos = dbShopService.getDbShopOption(idx);	// 옵션의 모든 정보 불러오기
		
		model.addAttribute("productVo", productVo);
		model.addAttribute("optionVos", optionVos);
		
		return "dbShop/dbProductContent";
	}
	
	// 상품상세정보보기창에서 '장바구니'버튼, '주문하기'버튼을 클릭하면 모두 이곳을 거쳐서 이동처리했다.
	// '장바구니'버튼에서는 '다시쇼핑하기'처리했고, '주문하기'버튼에서는 '주문창(장바구니창)'으로 보내도록 처리했다.
	@RequestMapping(value="/dbProductContent", method=RequestMethod.POST)
	public String dbProductContentPost(DbCartVO vo, HttpSession session, String flag) {
		// DBCartVO(vo) : 사용자가 선택한 품목(기본품목+옵션)의 정보를 담고 있는 VO
		// DBCartVO(resVo) : 사용자가 기존에 장바구니에 담아놓은적이 있는 품목(기본품목+옵션)의 정보를 담고 있는 VO
		String mid = (String) session.getAttribute("sMid");
		DbCartVO resVo = dbShopService.getDbCartProductOptionSearch(vo.getProductName(), vo.getOptionName(), mid);
		if(resVo != null) {		// 기존에 구매한적이 있었다면 '현재 구매한 내역'과 '기존 장바구니의 수량'을 합쳐서 'Update'시켜줘야한다.
			String[] voOptionNums = vo.getOptionNum().split(",");
			String[] resOptionNums = resVo.getOptionNum().split(",");
			int[] nums = new int[99];
			String strNums = "";
			for(int i=0; i<voOptionNums.length; i++) {
				nums[i] += (Integer.parseInt(voOptionNums[i]) + Integer.parseInt(resOptionNums[i]));
				strNums += nums[i];
				if(i < nums.length - 1) strNums += ",";
			}
			vo.setOptionNum(strNums);
			dbShopService.dbShopCartUpdate(vo);
		}		// 처음 구매하는 제품이라면 장바구니에 insert시켜준다.
		else {
			dbShopService.dbShopCartInput(vo);
		}
		
		if(flag.equals("order")) {
			return "redirect:/message/cartOrderOk";
		}
		else {
			return "redirect:/message/cartInputOk";
		}
	}
	
	// 장바구니에 담겨있는 모든 상품들의 내역을 보여주기-주문 전단계(장바구니는 DB에 들어있는 자료를 바로 불러와서 처리하면 된다.)
	@RequestMapping(value="/dbCartList", method=RequestMethod.GET)
	public String dbCartGet(HttpSession session, DbCartVO vo, Model model) {
		String mid = (String) session.getAttribute("sMid");
		List<DbCartVO> vos = dbShopService.getDbCartList(mid);
		
		if(vos.size() == 0) {
			return "redirect:/message/cartEmpty";
		}
		
		model.addAttribute("cartListVOS", vos);
		return "dbShop/dbCartList";
	}
	
	// 장바구니안에서 삭제시키고자 할 품목을 '구매취소'버튼 눌렀을때 처리
	@ResponseBody
	@RequestMapping(value="/dbCartDelete", method=RequestMethod.POST)
	public String dbCartDeleteGet(int idx) {
		dbShopService.dbCartDelete(idx);
		return "";
	}
	
	// 장바구니에서 '주문하기'버튼 클릭시에 처리하는 부분
	// 카트에 담겨있는 품목들중에서, 주문한 품목들을 읽어와서 세션에 담아준다. 이때 고객의 정보도 함께 처리하며, 주문번호를 만들어서 다음단계인 '결재'로 넘겨준다.
	@RequestMapping(value="/dbCartList", method=RequestMethod.POST)
	public String dbCartListPost(HttpServletRequest request, Model model, HttpSession session,
			@RequestParam(name="baesong", defaultValue = "0", required = false) int baesong) {
		String mid = session.getAttribute("sMid").toString();
		
		// 주문한 상품에 대하여 '고유번호'를 만들어준다.
		// 고유주문번호(idx) = 기존에 존재하는 주문테이블의 고유번호 + 1
		DbOrderVO maxIdx = dbShopService.getOrderMaxIdx();
		int idx = 1;
		if(maxIdx != null) idx = maxIdx.getMaxIdx() + 1;
		
		Date today = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String orderIdx = sdf.format(today) + idx;
				
		// 장바구니에서 구매를 위해 선택한 모든 항목들은 배열로 넘어온다.
		String[] idxChecked = request.getParameterValues("idxChecked");
		
		DbCartVO cartVo = new DbCartVO();
		List<DbOrderVO> orderVOS = new ArrayList<DbOrderVO>();
		
		for(String strIdx : idxChecked) {
			cartVo = dbShopService.getCartIdx(Integer.parseInt(strIdx));
			DbOrderVO orderVo = new DbOrderVO();
			orderVo.setProductIdx(cartVo.getProductIdx());
			orderVo.setProductName(cartVo.getProductName());
			orderVo.setMainPrice(cartVo.getMainPrice());
			orderVo.setThumbImg(cartVo.getThumbImg());
			orderVo.setOptionName(cartVo.getOptionName());
			orderVo.setOptionPrice(cartVo.getOptionPrice());
			orderVo.setOptionNum(cartVo.getOptionNum());
			orderVo.setTotalPrice(cartVo.getTotalPrice());
			orderVo.setCartIdx(cartVo.getIdx());
			orderVo.setBaesong(baesong);
			
			orderVo.setOrderIdx(orderIdx);	// 관리자가 만들어준 '주문고유번호'를 저장
			orderVo.setMid(mid);						// 로그인한 아이디를 저장한다.
			
			orderVOS.add(orderVo);
		}
		session.setAttribute("sOrderVOS", orderVOS);
		
		// 배송처리를 위한 현재 로그인한 아이디에 해당하는 고객의 정보를 member2테이블에서 가져온다.
		MemberVO memberVO = memberService.getMemberIdCheck(mid);
		model.addAttribute("memberVO", memberVO);
		
		return "dbShop/dbOrder";
	}
	
  // 결제시스템(결제창 호출하기) - API이용
	@RequestMapping(value="/payment", method=RequestMethod.POST)
	public String paymentPost(DbOrderVO orderVo, DbPayMentVO payMentVO, DbBaesongVO baesongVO, HttpSession session, Model model) {
		model.addAttribute("payMentVO", payMentVO);
		
		session.setAttribute("sPayMentVO", payMentVO);
		session.setAttribute("sBaesongVO", baesongVO);
		
		return "dbShop/paymentOk";
	}
	
  // 결제시스템 연습하기(결제창 호출후 결재 완료후에 처리하는 부분)
	// 주문 완료후 주문내역을 '주문테이블(dbOrder)에 저장
	// 주문이 완료되었기에 주문된 물품은 장바구니(dbCartList)에서 내역을 삭제처리한다.
	// 사용한 세션은 제거시킨다.
	// 작업처리후 오늘 구매한 상품들의 정보(구매품목,결제내역,배송지)들을 model에 담아서 확인창으로 넘겨준다.
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/paymentResult", method=RequestMethod.GET)
	public String paymentResultGet(HttpSession session, DbPayMentVO receivePayMentVO, Model model) {
		// 주문내역 dbOrder/dbBaesong 테이블에 저장하기(앞에서 저장했던 세션에서 가져왔다.)
		List<DbOrderVO> orderVOS = (List<DbOrderVO>) session.getAttribute("sOrderVOS");
		DbPayMentVO payMentVO = (DbPayMentVO) session.getAttribute("sPayMentVO");
		DbBaesongVO baesongVO = (DbBaesongVO) session.getAttribute("sBaesongVO");
		
//		사용된 세션은 반환한다.
//		session.removeAttribute("sOrderVOS");  // 마지막 결재처리후에 결재결과창에서 확인하고 있기에 지우면 안됨
		session.removeAttribute("sBaesongVO");
		
		for(DbOrderVO vo : orderVOS) {
			vo.setIdx(Integer.parseInt(vo.getOrderIdx().substring(8))); // 주문테이블에 고유번호를 셋팅한다.	
			vo.setOrderIdx(vo.getOrderIdx());        				// 주문번호를 주문테이블의 주문번호필드에 지정처리한다.
			vo.setMid(vo.getMid());							
			
			dbShopService.setDbOrder(vo);                 	// 주문내용을 주문테이블(dbOrder)에 저장.
			dbShopService.setDbCartDeleteAll(vo.getCartIdx()); // 주문이 완료되었기에 장바구니(dbCart)테이블에서 주문한 내역을 삭체처리한다.
			
		}
		// 주문된 정보를 배송테이블에 담기위한 처리(기존 baesongVO에 담기지 않은 내역들을 담아주고 있다.)
		baesongVO.setOIdx(orderVOS.get(0).getIdx());
		baesongVO.setOrderIdx(orderVOS.get(0).getOrderIdx());
		baesongVO.setAddress(payMentVO.getBuyer_addr());
		baesongVO.setTel(payMentVO.getBuyer_tel());
		
		dbShopService.setDbBaesong(baesongVO);  // 배송내용을 배송테이블(dbBaesong)에 저장
		dbShopService.setMemberPointPlus((int)(baesongVO.getOrderTotalPrice() * 0.01), orderVOS.get(0).getMid());	// 회원테이블에 포인트 적립하기(1%)
		
		payMentVO.setImp_uid(receivePayMentVO.getImp_uid());
		payMentVO.setMerchant_uid(receivePayMentVO.getMerchant_uid());
		payMentVO.setPaid_amount(receivePayMentVO.getPaid_amount());
		payMentVO.setApply_num(receivePayMentVO.getApply_num());
		
		// 오늘 주문에 들어간 정보들을 확인해주기위해 다시 session에 담아서 넘겨주고 있다.
		session.setAttribute("sPayMentVO", payMentVO);
		session.setAttribute("orderTotalPrice", baesongVO.getOrderTotalPrice());
		
		return "redirect:/message/paymentResultOk";
	}
	
	// 결재완료된 정보 보여주기
	@SuppressWarnings({ "unchecked" })
	@RequestMapping(value="/paymentResultOk", method=RequestMethod.GET)
	public String paymentResultOkGet(HttpSession session, Model model) {
		List<DbOrderVO> orderVOS = (List<DbOrderVO>) session.getAttribute("sOrderVOS");
		model.addAttribute("orderVOS", orderVOS);
		session.removeAttribute("sOrderVOS");
		return "dbShop/paymentResult";
	}
	
	// 배송지 정보 보여주기
	@RequestMapping(value="/dbOrderBaesong", method=RequestMethod.GET)
	public String dbOrderBaesongGet(String orderIdx, Model model) {
		
		List<DbBaesongVO> vos = dbShopService.getOrderBaesong(orderIdx);  // 같은 주문번호가 2개 이상 있을수 있기에 List객체로 받아온다.
		
		DbBaesongVO vo = vos.get(0);  // 같은 배송지면 0번째것 하나만 vo에 담아서 넘겨주면 된다.
		String payMethod = "";
		if(vo.getPayment().substring(0,1).equals("C")) payMethod = "카드결제";
		else payMethod = "은행(무통장)결제";
		
		model.addAttribute("payMethod", payMethod);
		model.addAttribute("vo", vo);
		
		return "dbShop/dbOrderBaesong";
	}
	
	// 현재 로그인 사용자가 주문내역 조회하기 폼 보여주기
	@RequestMapping(value="/dbMyOrder", method=RequestMethod.GET)
	public String dbMyOrderGet(HttpServletRequest request, HttpSession session, Model model,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize) {
		String mid = (String) session.getAttribute("sMid");
		int level = (int) session.getAttribute("sLevel");
		if(level == 0) mid = "전체";
		
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "dbMyOrder", mid, "");
		
		// 오늘 구매한 내역을 초기화면에 보여준다.
//		List<DbProductVO> vos = dbShopService.getMyOrderList(pageVO.getStartIndexNo(), pageSize, mid);
		List<DbBaesongVO> vos = dbShopService.getMyOrderList(pageVO.getStartIndexNo(), pageSize, mid);
		//System.out.println("vos : " + vos);
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO",pageVO);
		
		return "dbShop/dbMyOrder";
	}

  // 주문 조건 조회하기(날짜별(오늘/일주일/보름/한달/3개월/전체)
  @RequestMapping(value="/orderCondition", method=RequestMethod.GET)
  public String orderConditionGet(HttpSession session, int conditionDate, Model model,
      @RequestParam(name="pag", defaultValue="1", required=false) int pag,
      @RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize) {
    String mid = (String) session.getAttribute("sMid");
    String strConditionDate = conditionDate + "";
    PageVO pageVo = pageProcess.totRecCnt(pag, pageSize, "dbShopMyOrderCondition", mid, strConditionDate);

    List<DbBaesongVO> vos = dbShopService.getOrderCondition(mid, conditionDate, pageVo.getStartIndexNo(), pageSize);
    
		model.addAttribute("vos", vos);
		model.addAttribute("pageVo", pageVo);
    model.addAttribute("conditionDate", conditionDate);

    // 아래는 1일/일주일/보름/한달/3달/전체 조회시에 startJumun과 endJumun을 넘겨주는 부분(view에서 시작날짜와 끝날짜를 지정해서 출력시켜주기위해 startJumun과 endJumun값을 구해서 넘겨준다.)
    Calendar startDateJumun = Calendar.getInstance();
    Calendar endDateJumun = Calendar.getInstance();
    startDateJumun.setTime(new Date());  // 오늘날짜로 셋팅
    endDateJumun.setTime(new Date());    // 오늘날짜로 셋팅
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String startJumun = "";
    String endJumun = "";
    switch (conditionDate) {
      case 1:
        startJumun = sdf.format(startDateJumun.getTime());
        endJumun = sdf.format(endDateJumun.getTime());
        break;
      case 7:
        startDateJumun.add(Calendar.DATE, -7);
        break;
      case 15:
        startDateJumun.add(Calendar.DATE, -15);
        break;
      case 30:
        startDateJumun.add(Calendar.MONTH, -1);
        break;
      case 90:
        startDateJumun.add(Calendar.MONTH, -3);
        break;
      case 99999:
        startDateJumun.set(2022, 00, 01);
        break;
      default:
        startJumun = null;
        endJumun = null;
    }
    if(conditionDate != 1 && endJumun != null) {
      startJumun = sdf.format(startDateJumun.getTime());
      endJumun = sdf.format(endDateJumun.getTime());
    }

    model.addAttribute("startJumun", startJumun);
    model.addAttribute("endJumun", endJumun);

    return "dbShop/dbMyOrder";
  }
	
	// 날짜별 상태별 기존제품 구매한 주문내역 확인하기
	@RequestMapping(value="/myOrderStatus", method=RequestMethod.GET)
	public String myOrderStatusGet(
			HttpServletRequest request, 
			HttpSession session, 
			String startJumun, 
			String endJumun, 
			@RequestParam(name="pag", defaultValue="1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize,
  	  @RequestParam(name="conditionOrderStatus", defaultValue="전체", required=false) String conditionOrderStatus,
			Model model) {
		String mid = (String) session.getAttribute("sMid");
		int level = (int) session.getAttribute("sLevel");
		
		if(level == 0) mid = "전체";
		String searchString = startJumun + "@" + endJumun + "@" + conditionOrderStatus;
		PageVO pageVo = pageProcess.totRecCnt(pag, pageSize, "myOrderStatus", mid, searchString);  // 4번째인자에 '아이디/조건'(을)를 넘겨서 part를 아이디로 검색처리하게 한다.
		
		List<DbBaesongVO> vos = dbShopService.getMyOrderStatus(pageVo.getStartIndexNo(), pageSize, mid, startJumun, endJumun, conditionOrderStatus);
		model.addAttribute("vos", vos);				
		model.addAttribute("startJumun", startJumun);
		model.addAttribute("endJumun", endJumun);
		model.addAttribute("conditionOrderStatus", conditionOrderStatus);
		model.addAttribute("pageVo", pageVo);
		
		return "dbShop/dbMyOrder";
	}
	
}
