<%@ page import="java.io.*"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String bbsID = request.getParameter("bbsID");
    if (bbsID == null || bbsID.trim().equals("")) {
        out.println("잘못된 접근입니다.");
        return;
    }

    BbsDAO bbsDAO = new BbsDAO();
    String fileName = bbsDAO.getFileName(Integer.parseInt(bbsID));

    if (fileName == null || fileName.trim().equals("")) {
        out.println("파일이 존재하지 않습니다.");
        return;
    }

    String uploadPath = application.getRealPath("/uploads");
    String filePath = uploadPath + File.separator + fileName;
    File file = new File(filePath);

    if (!file.exists()) {
        out.println("파일이 존재하지 않습니다.");
        return;
    }

    String mimeType = getServletContext().getMimeType(filePath);
    if (mimeType == null) {
        mimeType = "application/octet-stream";
    }

    response.setContentType(mimeType);
    String encodedFileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
    response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

    FileInputStream fileInputStream = new FileInputStream(file);
    ServletOutputStream servletOutputStream = response.getOutputStream();

    byte[] bufferData = new byte[1024];
    int read;
    while ((read = fileInputStream.read(bufferData)) != -1) {
        servletOutputStream.write(bufferData, 0, read);
    }

    servletOutputStream.flush();
    servletOutputStream.close();
    fileInputStream.close();
%>
