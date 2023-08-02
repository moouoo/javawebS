<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>mailForm2.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <style>
    th {
      text-align: center;
      background-color: #eee;
    }
  </style>
  <script>
    'use strict';
    
    function jusorokView() {
    	$("#toMail").val('');	// 받는사람 이메일 입력란 초기화
    	
  		$(".modal-header #cnt").html(${cnt});
  		let jusorok = '';
  		jusorok += '<table class="table table-hover">';
  		jusorok += '<tr class="table-dark text-dark text-center">';
  		jusorok += '<th>번호</th><th>아이디</th><th>성명</th><th>메일주소</th><th>추가</th>';
  		jusorok += '</tr>';
  		jusorok += '<c:forEach var="vo" items="${vos}" varStatus="st">';
  		jusorok += '<tr class="text-center">';
  		/* 
  		jusorok += '<td onclick="location.href=\'${ctp}/study/mail/mailForm2?email=${vo.email}\';">${st.count}</td>';
  		jusorok += '<td onclick="location.href=\'${ctp}/study/mail/mailForm2?email=${vo.email}\';">${vo.mid}</td>';
  		jusorok += '<td onclick="location.href=\'${ctp}/study/mail/mailForm2?email=${vo.email}\';">${vo.name}</td>';
  		jusorok += '<td onclick="location.href=\'${ctp}/study/mail/mailForm2?email=${vo.email}\';">${vo.email}</td>';
  		 */
  		jusorok += '<td>${st.count}</td>';
  		jusorok += '<td>${vo.mid}</td>';
  		jusorok += '<td>${vo.name}</td>';
  		jusorok += '<td>${vo.email}</td>';
  		/* jusorok += '<td><input type="checkbox" name="mailCheck" id="mailCheck" onclick="addMail(\'${vo.email}\')"></td>'; */
  		jusorok += '<td><input type="checkbox" name="mailCheck" id="mailCheck" value="${vo.email}"></td>';
  		jusorok += '</tr>';
  		jusorok += '</c:forEach>';
  		jusorok += '<tr><td colspan="5" class="m-0 p-0"></td></tr>';
  		jusorok += '</table>';
  		$(".modal-body #jusorok").html(jusorok);
    }
    /* 
    function addMail(email) {
    	let str = $("#toMail").val();
    	if(str != "") str += ';';
    	$("#toMail").val(str+email);
    }
     */
    function addMailCheck() {
    	let emails = "";
			for(let i=0; i<document.getElementsByName("mailCheck").length; i++) {
				if(document.getElementsByName("mailCheck")[i].checked == true) {
					emails += document.getElementsByName("mailCheck")[i].value + ";";
				}
			}
			emails = emails.substring(0,emails.length-1);
    	$("#toMail").val(emails);
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">메 일 보 내 기2</h2>
  <p>받는 사람의 메일주소를 정확히 입력하셔야 합니다.</p>
  <form name="myform" method="post">
    <table class="table table-bordered">
      <tr>
        <th>받는사람</th>
        <td>
			    <div class="input-group">
				    <input type="text" name="toMail" id="toMail" value="${email}" class="form-control mr-2" placeholder="받는사람 메일주소를 입력하세요." autofocus required />
				    <div class="input-group-append">
					    <input type="button" value="주소록" onclick="jusorokView()" class="btn btn-info form-control" data-toggle="modal" data-target="#myModal" />
				    </div>
			    </div>
        </td>
      </tr>
      <tr>
        <th>메일제목</th>
        <td><input type="text" name="title" id="title" placeholder="메일 제목을 입력하세요." class="form-control" required/></td>
      </tr>
      <tr>
        <th>메일내용</th>
        <td><textarea rows="7" name="content" id="content" class="form-control" required></textarea></td>
      </tr>
      <tr>
        <td colspan="2" class="text-center">
          <input type="submit" value="메일보내기" class="btn btn-success"/>
          <input type="reset" value="다시쓰기" class="btn btn-secondary"/>
          <input type="button" value="돌아가기" onclick="location.href='${ctp}/member/memberMain';" class="btn btn-warning"/>
        </td>
      </tr>
    </table>
  </form>
</div>

<!-- 주소록을 Modal로 출력하기 -->
<div class="modal fade" id="myModal" style="width:680px">
	<div class="modal-dialog">
	  <div class="modal-content" style="width:600px">
	  	<div class="modal-header" style="width:600px">
	  		<h4 class="modal-title text-center">☆ 주 소 록 ☆(총건수:<span id="cnt"></span>)</h4>
	  		<button type="button" class="close" data-dismiss="modal">&times;</button>
	  	</div>
	  	<div class="modal-body" style="width:600px;height:400px;overflow:auto;">
	  		<span id="jusorok" style="cursor:pointer"></span>
	  	</div>
	  	<div class="modal-footer" style="width:600px">
	  		<button type="button" onclick="addMailCheck()" class="btn-success" data-dismiss="modal">메일선택</button>
	  		<button type="button" class="close btn-danger" data-dismiss="modal">Close</button>
	  	</div>
	  </div>
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>