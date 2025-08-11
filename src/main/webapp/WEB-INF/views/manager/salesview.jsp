<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
h2 {
	text-align: center;
	font-family: 'Segoe UI', sans-serif;
	margin: 30px 0;
}

table {
	width: 95%;
	max-width: 1200px;
	margin: 0 auto;
	border-collapse: collapse;
	font-family: 'Segoe UI', sans-serif;
	font-size: 14px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

thead {
	background-color: #343a40;
	color: white;
	border-bottom: 2px solid #dee2e6;
}

th, td {
	padding: 12px 15px;
	border-bottom: 1px solid #ddd;
	text-align: center;
}

/* ID 열은 좌측 정렬 */
th:nth-child(1), td:nth-child(1) {
	text-align: left;
}

/* 수량 열은 우측 정렬 */
th:nth-child(4), td:nth-child(4) {
	text-align: right;
}

/* 구매자명 (2), 제목 (3), 구매날짜 (5) 열은 가운데 정렬 (명확히 지정) */
th:nth-child(2), td:nth-child(2), th:nth-child(3), td:nth-child(3), th:nth-child(5),
	td:nth-child(5) {
	text-align: center;
}

tbody tr:hover {
	background-color: #eef5ff;
}

.total-sum {
    width: 95%;
    max-width: 1200px;
    margin: 0 auto 30px auto;
    font-family: 'Segoe UI', sans-serif;
    font-size: 48px;       /* 크게 */
    font-weight: bold;
    text-align: center;    /* 가운데 정렬 */
    color: #2a5298;        /* 예쁜 파란색 계열 */
}

</style>


<h2>판매 현황</h2>

<div class="total-sum">
    전체 판매 합계: <strong>${totalsum}</strong> 원
</div>

<table>
	<thead>
		<tr>
			<th>ID</th>
			<th>구매자명</th>
			<th>제목</th>
			<th>수량</th>
			<th>합계 가격</th>
			<th>구매날짜</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="purchase" items="${purchaseList}">
			<tr>
				<td>${purchase.id}</td>
				<td>${purchase.member_name}</td>
				
    		<c:forEach var="book" items="${purchase.bookList}">
				<td>${book.book_title}</td>
				<td>${book.quantity}</td>
			</c:forEach>
				<td>${purchase.total_price}</td>
				<td><fmt:formatDate value="${purchase.order_date}"
						pattern="yyyy-MM-dd" /></td>
			</tr>
		</c:forEach>
	</tbody>
</table>
