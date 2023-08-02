<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>error404.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>현재 제공되지 않는 페이지 입니다. 다시 접속해 주세요</h2>
  <div>(404에러발생시 보이는 화면)</div>
  <hr/>
    <div><img src="${ctp}/images/chicago.jpg" width="200px" /></div>
  <hr/>
  <p>
    <a href="${ctp}/errorPage/errorMain" class="btn btn-success">돌아가기</a>
  </p>
  <hr/>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>