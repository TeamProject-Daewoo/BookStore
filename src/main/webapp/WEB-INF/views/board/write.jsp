<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>글 작성</title>
    <style>
        #pageBody { font-family: Arial, sans-serif; background-color: #f4f4f4; }
        #formTitle { text-align: center; }
        #writeForm {
            width: 60%; margin: 20px auto; background: #fff; padding: 20px; border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        #writeForm label { display: block; margin: 10px 0 5px; font-weight: bold; }
        #titleInput, #authorInput, #contentInput {
            width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; resize: none;
        }
        #submitBtn {
            display: block; width: 100%; padding: 10px; margin-top: 15px; background-color: #4CAF50;
            border: none; color: white; font-size: 16px; cursor: pointer; border-radius: 4px;
        }
        #submitBtn:hover { background-color: #45a049; }
    </style>
</head>
<body id="pageBody">
<h2 id="formTitle">글 작성</h2>
<div id="formContainer">
    <form id="writeForm" method="post" action="${pageContext.request.contextPath}/board/write">
        <label for="titleInput">제목</label>
        <input type="text" id="titleInput" name="title" required>

        <label for="authorInput">작성자</label>
        <input type="text" id="authorInput" name="author" value="<sec:authentication property="name" />" disabled>
        <input type="hidden" name="author" value="<sec:authentication property='name' />">

        <label for="contentInput">내용</label>
        <textarea id="contentInput" name="content" rows="5" required></textarea>

        <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </c:if>

        <button id="submitBtn" type="submit">작성</button>
    </form>
</div>
</body>
</html>
