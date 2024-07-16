<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP 게시판 웹 사이트</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <style>
        .btn-arrow-left {
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <%
        String userID = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
        }
        
        int pageNumber = 1;     // 기본 페이지 번호
        if (request.getParameter("pageNumber") != null) {
            pageNumber = Integer.parseInt(request.getParameter("pageNumber")); // 전달받은 페이지 번호 저장
        }
    %>
    <nav class="navbar navbar-default">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expanded="false">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">메인</a></li>
                <li class="active"><a href="bbs.jsp">게시판</a></li>
            </ul>
            <%
                if (userID == null) {   // 로그인 하지 않은 상태
            %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle"
                        data-toggle="dropdown" role="button" aria-haspopup="true"
                        aria-expanded="false">접속하기<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li class="active"><a href="login.jsp">로그인</a></li>
                        <li><a href="join.jsp">회원가입</a></li>
                    </ul>
                </li>
            </ul>
            <%
                } else {    // 로그인한 상태
            %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle"
                        data-toggle="dropdown" role="button" aria-haspopup="true"
                        aria-expanded="false">회원관리<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="logoutAction.jsp">로그아웃</a></li>
                    </ul>
                </li>
            </ul>
            <%
                }
            %>
                
        </div>
    </nav>

    <div class="container">
        <div class="row">
            <table class="table table-striped" style="text-align:center; border : 1px solid #dddddd;">
                <thead>
                    <tr>
                        <th style="background-color: #eeeeee; text-align:center;">번호</th>
                        <th style="background-color: #eeeeee; text-align:center;">제목</th>
                        <th style="background-color: #eeeeee; text-align:center;">작성자</th>
                        <th style="background-color: #eeeeee; text-align:center;">작성일</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        BbsDAO bbsDAO = new BbsDAO();
                        ArrayList<Bbs> list = bbsDAO.getList(pageNumber); // 현재 페이지의 게시글 List를 가져옴
                        for(int i = 0; i < list.size(); i++) {
                            Bbs bbs = list.get(i);
                    %>
                    <tr>
                        <!-- 게시글 리스트 출력 시 -->
                        <td><%= bbs.getBbsID() %></td>
                        <td><a href="view.jsp?bbsID=<%= bbs.getBbsID() %>"><%= (bbs.getBbsTitle() != null) ? escapeHtml(bbs.getBbsTitle()) : "제목 없음" %></a></td>
                        <td><%= bbs.getUserID() %></td>
                        <td><%= formatDate(bbs.getBbsDate()) %></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>

            <!-- 이전 페이지, 다음 페이지 버튼 -->
            <%
                if (pageNumber != 1) {
            %>
            <a href="bbs.jsp?pageNumber=<%= pageNumber - 1 %>" class="btn btn-success btn-arrow-left">이전</a>
            <%
                }
                if (bbsDAO.nextPage(pageNumber + 1)) {
            %>
            <a href="bbs.jsp?pageNumber=<%= pageNumber + 1 %>" class="btn btn-success btn-arrow-left">다음</a>
            <%
                }
            %>

            <a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>

<%!
    // HTML escaping 함수
    public String escapeHtml(String input) {
        if (input == null) return null;
        return input.replaceAll(" ", "&nbsp;")
                    .replaceAll("<", "&lt;")
                    .replaceAll(">", "&gt;")
                    .replaceAll("\n", "<br>");
    }

    // 날짜 포맷 함수
    public String formatDate(String bbsDate) {
        if (bbsDate == null) return "";
        return bbsDate.substring(0, 11) + bbsDate.substring(11, 13) + " 시 " + bbsDate.substring(14, 16) + " 분";
    }
%>
