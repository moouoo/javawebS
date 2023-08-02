<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>merchant.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center"> 결 제 연 습</h2>
  <hr/>
  <form name="myform" method="post">
	  <table class="table table-bordered">
	    <tr>
	      <th>구매 금액</th>
	      <td><input type="number" name="amount" value="10" class="form-control"/></td>
	    </tr>
	    <tr>
	      <th>구매 물품명</th>
	      <td><input type="text" name="name" value="냉장고 300L" class="form-control"/></td>
	    </tr>
	    <tr>
	      <th>이메일</th>
	      <td><input type="text" name="buyer_email" value="cjsk1126@naver.com" class="form-control"/></td>
	    </tr>
	    <tr>
	      <th>주문자</th>
	      <td><input type="text" name="buyer_name" value="홍길동" class="form-control"/></td>
	    </tr>
	    <tr>
	      <th>연락처</th>
	      <td><input type="text" name="buyer_tel" value="010-3423-2704" class="form-control"/></td>
	    </tr>
	    <tr>
	      <th>주소</th>
	      <td><input type="text" name="buyer_addr" value="충북 청주시 서원구 사직대로 109" class="form-control"/></td>
	    </tr>
	    <tr>
	      <th>우편번호</th>
	      <td><input type="text" name="buyer_postcode" value="300-010" class="form-control"/></td>
	    </tr>
	    <tr>
	      <td colspan="2" class="text-center">
	        <input type="submit" value="결제하기" class="btn btn-success"/> &nbsp;
	        <input type="reset" value="다시입력" class="btn btn-warning"/> &nbsp;
	        <input type="button" value="주문취소" onclick="location.href='${ctp}/';" class="btn btn-secondary"/>
	      </td>
	    </tr>
	  </table>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>