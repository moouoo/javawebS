<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>qrCodeEx2.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <script>
    'use strict';
    
    function qrCheck() {
    	let moveUrl = $("#moveUrl").val();
    	
    	if(moveUrl.trim() == "") {
    		alert("이동할 URL을 확인하세요");
    		$("#moveUrl").focus();
    		return false;
    	}
    	let query = {
    			moveUrl : moveUrl
    	}
    	
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/study/qrCode/qrCodeEx2",
    		data : query,
    		success:function(res) {
    			alert("qr코드가 생성되었습니다.\n이름은? " + res);
    			let qrCode = 'QR Code명 : ' + res + '<br/>';
    			qrCode += '<img src="${ctp}/data/qrCode/'+res+'.png" />';
    			$("#demo").html(qrCode);
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
  <h2>정보 사이트로 이동하기</h2>
  <p>(소개하고싶은 사이트 주소를 입력하세요)</p>
  <hr/>
	<form method="post">
	  이동할 주소 :
	  <div class="input-group">
	  	<input type="text" name="moveUrl" id="moveUrl" value="cjsk1126.tistory.com" class="form-control" />
	  	<div class="input-group-append">
	  		<input type="button" value="소개 QR코드생성" onclick="qrCheck()" class="btn btn-success"/>
	  	</div>
	  </div>
	</form>
  <hr/>
    생성된 QR 코드 :<br/>
    <div id="demo"></div>
  <hr/>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>