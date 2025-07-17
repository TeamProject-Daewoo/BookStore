<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>책 목록</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

	<style>
	body {
		font-family: sans-serif;
	}	
	  .custom-table {
	    border-radius: 10px;
	    overflow: hidden;
	  }
	  .custom-table tbody tr {
	    cursor: pointer;
	    transition: background-color 0.2s;
	  }
	  .custom-table tbody tr:hover {
	    background-color: #f1f1f1;
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

<div class="container my-5">

  <!-- 제목 -->
  <h2 class="text-center mb-4 fw-bold">📚 책 목록</h2>

  <!-- 검색창 -->
  <div class="row justify-content-center mb-4">
    <div class="col-md-8">
      <form action="${pageContext.request.contextPath}/user/booklist" method="get" class="input-group">
        <input type="text" name="keyword" class="form-control" placeholder="책 이름 또는 글쓴이 검색" value="${param.keyword}">
        <button type="submit" class="btn btn-primary">검색</button>
      </form>
    </div>
  </div>

  <!-- 책 목록 테이블 -->
  <div class="table-responsive">
    <table style="table-layout: fixed; width: 100%;"  class="table table-striped table-bordered align-middle text-center custom-table table-hover">
      <thead class="table-dark">
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
          <tr onclick="location.href='${pageContext.request.contextPath}/user/bookdetail?id=${book.id}'">
            <td>${book.id}</td>
            <td>${book.title}</td>
            <td>${book.author}</td>
            <td>${book.price}</td>
            <td>${book.stock}</td>
            <td><c:out value="${book.description}" default="없음"/></td>
            <td>
              <c:if test="${not empty book.img}">
                <img src="${pageContext.request.contextPath}/resources/images/${book.img}" alt="책 이미지" class="img-thumbnail" style="max-width: 80px;">
              </c:if>
              <c:if test="${empty book.img}">
                <span class="text-muted">이미지 없음</span>
              </c:if>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>


</body>
</html>