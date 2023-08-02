<%@ page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>qrCodeEx4.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <script>
    'use strict';
    
    function qrCheck() {
    	let movieTemp;
    	let mid = $("#mid").val();
    	let name = $("#name").val();
    	let email = $("#email").val();
    	let movieName = $("#movieName").val();
    	let movieDate = $("#movieDate").val();
    	let movieTime = $("#movieTime").val();
    	let movieAdult = $("#movieAdult").val();
    	let movieChild = $("#movieChild").val();
    	
    	if(mid.trim() == "" || name.trim() == "" || email.trim() == "" || movieName.trim() == "" || movieDate.trim() == "" || movieTime.trim() == "") {
    		alert("영화명과 상영일자와 상영시간을 확인하세요");
    		return false;
    	}
    	let now = new Date();
    	let publishNow = now.getFullYear() + '-' + (now.getMonth()+1) + '-' + now.getDate();
    	alert("티켓 발행 날짜 : " + publishNow);
    	
    	// qr코드내역? 영화제목_상영날짜_상영시간_성인티켓수_어린이티켓수_아이디
    	movieTemp  = "아이디 : " + mid + ",\n";
    	movieTemp  += "성명 : " + name + ",\n";
    	movieTemp  += "이메일 : " + email + ",\n";
    	movieTemp  += "영화제목 : " + movieName + ",\n";
    	movieTemp += "상영일자 : " + movieDate + ",\n";
    	movieTemp += "상영시작시간 : " + movieTime + ",\n";
    	movieTemp += "성인 : " + movieAdult + "매,\n";
    	movieTemp += "어린이 : " + movieChild + "매,\n";
    	movieTemp += "티켓발행일자 : " + publishNow;
    			
    	let query = {
    			mid : mid,
    			name : name,
    			email : email,
    			movieName : movieName,
    			movieDate : movieDate,
    			movieTime : movieTime,
    			movieAdult: movieAdult,
    			movieChild: movieChild,
    			publishNow: publishNow,
    			movieTemp : movieTemp
    	}
    	
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/study/qrCode/qrCodeEx4",
    		data : query,
    		success:function(res) {
    			alert("qr코드가 생성되었습니다.\n이름은? " + res);
    			let qrCode = 'QR Code명 : ' + res + '<br/>';
    			qrCode += '<img src="${ctp}/data/qrCode/'+res+'.png" />';
    			$("#demo").html(qrCode);
    			$("#qrCodeView").show();
    			$("#bigo").val(res + ".png");
    		}
    	});
    }
    
    // qr코드 정보를 DB에서 검색하여 출력하기
    function bigoCheck() {
    	let qrCode = $("#bigo").val();
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/study/qrCode/qrCodeSearch",
    		data : {qrCode : qrCode},
    		success:function(vo) {
    			let str = '';
    			str += '아이디 : ' + vo.mid + '<br/>';
    			str += '성명 : ' + vo.name + '<br/>';
    			str += '이메일 : ' + vo.email + '<br/>';
    			str += '영화제목 : ' + vo.movieName + '<br/>';
    			str += '상영일자 : ' + vo.movieDate + '<br/>';
    			str += '상영시간 : ' + vo.movieTime + '<br/>';
    			str += '성인티켓수 : ' + vo.movieAdult + '<br/>';
    			str += '어린이티켓수 : ' + vo.movieChild + '<br/>';
    			str += '티켓발행날짜 : ' + vo.publishNow;
    			$("#demoBigo").html(str);
    		},
    		error:function() {
    			alert("전송오류!");
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
        <th>아이디</th>
        <td><input type="text" name="mid" id="mid" value="${sMid}" class="form-control" /></td>
      </tr>
      <tr>
        <th>성명</th>
        <td><input type="text" name="name" id="name" value="홍길동" class="form-control" /></td>
      </tr>
      <tr>
        <th>이메일</th>
        <td><input type="text" name="email" id="email" value="cjsk1126@naver.com" class="form-control" /></td>
      </tr>
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
  <div id="qrCodeView" style="display:none;">
    <h3>생성된 QR코드와 DB의 자료 확인하기</h3>
    <div>
      - 앞에서 생성된 QR코드를 찍어보고, 아래 검색버튼을 눌러서 출력자료와 비교해 본다.<br/>
      <input type="text" name="bigo" id="bigo"/>
      <input type="button" value="DB검색" onclick="bigoCheck()" class="btn btn-success"/>
    </div>
    <div id="demoBigo"></div>
  </div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>