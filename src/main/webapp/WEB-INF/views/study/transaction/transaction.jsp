<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>transaction.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <script>
    'use strict';
    
    function fCheck1() {
    	myform.flag.value = "user";
    	myform.action = "${ctp}/study/transaction/input1";
    	myform.submit();
    }
    
    function fCheck2() {
    	myform.flag.value = "user2";
    	myform.action = "${ctp}/study/transaction/input2";
    	myform.submit();
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>트랜잭션 연습</h2>
  <pre>
    트랙잭션 : 작업의 최소단위
    하나의 프로세스처리과정중에서 두개 이상의 자료(작업)을 동시에 처리하고자 할때,
    두개이상의 작업중 하나라도 처리가 미결된 상태로 작업이 종료되게 된다면,
    이미 실행된 작업들도 동시에 초기화 되어야한다.(롤백 - Roll Back) : 원자성 
  </pre>
  <form name="myform" method="get">
    <h3>유저 등록폼</h3>
    <table class="table table-bordered text-center">
      <tr>
        <th>아이디</th>
        <td><input type="text" name="mid" class="form-control" autofocus /></td>
      </tr>
      <tr>
        <th>성명</th>
        <td><input type="text" name="name" class="form-control" /></td>
      </tr>
      <tr>
        <th>나이</th>
        <td><input type="number" name="age" class="form-control" /></td>
      </tr>
      <tr>
        <th>주소</th>
        <td><input type="text" name="address" class="form-control" /></td>
      </tr>
      <tr>
        <th>별명</th>
        <td><input type="text" name="nickName" class="form-control" /></td>
      </tr>
      <tr>
        <th>직업</th>
        <td><input type="text" name="job" class="form-control" /></td>
      </tr>
      <tr>
        <td colspan="2">
          <input type="button" value="회원가입1(개별처리)" onclick="fCheck1()" class="btn btn-success mr-2" />
          <input type="button" value="회원가입2(일괄처리)" onclick="fCheck2()" class="btn btn-info mr-2" />
          <input type="reset" value="다시입력" class="btn btn-warning mr-2" />
          <input type="button" value="회원전체보기" onclick="location.href='transactionList';" class="btn btn-primary" />
        </td>
      </tr>
    </table>
    <input type="hidden" name="flag" />
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>