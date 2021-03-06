<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		System.out.println("관리자계정으로 로그인하십시오.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 방어 코드
	if(request.getParameter("memberNo")==null || request.getParameter("searchMemberId")==null || request.getParameter("currentPage")==null){
		response.sendRedirect(request.getContextPath()+"/admin/selectMemberList.jsp");
		return;
	}
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String searchMemberId = request.getParameter("searchMemberId");
	int currentPage = Integer.parseInt(request.getParameter("currentPage"));
	// 디버깅
	System.out.println(memberNo + " < updateMemberPwForm.jsp param : memberNo");
	
	MemberDao memberDao = new MemberDao();
	Member member = memberDao.selectMemberOne(memberNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateMemberPwForm.jsp</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
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
	         <h1>비밀번호 수정</h1>
		</div>
		<form id="updatePwForm" method="post" action="<%=request.getContextPath()%>/admin/updateMemberPwAction.jsp?memberNo=<%=memberNo%>&searchMemberId=<%=searchMemberId%>&currentPage=<%=currentPage%>">
			 <table class="table table-bordered">
			 	<tr>
					<td>번호</td>
					<td><input type="text" name="memberNo" value="<%=member.getMemberNo()%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>아이디</td>
					<td><input type="text" name="memberId" value="<%=member.getMemberId()%>" readonly="readonly"></td>
				</tr>
			 	<tr>
					<td>변경할 비밀번호를 입력하세요</td>
					<td><input type="password" id="memberNewPw" name="memberNewPw"></td>
				</tr>
			 </table>
			 <button id="updatePwBtn"type="button" class="btn btn-light">비밀번호 수정</button>
			 <a href ="<%=request.getContextPath()%>/admin/selectMemberList.jsp?searchMemberId=<%=searchMemberId%>&currentPage=<%=currentPage%>" class="btn btn-light">취소</a>
		</form>
	</div>
	<script>
		$('#updatePwBtn').click(function(){
			if($('#memberNewPw').val() == '') { // 변경할 비밀번호가 공백이면
				alert('변경할 비밀번호를 입력하세요');
				return;
			}
			$('#updatePwForm').submit();
		});
	</script>
</body>
</html>