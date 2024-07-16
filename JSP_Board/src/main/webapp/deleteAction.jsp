<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>

<%
    request.setCharacterEncoding("UTF-8");
    String bbsIDStr = request.getParameter("bbsID");

    if (bbsIDStr == null || bbsIDStr.trim().isEmpty()) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 접근입니다.')");
        script.println("history.back()");
        script.println("</script>");
        script.close();
        return;
    }

    int bbsID = Integer.parseInt(bbsIDStr);
    BbsDAO bbsDAO = new BbsDAO();
    int result = bbsDAO.deletePost(bbsID);

    if (result == 1) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('게시글이 성공적으로 삭제되었습니다.')");
        script.println("location.href = 'bbs.jsp'");
        script.println("</script>");
        script.close();
    } else {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('게시글 삭제에 실패했습니다. 다시 시도해주세요.')");
        script.println("history.back()");
        script.println("</script>");
        script.close();
    }
%>
