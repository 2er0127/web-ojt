<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.User" %>

<% 
    request.setCharacterEncoding("UTF-8"); 

    // 폼에서 전달된 값을 이용해 User 객체 생성
    User user = new User();
    user.setUserID(request.getParameter("userID"));
    user.setUserPassword(request.getParameter("userPassword"));
    user.setUserName(request.getParameter("userName"));
    user.setUserAddress(request.getParameter("userAddress"));
    user.setUserEmail(request.getParameter("userEmail"));

    // 현재 세션 확인
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

    // 사용자 입력 값 유효성 검사
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

    // 회원가입 처리
    UserDAO userDAO = new UserDAO();
    int result = userDAO.join(user);

    if (result == -1) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('이미 존재하는 아이디입니다.')");
        script.println("history.back()");
        script.println("</script>");
        script.close();
    } else {
        session.setAttribute("userID", user.getUserID()); // 회원가입 성공 시 세션 부여
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('회원가입 성공. 환영합니다!')");
        script.println("location.href = 'main.jsp'");
        script.println("</script>");
        script.close();
    }
%>
