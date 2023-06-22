package com.spring.javawebS.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.javawebS.vo.BoardReplyVO;
import com.spring.javawebS.vo.BoardVO;
import com.spring.javawebS.vo.GoodVO;

public interface BoardDAO {

	public int totRecCnt();

	public List<BoardVO> getBoardList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public int setBoardInput(@Param("vo") BoardVO vo);

	public BoardVO getBoardContent(@Param("idx") int idx);

	public void setBoardReadNum(@Param("idx") int idx);

	public ArrayList<BoardVO> getPrevNext(@Param("idx") int idx);

	public void boardGoodFlagCheck(@Param("idx") int idx, @Param("gFlag") int gFlag);

	public int totRecCntSearch(@Param("search") String search, @Param("searchString") String searchString);

	public List<BoardVO> getBoardListSearch(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("search") String search, @Param("searchString") String searchString);

	public int setBoardDelete(@Param("idx") int idx);

	public int setBoardUpdate(@Param("vo") BoardVO vo);

	public void setBoardGoodPlus(@Param("idx") int idx);

	public void setGoodPlusMinus(@Param("idx") int idx, @Param("goodCnt") int goodCnt);

	public void setGoodDBInput(@Param("goodVo") GoodVO goodVo);

	public void setGoodUpdate(@Param("idx") int idx, @Param("item") int item);

	public void setGoodDBDelete(@Param("idx") int idx);

	public GoodVO getBoardGoodCheck(@Param("partIdx") int partIdx, @Param("part") String part, @Param("mid") String mid);

	public String getMaxGroupId(@Param("boardIdx") int boardIdx);

	public void setBoardReplyInput(@Param("replyVO") BoardReplyVO replyVO);

	public List<BoardReplyVO> setBoardReply(@Param("idx") int idx);

	public void setBoardReplyDelete(@Param("replyIdx") int replyIdx, @Param("level") int level, @Param("groupId") int groupId, @Param("boardIdx") int boardIdx);

	public BoardReplyVO getBoardReplyIdx(@Param("replyIdx") int replyIdx);

	public void setBoardReplyUpdate(@Param("idx") int idx, @Param("content") String content, @Param("hostIp") String hostIp);

}
