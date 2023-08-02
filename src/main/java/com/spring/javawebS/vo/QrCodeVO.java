package com.spring.javawebS.vo;

import lombok.Data;

@Data
public class QrCodeVO {
	private String mid;
	private String name;
	private String email;
	
	private String moveUrl;
	
	private String movieName;
	private String movieDate;
	private String movieTime;
	private int movieAdult;
	private int movieChild;
	
	private String movieTemp;
	
	private String publishNow;	// 발행날짜
	private String qrCodeName;	// 생성된 QR코드 파일이름
	
}
