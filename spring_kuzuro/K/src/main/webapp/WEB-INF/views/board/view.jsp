<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 조회</title>
</head>
<body>
<div id="nav">
	<%@ include file="../include/nav.jsp" %>
</div>
	<form method="post">
		<label>제목</label>
		<input tpye="text" name="title" value="${view.title }"/><br/>
		
		<label>작성자</label>
		<input tpye="text" name="writer" value="${view.writer }"/><br/>
		
		<label>내용</label>
		<textarea cols="50" rows="5" name="content">${view.content }</textarea><br/>
		
		<div>
			<a href="/board/modify?bno=${view.bno }">게시물 수정</a>
			<a href="/board/delete?bno=${view.bno}">게시물 삭제</a>
			<!-- <a href="/board/list">게시물 목록</a> -->
		</div>
		
	</form>
	
	<%-- <label>제목</label>
${view.title}<br />

<label>작성자</label>
${view.writer}<br />

<label>내용</label><br />
${view.content}<br />
 
<div>
	<a href="/board/modify?bno=${view.bno }">게시물 수정</a>
</div>
--%>
</body>
</html>