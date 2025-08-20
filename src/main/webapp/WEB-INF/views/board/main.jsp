<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시판</title>
    <style>
        #pageBody { font-family: Arial, sans-serif; background-color: #f4f4f4; }
        #pageTitle { text-align: center; }
        #boardTable {
            width: 80%; margin: 20px auto; border-collapse: collapse; background: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        #boardTable th, #boardTable td {
            padding: 12px; border: 1px solid #ddd; text-align: center;
        }
        #boardTable th { background-color: #4CAF50; color: white; }
        #boardTable tr:nth-child(even) { background-color: #f9f9f9; }
        #writeBtn {
            display: block; width: 120px; margin: 20px auto; padding: 10px;
            background-color: #4CAF50; border: none; color: white;
            font-size: 16px; cursor: pointer; border-radius: 4px; text-align: center;
            text-decoration: none;
        }
        #writeBtn:hover { background-color: #45a049; }
    </style>
</head>
<body id="pageBody">
<h1 id="pageTitle">게시판</h1>

<!-- 글 목록 -->
<table id="boardTable">
    <thead>
    <tr>
        <th>번호</th>
        <th>제목</th>
        <th>작성자</th>
        <th>작성일</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${empty posts}">
            <tr>
                <td colspan="4">등록된 글이 없습니다.</td>
            </tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="p" items="${posts}">
                <!-- ✅ 행 전체를 클릭 가능하게 변경 (마우스오버 연회색) -->
                <tr onclick="location.href='${pageContext.request.contextPath}/board/view?id=${p.id}'"
                    style="cursor:pointer;"
                    onmouseover="this.style.backgroundColor='#f5f5f5';"
                    onmouseout="this.style.backgroundColor='';">
                    <td>${p.id}</td>
                    <td class="title-cell"><c:out value="${p.title}"/></td>
                    <td><c:out value="${p.author}"/></td>
                    <td>${p.createdAt}</td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<div style="text-align:center; margin:20px 0;">
    <c:if test="${totalPages > 1}">
        <a href="${pageContext.request.contextPath}/board/main?page=${prevPage}&size=${size}">&laquo; 이전</a>
        <c:forEach var="i" begin="1" end="${totalPages}">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <strong style="margin:0 6px;">${i}</strong>
                </c:when>
                <c:otherwise>
                    <a style="margin:0 6px;"
                       href="${pageContext.request.contextPath}/board/main?page=${i}&size=${size}">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        <a href="${pageContext.request.contextPath}/board/main?page=${nextPage}&size=${size}">다음 &raquo;</a>
    </c:if>
</div>

<!-- 작성 페이지로 이동하는 버튼 -->
<sec:authorize access="isAuthenticated()">
  <a id="writeBtn" href="${pageContext.request.contextPath}/board/write">작성</a>
</sec:authorize>
<sec:authorize access="!isAuthenticated()">
  <a id="writeBtn" href="#" onclick="alert('로그인이 필요합니다.'); return false;">작성</a>
</sec:authorize>

</body>
</html>
