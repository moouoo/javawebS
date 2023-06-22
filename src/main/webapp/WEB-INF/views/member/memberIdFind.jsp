<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>memberIdFind.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<script>
	'sue strict';
	
	function idCheck(){
		let email = $("#email").val();
		
		if(email == ""){
			alert("이메일을 입력해주세요!");
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
<p><br></p>
<div class="container">
	<h2>아이디 찾기</h2>
	<form method="post" name="myform">
		<div>
			이메일 : <input type="email" name="email" id="email" autofocus required class="form-comtrol" />
		</div>
		<div>
			<input type="button" value="아이디찾기" onclick="idCheck()" class="form-control" />
		</div>
	</form>
</div>
<p><br></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>