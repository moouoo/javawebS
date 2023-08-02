<!-- kakaoMenu.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<div>
  <p>
    <a href="${ctp}/study/kakaomap/kakaoEx1" class="btn btn-success">마커표시/저장</a>
    <a href="${ctp}/study/kakaomap/kakaoEx2" class="btn btn-primary">MyDB에저장된 지명검색</a>
    <a href="${ctp}/study/kakaomap/kakaoEx3" class="btn btn-warning">KakaoDB에저장된 키워드검색</a>
    <a href="${ctp}/study/kakaomap/kakaoEx4" class="btn btn-info">주변검색</a>
  </p>
</div>