<%@ page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>qrCodeEx3.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <script>
    'use strict';
    
    function qrCheck() {
    	let movieTemp;
    	let movieName = $("#movieName").val();
    	let movieDate = $("#movieDate").val();
    	let movieTime = $("#movieTime").val();
    	let movieAdult = $("#movieAdult").val();
    	let movieChild = $("#movieChild").val();
    	let mid = $("#mid").val();
    	
    	if(movieName.trim() == "" || movieDate.trim() == "" || movieTime.trim() == "") {
    		alert("영화명과 상영일자와 상영시간을 확인하세요");
    		return false;
    	}
    	// qr코드내역? 영화제목_상영날짜_상영시간_성인티켓수_어린이티켓수_아이디
    	movieTemp  = movieName + "_";
    	movieTemp += movieDate + "_";
    	movieTemp += movieTime + "_A";
    	movieTemp += movieAdult + "_C";
    	movieTemp += movieChild;
    			
    	let query = {
    			movieTemp : movieTemp
    	}
    	
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/study/qrCode/qrCodeEx3",
    		data : query,
    		success:function(res) {
    			alert("qr코드가 생성되었습니다.\n이름은? " + res);
    			let qrCode = 'QR Code명 : ' + res + '<br/>';
    			qrCode += '<img src="${ctp}/data/qrCode/'+res+'.png" />';
    			$("#demo").html(qrCode);
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
  <h2>영화 티켓 예매하기</h2>
  <p>(생성된 QR코드를 메일로 보내드립니다. QR코드를 입장시 매표소에 제시해 주세요.)</p>
  <hr/>
	<form method="post">
	  티켓 예매하기 :
	  <table class="table table-bordered">
	    <tr>
	      <th>영화명선택</th>
	      <td>
	        <select name="movieName" id="movieName" class="form-control" required>
	          <option value="">영화선택</option>
	          <option>인어공주</option>
	          <option>범죄도시3</option>
	          <option>엘리멘탈</option>
	          <option>스파이더맨</option>
	          <option>귀공자</option>
	          <option>인디아나존스</option>
	        </select>
	      </td>
	    </tr>
	    <tr>
	      <th>상영일자선택</th>
	      <td><input type="date" name="movieDate" id="movieDate" value="<%=LocalDate.now() %>" class="form-control"/></td>
	    </tr>
	    <tr>
	      <th>상영시간선택</th>
	      <td>
	        <select name="movieTime" id="movieTime" class="form-control" required>
	          <option value="">상영시간선택</option>
	          <option>12시00분</option>
	          <option>14시30분</option>
	          <option>17시00분</option>
	          <option>19시30분</option>
	          <option>22시00분</option>
	        </select>
	      </td>
	    </tr>
	    <tr>
	      <th>인원수</th>
	      <td>
	        성인  <input type="number" name="movieAdult" id="movieAdult" value="1" min="1" class="form-control"><br/>
	        어린이 <input type="number" name="movieChild" id="movieChild" value="0" min="0" class="form-control">
	      </td>
	    </tr>
	    <tr>
	      <td colspan="2">
	        <input type="button" value="티켓예매하기" onclick="qrCheck()" class="btn btn-success mr-2"/>
	        <input type="reset" value="다시예매하기" class="btn btn-warning mr-2"/>
	        <input type="button" value="돌아가기" onclick="location.href='${ctp}/study/qrCode/qrCodeForm';"  class="btn btn-danger"/>
	      </td>
	    </tr>
	  </table>
	  <input type="hidden" name="mid" value="${sMid}"/>
	</form>
  <hr/>
    생성된 QR 코드 :<br/>
    <div id="demo"></div>
  <hr/>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>