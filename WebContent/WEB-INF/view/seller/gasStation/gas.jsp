<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>board</title>
	<%@ include file="/WEB-INF/view/seller/topCssScript.jsp" %>
	<!-- services 라이브러리 불러오기 -->
	
	<link rel="stylesheet" href="//cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" />
	
	<!--  naver 좌표체계 변환  -->
	<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=1AOZXftrFTOi40E42F3H&submodules=geocoder"></script>
	<!-- content +='<script type="text/javascript"> src="//dapi.kakao.com/v2/maps/sdk.js?appkey=APIKEY&libraries=services,clusterer,drawing"> ';
	content +='<\/script>' -->	
	<!-- 주유 css 시작 -->
	<style>
		.gas{
			/* border:1px solid black; */
			
		}
		.gas_find{
		 height:100%;
		}
		.gas_loc{
		
		height: 50px;
			
		}
		.gas_main{
			margin:0 auto;
		}
		#gas_map{
			background-color:gray;
			width:100%;
			height:300px;
			float:left;
		}
		.gas_li{
			border:1px solid black;
			width:100%;
			height:100%;
			float:left;
		  }
		 /* select{
		 width:30%;
		 margin-right:30px;
		 } */
		 
		 
		 
		.map_wrap, .map_wrap * {margin:0; padding:0;font-family:'Malgun Gothic',dotum,'돋움',sans-serif;font-size:12px;}
		.map_wrap {position:relative;width:100%;height:350px;}
		#category {position:absolute;top:10px;left:10px;border-radius: 5px; border:1px solid #909090;box-shadow: 0 1px 1px rgba(0, 0, 0, 0.4);background: #fff;overflow: hidden;z-index: 2;}
		#category li {float:left;list-style: none;width:50px;px;border-right:1px solid #acacac;padding:6px 0;text-align: center; cursor: pointer;}
		#category li.on {background: #eee;}
		#category li:hover {background: #ffe6e6;border-left:1px solid #acacac;margin-left: -1px;}
		#category li:last-child{margin-right:0;border-right:0;}
		#category li span {display: block;margin:0 auto 3px;width:27px;height: 28px;}
		#category li .category_bg {background:url(http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_category.png) no-repeat;}
		#category li .bank {background-position: -10px 0;}
		#category li .mart {background-position: -10px -36px;}
		#category li .pharmacy {background-position: -10px -72px;}
		#category li .oil {background-position: -10px -108px;}
		#category li .cafe {background-position: -10px -144px;}
		#category li .store {background-position: -10px -180px;}
		#category li.on .category_bg {background-position-x:-46px;}
		.placeinfo_wrap {position:absolute;bottom:28px;left:-150px;width:300px;}
		.placeinfo {position:relative;width:100%;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;padding-bottom: 10px;background: #fff;}
		.placeinfo:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;}
		.placeinfo_wrap .after {content:'';position:relative;margin-left:-12px;left:50%;width:22px;height:12px;background:url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
		.placeinfo a, .placeinfo a:hover, .placeinfo a:active{color:#fff;text-decoration: none;}
		.placeinfo a, .placeinfo span {display: block;text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
		.placeinfo span {margin:5px 5px 0 5px;cursor: default;font-size:13px;}
		.placeinfo .title {font-weight: bold; font-size:14px;border-radius: 6px 6px 0 0;margin: -1px -1px 0 -1px;padding:10px; color: #fff;background: #d95050;background: #d95050 url(http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center;}
		.placeinfo .tel {color:#0f7833;}
		.placeinfo .jibun {color:#999;font-size:11px;margin-top:0;}
	</style>
	<!-- <iframe src="" -->
<!-- 주유 css 끝-->
	<script type="text/javascript">
	$(function(){
		//지도시작
		var container = document.getElementById('gas_map');
		var options = {
			center: new daum.maps.LatLng(37.550089, 126.842257),
			level: 3
		};

		var map = new daum.maps.Map(container, options);
		
		
		// 마커가 표시될 위치입니다 
		var markerPosition  = new daum.maps.LatLng(37.550089, 126.842257); 

		// 마커를 생성합니다
		var marker = new daum.maps.Marker({
		    position: markerPosition
		});
		// 마커가 지도 위에 표시되도록 설정합니다
		marker.setMap(map);
		// 아래 코드는 지도 위의 마커를 제거하는 코드입니다
		// marker.setMap(null);  
		// 마커를 클릭했을 때 해당 장소의 상세정보를 보여줄 커스텀오버레이입니다
			        var placeOverlay = new daum.maps.CustomOverlay({zIndex:1}), 
			            contentNode = document.createElement('div'), // 커스텀 오버레이의 컨텐츠 엘리먼트 입니다 
			            markers = [], // 마커를 담을 배열입니다
			            currCategory = ''; // 현재 선택된 카테고리를 가지고 있을 변수입니다

			        // 장소 검색 객체를 생성합니다
			        var ps = new daum.maps.services.Places(map); 

			        // 지도에 idle 이벤트를 등록합니다
			        daum.maps.event.addListener(map, 'idle', searchPlaces);

			        // 커스텀 오버레이의 컨텐츠 노드에 css class를 추가합니다 
			        contentNode.className = 'placeinfo_wrap';

			        // 커스텀 오버레이의 컨텐츠 노드에 mousedown, touchstart 이벤트가 발생했을때
			        // 지도 객체에 이벤트가 전달되지 않도록 이벤트 핸들러로 daum.maps.event.preventMap 메소드를 등록합니다 
			        addEventHandle(contentNode, 'mousedown', daum.maps.event.preventMap);
			        addEventHandle(contentNode, 'touchstart', daum.maps.event.preventMap);

			        // 커스텀 오버레이 컨텐츠를 설정합니다
			        placeOverlay.setContent(contentNode);  

			        // 각 카테고리에 클릭 이벤트를 등록합니다
			        addCategoryClickEvent();

			        // 엘리먼트에 이벤트 핸들러를 등록하는 함수입니다
			        function addEventHandle(target, type, callback) {
			            if (target.addEventListener) {
			                target.addEventListener(type, callback);
			            } else {
			                target.attachEvent('on' + type, callback);
			            }
			        }
			        // 카테고리 검색을 요청하는 함수입니다
			        function searchPlaces() {
			            if (!currCategory) {
			                return;
			            }
			            
			            // 커스텀 오버레이를 숨깁니다 
			            placeOverlay.setMap(null);

			            // 지도에 표시되고 있는 마커를 제거합니다
			            removeMarker();
			            
			            ps.categorySearch(currCategory, placesSearchCB, {useMapBounds:true}); 
			        }
			        // 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
			        function placesSearchCB(data, status, pagination) {
			            if (status === daum.maps.services.Status.OK) {

			                // 정상적으로 검색이 완료됐으면 지도에 마커를 표출합니다
			                displayPlaces(data);
			            } else if (status === daum.maps.services.Status.ZERO_RESULT) {
			                // 검색결과가 없는경우 해야할 처리가 있다면 이곳에 작성해 주세요

			            } else if (status === daum.maps.services.Status.ERROR) {
			                // 에러로 인해 검색결과가 나오지 않은 경우 해야할 처리가 있다면 이곳에 작성해 주세요
			                
			            }
			        }
			        // 지도에 마커를 표출하는 함수입니다
			        function displayPlaces(places) {

			            // 몇번째 카테고리가 선택되어 있는지 얻어옵니다
			            // 이 순서는 스프라이트 이미지에서의 위치를 계산하는데 사용됩니다
			            var order = document.getElementById(currCategory).getAttribute('data-order');

			            

			            for ( var i=0; i<places.length; i++ ) {

			                    // 마커를 생성하고 지도에 표시합니다
			                    var marker = addMarker(new daum.maps.LatLng(places[i].y, places[i].x), order);

			                    // 마커와 검색결과 항목을 클릭 했을 때
			                    // 장소정보를 표출하도록 클릭 이벤트를 등록합니다
			                    (function(marker, place) {
			                        daum.maps.event.addListener(marker, 'click', function() {
			                            displayPlaceInfo(place);
			                        });
			                    })(marker, places[i]);
			            }
			        }
			        // 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
			        function addMarker(position, order) {
			            var imageSrc = 'http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_category.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
			                imageSize = new daum.maps.Size(27, 28),  // 마커 이미지의 크기
			                imgOptions =  {
			                    spriteSize : new daum.maps.Size(72, 208), // 스프라이트 이미지의 크기
			                    spriteOrigin : new daum.maps.Point(46, (order*36)), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
			                    offset: new daum.maps.Point(11, 28) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
			                },
			                markerImage = new daum.maps.MarkerImage(imageSrc, imageSize, imgOptions),
			                    marker = new daum.maps.Marker({
			                    position: position, // 마커의 위치
			                    image: markerImage 
			                });

			            marker.setMap(map); // 지도 위에 마커를 표출합니다
			            markers.push(marker);  // 배열에 생성된 마커를 추가합니다

			            return marker;
			        }

			        // 지도 위에 표시되고 있는 마커를 모두 제거합니다
			        function removeMarker() {
			            for ( var i = 0; i < markers.length; i++ ) {
			                markers[i].setMap(null);
			            }   
			            markers = [];
			        }
			        // 클릭한 마커에 대한 장소 상세정보를 커스텀 오버레이로 표시하는 함수입니다
			        function displayPlaceInfo (place) {
			            var content = '<div class="placeinfo">' +
			                            '   <a class="title" href="' + place.place_url + '" target="_blank" title="' + place.place_name + '">' + place.place_name + '</a>';   

			            if (place.road_address_name) {
			                content += '    <span title="' + place.road_address_name + '">' + place.road_address_name + '</span>' +
			                            '  <span class="jibun" title="' + place.address_name + '">(지번 : ' + place.address_name + ')</span>';
			            }  else {
			                content += '    <span title="' + place.address_name + '">' + place.address_name + '</span>';
			            }                
			           
			            content += '    <span class="tel">' + place.phone + '</span>' + 
			                        '</div>' + 
			                        '<div class="after"></div>';

			            contentNode.innerHTML = content;
			            placeOverlay.setPosition(new daum.maps.LatLng(place.y, place.x));
			            placeOverlay.setMap(map);  
			        }
			        // 각 카테고리에 클릭 이벤트를 등록합니다
			        function addCategoryClickEvent() {
			            var category = document.getElementById('category'),
			                children = category.children;

			            for (var i=0; i<children.length; i++) {
			                children[i].onclick = onClickCategory;
			            }
			        }
			        // 카테고리를 클릭했을 때 호출되는 함수입니다
			        function onClickCategory() {
			            var id = this.id,
			                className = this.className;

			            placeOverlay.setMap(null);

			            if (className === 'on') {
			                currCategory = '';
			                changeCategoryClass();
			                removeMarker();
			            } else {
			                currCategory = id;
			                changeCategoryClass(this);
			                searchPlaces();
			            }
			        }
			        // 클릭된 카테고리에만 클릭된 스타일을 적용하는 함수입니다
			        function changeCategoryClass(el) {
			            var category = document.getElementById('category'),
			                children = category.children,
			                i;

			            for ( i=0; i<children.length; i++ ) {
			                children[i].className = '';
			            }

			            if (el) {
			                el.className = 'on';
			            } 
			        } 
		
		$('#GasBtn').click(function(){
			var sido = $('#sido').val();
			var gugun = $('#gugun').val();
			var dong = $('#dong').val();
			var search = sido + gugun + dong ;
			var prodcd =$('#prodcd option:selected').val();
			var text = $('#prodcd option:selected').text();
			var x;
			var y;
			var tm128;
			
			alert(text);
			
			var geocoder = new daum.maps.services.Geocoder();
			// 주소로 좌표를 검색합니다
			geocoder.addressSearch(search, function(result, status) {

			    // 정상적으로 검색이 완료됐으면 
			     if (status === daum.maps.services.Status.OK) {

			        var coords = new daum.maps.LatLng(result[0].y, result[0].x);
			        console.log("좌표따기 :" +coords);
			       	console.log("result[0].y" + result[0].y);
			       	console.log("result[0].x" + result[0].x);
			       	
			    	
			        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
			        map.setCenter(coords);
					
			      
			        // 결과값으로 받은 위치를 마커로 표시합니다
			        var marker = new daum.maps.Marker({
			            map: map,
			            position: coords
			        });

			        // 인포윈도우로 장소에 대한 설명을 표시합니다
			        var infowindow = new daum.maps.InfoWindow({
			            content: '<div style="width:150px;text-align:center;padding:6px 0;">현재위치</div>'
			        });
			        infowindow.open(map, marker);

			        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
			        map.setCenter(coords);
			        console.log("COORD :"+coords);
			        console.log("y :"+result[0].y);
			        console.log("x :"+result[0].x);
			        x = result[0].x;
			        y = result[0].y;
			        
			        var latlng = new naver.maps.LatLng(y, x); // 서울시청 위/경도 좌표

			        var utmk = naver.maps.TransCoord.fromLatLngToUTMK(latlng); // 위/경도 -> UTMK
			        	tm128 = naver.maps.TransCoord.fromUTMKToTM128(utmk);   // UTMK -> TM128
			        var naverCoord = naver.maps.TransCoord.fromTM128ToNaver(tm128); // TM128 -> NAVER
			        
			        console.log("latlng : " + latlng);
			        console.log("utmk : "+ utmk);
			        console.log("tm128 : " + tm128);
			        console.log("navercoord : " + naverCoord);
			        console.log("tm128 x : " + tm128.x);
			        console.log("tm128 y : " + tm128.y);
			        x = tm128.x;
			        y = tm128.y;
			       // 
			       
			        $.ajax({
						
						url :'/gasStation/test.do',	
						method : 'post',
						data : {
							'x' : x,
							'y' : y,
							'tm128' : tm128,
							'prodcd' : prodcd
							},
						success : function(data){
							console.log(data);
							var result = data.RESULT.OIL;
							console.log("result"+result);
							console.log("result.OS_NM"+result[0].OS_NM);
							var contentLi ='';
								contentLi +='<table border="1px solid black" width="100%" height="100%" id="gasList">';
								contentLi +='<thead>';
								contentLi +='<tr>';
								contentLi +='<th height="50px;">주유소 이름</th>';
								contentLi +='<th>유종</th>';
								contentLi +='<th>가격</th>';
								contentLi +='</tr>';
								contentLi += '</thead>';
								contentLi +='<tbody>';
								
								$.each(result,function (key,value){
									console.log(value.OS_NM);
									console.log(data.RESULT.OIL.OS_NM);
									contentLi +='<tr>';
									contentLi +='<td height="50px;">'+value.OS_NM+'</td>';
									contentLi +='<td>'+text+'</td>';
									contentLi +='<td>'+value.PRICE+'원</td>';
									contentLi +='</tr>';
					
								}); 
								contentLi +='</tbody>';
								contentLi +='</table>';
								console.log(contentLi);
								//리스트 테이블 옵션 
								$('#gasli').html(contentLi); 
								$('#gasList').DataTable({
									"pageLength": 5,
									"lengthMenu": [ 5, 10, 15 ],
									"pagingType": "simple",
								    "order": [[2,'asc']],
								    "searching": false,
								    "info": false
								});
						}
					}) 
			     } 
			});
		});
	});
	</script>

</head>
<body>
	<table style="height: 100%; width: 100%">
		<tr height="7%" bgcolor="#444">
			<td style="padding:0;">
				<%@ include file="/WEB-INF/view/seller/top.jsp" %>
				<script src="//cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
			</td>
		</tr>
		<tr bgcolor="">
			<td>
			<div class="container">
			<h2>주유정보</h2><small>제공 : daum 지도 ,한국석유공사 Opinet</small>
				<hr />
					<div class="gas">
						<div class="gas_loc">
						<h3>
						<small>지역별 주유소 찾기</small>
						</h3>
						</div>
						<div class="gas_find">
							<div class="col-sm-12">
								<div class="col-sm-8">
									<%@ include file="/WEB-INF/view/seller/gasStation/locSelect.jsp" %>
								</div>
								<div class="col-sm-3" sytle="padding:0;">
									<select id="prodcd" class="col-sm-12">
										<option id="prodcd1" name="gasoline" value="B027">휘발유</option>
										<option id="prodcd2" name="Diesel" value="D047">경유</option>
										<option id="prodcd3" name="kerosene" value="C004">실내등유</option>
									</select>
								</div>
								<div>
								
									<input type="button" class="btn btn-primary col-sm-1" value="검색" id="GasBtn"/>
								</div>
							</div>
						</div>
						<div class="gas_main">
							<div id="gas_map">지도
							<div class="map_wrap">
							    <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
								    <ul id="category"> 
								      
								        <li id="OL7" data-order="3"> 
								            <span class="category_bg oil"></span>
								   		         주유소
								        </li>  
								        <li id="CE7" data-order="4"> 
								            <span class="category_bg cafe"></span>
								      	      카페
								        </li>  
								        <li id="CS2" data-order="5"> 
								            <span class="category_bg store"></span>
								          	  편의점
								        </li>      
								    </ul>
								</div>
							</div>
							<div class="gas_li" id="gasli">
								<table border="1px solid black" width="100%" height="100%" id="test">
									<tr>
										<td height="50px;">주유소 이름</td>
										<td>휘발유</td>
										<td>가격</td>
									</tr>
									<tr>
										<td height="50px;">SK</td>
										<td>휘발유</td>
										<td>1,510원</td>
									</tr>
									<tr>
										<td height="50px;">GS</td>
										<td>휘발유</td>
										<td>1,519원</td>
									</tr>
									<tr>
										<td height="50px;">SK</td>
										<td>휘발유</td>
										<td>1,520원</td>
									</tr>
									<tr>
										<td height="50px;">GS</td>
										<td>휘발유</td>
										<td>1,521원</td>
									</tr>
								</table>
							</div>
						</div>
					</div>
				<!-- 지도 구현  script 시작 -->
				<!-- 지도 구현 script  끝-->
			</div>
			</td>
		</tr>
		<tr height="7%" style="background-color:#444">
			<td>
				<%@ include file="/WEB-INF/view/seller/bottom.jsp" %>
			
			</td>
		</tr>
	</table>
</body>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c449b1cbc3c291def2d6edada3e87082&libraries=services,clusterer,drawing"></script>
</html>