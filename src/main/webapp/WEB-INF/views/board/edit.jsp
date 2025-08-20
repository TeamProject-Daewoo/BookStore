<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>글 수정</title>
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
        .btn-row { margin-top: 10px; text-align: right; }
        .link-btn { margin-left: 8px; }
    </style>
</head>
<body id="pageBody">
<h2 id="formTitle">글 수정</h2>
<div id="formContainer">
    <!-- 수정 폼 -->
    <form id="writeForm" method="post" action="${pageContext.request.contextPath}/board/update">
        <!-- 글 ID -->
        <input type="hidden" name="id" value="${post.id}"/>

        <label for="titleInput">제목</label>
        <input type="text" id="titleInput" name="title" value="${post.title}" required>

        <label for="authorInput">작성자</label>
        <input type="text" id="authorInput" name="author" value="${post.author}" disabled>
        <!-- author를 수정 가능하게 하려면 disabled 제거하세요. 
             (컨트롤러/매퍼는 title, content만 업데이트 중) -->

        <label for="contentInput">내용</label>
        <textarea id="contentInput" name="content" rows="5" required><c:out value="${post.content}"/></textarea>

        <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </c:if>

        <button id="submitBtn" type="submit">수정완료</button>

        <div class="btn-row">
            <a class="link-btn" href="${pageContext.request.contextPath}/board/view?id=${post.id}">취소</a>
            <a class="link-btn" href="${pageContext.request.contextPath}/board/main">목록</a>
        </div>
    </form>
</div>
</body>
</html>
