<%@page import="com.dang.diary.model.service.DiaryService"%>
<%@page import="com.dang.diary.model.vo.Diary"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/include/header.jsp"%>

<!--페이징-->
<%@page import="java.util.List"%>
<%@page import="com.dang.member.school.model.vo.SchoolMember"%>
<%@page import="com.dang.diary.model.vo.Diary"%>
<%@page import="com.dang.diary.model.service.DiaryService"%>
<%@page import="javax.servlet.http.HttpSession"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, user-scalable=no" />
	<link rel="stylesheet" href="/previous/resources/css/main.css" />
	<link rel="stylesheet" href="/previous/resources/css/diaryView.css" />
	<link rel="preconnect" href="https://fonts.gstatic.com">
	<!-- <link href="https://fonts.googleapis.com/css2?family=Gamja+Flower&display=swap" rel="stylesheet"> -->
	<link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet">	
	
	<!--글씨 체-->
	<link rel="preconnect" href="https://fonts.gstatic.com">
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
	<!--     -->
	
	<noscript>
		<link rel="stylesheet" href="/previous/resources/css/noscript.css" />
	</noscript>
</head>
<body class="is-preload">

	<!-- Page Wrapper -->
	<div id="page-wrapper">

		<!-- Header -->
		<header id="header">
			<h1>
				<div id="dangmark"></div>
				<a href="/main.do" id="headermain" class="mainfont">댕댕아 놀면 뭐하니?</a>
			</h1>
			<nav id="nav">
				<ul>
					<li class="special"><a href="#menu" class="menuToggle"><span>Menu</span></a>
						<div id="menu">
							<ul>
								<li><a href="/main.do">Home</a></li>
								<c:choose>
									<c:when test ="${sessionScope.schoolMember != null}"><li><a href="/school/schoolpage.do">마이페이지</a></li></c:when>
									<c:when test ="${sessionScope.userMember != null}"><li><a href="/user/userpage.do">마이페이지</a></li></c:when>
								</c:choose>
								<li><a href="/map/map.do">유치원 찾기</a></li>
								<li><a href="/reservation/calendar.do">캘린더</a></li>
								<c:choose>
									<c:when test ="${sessionScope.schoolMember != null}"><li><a href="/school/logout.do">로그아웃</a></li></c:when>
									<c:when test ="${sessionScope.userMember != null}"><li><a href="/user/logout.do">로그아웃</a></li></c:when>
								</c:choose>
							</ul>
						</div></li>
				</ul>
			</nav>
		</header>


<%

	HttpSession KgNameSession = request.getSession();
	SchoolMember kgName = (SchoolMember) KgNameSession.getAttribute("schoolMember");
	
	int pageSize = 5; // 한 페이지에 출력할 레코드 수

	// 페이지 링크를 클릭한 번호 / 현재 페이지
	String pageNum = request.getParameter("pageNum");
	if (pageNum == null){ // 클릭한게 없으면 1번 페이지
		pageNum = "1";
	}
	// 연산을 하기 위한 pageNum 형변환 / 현재 페이지
	int currentPage = Integer.parseInt(pageNum);

	// 해당 페이지에서 시작할 레코드 / 마지막 레코드
	int startRow = (currentPage - 1) * pageSize + 1;
	int endRow = currentPage * pageSize;

 	int count = 0;
	
 	DiaryService diaryService = new DiaryService();
	
	count = diaryService.selectCountPage(kgName.getKgName()); // 데이터베이스에 저장된 총 갯수
	System.out.println(count);

 	List<Diary> list = null;
	if (count > 0) {
		// getList()메서드 호출 / 해당 레코드 반환
		list = diaryService.selectDiaryPage(startRow, endRow, kgName.getKgName());		
		System.out.println("view.jsp"+list);

	}  
