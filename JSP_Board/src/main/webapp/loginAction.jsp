<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %> <!-- userdao의 클래스 가져옴 -->
<%@ page import="java.io.PrintWriter" %> <!-- 자바 클래스 사용 -->
<% request.setCharacterEncoding("UTF-8"); %>
<!-- 한명의 회원정보를 담는 user클래스를 자바 빈즈로 사용 / scope:페이지 현재의 페이지에서만 사용-->

<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>jsp 게시판 웹사이트</title>
</head>

<body>

<%
	UserDAO userDAO = new UserDAO();
	String result = userDAO.login(user.getUserID(), user.getUserPassword());

	if (result == "fail") {					//로그인 실패
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('잘못된 계정정보 입니다.')");
		script.println("history.back()");
		script.println("</script>");
	} else if (result == "error") {			//디비 오류
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다."+result+"')");
		script.println("history.back()");
		script.println("</script>");
	}
	else {
		session.setAttribute("userID", result);	//로그인 성공 시 세션부여
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인 성공.')");
		script.println("location.href = 'main.jsp'");
		script.println("</script>");
	}
%>



</body>

</body>

</html>