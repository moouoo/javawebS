<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>transactionList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <script>
    'use strict';
    
    function userCheck() {
    	/* let user = myform.userSelect.value;
    	location.href = "transactionListUser"; */
    	myform.submit();
    }
  </script>
  <style>
    th {
      background-color: #eee;
      text-align: center;
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">회원 전체 리스트(${userSelect})</h2>
  <table class="table table-borderless">
    <tr>
      <td>
        <form name="myform" method="get">
	        <select name="userSelect" onchange="userCheck()" class="form-control" style="width:30%">
	          <option ${userSelect == 'user' ? 'selected' : ''}>user</option>
	          <option ${userSelect != 'user' ? 'selected' : ''}>user2</option>
	        </select>
        </form>
      </td>
      <td class="text-right">
        <a href="transaction" class="btn btn-warning">돌아가기</a>
      </td>
    </tr>
  </table>
  <table class="table table-hover text-center">
    <tr class="table-dark text-dark">
      <th>번호</th>
      <th>아이디</th>
      <c:if test="${userSelect == 'user'}">
	      <th>성명</th>
	      <th>나이</th>
	      <th>주소</th>
      </c:if>
      <c:if test="${userSelect != 'user'}">
	      <th>별명</th>
	      <th>직업</th>
      </c:if>
    </tr>
    <c:forEach var="vo" items="${vos}" varStatus="st">
      <tr>
        <td>${st.count}</td>
        <td>${vo.mid}</td>
        <c:if test="${userSelect == 'user'}">
	        <td>${vo.name}</td>
	        <td>${vo.age}</td>
	        <td>${vo.address}</td>
        </c:if>
        <c:if test="${userSelect != 'user'}">
	        <td>${vo.nickName}</td>
	        <td>${vo.job}</td>
        </c:if>
      </tr>
    </c:forEach>
    <tr><td colspan="5"></td></tr>
  </table>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>