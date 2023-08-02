package com.spring.javawebS;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.config.http.UserDetailsServiceFactoryBean;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.javawebS.pagination.PageProcess;
import com.spring.javawebS.pagination.PageVO;
import com.spring.javawebS.service.BoardService;
import com.spring.javawebS.vo.BoardReplyVO;
import com.spring.javawebS.vo.BoardVO;
import com.spring.javawebS.vo.GoodVO;

@Controller
@RequestMapping("/board")
public class BoardController {
	
	@Autowired
	BoardService boardService;
	
	@Autowired
	PageProcess pageProcess;
	
	@RequestMapping(value = "/boardList", method = RequestMethod.GET)
	public String boardListGet(
			@RequestParam(name="pag", defaultValue = "1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue = "5", required=false) int pageSize,
			Model model) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "board", "", "");
		
		List<BoardVO> vos = boardService.getBoardList(pageVO.getStartIndexNo(), pageSize);
		
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		
		return "board/boardList";
	}
	
	@RequestMapping(value = "/boardInput", method = RequestMethod.GET)
	public String boardInputGet() {
		return "board/boardInput";
	}
	
	@RequestMapping(value = "/boardInput", method = RequestMethod.POST)
	public String boardInputPost(BoardVO vo) {
		// content에 이미지가 저장되어 있다면, 저장된 이미지만 골라서 /resources/data/board/폴더에 저장시켜준다.
		boardService.imgCheck(vo.getContent());
		
		// 이미지들의 모든 복사작업을 마치면, ckeditor폴더경로를 board폴더 경로로 변경한다.(/resources/data/ckeditor/ ===>> /resources/data/board/)
		vo.setContent(vo.getContent().replace("/data/ckeditor/", "/data/board/"));

		// content안의 내용정리가 끝나면 변경된 vo를 DB에 저장시켜준다.
		int res = boardService.setBoardInput(vo);
		
		if(res == 1) return "redirect:/message/boardInputOk";
		else return "redirect:/message/boardInputNo";
	}

	// 글내용 상세보기
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/boardContent", method = RequestMethod.GET)
	public String boardContentGet(HttpSession session,
			@RequestParam(name="idx", defaultValue = "0", required=false) int idx,
			@RequestParam(name="pag", defaultValue = "1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue = "5", required=false) int pageSize,
			Model model) {
		// 글 조회수 1씩 증가시키기(조회수 중복방지 - 세션처리('board+고유번호'를 객체배열에 추가시켜준다.)
		ArrayList<String> contentIdx = (ArrayList) session.getAttribute("sContentIdx");
		if(contentIdx == null) {
			contentIdx = new ArrayList<String>();
		}
		String imsiContentIdx = "board" + idx;
		if(!contentIdx.contains(imsiContentIdx)) {
			boardService.setBoardReadNum(idx);	// 조회수 1증가하기
			contentIdx.add(imsiContentIdx);
		}
		session.setAttribute("sContentIdx", contentIdx);
		
		BoardVO vo = boardService.getBoardContent(idx);
		
		// 이전글/다음글 가져오기
		ArrayList<BoardVO> pnVos = boardService.getPrevNext(idx);
		model.addAttribute("pnVos", pnVos);
		model.addAttribute("vo", vo);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		
		
		// 해당글에 '좋아요' 버튼을 클릭하였었다면 '좋아요세션'에 아이디를 저장시켜두었기에 찾아서 있다면 sSw값을 1로 보내어 하트색을 빨강색으로 변경유지하게한다.(세션이 끈기면 다시 초기화 된다.)
		ArrayList<String> goodIdx = (ArrayList) session.getAttribute("sGoodIdx");
		if(goodIdx == null) {
			goodIdx = new ArrayList<String>();
		}
		String imsiGoodIdx = "boardGood" + idx;
		if(goodIdx.contains(imsiGoodIdx)) {
			session.setAttribute("sSw", "1");		// 로그인 사용자가 이미 좋아요를 클릭한 게시글이라면 빨강색으로 표시가히위해 sSW에 1을 전송하고 있다.
		}
		else {
			session.setAttribute("sSw", "0");
		}
		
		
		// DB에서 현재 게시글에 '좋아요'가 체크되어있는지를 알아오자.
		String mid = (String) session.getAttribute("sMid");
		GoodVO goodVo = boardService.getBoardGoodCheck(idx, "board", mid);
		model.addAttribute("goodVo", goodVo);
		
		// 댓글 가져오기(replyVOS) : 출력할때 1차정렬이 groupId오름차순, 2차정렬이 idx 오름차순
		List<BoardReplyVO> replyVOS = boardService.setBoardReply(idx);
		model.addAttribute("replyVOS", replyVOS);
		
		return "board/boardContent";
	}
	
	
	// 좋아요수 증가처리하기
	// 좋아요 버튼을 클릭했을때 처리(처음으로 '좋아요'누르면 1을, 이미 '좋아요'가 한번이라도 눌렸었다면 '0'을 돌려준다.
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@ResponseBody
	@RequestMapping(value = "/boardGoodCheckAjax", method = RequestMethod.POST)
	public String boardGoodCheckAjaxPost(HttpSession session, int idx) {
		String res = "0"; // 처음 0으로 셋팅하고, 처음 좋아요 버튼을 누르면 '1'을 돌려준다., 이미 '좋아요'를 한번 눌렀으면 '0'으로 res값을 보내준다.
		ArrayList<String> goodIdx = (ArrayList) session.getAttribute("sGoodIdx");
		if(goodIdx == null) {
			goodIdx = new ArrayList<String>();
		}
		String imsiGoodIdx = "boardGood" + idx;
		if(!goodIdx.contains(imsiGoodIdx)) {
			boardService.setBoardGoodPlus(idx);
			goodIdx.add(imsiGoodIdx);
			res = "1";	// 처음으로 좋아요 버튼을 클릭하였기에 '1'을 반환
		}
		session.setAttribute("sGoodIdx", goodIdx);
		
		return res;	// '좋아요'를 이미 눌렸을때 이곳으로 들어오면 처음설정값인 res는 '0'을 반환, 처음 눌렀으면 '1'을 반환~~
	}
	
	// 좋아요수 Plus버튼누르면 1증가처리..Minus버튼누르면 1감소 
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@ResponseBody
	@RequestMapping(value = "/boardGoodPlusMinus", method = RequestMethod.POST)
	public String boardGoodPlusMinusPost(HttpSession session, int idx, int goodCnt) {
		String res = "0";
		// 좋아요수 단 한번씩만 1회 증가/감소시키기.(중복방지처리 - 세션 사용 : 'good+(고유번호*goodCnt)'를 객체배열에 추가시킨다.)
		ArrayList<String> goodIdx = (ArrayList) session.getAttribute("sGoodIdx");
		if(goodIdx == null) {
			goodIdx = new ArrayList<String>();
		}
		String imsiGoodIdx = "good" + (idx*goodCnt);
		if(!goodIdx.contains(imsiGoodIdx)) {
			boardService.setGoodPlusMinus(idx, goodCnt);	// 좋아요수 증가/감소
			goodIdx.add(imsiGoodIdx);
		}
		else {
			res = "1";
		}
		session.setAttribute("sGoodIdx", goodIdx);
		return res;
	}
	
	//좋아요수 증가처리하기
	/*
	@ResponseBody
	@RequestMapping(value = "/boardGoodDBCheck", method = RequestMethod.POST)
	public void boardGoodFlagCheckPost(HttpSession session, int idx, int sSw) {
		sSw = sSw * (-1);
		boardService.boardGoodFlagCheck(idx, sSw);
		session.setAttribute("sGFlag", sSw);
	}
	*/
	
	// 좋아요~ 토글 처리(DB를 활용한 예제)
	@ResponseBody
	@RequestMapping(value = "/boardGoodDBCheck", method=RequestMethod.POST)
	public void boardGoodDBCheckPost(GoodVO goodVo) {
		// 처음 '좋아요'클릭시는 무조건 레코드를 생성, 그렇지 않으면, 즉 기존에 '좋아요'레코드가 있었다면 '해당레코드를 삭제' 처리한다.
		if(goodVo.getIdx() == 0) {
			boardService.setGoodDBInput(goodVo);
			boardService.setGoodUpdate(goodVo.getPartIdx(), 1);
		}
		else {
			boardService.setGoodDBDelete(goodVo.getIdx());
			boardService.setGoodUpdate(goodVo.getPartIdx(), -1);
		}
	}
	
	
	// 게시글 검색처리
	@RequestMapping(value = "/boardSearch", method = RequestMethod.GET)
	public String boardSearchGet(String search, String searchString,
			@RequestParam(name="pag", defaultValue = "1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue = "5", required=false) int pageSize,
			Model model) {		// search = search+"/"+searchString
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "board", search, searchString);
		
		List<BoardVO> vos = boardService.getBoardListSearch(pageVO.getStartIndexNo(), pageSize, search, searchString);
		
		String searchTitle = "";
		if(pageVO.getSearch().equals("title")) searchTitle = "글제목";
		else if(pageVO.getSearch().equals("name")) searchTitle = "글쓴이";
		else searchTitle = "글내용";
		
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("searchTitle", searchTitle);
		// model.addAttribute("searchCount", vos.size());
		
		return "board/boardSearch";
		
	}
	
	// 게시글 삭제하기
	@RequestMapping(value = "/boardDelete", method = RequestMethod.GET)
	public String boardDeleteGet(HttpSession session, HttpServletRequest request,
			@RequestParam(name="idx", defaultValue = "0", required=false) int idx,
			@RequestParam(name="pag", defaultValue = "1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue = "5", required=false) int pageSize,
			@RequestParam(name="nickName", defaultValue = "", required=false) String nickName
			) {
		// String sNickName = (String) session.getAttribute("sNickName");
		// if(!sNickName.equals(nickName)) return "redirect:/";
		
		// 게시글에 사진이 존재한다면 서버에 있는 사진파일을 먼저 삭제처리한다.
		BoardVO vo = boardService.getBoardContent(idx);
		if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgDelete(vo.getContent());
		
		// DB에서 실제로 존재하는 게시글을 삭제처리한다.
		int res = boardService.setBoardDelete(idx);
		
		if(res == 1) return "redirect:/message/boardDeleteOk";
		else return "redirect:/message/boardDeleteNo?idx="+idx+"&pag="+pag+"&pageSize="+pageSize;
	}
	
	// 게시글 수정하기 폼 호출
	@RequestMapping(value = "/boardUpdate", method = RequestMethod.GET)
	public String boardUpdateGet(Model model,
			@RequestParam(name="idx", defaultValue = "0", required=false) int idx,
			@RequestParam(name="pag", defaultValue = "1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue = "5", required=false) int pageSize
		) {
		// 수정창으로 이동시에는 먼저 원본파일에 그림파일이 있다면, 현재폴더(board)의 그림파일들을 ckeditor폴더로 복사시켜둔다.
		BoardVO vo = boardService.getBoardContent(idx);
		if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgCheckUpdate(vo.getContent());
		
		model.addAttribute("vo", vo);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		
		return "board/boardUpdate";
	}
	
	// 게시글에 변경된 내용을 수정처리하기(그림포함)
	@RequestMapping(value = "/boardUpdate", method = RequestMethod.POST)
	public String boardUpdatePost(BoardVO vo,
			@RequestParam(name="pag", defaultValue = "1", required=false) int pag,
			@RequestParam(name="pageSize", defaultValue = "5", required=false) int pageSize,
			Model model) {
		// 수정된 자료가 원본자료와 완전히 동일하다면 수정할 필요가 없기에, 먼저 DB에 저장된 원본자료를 불러와서 비교처리한다.
		BoardVO origVO = boardService.getBoardContent(vo.getIdx());
		
		// content의 내용이 조금이라도 변경된것이 있다면 내용을 수정처리한다.
		if(!origVO.getContent().equals(vo.getContent())) {
			// 실제로 수정하기 버튼을 클릭하게되면, 기존의 board폴더에 저장된, 현재 content의 그림파일 모두를 삭제 시킨다.
			if(origVO.getContent().indexOf("src=\"/") != -1) boardService.imgDelete(origVO.getContent());
			
			// board폴더에는 이미 그림파일이 삭제되어 있으므로(ckeditor폴더로 복사해놓았음), vo.getContent()에 있는 그림파일경로 'board'를 'ckeditor'경로로 변경해줘야한다.
			vo.setContent(vo.getContent().replace("/data/board/", "/data/ckeditor/"));
			
			// 앞의 작업이 끝나면 파일을 처음 업로드한것과 같은 작업을 처리시켜준다.
			// content에 이미지가 저장되어 있다면, 저장된 이미지만 골라서 /resources/data/board/폴더에 저장시켜준다.
			boardService.imgCheck(vo.getContent());
			
			// 이미지들의 모든 복사작업을 마치면, ckeditor폴더경로를 board폴더 경로로 변경한다.(/resources/data/ckeditor/ ===>> /resources/data/board/)
			vo.setContent(vo.getContent().replace("/data/ckeditor/", "/data/board/"));
		}
		
		// content의 내용과 그림파일까지, 잘 정비된 vo를 DB에 Update시켜준다.
		int res = boardService.setBoardUpdate(vo);
		
		model.addAttribute("idx", vo.getIdx());
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		
		if(res == 1) {
			return "redirect:/message/boardUpdateOk";
		}
		else {
			return "redirect:/message/boardUpdateNo";
		}
	}
	
	// 댓글 달기...
	@ResponseBody
	@RequestMapping(value = "/boardReplyInput", method = RequestMethod.POST)
	public String boardReplyInputPost(BoardReplyVO replyVO) {
		// 원본글의 댓글처리
		String strGroupId = boardService.getMaxGroupId(replyVO.getBoardIdx());
		if(strGroupId != null) replyVO.setGroupId(Integer.parseInt(strGroupId)+1);
		else replyVO.setGroupId(0);
		replyVO.setLevel(0);
		
		boardService.setBoardReplyInput(replyVO);
		
		return "1";
	}
	
	// 댓글(대댓글) 저장하기
	@ResponseBody
	@RequestMapping(value = "/boardReplyInput2", method = RequestMethod.POST)
	public String boardReplyInput2Post(BoardReplyVO replyVO) {
		replyVO.setLevel(replyVO.getLevel()+1);
		boardService.setBoardReplyInput(replyVO);
		
		return "";
	}
	
	// 댓글 삭제하기
	@ResponseBody
	@RequestMapping(value = "/boardReplyDelete", method = RequestMethod.POST)
	public String boardReplyDeletePost(
			@RequestParam(name="replyIdx", defaultValue = "0", required=false) int replyIdx,
			@RequestParam(name="level", defaultValue = "0", required=false) int level) {
		BoardReplyVO replyVO = boardService.getBoardReplyIdx(replyIdx);
		boardService.setBoardReplyDelete(replyVO.getIdx(), replyVO.getLevel(),replyVO.getGroupId(), replyVO.getBoardIdx());
		
		return "1";
	}
	
	// 댓글 수정하기
	@ResponseBody
	@RequestMapping(value = "/boardReplyUpdate", method = RequestMethod.POST)
	public String boardReplyUpdatePost(
			@RequestParam(name="idx", defaultValue = "0", required=false) int idx,
			@RequestParam(name="content", defaultValue = "", required=false) String content,
		  @RequestParam(name="hostIp", defaultValue = "", required=false) String hostIp) {
		boardService.setBoardReplyUpdate(idx, content, hostIp);
		
		return "1";
	}
	
}
