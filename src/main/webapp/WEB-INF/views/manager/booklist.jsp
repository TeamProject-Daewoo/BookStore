<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>책 목록 (관리자)</title>
<style>
  /* 전체 기본 폰트, 배경 */
  body {
    font-family: sans-serif;
    background: #f7f8fa;
    margin: 0px;
    color: #333;
  }
  
  /* 컨테이너 영역 */
  .container {
    background: white; padding: 20px 25px; border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  }

  h2 { margin-top: 0; margin-bottom: 15px; color: #2c3e50; }

  /* 새 책 추가 버튼 */
  .add-button {
    display: inline-block; margin-bottom: 15px; padding: 8px 14px;
    background-color: #2ecc71; color: white; text-decoration: none;
    border-radius: 5px; font-weight: 600; transition: background-color 0.3s ease;
  }
  .add-button:hover { background-color: #27ae60; }

  /* 테이블 스타일 */
  table { width: 100%; border-collapse: collapse; font-size: 14px; }
  thead { background-color: #3498db; color: white; }
  thead th { padding: 12px 10px; text-align: left; }
  tbody tr:nth-child(even) { background-color: #f9f9f9; }
  tbody tr:hover { background-color: #f1f7ff; }
  tbody td { padding: 10px; border-bottom: 1px solid #ddd; vertical-align: middle; }

  /* (핵심 수정) 긴 텍스트 줄임 처리 스타일 */
  .truncate-cell {
    max-width: 250px; /* 최대 너비를 설정하여 이보다 길어지면 ... 처리 */
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  /* 이미지 칸 썸네일 */
  td.image-cell { text-align: center; } /* 클래스로 변경 */
  td.image-cell img {
    max-width: 60px; height: 60px; object-fit: cover; border-radius: 4px;
  }

  /* 관리 버튼 */
  .actions a {
    margin-right: 8px; padding: 6px 12px; border-radius: 4px; font-size: 13px;
    color: white; text-decoration: none; font-weight: 600;
  }
  .actions a:first-child { background-color: #2980b9; }
  .actions a:last-child  { background-color: #c0392b; }
  .actions a:hover { opacity: 0.85; }
</style>
</head>
<body>
<div>
  <div class="container" id="content-container">
    <h2>책 목록 (관리자)</h2>

    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>제목</th>
          <th>저자</th>
          <th>가격</th>
          <th>재고</th>
          <th>이미지</th>
          <th>설명</th>
          <th>카테고리</th>
          <th>관리</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="book" items="${list}">
          <tr>
            <td>${book.id}</td>
            <td class="truncate-cell" title="${book.title}">${book.title}</td>
            <td class="truncate-cell" title="${book.author}">${book.author}</td>
            <td><fmt:formatNumber value="${book.price}" pattern="#,###" />원</td>
            <td>${book.stock}</td>
            <td class="image-cell">
              <c:if test="${not empty book.img}">
                <c:choose>
                  <c:when test="${book.img.startsWith('http')}">
                    <img src="${book.img}" alt="책 썸네일">
                  </c:when>
                  <c:otherwise>
                    <img src="${pageContext.request.contextPath}/resources/images/${book.img}" alt="책 썸네일">
                  </c:otherwise>
                </c:choose>
              </c:if>
            </td>
            <td class="truncate-cell" title="${book.description}">${book.description}</td>
            <td>${book.category}</td>
            <td class="actions">
              <a href="${pageContext.request.contextPath}/manager/bookeditform?id=${book.id}">수정</a>
              <a href="${pageContext.request.contextPath}/manager/bookdelete?id=${book.id}"
                 onclick="return confirm('정말로 이 책을 삭제하시겠습니까?');">삭제</a>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>