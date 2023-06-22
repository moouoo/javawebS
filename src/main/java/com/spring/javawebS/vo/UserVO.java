package com.spring.javawebS.vo;

import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.NotEmpty;
import org.hibernate.validator.constraints.Range;

import lombok.Data;

@SuppressWarnings("deprecation")
@Data
public class UserVO {
	private int idx;
	
	@NotEmpty(message = "아이디가 공백입니다./midEmpty")
	@Size(min=3, max=20, message = "아이디 길이가 잘못되었습니다./midSizeNo")
	private String mid;
	
	@NotEmpty(message = "성명이 공백입니다./nameEmpty")
	@Size(min=2, max=20, message = "성명 길이가 잘못되었습니다./nameSizeNo")
	private String name;
	
	@Range(min=18, max=99, message = "나이 범위를 벗어납니다./ageRangeNo")
	private int age;
	private String address;
}
