package com.spring.javawebS.service;

import java.util.ArrayList;
import java.util.List;

import com.spring.javawebS.vo.BoardReplyVO;
import com.spring.javawebS.vo.BoardVO;
import com.spring.javawebS.vo.GoodVO;

public interface BoardService {

	public List<BoardVO> getBoardList(int startIndexNo, int pageSize);

	public int setBoardInput(BoardVO vo);

	public void imgCheck(String content);

	public BoardVO getBoardContent(int idx);

	public void setBoardReadNum(int idx);

	public ArrayList<BoardVO> getPrevNext(int idx);

	public void boardGoodFlagCheck(int idx, int gFlag);

	public List<BoardVO> getBoardListSearch(int startIndexNo, int pageSize, String search, String searchString);

	public void imgDelete(String content);

	public int setBoardDelete(int idx);

	public void imgCheckUpdate(String content);

	public int setBoardUpdate(BoardVO vo);

	public void setBoardGoodPlus(int idx);

	public void setGoodPlusMinus(int idx, int goodCnt);

	public void setGoodDBInput(GoodVO goodVo);

	public void setGoodUpdate(int idx, int item);

	public void setGoodDBDelete(int idx);

	public GoodVO getBoardGoodCheck(int partIdx, String part, String mid);

	public String getMaxGroupId(int boardIdx);

	public void setBoardReplyInput(BoardReplyVO replyVO);

	public List<BoardReplyVO> setBoardReply(int idx);

	public void setBoardReplyDelete(int replyIdx, int level, int groupId, int boardIdx);

	public BoardReplyVO getBoardReplyIdx(int replyIdx);

	public void setBoardReplyUpdate(int idx, String content, String hostIp);

}
