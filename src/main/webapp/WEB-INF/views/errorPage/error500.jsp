<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>error500.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>현재 시스템 사정상 서비스가 중단되었습니다.</h2>
  <div>(500에러발생시 보이는 화면)</div>
  <hr/>
    <div><img src="${ctp}/images/paris.jpg" width="200px" /></div>
  <hr/>
  <p>
    <a href="${ctp}/errorPage/errorMain" class="btn btn-success">돌아가기(error)</a>
    <a href="${ctp}/transaction/transaction" class="btn btn-success">돌아가기(transaction)</a>
  </p>
  <hr/>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>