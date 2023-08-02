<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>errorMsg1.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>에러 발생시 호출되는 페이지입니다.</h2>
  <hr/>
  <h2>현재 시스템 정비중입니다.(errorMsg1.jsp)</h2>
  <p>사용에 불편을 드려서 죄송합니다.</p>
  <div>빠른시일내에 복구하도록 하겠습니다.</div>
  <hr/>
    <div><img src="${ctp}/images/newyork.jpg" width="200px" /></div>
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