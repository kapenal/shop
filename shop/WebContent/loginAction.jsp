<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	//인증 방어 코드 : 로그인 전에만 페이지 열람 가능
	if(session.getAttribute("loginMember") != null){
		System.out.println("이미 로그인 되어 있습니다.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 파라메터값 받기
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	//  디버깅 코드
	System.out.println(memberId + " < loginAction param : memberId");
	System.out.println(memberPw + " < loginAction param : memberPw");
	//방어 코드
	if( memberId == null || memberPw == null){
		System.out.println("로그인 또는 패스워드를 제대로 입력해주십쇼.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	// 데이터 타입
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	// 로그인 login 메서드 호출
	MemberDao memberDao = new MemberDao();
	Member returnMember = memberDao.login(paramMember);
	
	if(returnMember == null){
		System.out.println("로그인 실패");
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}else{
		System.out.println("로그인 성공");
		// request. session = JSP내장객체
		// session.setAttribute("변수명", Value);
		session.setAttribute("loginMember", returnMember);
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
%>