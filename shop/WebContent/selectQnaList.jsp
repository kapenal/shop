<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%@ page import="java.util.*"%>
<%
	Member loginMember = (Member)session.getAttribute("loginMember");
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 선택한 카테고리
	String categoryName = "";
	if(request.getParameter("categoryName") != null) {
		categoryName = request.getParameter("categoryName");
	}
	System.out.println(categoryName + "< 선택된 카테고리");
	// 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage + " < selectQnaList currentPage");
	// 한 페이지에 보여질 리스트의 행 수
	final int ROW_PER_PAGE = 10; // 상수 : 10으로 초기화와 동시에 끝까지 변하지 않는 수, 상수는 대문자로 표현
	// 화면에 보여질 페이지 번호의 갯수
	int displayPage = 10;
	// 목록 출력 시작
	int beginRow = (currentPage - 1) * ROW_PER_PAGE;
	System.out.println(beginRow + "< selectQnaList beginRow");
	// 화면에 보여질 시작 페이지 번호
	int startPage = ((currentPage - 1) / displayPage) * displayPage + 1;
	System.out.println(startPage + "< selectQnaList startPage");
	// 화면에 보여질 마지막 페이지 번호
	int endPage = startPage + displayPage - 1;
	System.out.println(endPage + "< selectQnaList endPage");
	// 전체 QnA 수
	QnaDao qnaDao = new QnaDao();
	// 회원 목록 출력 메서드 호출
	ArrayList<Qna> qnaList = null;
	int totalCount = 0;
	if(categoryName.equals("") == true) { // 카테고리 없을때
		qnaList = qnaDao.selectQnaList(beginRow, ROW_PER_PAGE);
		totalCount = qnaDao.selectQnaListAllByTotalPage();
	}else { // 카테고리 있을때 categoryName
		qnaList = qnaDao.selectQnaListByCategory(beginRow, ROW_PER_PAGE, categoryName);
		totalCount = qnaDao.selectQnaListAllByCategoryTotalPage(categoryName);
	}
	
	
	// 마지막 페이지 구하는 호출
	int lastPage = qnaDao.selectQnaListAllByLastPage(totalCount, ROW_PER_PAGE);
	System.out.println(lastPage + "< selectQnaList lastPage");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectQnaList.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<%
			if(session.getAttribute("loginMember") == null){
		%>
				<div style="text-align:right">
					<a href="<%=request.getContextPath()%>/loginForm.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none;">로그인</a> <a href="<%=request.getContextPath()%>/insertMemberForm.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none;"">회원가입</a>
				</div>
				<!-- 메인 메뉴 include 절대 주소 -->
				<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<%
			} else if(loginMember.getMemberLevel() < 1){
		%>
				<div style="text-align:right">
					<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/logOut.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none;">로그아웃</a>
				</div>
				<!-- 메인 메뉴 include 절대 주소 -->
				<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<%		
			} else if(loginMember.getMemberLevel() > 0){
		%>
				<div style="text-align:right">
					<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/logOut.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none;">로그아웃</a>
				</div>
				<!-- 관리자 메뉴 include 절대 주소 -->
				<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		<%	
			}
		%>
		<div class="jumbotron">
	         <h1>QnA게시판</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<div>
			<h2>QnA</h2>
		</div>
		<form action="<%=request.getContextPath()%>/selectQnaList.jsp">
			<select name="categoryName">
				<option value="">전체목록</option>
				<option value="전자책관련">전자책관련</option>
				<option value="개인정보관련">개인정보관련</option>
				<option value="기타">기타</option>
			</select>
			<button type="submit">선택</button>
		</form>
		<table class="table table-bordered">
			<thead>
				<tr>
					<th style="width:7%; text-align:center">No</th>
					<th style="width:12%; text-align:center">카테고리</th>
					<th>제목</th>
					<th style="width:10%; text-align:center">비밀글</th>
					<th style="width:10%; text-align:center">작성자</th>
					<th style="width:18%; text-align:center">작성 날짜</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(Qna q : qnaList){
				%>
						<tr>
							<td style="text-align:center"><%=q.getQnaNo()%></td>
							<td style="text-align:center"><%=q.getQnaCategory()%></td>
							<%
								if(q.getQnaSecret().equals("Y")){
									if(session.getAttribute("loginMember") == null){
							%>
										<td><%=q.getQnaTitle()%></td>
							<%	
									} else if (loginMember.getMemberNo() == q.getMemberNo() || loginMember.getMemberLevel() > 0) {
							%>		
										<td><a href="<%=request.getContextPath()%>/selectQnaOne.jsp?qnaNo=<%=q.getQnaNo()%>"><%=q.getQnaTitle()%></a></td>
							<%	
									} else{ // 작성자가 아닌 고객
							%>
										<td><%=q.getQnaTitle()%></td>
							<%		
									}
								} else{ // q.getQnaSecret == N
							%>
									<td><a href="<%=request.getContextPath()%>/selectQnaOne.jsp?qnaNo=<%=q.getQnaNo()%>"><%=q.getQnaTitle()%></a></td>
							<%	
								}
							%>
									
							<%	
								if(q.getQnaSecret().equals("Y")){
							%>		
									<td style="text-align:center"><img src="<%=request.getContextPath()%>/image/lock.png" width="60" height="30"></td>
							<%
								} else if(q.getQnaSecret().equals("N")){
							%>
									<td style="text-align:center"><img src="<%=request.getContextPath()%>/image/unlock.png" width="60" height="30"></td>
							<%		
								}
							%>
							
							<td style="text-align:center"><%=q.getMemberName()%></td>
							<td style="text-align:center"><%=q.getCreateDate()%></td>
						</tr>
				<%
					}
				%>
			</tbody>
		</table>
		<%
			if(session.getAttribute("loginMember") == null || loginMember.getMemberLevel() > 0){
				
			} else if(loginMember.getMemberLevel() < 1){
		%>
				<div style="text-align:right"><a href="<%=request.getContextPath()%>/insertQnaForm.jsp" class="btn btn-light">QnA 작성</a></div>
		<%
			}
			if(totalCount > ROW_PER_PAGE && currentPage > 1 ) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>/selectQnaList.jsp?categoryName=<%=categoryName%>">처음으로</a>
		<%
			}
			// 이전 버튼
			// 화면에 보여질 시작 페이지 번호가 화면에 보여질 페이지 번호의 갯수보다 크다면 이전 버튼을 생성
			if(currentPage > displayPage){
		%>
			<a class="btn btn-info" href="<%=request.getContextPath()%>/selectQnaList.jsp?currentPage=<%=startPage-1%>&categoryName=<%=categoryName%>">이전</a>
		<%
			}
			// 페이지 번호 버튼
			for(int i=startPage; i<=endPage; i++) {
				if(currentPage == i){
		%>
					<a class="btn btn-primary" href="<%=request.getContextPath()%>/selectQnaList.jsp?currentPage=<%=i%>&categoryName=<%=categoryName%>"><%=i%></a>
		<%	
			} else if(endPage<=lastPage) {
		%>
				<a class="btn btn-info" class="text-warning" href="<%=request.getContextPath()%>/selectQnaList.jsp?currentPage=<%=i%>&categoryName=<%=categoryName%>"><%=i%></a>
		<%
			} else if(endPage>lastPage) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>/selectQnaList.jsp?currentPage=<%=i%>&categoryName=<%=categoryName%>"><%=i%></a>
		<%	
			}
				// 카테고리 없을시 숫자 페이징이 10까지 나오는 것을 lastPage==0 을 if문에 or로 추가하여 이슈 해결
				if(i == lastPage || lastPage == 0) {	
					break;
				}
			}
			//다음 버튼
			// 화면에 보여질 마지막 페이지 번호가 마지막페이지보다 작다다면 이전 버튼을 생성
			if(endPage < lastPage) {
		%>
			<a class="btn btn-info" href="<%=request.getContextPath()%>/selectQnaList.jsp?currentPage=<%=startPage+displayPage%>&categoryName=<%=categoryName%>">다음</a>
		<%
			}
			// totalCount가 10보다 크면 다음페이지가 있기때문에 끝으로 보이도록 설정
			if(totalCount > ROW_PER_PAGE && currentPage != lastPage ) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>selectQnaList.jsp?currentPage=<%=lastPage%>&categoryName=<%=categoryName%>">끝으로</a>
		<%
			}
		%>
	</div>
</body>
</html>