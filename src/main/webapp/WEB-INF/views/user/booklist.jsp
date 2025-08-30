<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>책 목록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
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
#bannerCarousel {
    border-radius: 25px;         /* 전체 둥근 모서리 */
    overflow: hidden;             /* 이미지가 넘어가지 않도록 */
}

#bannerCarousel .carousel-inner {
    border-radius: 25px;        /* 내부 둥근 모서리 */
}

.banner-img {
    width: 100%;
    height: 500px;
    object-fit: cover;
    border-radius: 20px;        /* 안쪽 둥근 모서리 */
}
 .search-form {
    width: 100%;
    border-radius: 50px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  }
  .search-input {
    border: none;
    padding: 12px 20px;
    flex: 1;
    font-size: 1rem;
  }
  .search-input:focus {
    outline: none;
    box-shadow: none;
  }
  .search-btn {
    background-color: #0055a5; /* 교보문고 블루 느낌 */
    color: white;
    border: none;
    padding: 0 20px;
    font-weight: bold;
    transition: background 0.3s;
  }
  .search-btn:hover {
    background-color: #003d75;
  }
  </style>
</head>
<body>
	<br>
	<div class="container my-5">
  	<h2 class="text-center mb-4 fw-bold">📚 책 목록</h2>
	<!-- 검색창 -->
  	<!-- 검색창 -->
<div class="row justify-content-center mb-4">
  <div class="col-md-8">
    <form action="${pageContext.request.contextPath}/user/booklist" method="get" class="search-form d-flex">
      <input type="text" name="keyword" class="form-control search-input" placeholder="책 이름 또는 글쓴이 검색" value="${param.keyword}">
      <button type="submit" class="btn search-btn">
        <i class="bi bi-search"></i> 검색
      </button>
    </form>
  </div>
</div>
	<br>
  <!-- 자동 배너 시작 -->
  <div id="bannerCarousel" class="carousel slide mb-5 mx-auto" data-bs-ride="carousel">
    <div class="carousel-inner">
      <div class="carousel-item active">
		<a href="/user/bookdetail?isbn=9788936439743">
        	<img src="/resources/images/banner1.jpg" class="d-block w-100 banner-img" alt="배너1">
		</a>
      </div>
      <div class="carousel-item">
		<a href="/user/bookdetail?isbn=9791197221989">
        	<img src="/resources/images/banner2.jpg" class="d-block w-100 banner-img" alt="배너2">
		</a>
      </div>
      <div class="carousel-item">
		<a href="/user/bookdetail?isbn=9791198987631">
        	<img src="/resources/images/banner3.jpg" class="d-block w-100 banner-img" alt="배너3">
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
  

  

  <!-- 책 목록 카드 -->
  <div class="row">
    <c:forEach var="book" items="${pageList.list}">
      <div class="col-12 col-md-4">
        <%-- 1. onclick 링크의 파라미터 이름을 'isbn'으로 수정 --%>
        <div class="card book-card" onclick="location.href='${pageContext.request.contextPath}/user/bookdetail?isbn=${book.isbn}'">
          <c:if test="${not empty book.img}">
            
            <%-- 2. 이미지 경로를 두 가지 경우에 맞춰 처리 --%>
            <c:choose>
              <c:when test="${book.img.startsWith('http')}">
                <img src="${book.img}" alt="책 이미지" class="card-img-top book-img" style="height: 400px; object-fit: contain;">
              </c:when>
              <c:otherwise>
                <img src="${pageContext.request.contextPath}/resources/images/${book.img}" alt="책 이미지" class="card-img-top book-img" style="height: 400px; object-fit: contain;">
              </c:otherwise>
            </c:choose>
            
          </c:if>
          <c:if test="${empty book.img}">
            <div class="d-flex justify-content-center align-items-center" style="height:400px; background:#f8f9fa; color:#6c757d;">
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
</body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</html>
