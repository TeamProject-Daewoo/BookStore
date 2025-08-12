<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

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
	font-size: 48px; /* 크게 */
	font-weight: bold;
	text-align: center; /* 가운데 정렬 */
	color: #2a5298; /* 예쁜 파란색 계열 */
}
</style>


<h2>판매 현황</h2>

<div class="total-sum"></div>

<table>
	<thead>
		<tr>
			<th>ID</th>
			<th>구매자명</th>
			<th>제목(수량)</th>
			<th>합계</th>
			<th>구매날짜</th>
		</tr>
	</thead>
	<tbody></tbody>
</table>
<script>
	const socket = new WebSocket("ws://localhost:8888/salesSocket");
	function getBookInfor(books, td) {
		  books.forEach((book, index) => {
		    const textNode = document.createTextNode(
		      book.book_title+"("+book.quantity+"권)"
		    );
		    td.appendChild(textNode);
		    if(index < books.length-1)
		    	td.appendChild(document.createElement("br"));
		});
	}
	function render() {
		fetch("/api/renderSalesList", {
			method: 'GET',
			headers : {"Accept": "application/json"}
		})
		.then(response => response.json())
		.then(result => {
			//총합계
			document.getElementsByClassName("total-sum")[0].textContent = "전체 판매 합계: "+result.totalSum+"원";
			
			const tbody = document.querySelector("tbody");
		    tbody.innerHTML = "";
		    result.purchase.forEach(purchase => {
		    	const tr = document.createElement("tr");
	
				// id
				let td = document.createElement("td");
				td.textContent = purchase.id;
				tr.appendChild(td);
		
				// member_name
				td = document.createElement("td");
				td.textContent = purchase.member_name;
				tr.appendChild(td);
		
				// bookList 내부
				td = document.createElement("td");
				getBookInfor(purchase.bookList, td);
				tr.appendChild(td);

				// total_price
		     	td = document.createElement("td");
		      	td.textContent = purchase.total_price;
		      	tr.appendChild(td);
	
		      	// order_date 변환 (timestamp → yyyy-MM-dd)
		      	td = document.createElement("td");
		      	const dateObj = new Date(purchase.order_date);
		      	td.textContent = dateObj.toISOString().split("T")[0];
		      	tr.appendChild(td);
	
		      	tbody.appendChild(tr);
			});
		});
	}
	socket.onstart = () => render();
	socket.onmessage = (message) => render();
</script>