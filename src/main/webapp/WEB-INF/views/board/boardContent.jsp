<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>boardContent.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <style>
    th {
      text-align: center;
      background-color: #eee;
    }
  </style>
  <script>
    'use strict';
    
    // 전체 댓글(보이기/가리기)
    $(document).ready(function(){
    	$("#reply").show();
    	$("#replyViewBtn").hide();
    	
    	$("#replyHiddenBtn").click(function(){
    		$("#reply").slideUp(500);
    		$("#replyViewBtn").show();
    		$("#replyHiddenBtn").hide();
    	});
    	
    	$("#replyViewBtn").click(function(){
    		$("#reply").slideDown(500);
    		$("#replyViewBtn").hide();
    		$("#replyHiddenBtn").show();
    	});
    });
    
    // 좋아요버튼 클릭시 하트그림 빨강색처리(세션처리)...(세션이 끈어지면 다시 하트그림이 원래색으로 돌아가게 된다.)
    function goodCheck() {
    	// location.href = "${ctp}/board/boardGoodCheck.bo?idx=${vo.idx}";  // 일반처리한것... 아래는 aJax처리
    	
    	$.ajax({
    		type  : "post",
    		url   : "${ctp}/board/boardGoodCheckAjax",
    		data  : {idx : ${vo.idx}},
    		success:function(res) {
    			if(res == "0") alert("이미 좋아요 버튼을 클릭하셨습니다.");
    			else location.reload();
    		},
    		error : function() {
    			alert("전송 오류~~");
    		}
    	});
    }
    
    // 좋아요 Plus버튼누르면 1증가처리(세션처리).. (Minus버튼클릭시 1감소처리)
    function goodCheckPlusMinus(flag) {
    	$.ajax({
    		type  : "post",
    		url   : "${ctp}/board/boardGoodPlusMinus",
    		data  : {
    			idx : ${vo.idx},
    			goodCnt : flag
    		},
    		success:function(res) {
    			if(res == "1") alert("이미 누르셨습니다.");
    			else location.reload();
    		}
    	});
    }
    
    // DB를 활용한 좋아요 토글처리...
    function goodDBCheck(idx) {
    	if(idx == "") idx = 0;
    	$.ajax({
    		type  : "post",
    		url   : "${ctp}/board/boardGoodDBCheck",
    		data  : {
    			idx  : idx,
				  part : 'board',
				  partIdx : ${vo.idx},
				  mid  : '${sMid}'
				},
    		success:function() {
    			location.reload();
    		},
    		error : function() {
    			alert("전송 오류~~");
    		}
    	});
    }
    
    // 게시글 삭제처리
    function boardDelete() {
    	let ans = confirm("현 게시글을 삭제하시겠습니까?");
    	if(ans) location.href="${ctp}/board/boardDelete?idx=${vo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}&nickName=${vo.nickName}";
    }
    
    // 댓글달기(aJax처리)
    function replyCheck() {
    	let content = $("#content").val();
    	if(content.trim() == "") {
    		alert("댓글을 입력하세요!");
    		$("#content").focus();
    		return false;
    	}
    	let query = {
    			boardIdx : ${vo.idx},
    			mid      : '${sMid}',
    			nickName : '${sNickName}',
    			content  : content,
    			hostIp   : '${pageContext.request.remoteAddr}'
    	}
    	
    	$.ajax({
    		type  : "post",
    		url   : "${ctp}/board/boardReplyInput",
    		data  : query,
    		success:function(res) {
    			if(res == "1") {
    				alert("댓글이 입력되었습니다.");
    				location.reload();
    			}
    			else {
    				alert("댓글이 입력 실패~~");
    			}
    		},
    		error : function() {
    			alert("전송 오류!!!");
    		}
    	});
    }
    
    // 댓글삭제
    function replyDelete(idx, level) {
    	let ans = confirm("선택한 댓글을 삭제하시겠습니까?");
      if(!ans) return false;
      
      $.ajax({
        type : 'post',
        url : '${ctp}/board/boardReplyDelete',
        data : {
        	replyIdx : idx,
        	level : level
        },
        success : function(res) {
          if(res == '1') {
           alert('댓글이 삭제되었습니다.');
           location.reload();
          }
          else {
           alert('댓글이 삭제되지 않았습니다.');
          }
        },
        error : function() {
          alert('전송실패~~');
        }
      });
    }
    
    // 대댓글(부모댓글의 댓글, 대댓글의 대대댓글....,) 폼 출력하기
    function insertReply(idx, groupId, level, nickName) {
    	let insReply = '';
    	insReply += '<div class="container">';
    	insReply += '<table class="m-2 p-0" style="width:90%">';
    	insReply += '<tr>';
    	insReply += '<td class="p-0 text-left">';
    	insReply += '<div>';
    	insReply += '답변 댓글 달기: <input type="text" name="nickName" value="${sNickName}" size="6" readonly class="p-0"/>';
    	insReply += '</div>';
    	insReply += '</td><td>';
    	insReply += '<input type="button" value="답글달기" onclick="replyCheck2('+idx+','+groupId+','+level+')" />';
    	insReply += '</td></tr><tr><td colspan="2" class="text-center p-0">';
    	insReply += '<textarea rows="3" class="form-control p-0" name="content" id="content'+idx+'" />';
    	insReply += '@' + nickName + '\n';
    	insReply += '</textarea>';
    	insReply += '</td>';
    	insReply += '</tr>';
    	insReply += '</table>';
    	insReply += '</div>';
    	
    	$("#replyBoxOpenBtn"+idx).hide();
    	$("#replyBoxCloseBtn"+idx).show();
    	$("#replyBox"+idx).slideDown(500);
    	$("#replyBox"+idx).html(insReply);
    }
    
    // 대댓글창 닫기
    function closeReply(idx) {
    	$("#replyBoxOpenBtn"+idx).show();
    	$("#replyBoxCloseBtn"+idx).hide();
    	$("#replyBox"+idx).slideUp(500);
    }
    
    // 대댓글 저장하기
    function replyCheck2(idx, groupId, level) {
    	let boardIdx = '${vo.idx}';
    	let mid = '${sMid}';
    	let nickName = '${sNickName}';
    	let content = $("#content"+idx).val();
    	let hostIp = '${pageContext.request.remoteAddr}';
    	
    	if(content == "") {
    		alert("답변글(대댓글)을 입력하세요!");
    		$("#content"+idx).focus();
    		return false;
    	}
    	
    	let query = {
    			boardIdx : boardIdx,
    			mid      : mid,
    			nickName : nickName,
    			content  : content,
    			hostIp   : hostIp,
    			groupId  : groupId,
    			level    : level
    	}
    	
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/board/boardReplyInput2",
    		data : query,
    		success:function() {
    			location.reload();
    		},
    		error : function() {
    			alert("전송오류!");
    		}
    	});
    }
    
    // 대댓글 수정 폼 출력하기
    function updateReplyForm(idx, content) {
    	let insReply = '';
    	insReply += '<div class="container">';
    	insReply += '<table class="m-2 p-0" style="width:90%">';
    	insReply += '<tr>';
    	insReply += '<td class="p-0 text-left">';
    	insReply += '<div>';
    	insReply += '댓글 수정하기: <input type="text" name="nickName" value="${sNickName}" size="6" readonly class="p-0"/>';
    	insReply += '</div>';
    	insReply += '</td><td>';
    	insReply += '<input type="button" value="댓글수정" onclick="updateReply('+idx+')" />';
    	insReply += '</td></tr><tr><td colspan="2" class="text-center p-0">';
    	insReply += '<textarea rows="3" class="form-control p-0" name="content" id="content'+idx+'" />';
    	insReply += content.replaceAll("<br/>", "\n");
    	insReply += '</textarea>';
    	insReply += '</td>';
    	insReply += '</tr>';
    	insReply += '</table>';
    	insReply += '</div>';
    	
    	$("#replyBoxOpenBtn"+idx).hide();
    	$("#replyBoxCloseBtn"+idx).show();
    	$("#replyBox"+idx).slideDown(500);
    	$("#replyBox"+idx).html(insReply);
    }
    
    // 대댓글 수정하기
    function updateReply(idx) {
    	let content = $("#content"+idx).val();
    	let hostIp = "${pageContext.request.remoteAddr}";
    	
    	if(content == "") {
    		alert("답변글(대댓글)을 입력하세요!");
    		$("#content"+idx).focus();
    		return false;
    	}
    	
    	let query = {
    			idx : idx,
    			content : content,
    			hostIp  : hostIp
    	}
    	
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/board/boardReplyUpdate",
    		data : query,
    		success:function() {
    			alert("수정완표");
    			location.reload();
    		},
    		error : function() {
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
  <h2 class="text-center">글 내 용 보 기</h2>
  <br/>
  <table class="table table-borderless m-0 p-0">
    <tr>
      <td class="text-right">접속IP : ${vo.hostIp}</td>
    </tr>
  </table>
  <table class="table table-bordered">
    <tr>
      <th>글쓴이</th>
      <td>${vo.nickName}</td>
      <th>글쓴날짜</th>
      <td>${fn:substring(vo.WDate,0,fn:length(vo.WDate)-2)}</td>
    </tr>
    <tr>
      <th>글제목</th>
      <td colspan="3">${vo.title}</td>
    </tr>
    <tr>
      <th>전자메일</th>
      <td>${vo.email}</td>
      <th>조회수</th>
      <td>${vo.readNum}</td>
    </tr>
    <tr>
      <th>홈페이지</th>
      <td>${vo.homePage}</td>
      <th>좋아요</th>
      <td>
        <%-- 
        ${vo.good} /
        <a href="javascript:goodSwitchCheck(${sGFlag})">
          <c:if test="${sSw == '1'}"><font color="#f00" size="5">♥</font></c:if>
          <c:if test="${sSw != '1'}"><font color="#000" size="5">♥</font></c:if>
        </a> /
        <a href="javascript:goodCheckPlus()">👍</a>
        <a href="javascript:goodCheckMinus()">👎</a> /
        --%>
				<a href="javascript:goodCheck()">
          <c:if test="${sSw == '1'}"><font color="red">❤</font></c:if>
          <c:if test="${sSw != '1'}">❤</c:if>
        </a>
        ${vo.good} ,
        <a href="javascript:goodCheckPlusMinus(1)">👍</a>
        <a href="javascript:goodCheckPlusMinus(-1)">👎</a> ,
        <a href="javascript:goodDBCheck(${goodVo.idx})">
          <c:if test="${!empty goodVo}"><font color="red">❤</font></c:if>
          <c:if test="${empty goodVo}">❤</c:if>(토글DB) ,
        </a>
      </td>
    </tr>
    <tr>
      <th>글내용</th>
      <td colspan="3" style="height:220px">${fn:replace(vo.content, newLine, "<br/>")}</td>
    </tr>
    <tr>
      <td colspan="4" class="text-center">
        <c:if test="${flag == 'search'}"><input type="button" value="돌아가기" onclick="location.href='${ctp}/board/boardSearch?search=${search}&searchString=${searchString}&pag=${pag}&pageSize=${pageSize}';" class="btn btn-primary"/></c:if>
        <c:if test="${flag == 'searchMember'}"><input type="button" value="돌아가기" onclick="location.href='${ctp}/board/boardSearchMember?pag=${pag}&pageSize=${pageSize}';" class="btn btn-primary"/></c:if>
        <c:if test="${flag != 'search' && flag != 'searchMember'}"><input type="button" value="돌아가기" onclick="location.href='${ctp}/board/boardList?pag=${pag}&pageSize=${pageSize}';" class="btn btn-primary"/></c:if>
        &nbsp;
      	<c:if test="${sMid == vo.mid || sLevel == 0}">
        	<input type="button" value="수정하기" onclick="location.href='${ctp}/board/boardUpdate?idx=${vo.idx}&pag=${pag}&pageSize=${pageSize}';" class="btn btn-warning"/> &nbsp;
        	<input type="button" value="삭제하기" onclick="boardDelete()" class="btn btn-danger"/>
      	</c:if>
      </td>
    </tr>
  </table>
  
  <c:if test="${flag != 'search' && flag != 'searchMember'}">
	  <!-- 이전글/ 다음글 처리 -->
	  <table class="table table-borderless">
	    <tr>
	      <td>
	        <c:if test="${!empty pnVos[1]}">
	          ☝ <a href="${ctp}/board/boardContent?idx=${pnVos[1].idx}&pag=${pag}&pageSize=${pageSize}">다음글 : ${pnVos[1].title}</a><br/>
	        </c:if>
	        <c:if test="${vo.idx < pnVos[0].idx}">
	        	☝ <a href="${ctp}/board/boardContent?idx=${pnVos[0].idx}&pag=${pag}&pageSize=${pageSize}">다음글 : ${pnVos[0].title}</a><br/>
	        </c:if>
	        <c:if test="${vo.idx > pnVos[0].idx}">
	        	👇 <a href="${ctp}/board/boardContent?idx=${pnVos[0].idx}&pag=${pag}&pageSize=${pageSize}">이전글 : ${pnVos[0].title}</a><br/>
	        </c:if>
	      </td>
	    </tr>
	  </table>
  </c:if>
  
  <!-- 댓글(대댓글) 보이기 가리기 버튼처리 -->
  <div class="text-center mb-3">
    <input type="button" value="댓글보이기" id="replyViewBtn" class="btn btn-secondary" style="display:none;" />
    <input type="button" value="댓글가리기" id="replyHiddenBtn" class="btn btn-info"/>
  </div>
  <!-- 댓글 리스트보여주기 -->
  <div id="reply" class="container">
    <table class="table table-hover text-left">
      <tr>
        <th colspan="2"> &nbsp;작성자</th>
        <th>댓글내용</th>
        <th>작성일자</th>
        <th>접속IP</th>
        <th>답글</th>
      </tr>
      <c:forEach var="replyVO" items="${replyVOS}" varStatus="st">
	        <tr>
		        <c:if test="${replyVO.level>=1}"><td></td></c:if>
	          <td>${replyVO.nickName}
	            <c:if test="${sMid == replyVO.mid || sLevel == 0}">
	              (<a href="javascript:replyDelete(${replyVO.idx},${replyVO.level})" title="댓글삭제"><b>x</b></a>)
	            </c:if>
	          </td>
	          <td>${fn:replace(replyVO.content, newLine, "<br/>")}</td>
	          <td class="text-center">${fn:substring(replyVO.WDate,0,10)}</td>
	          <td class="text-center">${replyVO.hostIp}</td>
	          <td class="text-center">
	            <c:set var="content" value="${fn:replace(replyVO.content, newLine, '<br/>')}" />
	            <input type="button" value="답글" onclick="insertReply('${replyVO.idx}','${replyVO.groupId}','${replyVO.level}','${replyVO.nickName}')" id="replyBoxOpenBtn${replyVO.idx}" class="btn btn-success btn-sm" />
	            <input type="button" value="수정" onclick="updateReplyForm('${replyVO.idx}','${content}')" id="replyBoxUpdateBtn${replyVO.idx}" class="btn btn-info btn-sm" />
	            <input type="button" value="접기" onclick="closeReply(${replyVO.idx})" id="replyBoxCloseBtn${replyVO.idx}" class="btn btn-warning btn-sm" style="display:none;" />
	          </td>
	        </tr>
	        <tr>
	          <td colspan="6" class="m-0 p-0" style="border-top:none;"><div id="replyBox${replyVO.idx}"></div></td>
	        </tr>
      </c:forEach>
    </table>
  </div>
  
  <!-- 댓글 입력창 -->
  <form name="replyForm">
  	<table class="table tbale-center">
  	  <tr>
  	    <td style="width:85%" class="text-left">
  	      글내용 :
  	      <textarea rows="4" name="content" id="content" class="form-control"></textarea>
  	    </td>
  	    <td style="width:15%">
  	    	<br/>
  	      <p>작성자 : ${sNickName}</p>
  	      <p><input type="button" value="댓글달기" onclick="replyCheck()" class="btn btn-primary btn-sm"/></p>
  	    </td>
  	  </tr>
  	</table>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>