<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
	body {text-align:center;}
</style>
<title>Insert title here</title>
</head>
<body>
	<%
		PrintWriter script =response.getWriter();
		script.println("<script>");
		script.println("alert('중복된 아이디가 있습니다 다시 시도해주세요')");
		script.println("history.back()");
		script.println("</script>");
	%>
</body>
</html>