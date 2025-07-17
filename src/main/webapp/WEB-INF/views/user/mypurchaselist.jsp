<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매 내역</title>
<style>
body {
	font-family: sans-serif;
}

.container {
	width: 90%;
	margin: 50px auto;
	padding: 20px;
	border: 1px solid #ccc;
	border-radius: 5px;
}

h2 {
	text-align: center;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
}

th, td {
	border: 1px solid #ddd;
	padding: 8px;
	text-align: left;
}

th {
	background-color: #f2f2f2;
}

.actions a {
	margin-right: 10px;
	text-decoration: none;
	color: #007bff;
}

.actions a:hover {
	text-decoration: underline;
}

.add-button {
	display: inline-block;
	padding: 10px 15px;
	background-color: #28a745;
	color: white;
	text-decoration: none;
	border-radius: 5px;
	margin-top: 20px;
}

.add-button:hover {
	background-color: #218838;
}

.book-img {
    width: 80px;        /* 원하는 너비로 조정 */
    height: auto;       /* 비율 유지하면서 높이 자동 조절 */
    border-radius: 5px; /* 모서리 살짝 둥글게 */
    object-fit: cover;  /* 이미지가 잘리지 않게 비율 맞춤 */
}

</style>
</head>
<body>
	<div class="container">
		<h2>구매 목록</h2>
		<table>
			<thead>
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>사진</th>
					<th>수량</th>
					<th>구매날짜</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="purchase" items="${purchaseList}" varStatus="status">
					<tr>
						<td>${status.index + 1}</td>
						<td>${purchase.book_title}</td>
						<td><img class="book-img" src="${pageContext.request.contextPath}/resources/images/${purchase.img}" alt="책 이미지"/></td>
						<td>${purchase.quantity}</td>
						<td><fmt:formatDate value="${purchase.order_date}"
								pattern="yyyy-MM-dd" /></td>
					</tr>
				</c:forEach>
			</tbody>

		</table>
		<a class="add-button"
			href="${pageContext.request.contextPath}/user/booklist">돌아가기</a>
	</div>
</body>
</html>