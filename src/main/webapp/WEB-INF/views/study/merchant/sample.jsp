<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>sample.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <!-- jQuery -->
  <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
  <!-- iamport.payment.js -->
  <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
  <script>
    var IMP = window.IMP;
    IMP.init("imp87432616");

    function requestPay() {
      IMP.request_pay(
        {
          pg: "html5_inicis.INIpayTest",
          pay_method: "card",
          merchant_uid: "javawebS_" + new Date().getTime(),
          name: "${vo.name}",
          amount: "${vo.amount}",
          buyer_email: "${vo.buyer_email}",
          buyer_name: "${vo.buyer_name}",
          buyer_tel: "${vo.buyer_tel}",
          buyer_addr: "${vo.buyer_addr}",
          buyer_postcode: "${vo.buyer_postcode}",
        },
        function (rsp) {
          if(rsp.success) {
        	  alert("결재가 완료되었습니다.");
        	  location.href = '${ctp}/study/merchant/merchantOk';
          }
          else {
        	  alert("결재 실패~~");
        	  location.href = '${ctp}/study/merchant/merchant';
          }
        }
      );
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <button onclick="requestPay()" class="btn btn-success">결제하기</button>
  <!-- 결제하기 버튼 생성 -->
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>