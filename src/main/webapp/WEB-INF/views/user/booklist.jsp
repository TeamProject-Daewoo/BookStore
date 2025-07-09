<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>책 목록</title>
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
    }
    .search-bar {
      margin: 20px;
      text-align: center;
    }
    .search-bar input[type="text"] {
      padding: 8px;
      width: 300px;
      font-size: 16px;
    }
    .search-bar button {
      padding: 8px 16px;
      font-size: 16px;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      padding: 10px;
      border: 1px solid #ddd;
      text-align: center;
    }
    th {
      background-color: #f8f9fa;
    }
    tr:hover {
      background-color: #f1f1f1;
    }
    img {
      max-width: 60px;
      height: auto;
    }
  </style>
  <script>
    // Check for flash attributes and display alerts
    window.onload = function() {
        var successMessage = "${successMessage}";
        var errorMessage = "${errorMessage}";

        if (successMessage && successMessage !== "") {
            alert(successMessage);
        }
        if (errorMessage && errorMessage !== "") {
            alert(errorMessage);
        }
    };
  </script>
</head>
<body>

  <h2 style="text-align:center;">책 목록</h2>

  <!-- ✅ 검색창 영역 -->
  <div class="search-bar">
    <form action="${pageContext.request.contextPath}/user/booklist" method="get">
      <input type="text" name="keyword" placeholder="책 이름 또는 글쓴이 검색" value="${param.keyword}" />
      <button type="submit">검색</button>
    </form>
  </div>

  <!-- ✅ 책 목록 테이블 -->
  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>책 이름</th>
        <th>글쓴이</th>
        <th>가격</th>
        <th>재고</th>
        <th>설명</th>
        <th>이미지</th>
      </tr>
    </thead>
   <tbody>
  <c:forEach var="book" items="${pageList.list}">
    <tr>
      <td>${book.id}</td>
      <td>
        <a href="${pageContext.request.contextPath}/user/bookdetail?id=${book.id}">
          ${book.title}
        </a>
      </td>
      <td>${book.author}</td>
      <td>${book.price}</td>
      <td>${book.stock}</td>
      <td><c:out value="${book.description}" default="없음"/></td>
      <td>
        
        <c:if test="${not empty book.img}">
          <img src="${pageContext.request.contextPath}/resources/images/${book.img}" alt="책 이미지"/>
        </c:if>
        <c:if test="${empty book.img}">
          이미지 없음
        </c:if>
      </td>
    </tr>
  </c:forEach>
</tbody>

  </table>

</body>
</html>