<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		System.out.println("관리자계정으로 로그인하십시오.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	
	// 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	OrderDao orderDao = new OrderDao();
	
	// 한 페이지에 보여질 리스트의 행 수
	final int ROW_PER_PAGE = 10; // 상수 : 10으로 초기화와 동시에 끝까지 변하지 않는 수, 상수는 대문자로 표현
	int beginRow = (currentPage - 1) * ROW_PER_PAGE;
	System.out.println(beginRow + "< selectOrderList beginRow");
	// 전체 회원 수
	int totalCount = 0;
	// 주문 목록 출력 메서드 호출
	ArrayList<OrderEbookMember> list = orderDao.selectOrderList(beginRow, ROW_PER_PAGE);
	totalCount = orderDao.selectOrderListAllByTotalPage();
	// 화면에 보여질 페이지 번호의 갯수
	int displayPage = 10;
	System.out.println(displayPage + "selectOrderList displayPage");
	// 화면에 보여질 시작 페이지 번호
	// (currentPage - 1)을 하는 이유는 현재페이지가 10일시에도 startPage가 1이기 위해서
	int startPage = ((currentPage - 1) / displayPage) * displayPage + 1;
	System.out.println(startPage + "< selectOrderList startPage");
	// 화면에 보여질 마지막 페이지 번호
	// -1을 하는 이유는 페이지 번호의 갯수가 10개이기 때문에 statPage에서 더한 1을 빼준다
	int endPage = startPage + displayPage - 1;
	System.out.println(endPage + "< selectOrderList endPage");
	// 마지막 페이지 구하는 호출
	int lastPage = orderDao.selectOrderListAllByLastPage(totalCount, ROW_PER_PAGE);
	System.out.println(lastPage + " < selectOrderList lastPage");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectOrderList.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<div style="text-align:right">
			<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/insertMemberForm.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none;">로그아웃</a>
		</div>
		<!-- 관리자 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>주문 관리</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<div>
			<h2>주문 목록</h2>
		</div>
		<table class="table table-bordered">
			<thead>
				<tr>
					<th style="width:9%; text-align:center">주문 번호</th>
					<th>책 제목</th>
					<th style="width:8%; text-align:center">가격</th>
					<th style="width:18%; text-align:center">주문 날짜</th>
					<th style="width:12%; text-align:center">구매자ID</th>
					<th style="width:12%; text-align:center">상세주문내역</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(OrderEbookMember oem : list){
				%>
						<tr>
							<td style="text-align:center"><%=oem.getOrder().getOrderNo()%></td>
							<td><a href="<%=request.getContextPath()%>/admin/selectEbookOne.jsp?ebookNo=<%=oem.getEbook().getEbookNo()%>"><%=oem.getEbook().getEbookTitle()%></a></td>
							<td style="text-align:center"><%=oem.getOrder().getOrderPrice()%>원</td>
							<td style="text-align:center"><%=oem.getOrder().getCreateDate()%></td>
							<td style="text-align:center"><a href="<%=request.getContextPath()%>/admin/selectMemberList.jsp?searchMemberId=<%=oem.getMember().getMemberId()%>"><%=oem.getMember().getMemberId()%></a></td>
							<td style="text-align:center"><a href="<%=request.getContextPath()%>/admin/selectOrderOne.jsp?orderNo=<%=oem.getOrder().getOrderNo()%>">상세주문내역</a></td>
						</tr>
				<%
					}
				%>
			</tbody>
		</table>
		<br>
		<%
			if(totalCount > ROW_PER_PAGE && currentPage > 1 ) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>/admin/selectOrderList.jsp?currentPage=1">처음으로</a>
		<%
			}
			// 이전 버튼
			// 화면에 보여질 시작 페이지 번호가 화면에 보여질 페이지 번호의 갯수보다 크다면 이전 버튼을 생성
			if(currentPage > displayPage){
		%>
			<a class="btn btn-info" href="<%=request.getContextPath()%>/admin/selectOrderList.jsp?currentPage=<%=startPage-1%>">이전</a>
		<%
			}
			// 페이지 번호 버튼
			for(int i=startPage; i<=endPage; i++) {
				if(currentPage == i){
		%>
					<a class="btn btn-primary" href="<%=request.getContextPath()%>/admin/selectOrderList.jsp?currentPage=<%=i%>"><%=i%></a>
		<%	
			} else if(endPage<=lastPage) {
		%>
				<a class="btn btn-info" class="text-warning" href="<%=request.getContextPath()%>/admin/selectOrderList.jsp?currentPage=<%=i%>"><%=i%></a>
		<%
			} else if(endPage>lastPage) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>/admin/selectOrderList.jsp?currentPage=<%=i%>"><%=i%></a>
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
			<a class="btn btn-info" href="<%=request.getContextPath()%>/admin/selectOrderList.jsp?currentPage=<%=startPage+displayPage%>">다음</a>
		<%
			}
			// totalCount가 10보다 크면 다음페이지가 있기때문에 끝으로 보이도록 설정
			if(totalCount > ROW_PER_PAGE && currentPage != lastPage ) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>/admin/selectOrderList.jsp?currentPage=<%=lastPage%>">끝으로</a>
		<%
			}
		%>
	</div>
</body>
</html>