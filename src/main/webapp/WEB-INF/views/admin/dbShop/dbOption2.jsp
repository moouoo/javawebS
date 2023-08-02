<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>dbOption2.jsp(상품의 옵션 등록)</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
  <style>
    .product1, .product2 {
      float: left;
    }
    .product3 {
      clear: both;
    }
  </style>
  <script>
  	'use strict';
    let cnt = 1;
    
    // 옵션항목 추가
    function addOption() {
    	let strOption = "";
    	let test = "t" + cnt; 
    	
    	strOption += '<div id="'+test+'"><hr size="5px"/>';
    	strOption += '<font size="4"><b>상품옵션등록</b></font>&nbsp;&nbsp;';
    	strOption += '<input type="button" value="옵션삭제" class="btn btn-outline-danger btn-sm" onclick="removeOption('+test+')"/><br/>'
    	strOption += '상품옵션이름';
    	strOption += '<input type="text" name="optionName" id="optionName'+cnt+'" class="form-control"/>';
    	strOption += '<div class="form-group">';
    	strOption += '상품옵션가격';
    	strOption += '<input type="text" name="optionPrice" id="optionPrice'+cnt+'" class="form-control"/>';
    	strOption += '</div>';
    	strOption += '</div>';
    	$("#optionType").append(strOption);
    	cnt++;
    }
    
    // 옵션항목 삭제
    function removeOption(test) {
    	/* $("#"+test).remove(); */
    	$("#"+test.id).remove();
    }
    
    // 옵션 입력후 등록전송
    function fCheck() {
    	for(let i=1; i<=cnt; i++) {
    		if($("#t"+i).length != 0 && document.getElementById("optionName"+i).value=="") {
    			alert("빈칸 없이 상품 옵션명을 모두 등록하셔야 합니다");
    			return false;
    		}
    		else if($("#t"+i).length != 0 && document.getElementById("optionPrice"+i).value=="") {
    			alert("빈칸 없이 상품 옵션가격을 모두 등록하셔야 합니다");
    			return false;
    		}
    	}
    	if(document.getElementById("optionName").value=="") {
    		alert("상품 옵션이름을 등록하세요");
    		return false;
    	}
    	else if(document.getElementById("optionPrice").value=="") {
    		alert("상품 옵션가격을 등록하세요");
    		return false;
    	}
    	myform.flag.value = "option2";
    	myform.submit();
    }
    
    
    // 옵션항목 삭제하기
    function optionDelete(idx) {
    	let ans = confirm("현재 선택한 옵션을 삭제하시겠습니까?");
    	if(!ans) return false;
    	
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/dbShop/optionDelete",
    		data : {idx : idx},
    		success:function() {
    			alert("삭제되었습니다.");
    			location.reload();
    		},
    		error : function() {
    			alert("전송오류!");
    		}
    	});
    }
    
    // 콤마찍기
    function numberWithCommas(x) {
		  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
  </script>
</head>
<body>
<p><br/></p>
<div class="container">
  <h2>상품에 따른 옵션 등록</h2>
  <hr/>
  <form name="myform" method="post" action="${ctp}/dbShop/dbOption">
    <div class="product1">
      <p>-대분류명 : ${vo.categoryMainName}</p>
      <p>-중분류명 : ${vo.categoryMiddleName}</p>
      <p>-소분류명 : ${vo.categorySubName}</p>
      <p>-상품명(모델명) : ${vo.productName}</p>
      <p>
        -등록된 옵션리스트(옵션항목 클릭후 삭제) :<br/> &nbsp; &nbsp;
        <c:forEach var="i" begin="1" end="${fn:length(optionVOS)}">
          <a href="javascript:optionDelete(${optionVOS[i-1].idx})">${optionVOS[i-1].optionName}</a> <c:if test="${fn:length(optionVOS) != (i)}">/</c:if>
        </c:forEach>
        <c:if test="${fn:length(optionVOS) == 0}">등록된 옵션이 없습니다.</c:if>
      </p>
      <p><a href="${ctp}/dbShop/dbShopContent?idx=${vo.idx}" class="btn btn-success">돌아가기</a></p>
    </div>
    <div class="product2">
      <p><img src="${ctp}/dbShop/product/${vo.FSName}" width="80%"/></p>
    </div>
    <div class="product3">
	    <hr/>
	    <font size="4"><b>상품옵션등록</b></font>&nbsp;&nbsp;
	    <input type="button" value="옵션박스추가하기" onclick="addOption()" class="btn btn-secondary btn-sm"/><br/>
	    <div class="form-group">
	      <label for="optionName">상품옵션이름</label>
	      <input type="text" name="optionName" id="optionName" class="form-control"/>
	    </div>
	    <div class="form-group">
	      <label for="optionPrice">상품옵션가격</label>
	      <input type="text" name="optionPrice" id="ozxcptionPrice" class="form-control"/>
	    </div>
	    <div id="optionType"></div>
	    <hr/>
	    <div class='text-right'><input type="button" value="옵션등록" onclick="fCheck()" class="btn btn-primary"/></div>
    </div>
    <input type="hidden" name="productIdx" value="${vo.idx}">
    <input type="hidden" name="productName" value="${vo.productName}">
    <input type="hidden" name="flag" value="option2">
  </form>
</div>
<p><br/></p>
</body>
</html>