<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    .book-card {
      cursor: pointer;
      transition: box-shadow 0.3s;
      margin-bottom: 1.5rem;
    }
    .book-card:hover {
      box-shadow: 0 0 11px rgba(33,33,33,.2);
    }
    .book-img {
      max-width: 100%;
      height: 400px; /* 이미지 높이를 고정하여 카드 크기를 일정하게 유지 */
      object-fit: contain;
      border-radius: 6px;
    }
    .book-info {
      margin-top: 0.5rem;
    }
	.carousel-control-prev-icon,
	.carousel-control-next-icon {
	  filter: invert(100%) sepia(100%) saturate(0%) hue-rotate(0deg) brightness(100%) contrast(100%);
	}
  </style>
</head>
<body>
  <div class="container my-5">
  <h2 class="text-center mb-4 fw-bold">📚 책 목록 :「${pageList.category}」</h2>

  <div class="row justify-content-center mb-4">
    <div class="col-md-8">
      <form action="${pageContext.request.contextPath}/category/${categoryKey}" method="get" class="input-group">
        <input type="text" name="keyword" class="form-control" placeholder="책 이름 또는 글쓴이 검색" value="${param.keyword}">
        <button type="submit" class="btn btn-primary">검색</button>
      </form>
    </div>
  </div>

  <div class="row">
    <c:if test="${empty pageList.list}">
      <div class="col-12 text-center py-5">
        <p class="text-muted fs-5">해당 카테고리에 등록된 책이 없습니다.</p>
      </div>
    </c:if>

    <c:forEach var="book" items="${pageList.list}">
      <div class="col-12 col-md-4">
        <%-- 1. onclick 링크의 파라미터 이름을 'id'에서 'isbn'으로 수정 --%>
        <div class="card book-card" 
             onclick="location.href='${pageContext.request.contextPath}/user/bookdetail?isbn=${book.isbn}'">
          
          <c:if test="${not empty book.img}">
            <%-- 2. 이미지 경로를 로컬/API 경우에 따라 다르게 처리 --%>
            <c:choose>
              <c:when test="${book.img.startsWith('http')}">
                <img src="${book.img}" alt="책 이미지" class="card-img-top book-img">
              </c:when>
              <c:otherwise>
                <img src="${pageContext.request.contextPath}/resources/images/${book.img}" alt="책 이미지" class="card-img-top book-img">
              </c:otherwise>
            </c:choose>
          </c:if>

          <c:if test="${empty book.img}">
            <div class="d-flex justify-content-center align-items-center" 
                 style="height:400px; background:#f8f9fa; color:#6c757d;">
              이미지 없음
            </div>
          </c:if>
          
          <div class="card-body book-info text-center">
            <h5 class="card-title">${book.title}</h5>
            <p class="card-text mb-1">글쓴이: ${book.author}</p>
            <p class="card-text fw-bold">가격: <fmt:formatNumber value="${book.price}" pattern="#,###" />원</p>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>