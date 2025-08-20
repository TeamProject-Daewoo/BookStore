<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>게시글 보기</title>
  <style>
    #pageBody { font-family: Arial, sans-serif; background:#f4f4f4; }
    .view-wrap {
      width: 80%; margin: 20px auto; background:#fff; padding: 20px;
      border-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,.1);
    }
    .view-row { margin: 10px 0; }
    .row-flex { display:flex; align-items:center; justify-content:space-between; }
    .label { font-weight: bold; width: 80px; display:inline-block; }
    .content-box {
      margin-top: 10px; padding: 12px; border:1px solid #ddd; border-radius: 4px;
      white-space: pre-wrap; line-height: 1.5; background:#fff;
    }
    .btns { text-align: right; margin-top: 15px; }
    .btn {
      display:inline-block; padding:8px 14px; border-radius:4px; text-decoration:none; 
      background:#4CAF50; color:#fff; margin-left:8px;
    }
    .btn:hover { background:#45a049; }
    .inline-form { display:inline; margin-left:8px; }
  </style>
</head>
<body id="pageBody">
  <div class="view-wrap">
    <!-- 번호 행 + 우측 액션 버튼 -->
    <div class="view-row row-flex">
      <div><span class="label">번호</span> ${post.id}</div>

      <!-- 로그인했고, 글 주인일 때만 버튼 노출 -->
      <sec:authorize access="isAuthenticated()">
        <c:if test="${post.user_id == pageContext.request.userPrincipal.name}">
          <div>
            <a class="btn" href="${pageContext.request.contextPath}/board/edit?id=${post.id}">수정</a>
            <form class="inline-form" method="post" action="${pageContext.request.contextPath}/board/delete">
              <input type="hidden" name="id" value="${post.id}">
              <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              </c:if>
              <button class="btn" type="submit" onclick="return confirm('삭제하시겠습니까?');">삭제</button>
            </form>
          </div>
        </c:if>
      </sec:authorize>
    </div>

    <div class="view-row"><span class="label">제목</span> <c:out value="${post.title}"/></div>
    <div class="view-row"><span class="label">작성자</span> <c:out value="${post.author}"/></div>

    <div class="view-row">
      <div class="label">내용</div>
      <div class="content-box"><c:out value="${post.content}"/></div>
    </div>

    <div class="btns">
      <a class="btn" href="${pageContext.request.contextPath}/board/main">목록</a>
    </div>
  </div>
</body>
</html>
