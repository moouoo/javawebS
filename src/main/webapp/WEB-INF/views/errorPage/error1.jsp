<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="/WEB-INF/views/errorPage/errorMsg1.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>error1.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>에러를 발생시켜주는 jsp 파일</h2>
<%
  int su = 10 / 0;
%>
  결과 : <%=su %><br/>
  <p>
    <%-- <a href="${ctp}/errorPage/errorMain" class="btn btn-success">돌아가기</a> --%>
    <a href="errorMain" class="btn btn-success">돌아가기</a>
  </p>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>