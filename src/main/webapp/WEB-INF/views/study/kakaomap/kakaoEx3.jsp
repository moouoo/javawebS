<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>kakaoEx3.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <script>
    function addressSave() {
    	var selectAddress = myform.selectAddress.value;
    	var latitude = myform.latitude.value;
    	var longitude = myform.longitude.value;
    	
    	if(latitude == "" || longitude == "") {
    		alert("저장할 지점을 선택하세요");
    		myform.selectAddress.focus();
    		return false;
    	}
    	
    	var query = {
    			address  : selectAddress,
    			latitude : latitude,
    			longitude: longitude
    	}
    	
    	$.ajax({
    		type  : "post",
    		url   : "${ctp}/study/kakaomap/kakaoEx1",
    		data  : query,
    		success:function(res) {
    			if(res != "1") alert("같은 지점이 있습니다. 이름을 변경해서 다시 등록하세요.");
    			else alert("선택한 지점이 DB에 저장되었습니다.");
    		},
    		error : function() {
    			alert("전송오류!");
    		}
    	})
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>지명으로 위치검색후 카카오DB에 저장된 '위도/경도'를 알아내어, 내 DB에 저장하기(${address})</h2>
  <form name="myform">
    <p>키워드검색 :
      <input type="text" name="address" id="address" autofocus required />
      <input type="submit" value="키워드검색처리" />
      <input type="button" value="검색된지점을 내DB에 넣기" onclick="addressSave()" />
      <span id="demo"></span>
    </p>
    <input type="hidden" name="selectAddress" id="selectAddress" />
    <input type="hidden" name="latitude" id="latitude" />
    <input type="hidden" name="longitude" id="longitude" />
  </form>
  
<div id="map" style="width:100%;height:500px;"></div>

	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=158c673636c9a17a27b67c95f2c6be5c&libraries=services"></script>
	<script>
	// 마커를 클릭하면 장소명을 표출할 인포윈도우 입니다
	var infowindow = new kakao.maps.InfoWindow({zIndex:1});
	
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = {
	        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
	        level: 3 // 지도의 확대 레벨
	    };  
	
	// 지도를 생성합니다    
	var map = new kakao.maps.Map(mapContainer, mapOption); 
	
	// 장소 검색 객체를 생성합니다
	var ps = new kakao.maps.services.Places(); 
	
	// 키워드로 장소를 검색합니다
	ps.keywordSearch('${address}', placesSearchCB); 
	
	// 키워드 검색 완료 시 호출되는 콜백함수 입니다
	function placesSearchCB (data, status, pagination) {
	    if (status === kakao.maps.services.Status.OK) {
	
	        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
	        // LatLngBounds 객체에 좌표를 추가합니다
	        var bounds = new kakao.maps.LatLngBounds();
	
	        for (var i=0; i<data.length; i++) {
	            displayMarker(data[i]);    
	            bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));
	        }       
	
	        // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
	        map.setBounds(bounds);
	    } 
	}
	
	// 지도에 마커를 표시하는 함수입니다
	function displayMarker(place) {
	    
	    // 마커를 생성하고 지도에 표시합니다
	    var marker = new kakao.maps.Marker({
	        map: map,
	        position: new kakao.maps.LatLng(place.y, place.x) 
	    });
	
	    // 마커에 클릭이벤트를 등록합니다
	    kakao.maps.event.addListener(marker, 'click', function() {
	        // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
	        infowindow.setContent('<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>');
	        infowindow.open(map, marker);
	        
	        //alert(place.place_name + "/" + place.y + "/" + place.x);
	        $("#selectAddress").val(place.place_name);
	        $("#latitude").val(place.y);
	        $("#longitude").val(place.x);
	        $("#demo").html("장소명:"+place.place_name+" , 위도:"+place.y+" , 경도:"+place.x);
	    });
	}
	</script>
  
  
	<hr/>
	<jsp:include page="kakaoMenu.jsp" />
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>