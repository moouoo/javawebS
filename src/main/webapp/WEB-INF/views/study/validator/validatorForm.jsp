<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>validatorForm.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <style>
    th {
      text-align: center;
      background-color: #eee;
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">User 등록하기</h2>
  <br/>
  <form method="post">
    <table class="table table-bordered">
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
        <td><input type="number" name="age" class="form-control" value="0" /></td>
      </tr>
      <tr>
        <th>주소</th>
        <td><input type="text" name="address" class="form-control" /></td>
      </tr>
      <tr>
        <td colspan="2" class="text-center">
          <input type="submit" value="등록" class="btn btn-success mr-2" /> 
          <input type="reset" value="다시등록" class="btn btn-info mr-2" /> 
          <input type="button" value="돌아가기" onclick="location.href='${ctp}/study/validator/validatorList';" class="btn btn-warning" /> 
        </td>
      </tr>
    </table>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>