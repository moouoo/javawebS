<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>errorMain.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>에러발생에 대한 대처 연습</h2>
  <hr/>
  <div>
    <pre>
      JSP파일(View)에서의 서블릿에러가 발생시는 JSP파일 상단에 @page지시자를 이용한 에러페이지로 이동처리한다.
      < % @ page errorPage = "에러발생시 처리할 jsp파일 경로와 파일명" % >
    </pre>
    <p>
      <a href="${ctp}/errorPage/error1" class="btn btn-success">JSP 오류페이지호출</a>
    </p>
    <hr/>
    <pre>
      서블릿(servlet)에서의 에러가 발생시를 대비하여 처리하는 방법?
      - web.xml 에 error에 필요한 설정을 미리해두고 지정페이지로 보내준다.
        처리방법?(web.xml)
        < error-page>
          < error-code>에러발생코드번호(400/404/500)< /error-code>
          < location>에러발생시 호출할 컨트롤러...< /location>
        < /error-page>
    </pre>
    <p>
      <a href="${ctp}/0000000" class="btn btn-secondary mr-2">Servlet 오류(404오류)</a>
      <a href="${ctp}/errorPage/error500Check" class="btn btn-warning">Servlet 오류(500오류)</a>
    </p>
  </div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>