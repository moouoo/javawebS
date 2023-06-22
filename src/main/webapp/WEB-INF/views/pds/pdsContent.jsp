<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>pdsContent.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <script>
    'use strict';
    
    // 화면처음으로 부드럽게 이동시키기
		$(window).scroll(function(){
			if($(this).scrollTop() > 100 ){
	      $("#topBtn").addClass("on");
	    }
	    else{
	      $("#topBtn").removeClass("on");
	    }
			
			$("#topBtn").click(function() {
			  window.scrollTo({ top: 0, behavior: "smooth" });  //페이지에서 특정 위치로 스크롤 이동시키기 위해서는 window.scrollTo 메서드를 사용
			});
		});
		
    // 다운로드 회수 증가
    function downNumCheck(idx) {
    	$.ajax({
    		type  : "post",
    		url   : "${ctp}/pds/pdsDownNumCheck",
    		data  : {idx : idx},
    		success:function() {
    			location.reload();
    		},
    		error : function() {
    			alert("전송오류!!");
    		}
    	});
    }
  </script>
  <style>
    th {
      background-color: #eee;
    }
    
		h6 {
		  position: fixed;
		  right: 1rem;
		  bottom: -50px;
		  opacity: 0;
		  transition: 0.7s ease;
		}
		.on {
		  opacity: 0.8;
		  cursor: pointer;
		  bottom: 0;
		}
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">개별 자료 상세 내역</h2>
  <br/>
  <table class="table table-bordered text-center">
    <tr>
      <th>올린이</th>
      <td>${vo.nickName}</td>
      <th>올린날짜</th>
      <td>${fn:substring(vo.FDate,0,fn:length(vo.FDate)-2)}</td>
    </tr>
    <tr>
      <th>파일명</th>
      <td>
        <c:set var="fNames" value="${fn:split(vo.FName,'/')}"/>
        <c:set var="fSNames" value="${fn:split(vo.FSName,'/')}"/>
        <c:forEach var="fName" items="${fNames}" varStatus="st">
          <a href="${ctp}/pds/${fSNames[st.index]}" download="${fName}" onclick="downNumCheck(${vo.idx})">${fName}</a><br/>
        </c:forEach>
      </td>
      <th>다운횟수</th>
      <td>${vo.downNum}</td>
    </tr>
    <tr>
      <th>분류</th>
      <td>${vo.part}</td>
      <th>파일크기</th>
      <td><fmt:formatNumber value="${vo.FSize / 1024}" pattern="#,##0"/>KByte</td>
    </tr>
    <tr>
      <th>제목</th>
      <td colspan="3" class="text-left">${vo.title}</td>
    </tr>
    <tr>
      <th>상세내역</th>
      <td colspan="3" style="height:280px;" class="text-left">${fn:replace(vo.content, newLine, '<br/>')}</td>
    </tr>
  </table>
  <div class="text-center">
    <input type="button" value="돌아가기" onclick="location.href='${ctp}/pds/pdsList?pag=${pag}&part=${part}';" class="btn btn-secondary"/>
  </div>
  <hr/>
  <div class="text-center">
	  <c:set var="fSNames" value="${fn:split(vo.FSName,'/')}"/>
	  <c:forEach var="fSName" items="${fSNames}" varStatus="st">
	    ${st.count}. ${fSName}<br/>
	    <c:set var="fSNameLen" value="${fn:length(fSName)}"/>
	  	<c:set var="ext" value="${fn:substring(fSName,fSNameLen-3,fSNameLen)}"/>
	  	<c:set var="extUpper" value="${fn:toUpperCase(ext)}"/>
	  	<c:if test="${extUpper=='JPG' || extUpper=='GIF' || extUpper=='PNG'}">
	  		<img src="${ctp}/pds/${fSName}" width="85%"/>
	  	</c:if>
	  	<hr/>
	  </c:forEach>
  </div>
</div>
<h6 id="topBtn" class=""><img src="${ctp}/images/arrowTop.gif"/></h6>
<!-- <h6 id="topBtn" class="">맨위로</h6> -->
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>