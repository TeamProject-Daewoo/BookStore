<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>자유 게시판</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        h1#pageTitle {
            text-align: center;
            margin: 30px 0 10px 0;
            font-size: 2em;
            color: #333;
        }

        /* 글쓰기 버튼 */
        #writeBtn {
            display: block;
            width: 120px;
            margin: 20px auto;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            text-align: center;
            text-decoration: none;
            transition: background-color 0.3s, transform 0.2s;
        }
        #writeBtn:hover { background-color: #45a049; transform: translateY(-2px); }

        /* 테이블 스타일 */
        #boardTable {
            width: 60%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border-radius: 5px;
            overflow: hidden;
        }
        #boardTable th, #boardTable td { padding: 12px; text-align: center; }
        #boardTable th { background-color: #4CAF50; color: white; font-weight: 600; }
        #boardTable td { border-bottom: 1px solid #eee; color: #555; }
        #boardTable tr:nth-child(even) { background-color: #f9f9f9; }
        #boardTable tr:hover { background-color: #e8f5e9; cursor: pointer; transition: background-color 0.2s; }
        #boardTable th:nth-child(1), #boardTable td:nth-child(1) { width: 60px; }
        #boardTable th:nth-child(2), #boardTable td:nth-child(2) { width: 50%; }
        #boardTable th:nth-child(3), #boardTable td:nth-child(3) { width: 120px; }
        #boardTable th:nth-child(4), #boardTable td:nth-child(4) { width: 120px; }
        #boardTable th:nth-child(5), #boardTable td:nth-child(5) { width: 80px; }
        .title-cell { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

        /* 페이지네비게이션 */
        .pagination { text-align: center; margin: 20px 0; }
        .pagination a { margin: 0 5px; padding: 6px 12px; text-decoration: none; color: #4CAF50; border: 1px solid #4CAF50; border-radius: 4px; transition: all 0.3s; }
        .pagination a:hover { background-color: #4CAF50; color: #fff; }
        .pagination strong { margin: 0 5px; padding: 6px 12px; background-color: #4CAF50; color: white; border-radius: 4px; }
        .disabled { pointer-events: none; color: gray; border-color: gray; }
    </style>
</head>
<body>

<h1 id="pageTitle">자유 게시판</h1>

<!-- 로그인 상태일 때만 currentUsername 변수 설정 -->
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal.username" var="currentUsername" />
</sec:authorize>

<!-- 글 목록 테이블 -->
<table id="boardTable">
    <thead>
    <tr>
        <th>번호</th>
        <th>제목</th>
        <th>작성자</th>
        <th>작성일</th>
        <th>조회수</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${empty posts}">
            <tr><td colspan="5">등록된 글이 없습니다.</td></tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="p" items="${posts}">
                <tr onclick="location.href='${pageContext.request.contextPath}/board/view?id=${p.id}'">
                    <td>${p.id}</td>
                     <td class="title-cell">
    					<c:out value="${p.title}"/> 
    					<span style="color: gray; font-size: 0.9em;">
        					[<c:out value="${p.commentCount}"/>]
    					</span>
					</td>
                    <td>
                        <c:out value="${p.author}"/>
                    </td>
                    <td>${p.createdAt}</td>
                    <td>${p.viewCount}</td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<!-- 페이지 네비게이션 -->
<div class="pagination">
    <c:if test="${totalPages > 1}">
        <a id="prePage" href="${pageContext.request.contextPath}/board/main?page=${currentPage-1}&size=${size}">&laquo; 이전</a>
        <c:forEach var="i" begin="1" end="${totalPages}">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <strong>${i}</strong>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/board/main?page=${i}&size=${size}">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        <a id="nextPage" href="${pageContext.request.contextPath}/board/main?page=${currentPage+1}&size=${size}">다음 &raquo;</a>
    </c:if>
</div>

<!-- 글쓰기 버튼: 테이블 아래 -->
<sec:authorize access="isAuthenticated()">
    <a id="writeBtn" href="${pageContext.request.contextPath}/board/write">글쓰기</a>
</sec:authorize>
<sec:authorize access="!isAuthenticated()">
    <a id="writeBtn" href="#" 
       onclick="alert('로그인이 필요합니다.'); location.href='${pageContext.request.contextPath}/user/loginform'; return false;">
       글쓰기
    </a>
</sec:authorize>

<script>
    if(${totalPages} > 1) {
        const pre = document.getElementById("prePage");
        if(${currentPage} <= 1) pre.classList.add("disabled");
        else pre.classList.remove("disabled");

        const next = document.getElementById("nextPage");
        if(${currentPage} >= ${totalPages}) next.classList.add("disabled");
        else next.classList.remove("disabled");
    }
</script>

</body>
</html>
