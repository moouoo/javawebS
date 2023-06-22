<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>pdsList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <script>
    'use strict';
    
    // part선택시 해당 part만 불러오기
    function partCheck() {
    	let part = partForm.part.value;
    	location.href = "${ctp}/pds/pdsList?part="+part;
    }
    
    // 다운로드횟수 증가처리(AJAX)
    function downNumCheck(idx) {
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/pds/pdsDownNumCheck",
    		data : {idx : idx},
    		success : function() {
    			location.reload();
    		},
    		error : function() {
    			alert("전송오류!!!");
    		}
    	});
    }
    
    // 파일 삭제처리(ajax) - prompt창을 통해 비번 받아서 삭제처리
    function pdsDeleteCheck(idx, fSName) {
    	let ans = confirm("선택된 자표파일을 삭제하시겠습니까?");
    	if(!ans) return false;
    	
    	let pwd = prompt("비밀번호를 입력하세요?");
    	let query = {
    			idx : idx,
    			fSName : fSName,
    			pwd : pwd
    	}
    	
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/pds/pdsDeleteCheck",
    		data : query,
    		success:function(res) {
    			if(res == "1") {
    				alert('삭제되었습니다.');
    				location.reload();
    			}
    			else {
    				alert("삭제 실패~");
    			}
    		},
    		error : function() {
    			alert("전송 실패~");
    		}
    	});
    }
    
    // 모달창 연습하기
    function modalView(title,nickName,mid,part,fName,fSName,fSize,downNum,fDate) {
    	let imgs = fSName.split("/");
    	fDate = fDate.substring(0,19);
    	fSize = parseInt(fSize / 1024) + "KByte";
    	
    	$("#myModal").on("show.bs.modal", function(e){
    		$(".modal-header #title").html(title);
    		$(".modal-header #part").html(part);
    		$(".modal-body #nickName").html(nickName);
    		$(".modal-body #mid").html(mid);
    		$(".modal-body #fName").html(fName);
    		$(".modal-body #fDate").html(fDate);
    		$(".modal-body #fSize").html(fSize);
    		$(".modal-body #downNum").html(downNum);
    		$(".modal-body #fSName").html(fSName);
    		
    		// 저장된 파일에 그림이 1장이라도 있다면 1장만 화면에 출력시켜준다.
    		$(".modal-body #imgSrc").attr("src",'');	// 기존에 존재하는 그림파일이 있으면 제거시킨다.(src값을 없앴기에 보이지 않게처리했다.)
    		for(let i=0; i<imgs.length; i++) {
    			let imgExt = imgs[i].substring(imgs[i].lastIndexOf(".")+1).toUpperCase();
    			if(imgExt=="JPG" || imgExt=="GIF" || imgExt=="PNG") {
    				$(".modal-body #imgSrc").attr("src",'${ctp}/pds/'+imgs[i]);
    				break;
    			}
    		}
    	});
    }
    
    // modal창을 통해서 비밀번호 확인후 파일을 삭제처리(Ajax처리)
    function pdsDelCheckModalOk() {
    	let idx = pwdModalForm.idx.value;
    	let pwd = pwdModalForm.pwd.value;
    	let query = {
    			idx : idx,
    			pwd : pwd
    	}
    	
    	$.ajax({
    		type   : "post",
    		url    : "${ctp}/pds/pdsDeleteCheck",
    		data   : query,
    		success:function(res) {
    			if(res == "1") {
    				alert("삭제되었습니다.");
    				location.reload();
    			}
    			else {
    				alert("삭제 실패~~");
    			}
    		},
    		error : function() {
    			alert("전송 오류~~");
    		}
    	});
    }
    
    
    // modal창을 통해서 비밀번호 확인후 파일을 삭제처리
    function pdsDelCheckModal(idx,fSName) {
  		$("#myPwdModal .modal-body #idx").val(idx);
  		$("#myPwdModal .modal-body #fSName").val(fSName);
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">자 료 실 리 스 트(${pageVO.part})</h2>
  <br/>
  <table class="table table-borderless">
    <tr>
      <td style="width:20%" class="text-left">
        <form name="partForm">
          <select name="part" onchange="partCheck()" class="form-control">
            <option ${pageVO.part=="전체" ? "selected" : ""}>전체</option>
            <option ${pageVO.part=="학습" ? "selected" : ""}>학습</option>
            <option ${pageVO.part=="여행" ? "selected" : ""}>여행</option>
            <option ${pageVO.part=="음식" ? "selected" : ""}>음식</option>
            <option ${pageVO.part=="기타" ? "selected" : ""}>기타</option>
          </select>
        </form>
      </td>
      <td class="text-right">
        <a href="${ctp}/pds/pdsInput?part=${pageVO.part}" class="btn btn-success">자료올리기</a>
      </td>
    </tr>
  </table>
  <table class="table table-hover text-center">
    <tr class="table-dark text-dark">
      <th>번호</th>
      <th>자료제목</th>
      <th>올린이</th>
      <th>올린날짜</th>
      <th>분류</th>
      <th>파일명(크기)</th>
      <th>다운수</th>
      <th>비고</th>
    </tr>
    <c:set var="curScrStartNo" value="${pageVO.curScrStartNo}"/>
    <c:forEach var="vo" items="${vos}" varStatus="st">
      <tr>
        <td>${curScrStartNo}</td>
        <td>
          <a href="${ctp}/pds/pdsContent?idx=${vo.idx}&pag=${pageVO.pag}&part=${pageVO.part}">${vo.title}</a>
    	    <c:if test="${vo.hour_diff <= 24}"><img src="${ctp}/images/new.gif"/></c:if>
        </td>
        <td>${vo.nickName}</td>
        <td>
          <%-- ${vo.fDate} --%>
          <c:if test="${vo.hour_diff > 24}">${fn:substring(vo.FDate,0,10)}</c:if>
          <c:if test="${vo.hour_diff < 24}">		<!-- 24시간이 지나지 않았지만 현재시간~자정까찌는 '날짜:시간', 나머지는 '시간'만 출력 -->
    	      ${vo.day_diff > 0 ? fn:substring(vo.FDate,0,16) : fn:substring(vo.FDate,11,19)}
    	    </c:if>
        </td>
        <td>${vo.part}</td>
        <td>
          <c:set var="fNames" value="${fn:split(vo.FName,'/')}"/>
          <c:set var="fSNames" value="${fn:split(vo.FSName,'/')}"/>
          <c:forEach var="fName" items="${fNames}" varStatus="st">
            <a href="${ctp}/pds/${fSNames[st.index]}" download="${fName}" onclick="downNumCheck(${vo.idx})">${fName}</a><br/>
          </c:forEach>
          (<fmt:formatNumber value="${vo.FSize/1024}" pattern="#,##0" />KByte)
        </td>
        <td>${vo.downNum}</td>
        <td>
          <a href="#" onclick="modalView('${vo.title}','${vo.nickName}','${vo.mid}','${vo.part}','${vo.FName}','${vo.FSName}','${vo.FSize}','${vo.downNum}','${vo.FDate}')" class="badge badge-info" data-toggle="modal" data-target="#myModal">모달창</a><br/>
          <a href="${ctp}/pds/pdsTotalDown?idx=${vo.idx}" class="badge badge-primary">전체다운</a><br/>
          <%-- <a href="javascript:pdsDeleteCheck('${vo.idx}','${vo.FSName}')" class="badge badge-danger">삭제1</a> --%>
          <a href="#" onclick="pdsDelCheckModal('${vo.idx}','${vo.FSName}')" data-toggle="modal" data-target="#myPwdModal" class="badge badge-danger">삭제</a>
        </td>
      </tr>
      <c:set var="curScrStartNo" value="${curScrStartNo - 1}"/>
    </c:forEach>
    <tr><td colspan="8" class="m-0 p-0"></td></tr>
  </table>
</div>

<!-- 블록 페이지 시작 -->
<div class="text-center">
  <ul class="pagination justify-content-center">
    <c:if test="${pageVO.pag > 1}">
      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/pds/pdsList?part=${pageVO.part}&pag=1">첫페이지</a></li>
    </c:if>
    <c:if test="${pageVO.curBlock > 0}">
      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/pds/pdsList?part=${pageVO.part}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li>
    </c:if>
    <c:forEach var="i" begin="${(pageVO.curBlock)*pageVO.blockSize + 1}" end="${(pageVO.curBlock)*pageVO.blockSize + pageVO.blockSize}" varStatus="st">
      <c:if test="${i <= pageVO.totPage && i == pageVO.pag}">
    		<li class="page-item active"><a class="page-link bg-secondary border-secondary" href="${ctp}/pds/pdsList?part=${pageVO.part}&pag=${i}">${i}</a></li>
    	</c:if>
      <c:if test="${i <= pageVO.totPage && i != pageVO.pag}">
    		<li class="page-item"><a class="page-link text-secondary" href="${ctp}/pds/pdsList?part=${pageVO.part}&pag=${i}">${i}</a></li>
    	</c:if>
    </c:forEach>
    <c:if test="${pageVO.curBlock < pageVO.lastBlock}">
      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/pds/pdsList?part=${pageVO.part}&pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}">다음블록</a></li>
    </c:if>
    <c:if test="${pageVO.pag < pageVO.totPage}">
      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/pds/pdsList?part=${pageVO.part}&pag=${pageVO.totPage}">마지막페이지</a></li>
    </c:if>
  </ul>
