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
      height: auto;
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
  <!-- 자동 배너 시작 -->
  <div id="bannerCarousel" class="carousel slide mb-5 mx-auto" data-bs-ride="carousel">
    <div class="carousel-inner">
      <div class="carousel-item active">
		<a href="/user/bookdetail?id=1">
        	<img src="/resources/images/banner1.jpg" class="d-block w-100" alt="배너1" style="height:500px; object-fit:cover; background:#e9ecef;">
		</a>
      </div>
      <div class="carousel-item">
		<a href="/user/bookdetail?id=1">
        	<img src="/resources/images/banner2.jpg" class="d-block w-100" alt="배너2" style="height:500px; object-fit:cover; background:#e9ecef;">
		</a>
      </div>
      <div class="carousel-item">
		<a href="/user/bookdetail?id=1">
        	<img src="/resources/images/banner3.jpg" class="d-block w-100" alt="배너3" style="height:500px; object-fit:cover; background:#e9ecef;">
		</a>
      </div>
    </div>

    <!-- 좌우 버튼 -->
    <button class="carousel-control-prev" type="button" data-bs-target="#bannerCarousel" data-bs-slide="prev">
      <span class="carousel-control-prev-icon"></span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#bannerCarousel" data-bs-slide="next">
      <span class="carousel-control-next-icon"></span>
    </button>
  </div>
  <!-- 자동 배너 끝 -->
  <div class="container my-5">
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

  <!-- 책 목록 카드 -->
  <div class="row">
    <c:forEach var="book" items="${pageList.list}">
      <div class="col-12 col-md-4">
        <div class="card book-card" onclick="location.href='${pageContext.request.contextPath}/user/bookdetail?id=${book.id}'">
          <c:if test="${not empty book.img}">
            <img src="${pageContext.request.contextPath}/resources/images/${book.img}" alt="책 이미지" class="card-img-top book-img">
          </c:if>
          <c:if test="${empty book.img}">
            <div class="d-flex justify-content-center align-items-center" style="height:180px; background:#f8f9fa; color:#6c757d;">
              이미지 없음
            </div>
          </c:if>
          <div class="card-body book-info text-center">
            <h5 class="card-title">${book.title}</h5>
            <p class="card-text mb-1">글쓴이: ${book.author}</p>
            <p class="card-text fw-bold">가격: ${book.price}원</p>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
