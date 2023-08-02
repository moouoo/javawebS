<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>thumbnailResult.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <script>
    'use strict';
    function thumbnailDelete(thumbnailFile) {
    	let ans = confirm("현재 파일을 삭제할까요?");
    	if(!ans) return false;
    	
    	let file = thumbnailFile.substring(2);
    	
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/study/thumbnail/thumbnailDelete",
    		data : {
    			thumbnailFile : thumbnailFile,
    			file : file
    		},
    		success:function() {
  				alert("썸네일 이미지가 삭제 되었습니다.");
  				location.reload();
    		},
    		error:function() {
    			alert("전송오류!!");
    		}
    	});
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>저장된 썸네일 이미지 보기</h2>
  <hr/>
  <div class="row">
    <div class="col">서버의 파일 경로 : ${ctp}/data/thumbnail/~~~파일명</div>
    <div class="col text-right"><a href="${ctp}/study/thumbnail/thumbnailForm" class="btn btn-success">썸네일 생성창으로이동</a></div>
  </div>
  <hr/>
  <form name="myform">
    <table class="table table-hover text-center">
      <tr>
        <th>번호</th>
        <th>파일명</th>
        <th>썸네일이미지</th>
        <th>삭제:</th>
      </tr>
      <c:forEach var="file" items="${files}">
        <c:if test="${fn:substring(file,0,2) == 's_'}">
	        <tr>
	          <td>${cnt}</td>
	          <td>${fn:substring(file,2,fn:length(file))}</td>
	          <%-- <td><a href="${ctp}/data/thumbnail/${file}" target="_blank"><img src="${ctp}/data/thumbnail/${fn:substring(file,2,fn:length(file)}"/></a></td> --%>
	          <td><a href="${ctp}/data/thumbnail/${fn:substring(file,2,fn:length(file))}" target="_blank"><img src="${ctp}/data/thumbnail/${file}"/></a></td>
	          <td><input type="button" value="삭제" onclick="thumbnailDelete('${file}')" class="btn btn-danger btn-sm"/></td>
	        </tr>
	        <c:set var="cnt" value="${cnt - 1}"/>
        </c:if>
      </c:forEach>
      <tr><td colspan="4" class="m-0 p-0"></td></tr>
    </table>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>