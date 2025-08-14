<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.Calendar, java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매 내역</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
	border: none;
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
.dash-grid {
    width:95%; max-width:1200px; margin:32px auto; display:grid; grid-template-columns:2fr 1fr; gap:24px;
  }
  .card {
    background:#fff; border:1px solid #eee; border-radius:16px; padding:16px; box-shadow:0 2px 8px rgba(0,0,0,.04);
  }
  .card h3 { margin:0 0 12px; color:#333; text-align:left; font-family:sans-serif; }
  canvas { width:100%; height:360px; }
</style>
</head>
<body>
	<div class="container">
		<h2>구매 목록</h2>
		<br>
		<!-- 최근 7일 일별 구매 수량 그래프 -->
  		<c:if test="${not empty purchaseList}">
    		<div class="dash-grid">
    		<!-- 그래프 카드 -->
    			<div class="card">
      			<h3>최근 7일 일별 구매 금액</h3>
      			<canvas id="dailyAmount"></canvas>
    			</div>
    			<!-- 총합 카드 -->
    			<div class="card" style="display:flex; align-items:center; justify-content:center; font-size:24px; font-weight:bold;">
      			<div>
        			<span id="totalAmount">1주일 총 구매 금액 ₩ 0</span>
      			</div>
    			</div>
  			</div>
 		 </c:if>
		<table>
			<thead>
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>사진</th>
					<th>수량</th>
					<th>금액</th>
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
						<td>${purchase.price}원</td>
						<td><fmt:formatDate value="${purchase.order_date}"
								pattern="yyyy-MM-dd" /></td>
					</tr>
				</c:forEach>
			</tbody>

		</table>
		<a class="add-button"
			href="${pageContext.request.contextPath}/user/booklist">돌아가기</a>
</div>
<!-- 그래프 JS -->
		<c:if test="${not empty purchaseList}">
		<script>
		document.addEventListener('DOMContentLoaded', function () {
		  var purchases = [
		    <c:forEach var="p" items="${purchaseList}" varStatus="st">
		      {
		        amount: ${p.price * p.quantity},
		        order_ts: ${p.order_date.time}
		      }<c:if test="${!st.last}">,</c:if>
		    </c:forEach>
		  ];

		  // 최근 7일 날짜 배열
		  var today = new Date();
		  var days = [];
		  for (var i = 6; i >= 0; i--) {
		    var d = new Date(today);
		    d.setDate(today.getDate() - i);
		    var y  = d.getFullYear();
		    var m  = String(d.getMonth() + 1).padStart(2, '0');
		    var dd = String(d.getDate()).padStart(2, '0');
		    days.push(y + '-' + m + '-' + dd);
		  }

		  // 날짜별 금액 합계
		  var dailyAmountMap = {};
		  var totalAmount = 0;
		  for (var k = 0; k < days.length; k++) dailyAmountMap[days[k]] = 0;

		  purchases.forEach(function (p) {
		    var d = new Date(p.order_ts);
		    var key = d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
		    if (dailyAmountMap.hasOwnProperty(key)) {
		      dailyAmountMap[key] += Number(p.amount || 0);
		      totalAmount += Number(p.amount || 0); // 총합 계산
		    }
		  });

			// 총합 표시 (그래프 오른쪽)
		  document.getElementById('totalAmount').textContent = '1주일 총 구매 금액: ₩ ' + totalAmount.toLocaleString();
		  	
		  var dailyLabels = days.map(function(d) { return d.slice(5); }); // MM-DD
		  var dailyAmounts = days.map(function(d) { return dailyAmountMap[d]; });

		  // Chart.js
		  var ctx = document.getElementById('dailyAmount').getContext('2d');
		  new Chart(ctx, {
		    type: 'line',
		    data: {
		      labels: dailyLabels,
		      datasets: [{
		        label: '최근 7일 일별 구매 금액',
		        data: dailyAmounts,
		        fill: true,
		        borderColor: 'rgba(54, 162, 235, 1)',
		        backgroundColor: 'rgba(54, 162, 235, 0.2)',
		        tension: 0.3
		      }]
		    },
		    options: {
		      scales: {
		        y: {
		          beginAtZero: true,
		          ticks: {
		            callback: v => '₩ ' + Number(v).toLocaleString()
		          }
		        }
		      },
		      plugins: {
		        tooltip: {
		          callbacks: {
		            label: ctx => '₩ ' + Number(ctx.parsed.y).toLocaleString()
		          }
		        }
		      }
		    }
		  });
		});
		</script>
		</c:if>
</body>
</html>