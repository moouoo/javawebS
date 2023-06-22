<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>memberUpdate.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <script src="${ctp}/js/woo.js"></script>
  <script>
    'use strict';
    // 닉네임 중복버튼을 클릭했는지의 여부를 확인하기위한 변수(버튼 클릭후에는 내용 수정처리 못하도록 처리)
    let nickCheckSw = 0;
    
    function fCheck() {
    	// 유효성 검사.....
    	// 닉네임,성명,이메일,홈페이지,전화번호,비밀번호 등등....
    	
      let regNickName = /^[가-힣]+$/;
      let regName = /^[가-힣a-zA-Z]+$/;
      let regEmail =/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
      let regURL = /^(https?:\/\/)?([a-z\d\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?$/;
    	let regTel = /\d{2,3}-\d{3,4}-\d{4}$/g;
    	
    	let nickName = myform.nickName.value;
    	let name = myform.name.value;
    	let email1 = myform.email1.value.trim();
    	let email2 = myform.email2.value;
    	let email = email1 + "@" + email2;
    	let homePage = myform.homePage.value;
    	let tel1 = myform.tel1.value;
    	let tel2 = myform.tel2.value.trim();
    	let tel3 = myform.tel3.value.trim();
    	let tel = tel1 + "-" + tel2 + "-" + tel3;
    	
    	let submitFlag = 0;		// 모든 체크가 정상으로 종료되게되면 submitFlag는 1로 변경처리될수 있게 한다.
    	
    	// 사진 업로드 체크를 위한 준비
    	let maxSize = 1024 * 1024 * 2; 	// 업로드할 회원사진의 용량은 2MByte까지로 제한한다.
    	let fName = myform.fName.value;
    	let ext = fName.substring(fName.lastIndexOf(".")+1).toUpperCase();	// 파일 확장자 발췌후 대문자로 변환
    	
    	// 앞의 정규식으로 정의된 부분에 대한 유효성체크
    	if(!regNickName.test(nickName)) {
        alert("닉네임은 한글만 사용가능합니다.");
        myform.nickName.focus();
        return false;
      }
      else if(!regName.test(name)) {
        alert("성명은 한글과 영문대소문자만 사용가능합니다.");
        myform.name.focus();
        return false;
      }
      else if(!regEmail.test(email)) {
        alert("이메일 형식에 맞지않습니다.");
        myform.email1.focus();
        return false;
      }
      else if((homePage != "http://" && homePage != "")) {
        if(!regURL.test(homePage)) {
	        alert("작성하신 홈페이지 주소가 URL 형식에 맞지않습니다.");
	        myform.homePage.focus();
	        return false;
        }
        else {
	    	  submitFlag = 1;
	      }
      }
    	
    	if(tel2 != "" && tel3 != "") {
    	  if(!regTel.test(tel)) {
	    		alert("전화번호형식을 확인하세요.(000-0000-0000)");
	    		myform.tel2.focus();
	    		return false;
    	  }
    	  else {
    		  submitFlag = 1;
    	  }
    	}
    	else {		// 전화번호를 입력하지 않을시 DB에는 '010- - '의 형태로 저장하고자 한다.
    		tel2 = " ";
    		tel3 = " ";
    		tel = tel1 + "-" + tel2 + "-" + tel3;
    		submitFlag = 1;
    	}
    	
    	// 전송전에 '주소'를 하나로 묶어소 전송처리 준비한다.
    	let postcode = myform.postcode.value + " ";
    	let roadAddress = myform.roadAddress.value + " ";
    	let detailAddress = myform.detailAddress.value + " ";
    	let extraAddress = myform.extraAddress.value + " ";
  		myform.address.value = postcode + "/" + roadAddress + "/" + detailAddress + "/" + extraAddress + "/";
    	
  		// 전송전에 파일에 관한 사항체크...(회원사진의 내역이 비었으면 noimage를 hidden필드인 photo필드에 담아서 전송한다.)
  		if(fName.trim() == "") {
  			myform.photo.value = "noimage.jpg";
				submitFlag = 1;
  		}
  		else {
  			let fileSize = document.getElementById("file").files[0].size;
  			
  			if(ext != "JPG" && ext != "GIF" && ext != "PNG") {
  				alert("업로드 가능한 파일은 'JPG/GIF/PNG'파일 입니다.");
  				return false;
  			}
  			else if(fName.indexOf(" ") != -1) {
  				alert("업로드 파일명에 공백을 포함할 수 없습니다.");
  				return false;
  			}
  			else if(fileSize > maxSize) {
  				alert("업로드 파일의 크기는 2MByte를 초과할수 없습니다.");
  				return false;
  			}
    		submitFlag = 1;
    	}
  		
    	// 전송전에 모든 체크가 끝나면 submitFlag가 1로 되게된다. 이때 값들을 서버로 전송처리한다.
    	if(submitFlag == 1) {
    		if(nickName == '${sNickName}') nickCheckSw = 1;
    		if(nickCheckSw == 0) {
    			alert("닉네임 중복체크버튼을 눌러주세요!");
    			document.getElementById("nickNameBtn").focus();
    		}
    		else {
    			let hobbys = "";
    			let hobby = document.getElementsByName("hobby");
    			for(let i=0; i<hobby.length; i++) {
    				if(document.getElementsByName("hobby")[i].checked == true) {
    					hobbys += document.getElementsByName("hobby")[i].value + "/";
    				}
    			}
    			//alert("hobbys : " + hobbys);
    			
	    		myform.email.value = email;
	    		myform.tel.value = tel;
    			myform.hobbys.value = hobbys;
	    		
		    	myform.submit();
    		}
    	}
    	else {
    		alert("회원가입 실패~~ 폼의 내용을 확인하세요.");
    	}
    	
    }
    
    // 닉네임 중복체크
    function nickCheck() {
    	let nickName = myform.nickName.value;
    	if(nickName.trim() == "" || nickName.length < 2 || nickName.length > 20) {
    		alert("닉네임을 확인하세요!(닉네임는 2~20자 이내)");
    		myform.nickName.focus();
    		return false;
    	}
    	if(nickName == '${sNickName}') {
    		nickCheckSw = 1;
    		return false;
    	}
    	
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/member/memberNickCheck",
    		data : {nickName : nickName},
    		success:function(res) {
    			if(res == "1") {
    				alert("이미 사용중인 닉네임 입니다. 다시 입력해 주세요");
    				$("#nickName").focus();
    			}
    			else  {
    				alert("사용 가능한 닉네임 입니다.");
    				nickCheckSw = 1;
    				$("#name").focus();
    			}
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
  <form name="myform" method="post" action="${ctp}/member/memberUpdateOk" class="was-validated" enctype="multipart/form-data">
    <h2>회 원 정 보 수 정</h2>
    <br/>
    <div class="form-group">
      아이디 : ${sMid}
    </div>
    <div class="form-group">
      <label for="nickName">닉네임(한글) : &nbsp; &nbsp;<input type="button" id="nickNameBtn" value="닉네임 중복체크" class="btn btn-secondary btn-sm" onclick="nickCheck()"/></label>
      <input type="text" name="nickName" id="nickName" value="${vo.nickName}" class="form-control" placeholder="별명(한글)을 입력하세요." name="nickName" required />
    </div>
    <div class="form-group">
      <label for="name">성명 :</label>
      <input type="text" name="name" id="name" value="${vo.name}" placeholder="성명을 입력하세요." class="form-control" required />
    </div>
    <div class="form-group">
      <label for="email1">Email address:</label>
        <div class="input-group mb-3">
          <c:set var="emails" value="${fn:split(vo.email,'@')}" />
          <c:set var="email1" value="${emails[0]}"/>
          <c:set var="email2" value="${emails[1]}"/>
          <input type="text" name="email1" id="email1" value="${email1}" class="form-control" placeholder="Email을 입력하세요." required />
          <div class="input-group-append">
            <select name="email2" class="custom-select">
              <option value="naver.com"   ${email2 == 'naver.com'   ? selected : ''}>naver.com</option>
              <option value="hanmail.net" ${email2 == 'hanmail.net' ? selected : ''}>hanmail.net</option>
              <option value="hotmail.com" ${email2 == 'hotmail.com' ? selected : ''}>hotmail.com</option>
              <option value="gmail.com"   ${email2 == 'gmail.com'   ? selected : ''}>gmail.com</option>
              <option value="nate.com"    ${email2 == 'nate.com'    ? selected : ''}>nate.com</option>
              <option value="yahoo.com"   ${email2 == 'yahoo.com'   ? selected : ''}>yahoo.com</option>
            </select>
          </div>
        </div>
    </div>
    <div class="form-group">
      <div class="form-check-inline">
        <span class="input-group-text">성별 :</span> &nbsp; &nbsp;
        <label class="form-check-label">
          <input type="radio" class="form-check-input" name="gender" value="남자" <c:if test="${vo.gender=='남자'}">checked</c:if>>남자
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="radio" class="form-check-input" name="gender" value="여자" <c:if test="${vo.gender=='여자'}">checked</c:if>>여자
        </label>
      </div>
    </div>
    <div class="form-group">
      <label for="birthday">생일</label>
      <input type="date" name="birthday" value="${fn:substring(vo.birthday,0,10)}" class="form-control"/>
    </div>
    <div class="form-group">
      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text">전화번호 :</span> &nbsp;&nbsp;
            <c:set var="tel" value="${fn:split(vo.tel,'-')}"/>
            <c:set var="tel1" value="${tel[0]}"/>
            <c:set var="tel2" value="${fn:trim(tel[1])}"/>
            <c:set var="tel3" value="${fn:trim(tel[2])}"/>
            <select name="tel1" class="custom-select">
              <option value="010" ${tel1=="010" ? selected : ""}>010</option>
              <option value="02"  ${tel1=="02" ? selected : ""}>서울</option>
              <option value="031" ${tel1=="031" ? selected : ""}>경기</option>
              <option value="032" ${tel1=="032" ? selected : ""}>인천</option>
              <option value="041" ${tel1=="041" ? selected : ""}>충남</option>
              <option value="042" ${tel1=="042" ? selected : ""}>대전</option>
              <option value="043" ${tel1=="043" ? selected : ""}>충북</option>
              <option value="051" ${tel1=="051" ? selected : ""}>부산</option>
              <option value="052" ${tel1=="052" ? selected : ""}>울산</option>
              <option value="061" ${tel1=="061" ? selected : ""}>전북</option>
              <option value="062" ${tel1=="062" ? selected : ""}>광주</option>
            </select>-
        </div>
        <input type="text" name="tel2" value="${tel2}" size=4 maxlength=4 class="form-control"/>-
        <input type="text" name="tel3" value="${tel3}" size=4 maxlength=4 class="form-control"/>
      </div>
    </div>
    <div class="form-group">
      <label for="address">주소</label>
      <c:set var="address" value="${fn:split(vo.address,'/')}"/>
      <c:set var="postcode" value="${address[0]}"/>
      <c:set var="roadAddress" value="${address[1]}"/>
      <c:set var="detailAddress" value="${address[2]}"/>
      <c:set var="extraAddress" value="${address[3]}"/>
      <div class="input-group mb-1">
        <input type="text" name="postcode" id="sample6_postcode" value="${postcode}" placeholder="우편번호" class="form-control">
        <div class="input-group-append">
          <input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기" class="btn btn-secondary">
        </div>
      </div>
      <input type="text" name="roadAddress" id="sample6_address" value="${roadAddress}" size="50" placeholder="주소" class="form-control mb-1">
      <div class="input-group mb-1">
        <input type="text" name="detailAddress" id="sample6_detailAddress" value="${detailAddress}" placeholder="상세주소" class="form-control"> &nbsp;&nbsp;
        <div class="input-group-append">
          <input type="text" name="extraAddress" id="sample6_extraAddress" value="${extraAddress}" placeholder="참고항목" class="form-control">
        </div>
      </div>
    </div>
    <div class="form-group">
      <label for="homepage">Homepage address:</label>
      <input type="text" class="form-control" name="homePage" value="${vo.homePage}" placeholder="홈페이지를 입력하세요." id="homePage"/>
    </div>
    <div class="form-group">
      <label for="name">직업</label>
      <select class="form-control" id="job" name="job">
        <!-- <option value="">직업선택</option> -->
        <option ${vo.job=='학생'  ? selected : ''}>학생</option>
        <option ${vo.job=='회사원' ? selected : ''}>회사원</option>
        <option ${vo.job=='공무원' ? selected : ''}>공무원</option>
        <option ${vo.job=='군인'  ? selected : ''}>군인</option>
        <option ${vo.job=='의사'  ? selected : ''}>의사</option>
        <option ${vo.job=='법조인' ? selected : ''}>법조인</option>
        <option ${vo.job=='세무인' ? selected : ''}>세무인</option>
        <option ${vo.job=='자영업' ? selected : ''}>자영업</option>
        <option ${vo.job=='기타'  ? selected : ''}>기타</option>
      </select>
    </div>
    <div class="form-group">
      <c:set var="strHobby" value="${vo.hobby}"/>
      <div class="form-check-inline">
        <span class="input-group-text">취미</span> &nbsp; &nbsp;
        <label class="form-check-label">
          <input type="checkbox" class="form-check-input" value="등산" name="hobby" <c:if test="${fn:contains(strHobby,'등산')}">checked</c:if> />등산
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="checkbox" class="form-check-input" value="낚시" name="hobby" <c:if test="${fn:contains(strHobby,'낚시')}">checked</c:if>/>낚시
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="checkbox" class="form-check-input" value="수영" name="hobby" <c:if test="${fn:contains(strHobby,'수영')}">checked</c:if>/>수영
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="checkbox" class="form-check-input" value="독서" name="hobby" <c:if test="${fn:contains(strHobby,'독서')}">checked</c:if>/>독서
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="checkbox" class="form-check-input" value="영화감상" name="hobby" <c:if test="${fn:contains(strHobby,'영화감상')}">checked</c:if>/>영화감상
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="checkbox" class="form-check-input" value="바둑" name="hobby" <c:if test="${fn:contains(strHobby,'바둑')}">checked</c:if>/>바둑
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="checkbox" class="form-check-input" value="축구" name="hobby" <c:if test="${fn:contains(strHobby,'축구')}">checked</c:if>/>축구
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="checkbox" class="form-check-input" value="기타" name="hobby" <c:if test="${fn:contains(strHobby,'기타')}">checked</c:if>/>기타
        </label>
      </div>
    </div>
    <div class="form-group">
      <label for="content">자기소개</label>
      <textarea rows="5" class="form-control" id="content" name="content" placeholder="자기소개를 입력하세요.">${vo.content}</textarea>
    </div>
    <div class="form-group">
      <div class="form-check-inline">
        <span class="input-group-text">정보공개</span>  &nbsp; &nbsp;
        <label class="form-check-label">
          <input type="radio" class="form-check-input" name="userInfor" value="공개" ${vo.userInfor=='공개' ? 'checked' : '' } />공개
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="radio" class="form-check-input" name="userInfor" value="비공개" ${vo.userInfor=='비공개' ? 'checked' : '' }/>비공개
        </label>
      </div>
    </div>
    <div  class="form-group">
      회원 사진(파일용량:2MByte이내) : <img src="${ctp}/member/${vo.photo}" width="80px"/>
      <input type="file" name="fName" id="file" class="form-control-file border"/>
    </div>
    <button type="button" class="btn btn-success" onclick="fCheck()">회원가입</button> &nbsp;
    <button type="reset" class="btn btn-secondary">다시작성</button> &nbsp;
    <button type="button" class="btn btn-warning" onclick="location.href='${ctp}/MemberLogin.mem';">돌아가기</button>
    
    <input type="hidden" name="email" />
    <input type="hidden" name="tel" />
    <input type="hidden" name="address" />
    <input type="hidden" name="photo"/>
    <input type="hidden" name="hobbys"/>
    <input type="hidden" name="mid" value="${sMid}"/>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>