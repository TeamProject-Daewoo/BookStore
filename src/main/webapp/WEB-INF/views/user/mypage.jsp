<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.Calendar, java.util.Date" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<title>내 프로필</title>
<style>
body {
    font-family: 'Apple SD Gothic Neo', 'Segoe UI', sans-serif;
    background-color: #f8f9fa;
    margin: 0;
    padding: 0;
}

/* 프로필 카드 */
.profile-container {
    max-width: 1000px;
    margin: 60px auto;
    padding: 30px 40px;
    background-color: #fff;
    border: 1px solid #dee2e6;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.profile-main {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 20px;
    margin-bottom: 20px;
}

.profile-header h2 {
    font-size: 26px;
    margin: 0;
}

.btn-edit {
    padding: 8px 16px;
    background-color: #28a745;
    color: white;
    border: none;
    border-radius: 6px;
    text-decoration: none;
    font-size: 14px;
}

.btn-edit:hover {
    background-color: #218838;
}

.profile-item {
    font-size: 16px;
    margin-top: 10px;
}

.profile-item span {
    font-weight: bold;
}

/* 구매 목록 */
.purchase-container {
    max-width: 1000px;
    margin: 40px auto;
    padding: 30px 40px;
    background-color: #fff;
    border: 1px solid #dee2e6;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.purchase-container h2 {
    text-align: center;
    margin-bottom: 20px;
    font-size: 24px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
}

th, td {
    border: 1px solid #dee2e6;
    padding: 10px;
    text-align: left;
}

th {
    background-color: #f1f3f5;
    font-weight: 600;
}

tr:nth-child(even) {
    background-color: #f9f9f9;
}

tr:hover {
    background-color: #e9ecef;
}

.book-img {
    width: 70px;
    height: auto;
    border-radius: 5px;
    object-fit: cover;
}

.add-button {
    display: inline-block;
    padding: 10px 20px;
    background-color: #28a745;
    color: white;
    text-decoration: none;
    border-radius: 6px;
    margin-top: 20px;
    text-align: center;
}

.add-button:hover {
    background-color: #218838;
}

/* 대시보드 카드 */
.dash-grid {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 20px;
    margin-bottom: 20px;
}

.card {
    background: #fff;
    border: 1px solid #eee;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 2px 8px rgba(0,0,0,.05);
}

.card h3 {
    margin: 0 0 12px;
    font-size: 18px;
    color: #333;
}

#totalAmount {
    font-size: 20px;
    font-weight: bold;
    text-align: center;
}

/* 반응형 */
@media (max-width: 768px) {
    .profile-main {
        flex-direction: column;
        align-items: flex-start;
    }
    .dash-grid {
        grid-template-columns: 1fr;
    }
}
</style>
<c:if test="${not empty message}">
	<script>
		window.onload = function() {
			alert("${message}");
			location.replace(location.pathname);
		};
	</script>
</c:if>
</head>
<body>

<sec:authentication property="name" var="username"/>

<!-- 프로필 -->
<div class="profile-container">
    <div class="profile-main">
        <div>
            <h2>${username}님</h2>
        </div>
        <a href="<c:url value='/user/checkPasswordform'/>" class="btn-edit">개인정보 수정</a>
    </div>
</div>

<!-- 구매 목록 -->
<div class="purchase-container">
    <h2>구매 목록</h2>

    <c:if test="${not empty purchaseList}">
        <div class="dash-grid">
            <div class="card">
                <h3>최근 7일 일별 구매 금액</h3>
                <canvas id="dailyAmount"></canvas>
            </div>
            <div class="card" style="display:flex; align-items:center; justify-content:center;">
                <span id="totalAmount">1주일 총 구매 금액 ₩ 0</span>
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
                    <td><fmt:formatDate value="${purchase.order_date}" pattern="yyyy-MM-dd"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <a class="add-button" href="${pageContext.request.contextPath}/user/booklist">돌아가기</a>
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

  var dailyAmountMap = {};
  var totalAmount = 0;
  for (var k = 0; k < days.length; k++) dailyAmountMap[days[k]] = 0;

  purchases.forEach(function (p) {
    var d = new Date(p.order_ts);
    var key = d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
    if (dailyAmountMap.hasOwnProperty(key)) {
      dailyAmountMap[key] += Number(p.amount || 0);
      totalAmount += Number(p.amount || 0);
    }
  });

  document.getElementById('totalAmount').textContent = '1주일 총 구매 금액: ₩ ' + totalAmount.toLocaleString();
  
  var dailyLabels = days.map(function(d) { return d.slice(5); }); // MM-DD
  var dailyAmounts = days.map(function(d) { return dailyAmountMap[d]; });

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
          ticks: { callback: v => '₩ ' + Number(v).toLocaleString() }
        }
      },
      plugins: {
        tooltip: {
          callbacks: { label: ctx => '₩ ' + Number(ctx.parsed.y).toLocaleString() }
        }
      }
    }
  });
});
</script>
</c:if>

</body>
</html>