</div>
<!-- 블록 페이지 끝 -->

<!-- The Modal(모달창 클릭시 자료실의 내용을 모달창에 출력한다. -->
<div class="modal fade" id="myModal">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
    
      <!-- Modal Header -->
      <div class="modal-header">
        <h4 class="modal-title"><span id="title"></span>(분류:<span id="part"></span>)</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
        - 올린이 : <span id="nickName"></span>
        <hr/>
        - 아이디 : <span id="mid"></span><br/>
        - 파일명 : <span id="fName"></span><br/>
        - 파일올린날짜 : <span id="fDate"></span><br/>
        - 파일크기 : <span id="fSize"></span><br/>
        - 파일다운횟수 : <span id="downNum"></span><br/>
        <hr/>
        - 저장파일명 : <span id="fSName"></span><br/>
        <img id="imgSrc" width="450px"/><br/>
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>
      
    </div>
  </div>
</div>

<!-- The Modal(폼태그로 비밀번호 처리하기 위한 모달창) -->
<div class="modal fade" id="myPwdModal">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal Header -->
      <div class="modal-header">
        <h4 class="modal-title">비밀번호 조회.</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
        <form name="pwdModalForm" class="was-validated">
          비밀번호 :
          <input type="password" name="pwd" id="pwd" placeholder="비밀번호를 입력하세요." class="form-control mb-2" required />
          <input type="button" value="비밀번호확인후전송" onclick="pdsDelCheckModalOk()" class="btn btn-success form-control"/>
          <input type="hidden" name="idx" id="idx"/>
        </form>
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>
      
    </div>
  </div>
</div>

<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>