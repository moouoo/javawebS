<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>ajaxTest3.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <script>
    'use strict';
    function nameCheck1() {
    	let name = document.getElementById("name").value;
    	if(name.trim() == "") {
    		alert("이름을 입력하세요");
    		document.getElementById("name").focus();
    		return false;
    	}
    	
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/study/ajax/ajaxTest3_1",
    		data : {name : name},
    		success:function(vo) {
    			//alert(vo);
    			let str = '<b>VO로 전송된 자료의 출력</b><hr/>';
    			if(vo != '') {
    				str += '성명 : ' + vo.name + '<br/>';
    				str += '이메일 : ' + vo.email + '<br/>';
    				str += '홈페이지 : ' + vo.homePage + '<br/>';
    				str += '성별 : ' + vo.gender + '<br/>';
    				str += '포인트 : ' + vo.point + '<br/>';
    			}
    			else {
    				str += '<font color="red"><b>찾고자 하는 자료가 없습니다.</b></font>';
    			}
    			$("#demo").html(str);
    		},
    		error : function() {
    			alert("전송오류!");
    		}
    	});
    }
    	
    function nameCheck2() {
    	let name = document.getElementById("name").value;
    	if(name.trim() == "") {
    		alert("이름을 입력하세요");
    		document.getElementById("name").focus();
    		return false;
    	}
    	
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/study/ajax/ajaxTest3_2",
    		data : {name : name},
    		success:function(vos) {
    			//alert(vo);
    			let str = '<b>VOS로 전송된 자료의 출력</b><hr/>';
    			if(vos != '') {
    				str += '<table class="table table-bordered">';
    				str += '<tr class="table-dark text-dark">';
    				str += '<th>성명</th><th>이메일</th><th>홈페이지</th><th>성별</th><th>포인트</th>';
    				str += '</tr>';
    				for(let i=0; i<vos.length; i++) {
	    				str += '<tr class="text-center">';
	    				str += '<td>'+vos[i].name+'</td>';
	    				str += '<td>'+vos[i].email+'</td>';
	    				str += '<td>'+vos[i].homePage+'</td>';
	    				str += '<td>'+vos[i].gender+'</td>';
	    				str += '<td>'+vos[i].point+'</td>';
	    				str += '</tr>';
    				}
    				str += '</table>';
    			}
    			else {
    				str += '<font color="red"><b>찾고자 하는 자료가 없습니다.</b></font>';
    			}
    			$("#demo").html(str);
    		},
    		error : function() {
    			alert("전송오류!");
    		}
    	});
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>AJax를 활용한 '회원 성명' 검색</h2>
  <form>
    <p>아이디 : 
      <input type="text" name="name" id="name" autofocus /> &nbsp;
      <input type="button" value="성명일치검색" onclick="nameCheck1()" class="btn btn-success"/> &nbsp;
      <input type="button" value="성명부분일치검색" onclick="nameCheck2()" class="btn btn-success"/> &nbsp;
      <input type="button" value="다시입력" onclick="nameCheck()" class="btn btn-secondary"/> &nbsp;
      <input type="button" value="돌아가기" onclick="location.href='${ctp}/study/ajax/ajaxForm';" class="btn btn-warning"/>
    </p>
  </form>
  <p id="demo"></p>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>