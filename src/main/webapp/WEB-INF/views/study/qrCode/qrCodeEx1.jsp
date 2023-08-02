<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>qrCodeEx1/jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <script>
    'use strict';
    
    function qrCheck() {
    	let mid = $("#mid").val();
    	let name = $("#name").val();
    	let email = $("#email").val();
    	
    	if(mid.trim() == "" || name.trim() == "" || email.trim() == "") {
    		alert("개인 정보를 확인하세요");
    		$("#mid").focus();
    		return false;
    	}
    	let query = {
    			mid : mid,
    			name : name,
    			email : email
    	}
    	
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/study/qrCode/qrCodeEx1",
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
  <h2>개인 정보를 QR코드로 생성</h2>
  <hr/>
  <form method="post">
    <b>개인 정보 입력</b><br/>
    <table class="table table-bordered">
      <tr>
        <th>아이디</th>
        <td><input type="text" name="mid" id="mid" value="${sMid}" class="form-control" /></td>
      </tr>
      <tr>
        <th>성명</th>
        <td><input type="text" name="name" id="name" value="홍길동" class="form-control" /></td>
      </tr>
      <tr>
        <th>이메일</th>
        <td><input type="text" name="email" id="email" value="cjsk1126@naver.com" class="form-control" /></td>
      </tr>
      <tr>
        <td colspan="2" class="text-center">
          <input type="button" value="QR코드 생성" onclick="qrCheck()" class="btn btn-success mr-3">
          <input type="button" value="다시입력" onclick="location.reload()" class="btn btn-warning">
        </td>
      </tr>
    </table>
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