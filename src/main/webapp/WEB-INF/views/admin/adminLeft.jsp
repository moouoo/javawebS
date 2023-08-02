<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>adminLeft.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<body style="background-color:#efa; font-size:0.8em;">
<p><br/></p>
<div class="text-center card-hover" id="accordion">
  <h5>관리자메뉴</h5>
  <hr/>
  <p><a href="${ctp}/" target="_top">홈으로</a></p>
  <hr/>
  <p><a href="${ctp}/GuestList.gu" target="adminContent">방명록리스트</a></p>
  <hr/>
  <p><a href="${ctp}/BoardList.bo" target="adminContent">게시판리스트</a></p>
  <hr/>
  <p><a href="${ctp}/AdminMemberList.ad" target="adminContent">회원리스트</a></p>
  <hr/>
  <div class="card">
    <div class="card-header bg-warning m-0 p-2">
      <a class="card-link" data-toggle="collapse" href="#collapseOne">
        예약관리
      </a>
    </div>
    <div id="collapseOne" class="collapse" data-parent="#accordion">	<!-- 처음부터 메뉴 보이게 하려면?  class="collapse show" -->
      <div class="card-body m-2 p-1">
        <a href="${ctp}/AdminReservationList.res" target="adminContent">예약관리리스트</a>
      </div>
      <div class="card-body m-2 p-1">
        <a href="${ctp}/AdminReservationProcessList.res" target="adminContent">예약현황리스트</a>
      </div>
    </div>
  </div>
  <hr/>
  <div class="card">
    <div class="card-header bg-warning m-0 p-2">
      <a class="card-link" data-toggle="collapse" href="#collapseTwo">
        상품관리
      </a>
    </div>
    <div id="collapseTwo" class="collapse" data-parent="#accordion">	<!-- 처음부터 메뉴 보이게 하려면?  class="collapse show" -->
      <div class="card-body m-2 p-1">
        <a href="${ctp}/dbShop/dbCategory" target="adminContent">상품분류등록</a>
      </div>
      <div class="card-body m-2 p-1">
        <a href="${ctp}/dbShop/dbProduct" target="adminContent">상품등록관리</a>
      </div>
      <div class="card-body m-2 p-1">
        <a href="${ctp}/dbShop/dbShopList" target="adminContent">상품등록조회</a>
      </div>
      <div class="card-body m-2 p-1">
        <a href="${ctp}/dbShop/dbOption" target="adminContent">옵션등록관리</a>
      </div>
    </div>
  </div>
  <hr/>
</div>
<p><br/></p>
</body>
</html>