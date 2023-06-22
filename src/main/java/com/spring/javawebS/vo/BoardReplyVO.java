package com.spring.javawebS.vo;

import lombok.Data;

@Data
public class BoardReplyVO {
	private int idx;
	private int boardIdx;
	private String mid;
	private String nickName;
	private String WDate;
	private String hostIp;
	private String content;
	private int groupId;
	private int level;
}
