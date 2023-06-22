<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>memberPwdUpdate.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <style>
    th {
      text-align: center;
      background-color: #eee;
    }
  </style>
  <script>
    'use strict';
    
    function pwdCheck() {
    	let newPwd = $("#newPwd").val();
    	let rePwd = $("#rePwd").val();
    	
    	if(newPwd == "" || rePwd == "") {
    		alert("새 비밀번호를 입력하세요");
    		$("#newPwd").focus();
    	}
    	else if(newPwd != rePwd) {
    		alert("확인비밀번호가 일치하지 않습니다.");
    		$("#rePwd").focus();
    	}
    	else {
    		myform.submit();
    	}
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>비밀번호 찾기</h2>
  <p>아이디와 이메일주소를 입력후 메일로 임시비밀번호를 발급 받으세요</p>
  <form name="myform" method="post">
    <table class="table table-bordered">
      <tr>
        <th>새비밀번호</th>
        <td><input type="password" name="newPwd" id="newPwd" class="form-control" required /></td>
      </tr>
      <tr>
        <th>비밀번호확인</th>
        <td><input type="password" name="rePwd" id="rePwd" class="form-control" required /></td>
      </tr>
      <tr>
        <td colspan="2" class="text-center">
          <input type="button" onclick="pwdCheck()" value="비밀번호변경" class="btn btn-success" />
          <input type="reset" value="다시입력" class="btn btn-warning" />
          <input type="button" value="돌아가기" onclick="location.href='${ctp}/member/memberMain';" class="btn btn-secondary" />
        </td>
      </tr>
    </table>
    <input type="hidden" name="mid" value="${sMid}"/>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>