<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>thumbnailForm.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <script>
    'use strict';
    
    function fCheck() {
    	let maxSize = 1024 * 1024 * 20;
    	let file = $("#file").val();
    	
    	if(file == "" || file == null) {
    		alert("업로드할 파일명을 선택해 주세요");
    		return false;
    	}
    	
    	let ext = file.substring(file.lastIndexOf(".")+1).toUpperCase();
    	if(ext != "JPG" && ext != "GIF" && ext != "PNG") {
    		alert("업로드 가능한 파일은 그림파일(jpg/gif/png)만 가능합니다.");
    		return false;
    	}
    	if(file.size > maxSize) {
    		alert("업로드할 파일의 용량은 최대 20MByte 입니다.");
    		return false;
    	}
    	else {
    		myform.submit();
    	}
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>썸네일 연습</h2>
  <form name="myform" method="post" enctype="multipart/form-data">
    <p>파일명 :
      <input type="file" name="file" id="file" class="form-control-file border" accept=".jpg,.gif,.png"/>
    </p>
    <p>
      <input type="button" value="썸네일만들기" onclick="fCheck()" class="btn btn-success"/> &nbsp;
      <input type="reset" value="다시선택" class="btn btn-warning"/> &nbsp;
      <input type="button" value="파일리스트로이동" onclick="location.href='${ctp}/study/thumbnail/thumbnailResult';" class="btn btn-primary"/>
    </p>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>