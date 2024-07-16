<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.User" %>

<% 
    request.setCharacterEncoding("UTF-8"); 

    User user = new User();
    user.setUserID(request.getParameter("userID"));
    user.setUserPassword(request.getParameter("userPassword"));
    user.setUserName(request.getParameter("userName"));
    user.setUserAddress(request.getParameter("userAddress"));
    user.setUserEmail(request.getParameter("userEmail"));

    String sessionUserID = (String) session.getAttribute("userID");

    if (sessionUserID != null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('이미 로그인 되어 있습니다.')");
        script.println("location.href = 'main.jsp'");
        script.println("</script>");
        script.close();
        return;
    }

    if (user.getUserID() == null || user.getUserID().trim().isEmpty() ||
        user.getUserPassword() == null || user.getUserPassword().trim().isEmpty() ||
        user.getUserName() == null || user.getUserName().trim().isEmpty() ||
        user.getUserAddress() == null || user.getUserAddress().trim().isEmpty() ||
        user.getUserEmail() == null || user.getUserEmail().trim().isEmpty()) {
        
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('입력이 안된 사항이 있습니다.')");
        script.println("history.back()");
        script.println("</script>");
        script.close();
        return;
    }

    UserDAO userDAO = new UserDAO();
    int result = userDAO.join(user);

    if (result == -1) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('이미 존재하는 아이디입니다.')");
        script.println("history.back()");
        script.println("</script>");
        script.close();
    } else if (result == 1) {
        session.setAttribute("userID", user.getUserID());
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('회원가입 성공. 환영합니다!')");
        script.println("location.href = 'main.jsp'");
        script.println("</script>");
        script.close();
    } else {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('데이터베이스 오류가 발생했습니다. 다시 시도해주세요.')");
        script.println("history.back()");
        script.println("</script>");
        script.close();
    }
%>
