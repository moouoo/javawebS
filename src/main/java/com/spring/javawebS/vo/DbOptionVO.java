package com.spring.javawebS.vo;

import lombok.Data;

@Data
public class DbOptionVO {
	private int idx;
	private int productIdx;
	private String optionName;
	private int optionPrice;
	
	private String productName;
}
