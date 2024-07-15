<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		
		//현재 세션 상태 확인
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String) session.getAttribute("userID");	//세션의 userid 확인
		}
		if(userID == null)	//로그인 한 경우에만 글 쓰기 가능
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		
		
		int bbsID = 0;
		if(request.getParameter("bbsID") != null)
		{
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if(bbsID == 0)	//게시판 글번호가 잘못된 경우
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		if(!userID.equals(bbs.getUserID())){	//권한이 없는 사용자일 경우
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다..')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		
		else	// 권한이 있는 사용자일 경우
		{
			if(request.getParameter("bbsTitle") == null || request.getParameter("bbsContent")  == null ||
					request.getParameter("bbsTitle").equals("") || request.getParameter("bbsContent").equals(""))	//수정시 빈칸이 있는 경우
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else	//빈칸이 없는 경우
			{
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.update(bbsID, request.getParameter("bbsTitle"), request.getParameter("bbsContent"));	//db에 수정 기능 요청
				if (result == -1)
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글 수정에 실패했습니다..')");
					script.println("history.back()");
					script.println("</script>");
				}
				else
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글 수정에 성공했습니다.')");
					script.println("location.href = 'bbs.jsp'");
					script.println("</script>");
				}
			}
		}
	%>


</body>
</html>