<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>webSocket.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
  <style>
		#list {
			height: 400px;
			padding: 15px;
			overflow: auto;
		}
  </style>
  <script>
	  $(document).ready(function(){
		  
			//채팅 서버 주소
		  //let url = "ws://192.168.50.20:9090/javawebS/chatserver";
		  let url = "ws://localhost:9090/${ctp}/chatserver";
		     		
		  // 웹 소켓
		  let ws;
		
		  // '연결'버튼을 클릭하면 아래 내용을 수행처리한다.(먼저 사용자가 입력되어있는 상태라면 웹소켓에 접속처리후 작업할 수 있게 한다.)
		  $('#btnConnect').click(function() {
		  	// 유저명 확인
	     	if ($('#user').val().trim() != '') {
	     		// 연결
	  	   	ws = new WebSocket(url);
	  	   			
	  	   	// 소켓 이벤트 매핑(웹소켓에 연결되면 'onopen'메소드가 수행된다.)
	  	   	ws.onopen = function (evt) {
	  	   		console.log($('#user').val(), '서버 연결 성공');
	  	   		print($('#user').val(), '입장했습니다.');
	  	   				
	  	   		// 현재 사용자가 입장했다고 서버에게 통지(유저명 전달) - 처음 접속시에는 매개값의 첫글자를 '1'을 붙여서 서버로 전송한다.(ws.send(매개값))
	  	   		// -> '1#유저명#' 과 같은 형식으로 편집해서 서버로 보내준다.
		  			ws.send('1#' + $('#user').val() + '#');
		  			
		  			$('#chatStatus').html('${sNickName}님 접속중');
	  	   		
		  			$('#user').attr('readonly', true);					// 'user명'은 수정불가로 처리
		  			$('#btnConnect').attr('disabled', true);		// '연결'버튼은 비활성화처리
		  			$('#btnDisconnect').attr('disabled', false);// '종료'버튼은 활성화 처리
		  			$('#msg').attr('disabled', false);	// 사용불가로 해 두었던 메세지 입력박스를 사용가능상태로 전환
		  			$('#msg').focus();
		  		};
	        
		  		// 메세지를 보내면 서버에 다녀온후(getBasicRemote().sendText()에서 보낸 메세지가져옴) onmessage메소드가 실행됨.
	  			ws.onmessage = function (evt) {		// 서버에서 넘어온값이 '2#user명: 메세지' 라고 한다면...
		  			let index = evt.data.indexOf("#", 2);
		  			let no = evt.data.substring(0, 1);
		  			let user = evt.data.substring(2, index);  // 최초 로그인사용자가 '연결'시에는 index값이 -1이다.
		  			
		  			// index값이 -1일 경우는 처음 접속시일 경우이다.
		  			// 메세지가 올경우는 '2#user명:메세지'로 전송되어 온다.
		  			if(index == -1) user = evt.data.substring(evt.data.indexOf("#")+1, evt.data.indexOf(":"));
		  			
		  			let txt = evt.data.substring(evt.data.indexOf(":")+1);
		  			
		  	   				
		  			if (no == '1') {
		  				print2(user);
		  			} else if (no == '2') {
		  				if (txt != '') print(user, txt);
		  			} else if (no == '3') {
		  				print3(user);
		  			}
		  			$('#list').scrollTop($('#list').prop('scrollHeight'));	// 스크롤바 가장 아래쪽으로 내리기
		  		};
	  	   	
		  		// 웹소켓 접속이 종료될때 수행되는 메소드
		  		ws.onclose = function (evt) {
		  			console.log('소켓이 닫힙니다.');
		  		};
	
		  		// 웹소켓 에러시에 수행되는 메소드
		  		ws.onerror = function (evt) {
		  			console.log(evt.data);
		  		};
		  	} else {
		  		alert('유저명을 입력하세요.');
		  		$('#user').focus();
		  	}
		  });
		
		  // 로그인한 사용자가 처음 접속할때와 메세지 전송시 처리...... 메세지 전송 및 아이디
		  function print(user, txt) {
		  	let temp = '';
		  	if('${sNickName}'!=user) {
		  		temp += '<div style="margin-bottom:3px;margin-right:100px">';
		  	}
		  	else {
		  		temp += '<div style="margin-bottom:3px;margin-left:100px" class="text-right">';
		  	}
		  	temp += '<font size="0.9em">[' + user + ']</font> ';
		  	temp += '<span style="font-size:11px;color:#777;">' + new Date().toLocaleTimeString() + '</span><br/>';
		  	if('${sNickName}'!=user) {
		  		temp += '<div style="background-color:#CEF6EC;border:1px solid #fff; border-radius:4px; padding:5px; text-align:left;width:auto;">'+txt+'</div>';
		  	}
		  	else {
		  		if(txt.indexOf("입장했습니다.") != -1) {
		  		  temp += '<div style="background-color:#ff0;border:1px solid #ccc;border-radius:4px;padding:5px;text-align:left;width:auto;">'+user+"님이 " + txt+'</div>';
		  		}
		  		else {
		  		  temp += '<div style="background-color:#ff0;border:1px solid #ccc;border-radius:4px;padding:5px;text-align:left;width:auto;">'+txt+'</div>';		  			
		  		}
		  	}
		  	temp += '</div>';
			  temp = temp.replace(/\n/gi,"<br/>");
		  			
		  	$('#list').append(temp);
		  }
		  		
		  // 다른 client 사용자가 처음 접속할때...		
		  function print2(user) {
		  	let temp = '';
		  	temp += '<div style="margin-bottom:3px;">';
		  	temp += "<font color='red'>'" + user + "'</font> 이(가) <font color='blue'>접속</font>했습니다." ;
		  	temp += ' <span style="font-size:11px;color:#777;">' + new Date().toLocaleTimeString() + '</span>';
		  	temp += '</div>';
		  			
		  	$('#list').append(temp);
		  }
		
		  // client 접속 종료
		  function print3(user) {
		  	let temp = '';
		  	temp += '<div style="margin-bottom:3px;">';
		  	temp += "<font color='red'>'" + user + "'</font> 이(가) <font color='red'>종료</font>했습니다." ;
		  	temp += ' <span style="font-size:11px;color:#777;">' + new Date().toLocaleTimeString() + '</span>';
		  	temp += '</div>';
		  			
		  	$('#list').append(temp);
		  }
	
		  // user명 입력후 연결버튼 누를때 수행
		  $('#user').keydown(function() {
		  	if (event.keyCode == 13) {
		  		$('#btnConnect').click();
		  	}
		  });
		  
		  // 메세지 입력후 엔터키를 누를때 수행
		  $('#msg').keydown(function() {
		  	if (event.keyCode == 13) {
		  		if(!event.shiftKey) {
			  		if($('#msg').val().trim() == '') return false;
			  		let chatColor = $("#chatColor").val();
			  		
			  		ws.send('2#' + $('#user').val() + '#' + $(this).val() + '@' + chatColor);
			  		print($('#user').val(), '<font color="'+chatColor+'">'+$(this).val()+'</font>');
			  		
			  		event.preventDefault();	// 커서를 원래 위치로 복원하기
			      $('#msg').val('');  		// 메세지창 청소하고 다음메세지를 준비
			  		$('#msg').focus();
			  		$('#list').scrollTop($('#list').prop('scrollHeight'));	// 스크롤바 가장 아래쪽으로 내리기
		  		}
		  	}
		  });
		  		
		  // '종료'버튼 클릭시 수행..
		  $('#btnDisconnect').click(function() {
		  	ws.send('3#' + $('#user').val() + '#');
		  	ws.close();
		  			
		  	$('#user').attr('readonly', false);
		  	
		    $('#user').val('${sNickName}');
		  	$('#user').attr('disabled', true);
		  	$('#chatStatus').html('${sNickName}님 <font color="red">접속대기</font>상태');
		  	$('#list').append('<font color="red">${sNickName}</font>님 접속종료');
		  			
		  	$('#btnConnect').attr('disabled', false);
		  	$('#btnDisconnect').attr('disabled', true);
		  			
		  	$('#msg').val('');
		  	$('#msg').attr('disabled', true);
		  });
		  
	  });
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<br/>
<div class="container">
	<h2 class="page-header">대화방<font size="3" color="blue">(<span id="chatStatus">${sNickName}님 <font color="red">접속대기</font>상태</span>)</font></h2>		
	
	<div class="row">
		<div class="col-7">
		  <input type="text" name="user" value="${sNickName}" id="user" class="form-control m-0" readonly />
		</div>
		<div class="col-5">
		  <input type="button" value="연결" id="btnConnect" class="btn btn-success btn-sm m-0"/>
		  <input type="button" value="종료" id="btnDisconnect" class="btn btn-warning btn-sm m-0" disabled />
		  <input type="color" name="chatColor" id="chatColor" title="글자색 변경" style="width:40px;" class="p-0"/>
		</div>
	</div>
	<div style="height:400px;border:1px solid #fff;border-radius:4px;margin:2px 0;background-color:#F5ECCE">
		<div id="list"></div>
	</div>
	<div>
		<div>
		  <textarea name="msg" id="msg" rows="3" placeholder="대화 내용을 입력하세요." class="form-control mb-2" disabled></textarea>
		</div>
	</div>
	
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>