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
	background-color: #f8f8f8;
}

.book-title a {
	text-decoration: none;
	color: inherit; /* 필요하면 글자색도 부모 색상과 같게 */
}

.container {
	max-width: 1000px;
	margin: 30px auto;
	padding: 0 20px;
}

.book-card {
	display: flex;
	background: #fff;
	margin-bottom: 20px;
	border: 1px solid #ddd;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.book-card img {
	width: 120px;
	height: auto;
}

.book-info {
	flex: 1;
	display: flex;
	flex-direction: row; /* 가로 배치 */
	justify-content: space-between;
	align-items: center; /* 세로 중앙 정렬 */
	padding: 15px;
}

.book-info-content {
	flex: 1;
}

.book-title {
	font-size: 18px;
	font-weight: bold;
	margin: 0 0 10px;
}

.book-author {
	color: #555;
	margin-bottom: 8px;
}

.book-price {
	color: #d32f2f;
	font-weight: bold;
	margin-bottom: 8px;
}

.book-description {
	font-size: 14px;
	color: #333;
	margin-bottom: 12px;
}

.buttons {
	display: flex;
	flex-direction: column; /* 버튼을 위아래로 나열하고 싶으면 column */
	gap: 10px;
	margin-left: 20px;
}

.buttons button {
	padding: 8px 16px;
	border: none;
	background: #1976d2;
	color: white;
	border-radius: 4px;
	cursor: pointer;
}

.buttons button:hover {
	background: #125ea7;
}

.search-bar {
	text-align: center;
	margin-bottom: 30px;
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
</style>
<script>
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

	<div class="container">
		<h2 class="title-bar">📚 책 목록</h2>

		<div class="search-bar">
			<form action="${pageContext.request.contextPath}/user/booklist"
				method="get">
				<input type="text" name="keyword" placeholder="책 이름 또는 글쓴이 검색"
					value="${param.keyword}" />
				<button type="submit">검색</button>
			</form>
		</div>

		<c:forEach var="book" items="${pageList.list}">
			<div class="book-card">
				<c:if test="${not empty book.img}">
					<img
						src="${pageContext.request.contextPath}/resources/images/${book.img}"
						alt="책 이미지">
				</c:if>
				<c:if test="${empty book.img}">
					<img src="https://via.placeholder.com/120x160?text=No+Image"
						alt="이미지 없음">
				</c:if>

				<div class="book-info">
					<div class="book-info-content">
						<div class="book-title">
							<a
								href="${pageContext.request.contextPath}/user/bookdetail?id=${book.id}">
								${book.title} </a>
						</div>
						<div class="book-author">${book.author}</div>
						<div class="book-price">${book.price}원</div>
						<div class="book-description">
							<c:out value="${book.description}" default="설명이 없습니다." />
						</div>
					</div>
					<div class="buttons">
						<form action="/cart/add" method="post" class="mb-2">
							<input type="hidden" name="bookId" value="${book.id}"> <input
								type="hidden" name="quantity" id="cart-quantity-input" value="1">
							<input type="hidden" name="${_csrf.parameterName}"
								value="${_csrf.token }" />
							<button type="submit" class="btn btn-success w-100">장바구니</button>
						</form>

						<form action="/purchase/direct" method="post">
							<input type="hidden" name="bookId" value="${book.id}"> <input
								type="hidden" name="quantity" id="buy-now-quantity-input"
								value="1"> <input type="hidden"
								name="${_csrf.parameterName}" value="${_csrf.token }" />
							<button type="submit" class="btn btn-warning w-100">바로구매</button>
						</form>
					</div>
				</div>
			</div>
		</c:forEach>

	</div>

</body>
</html>