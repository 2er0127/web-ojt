<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>게시글 수정 처리</title>
</head>
<body>
    <%
        String userID = (String) session.getAttribute("userID");
        if(userID == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인을 하세요.')");
            script.println("location.href = 'login.jsp'");
            script.println("</script>");
        } else {
            String appPath = application.getRealPath("/");
            String uploadPath = appPath + "uploads"; // 업로드 경로
            
            // 업로드 폴더가 없으면 생성
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            
            int maxSize = 10 * 1024 * 1024; // 최대 파일 크기 10MB
            String encoding = "UTF-8";

            try {
                MultipartRequest multi = new MultipartRequest(request, uploadPath, maxSize, encoding, new DefaultFileRenamePolicy());

                int bbsID = Integer.parseInt(multi.getParameter("bbsID"));
                String bbsTitle = multi.getParameter("bbsTitle");
                String bbsContent = multi.getParameter("bbsContent");
                String fileName = null;

                Enumeration files = multi.getFileNames();
                if (files.hasMoreElements()) {
                    String file = (String)files.nextElement();
                    fileName = multi.getFilesystemName(file);
                }

                if (bbsTitle == null || bbsContent == null) {
                    PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("alert('입력이 안된 사항이 있습니다.')");
                    script.println("history.back()");
                    script.println("</script>");
                } else {
                    BbsDAO bbsDAO = new BbsDAO();
                    int result = bbsDAO.update(bbsID, bbsTitle, bbsContent, fileName);
                    if (result == -1) {
                        PrintWriter script = response.getWriter();
                        script.println("<script>");
                        script.println("alert('글 수정에 실패했습니다. 데이터베이스 오류가 발생했습니다.')");
                        script.println("history.back()");
                        script.println("</script>");
                    } else {
                        PrintWriter script = response.getWriter();
                        script.println("<script>");
                        script.println("alert('글 수정에 성공했습니다.')");
                        script.println("location.href = 'bbs.jsp'");
                        script.println("</script>");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('글 수정에 실패했습니다. 예기치 않은 오류가 발생했습니다.')");
                script.println("history.back()");
                script.println("</script>");
            }
        }
    %>
</body>
</html>