%>

	<!-- Main -->

		<div class="board">
			<div id = "wrap">
				<div id = "title">알림장</div>
				<center>
					<table class = "table" align="center">
						<thead>
							<tr  align="center">
								<td class = "infrm" width="7%">번호</td>
								<td class = "infrm" width="7%">작성자</td>
								<td class = "infrm" width="7%">제목</td>
								<td class = "infrm" width="10%">작성일</td>							
							</tr>
						</thead>
						<%
							if (count > 0 ) { // 데이터베이스에 데이터가 있으면
								for (int i = 0; i < list.size(); i++) {
									Diary diary = list.get(i);
									// 반환된 list에 담긴 참조값 할당
						%>
						<tr  align="center">
							<td class = "bdIdx"><a href="/diary/detail.do?bdIdx=<%=diary.getBdDiaryIdx()%>"><%=diary.getBdDiaryIdx()%></a></td>
							<td><%=diary.getKgName()%></td>
							<td><%=diary.getTitle()%></td>
							<td><%=diary.getRegDate()%></td>							
						</tr>
						<%
								}
							} else { // 데이터가 없으면
						%>
							<script>
								alert("등록된 알림이 없습니다")
							</script>
							<%
								}
							%>
							
						<tr>
							<td align="center" colspan="4" style="font-size: 0.7vw">
								<%	// 페이징  처리
									if(count > 0){
										// 총 페이지의 수
										int pageCount = count / pageSize + (count%pageSize == 0 ? 0 : 1);
										// 한 페이지에 보여줄 페이지 블럭(링크) 수
										int pageBlock = 10;
										// 한 페이지에 보여줄 시작 및 끝 번호(예 : 1, 2, 3 ~ 10 / 11, 12, 13 ~ 20)
										int startPage = ((currentPage-1)/pageBlock)*pageBlock+1;
										int endPage = startPage + pageBlock - 1;
										
										// 마지막 페이지가 총 페이지 수 보다 크면 endPage를 pageCount로 할당
										if(endPage > pageCount){
											endPage = pageCount;
										}
										
										if(startPage > pageBlock){ // 페이지 블록수보다 startPage가 클경우 이전 링크 생성
								%>
											<a href="/diary/kindergardenview.do?pageNum=<%=startPage - 10%>">[이전]</a>	
								<%			
										}
										
										for(int i=startPage; i <= endPage; i++){ // 페이지 블록 번호
											if(i == currentPage){ // 현재 페이지에는 링크를 설정하지 않음
								%>
												[<%=i %>]
								<%									
											}else{ // 현재 페이지가 아닌 경우 링크 설정
								%>
												<a href="/diary/kindergardenview.do?pageNum=<%=i%>">[<%=i %>]</a>
								<%	
											}
										} // for end
										
										if(endPage < pageCount){ // 현재 블록의 마지막 페이지보다 페이지 전체 블록수가 클경우 다음 링크 생성
								%>
											<a href="/diary/kindergardenview.do?pageNum=<%=startPage + 10 %>">[다음]</a>
								<%			
										}
									}
								%>
							</td>
						</tr>
					</table>
				</center>
			
			
				<div id = "write">
					<button id ="writeBtn"><a href="/diary/write.do">글쓰기</a></button>
				</div>
			</div>
		</div>
		
		
		
		<!-- Footer -->
		<footer id="footer">
			<div id = "footerMark">&copy;댕댕아놀면뭐하니?</div>
		</footer>

	</div>
	
	


	<!-- Scripts -->
	<script src="/previous/resources/js/jquery.min.js"></script>
	<script src="/previous/resources/js/jquery.scrollex.min.js"></script>
	<script src="/previous/resources/js/jquery.scrolly.min.js"></script>
	<script src="/previous/resources/js/browser.min.js"></script>
	<script src="/previous/resources/js/breakpoints.min.js"></script>
	<script src="/previous/resources/js/util.js"></script>
	<script src="/previous/resources/js/main.js"></script>

</body>
</html>