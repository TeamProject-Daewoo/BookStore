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
    width:95%; max-width:1200px; margin:0 auto; border-collapse:collapse;
    font-family:sans-serif; font-size:14px; box-shadow:0 2px 8px rgba(0,0,0,.1); background:#fff;
  }
thead { 
	background:#343a40; color:#fff; border-bottom:2px solid #dee2e6; 
}
th, td { 
	padding:12px 15px; border-bottom:1px solid #ddd; text-align:center; 
}
th:nth-child(1), td:nth-child(1) { 
	text-align:left; 
}
th:nth-child(4), td:nth-child(4) { 
	text-align:right; 
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
	align-self: flex-start; /* Flexbox 안에서 왼쪽 정렬 */
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
.card h3 { 
	margin:0 0 12px; color:#333; text-align:left; font-family:sans-serif; 
}
.total-card {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  font-size: 18px;
  padding: 50px;
  border-radius: 20px;
  background: linear-gradient(135deg, #6c7ae0, #42a5f5);
  color: white;
  box-shadow: 0 12px 24px rgba(0,0,0,0.25);
  transition: transform 0.3s, box-shadow 0.3s;
}

.total-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 16px 32px rgba(0,0,0,0.35);
}

.total-content {
  text-align: center;
}

.total-icon {
  font-size: 40px;
  margin-bottom: 12px;
}

.total-label {
  display: block;
  font-size: 16px;
  font-weight: 500;
  margin-bottom: 8px;
}

.total-amount {
  display: block;
  font-size: 32px;
  font-weight: bold;
  letter-spacing: 1px;
}

.chart-buttons button { 
  	border: 1px solid #ccc; background-color: #f0f0f0; padding: 5px 12px; border-radius: 15px; cursor: pointer; font-size: 0.9em; 
}

.chart-buttons button.active { 
  	background-color: #6c7ae0; color: white; border-color: #6c7ae0; font-weight: bold; 
}

  #orderSelect {
	  height: 40px;
	  background-size: 20px;
	  padding: 5px 30px 5px 10px;
	  border-radius: 4px;
	  margin-right: 5px;
	  outline: 0 none;
	}
	#orderSelect option {padding: 3px 0;}
	.table-container {
	  display: flex;
	  flex-direction: column;
	  align-items: center;
	}
	.table-header {
	  width: 95%;
	  display: flex;
	  justify-content: center;
	  align-items: center;
	  margin-bottom: 10px;
	}
	#orderToggle {
		height: 40px; display: flex; align-items:center; gap:.5rem;
		border:1px solid #ddd; border-radius:10px; margin-right:10px;
		background:#fff; cursor:pointer; box-shadow:0 1px 3px rgba(0,0,0,.06);
		font-family: sans-serif;
	}
	#orderToggle:hover  {
		background:#eee;
	}
   .search-box {
	    display: flex;
	    gap: 8px;
	    width: 100%;
	    max-width: 400px;
	    padding: 6px 10px;
	    background: #fff;
	    border: 1px solid #ddd;
	    border-radius: 99px;
	    box-shadow: 0 2px 6px rgba(0,0,0,.05);
	 }
 	.search-box input {
	    flex: 1;
	    border: none;
	    outline: none;
	    font-size: 14px;
	    padding: 8px 10px;
	    border-radius: 99px;
	  }
   .search-box input::placeholder {color: #aaa;}
  .search-box button {
    border: none;
    background: #2563eb;
    color: white;
    font-size: 14px;
    font-weight: 500;
    padding: 8px 16px;
    border-radius: 99px;
    cursor: pointer;
    transition: background 0.2s ease;
  }
  .search-box button:hover {background: #1d4ed8;}
  canvas { width:100%; height:500px; }
</style>
</head>
<body>
	<div class="container">
		<!-- 최근 7일 일별 구매 수량 그래프 -->
  		<c:if test="${not empty purchaseList}">
    		<div class="dash-grid">
    		<!-- 그래프 카드 -->
    			<div class="card">
      			<h3 id="chartTitle">최근 7일 일별 구매 금액</h3>
      			<div class="chart-buttons">
      	  		<!-- 통계 추가할 때 클래스명 'chartType-btn'으로 하기(script에서 동적 처리) -->
          			<button id="daily-btn" class="chartType-btn active" onclick="changeChartType('daily')">일별</button>
					<button id="weekly-btn" class="chartType-btn" onclick="changeChartType('weekly')">주별</button>
					<button id="month-btn" class="chartType-btn" onclick="changeChartType('month')">월별</button>
      			</div>
      			<canvas id="dailyAmount"></canvas>
    			</div>
    			<!-- 총합 카드 -->
    			<div class="card total-card">
  					<div class="total-content">
    				<div class="total-icon">💰</div>
    				<span class="total-label">총 구매 금액</span>
    				<span id="totalAmount" class="total-amount">₩ 0</span>
 					</div>
				</div>
  			</div>
 		 </c:if>
 		 </div>
 		 <!-- 검색 -->
  		 <div class="table-container">
			<div class="table-header">
			<select id="orderSelect">
	  			<option value="p.order_date">날짜</option>
	  			<option value="b.price">가격</option>
			</select>
			<button id="orderToggle" type="button" data-order="desc">
	  			<span id="orderText">▼내림차순</span>
			</button>
			<div class="search-box">
	  			<input type="text" name="keyword" placeholder="제목 검색">
	    		<button>검색</button>
    		</div>
		</div>
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
</div>

<!-- 그래프 JS -->
		<c:if test="${not empty purchaseList}">
<script>
document.addEventListener('DOMContentLoaded', function () {
    // ====== 그래프 데이터 ======
    var purchases = [
        <c:forEach var="p" items="${purchaseList}" varStatus="st">
        {
            amount: ${p.price * p.quantity},
            order_ts: ${p.order_date.time}
        }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    var ctx = document.getElementById('dailyAmount') ? document.getElementById('dailyAmount').getContext('2d') : null;
    var chart; // Chart.js 인스턴스

    function aggregateData(type) {
        var map = {};
        var total = 0;
        var today = new Date();

        if(type === 'daily'){
            for(var i=6; i>=0; i--){
                var d = new Date(today);
                d.setDate(today.getDate() - i);
                var key = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
                map[key] = 0;
            }
        } else if(type === 'weekly'){
            var startOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
            var endOfMonth = new Date(today.getFullYear(), today.getMonth() + 1, 0);
            for(var d = new Date(startOfMonth); d <= endOfMonth; d.setDate(d.getDate() + 7)){
                var day = d.getDay();
                var monday = new Date(d);
                monday.setDate(d.getDate() - (day === 0 ? 6 : day - 1));
                var key = String(monday.getMonth()+1).padStart(2,'0') + '-' + String(monday.getDate()).padStart(2,'0');
                map[key] = 0;
            }
        } else if(type === 'month'){
            for(var i=5; i>=0; i--){
                var d = new Date(today.getFullYear(), today.getMonth()-i, 1);
                var key = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0');
                map[key] = 0;
            }
        }

        purchases.forEach(function(p){
            var d = new Date(p.order_ts);
            var key;
            if(type === 'daily'){
                key = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
            } else if(type === 'weekly'){
                var day = d.getDay();
                var monday = new Date(d);
                monday.setDate(d.getDate() - (day === 0 ? 6 : day - 1));
                key = String(monday.getMonth()+1).padStart(2,'0') + '-' + String(monday.getDate()).padStart(2,'0');
            } else {
                key = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0');
            }

            if(map.hasOwnProperty(key)){
                map[key] += Number(p.amount || 0);
                total += Number(p.amount || 0);
            }
        });

        var labels = Object.keys(map).sort();
        var data = labels.map(k => map[k]);

        if(type === 'daily') labels = labels.map(l => l.slice(5)); // MM-DD
        if(type === 'weekly') labels = labels.map(l => l); 
        if(type === 'month') labels = labels.map(l => l.replace('-','/')); // YYYY/MM

        return { labels: labels, data: data, total: total };
    }

    function renderChart(type) {
        if(!ctx) return;
        var agg = aggregateData(type);

        // 총 구매 금액 업데이트
        if(type === 'daily'){
            document.getElementById('totalAmount').textContent =
                '최근 7일 일별 합계 ' + agg.total.toLocaleString() + '원';
        } else if(type === 'weekly'){
            document.getElementById('totalAmount').textContent =
                '이번 달 주간 합계 ' + agg.total.toLocaleString() + '원';
        } else {
            var today = new Date();
            var month = today.getMonth() + 1;
            document.getElementById('totalAmount').textContent =
                month + '월 전체 합계 ' + agg.total.toLocaleString() + '원';
        }

        // 그래프 제목 업데이트
        document.getElementById('chartTitle').textContent = 
            type === 'daily' ? '일별 구매 추이' :
            type === 'weekly' ? '주별 구매 추이' :
            '월별 구매 추이';

        if(chart) chart.destroy();

        chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: agg.labels,
                datasets: [{
                    label: type === 'daily' ? '일별 구매 금액' :
                           type === 'weekly' ? '주별 구매 금액' :
                           '월별 구매 금액',
                    data: agg.data,
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
    }

    // ====== 검색 & 정렬 ======
    const searchInput = document.querySelector('.search-box input');
    const searchButton = document.querySelector('.search-box button');
    const tableBody = document.querySelector('table tbody');
    const orderSelect = document.getElementById('orderSelect');
    const orderToggle = document.getElementById('orderToggle');
    const orderText = document.getElementById('orderText');

    function filterAndSort() {
        const keyword = searchInput.value.toLowerCase();
        const criterion = orderSelect.value;
        const order = orderToggle.getAttribute('data-order');

        // 검색 후 표시되는 행만 선택
        let rows = Array.from(tableBody.rows);
        rows.forEach(row => {
            const title = row.cells[1].textContent.toLowerCase();
            row.style.display = title.includes(keyword) ? '' : 'none';
        });

        rows = rows.filter(r => r.style.display !== 'none');

        // 정렬
        rows.sort((a, b) => {
            let valA, valB;
            if(criterion === 'p.order_date'){
                valA = new Date(a.cells[5].textContent + 'T00:00:00');
                valB = new Date(b.cells[5].textContent + 'T00:00:00');
            } else if(criterion === 'b.price'){
                valA = parseInt(a.cells[4].textContent.replace(/[^0-9]/g, ''));
                valB = parseInt(b.cells[4].textContent.replace(/[^0-9]/g, ''));
            }
            return order === 'asc' ? valA - valB : valB - valA;
        });

        rows.forEach(r => tableBody.appendChild(r));
    }

    // 이벤트 연결
    searchInput.addEventListener('keyup', e => { if(e.key==='Enter') filterAndSort(); });
    searchButton.addEventListener('click', filterAndSort);
    orderSelect.addEventListener('change', filterAndSort);
    orderToggle.addEventListener('click', function(){
        const newOrder = orderToggle.getAttribute('data-order') === 'asc' ? 'desc' : 'asc';
        orderToggle.setAttribute('data-order', newOrder);
        orderText.textContent = newOrder === 'asc' ? '▲오름차순' : '▼내림차순';
        filterAndSort();
    });

    // ====== 초기 렌더링 ======
    renderChart('daily');
    filterAndSort();

    // 차트 버튼 클릭
    document.querySelectorAll('.chartType-btn').forEach(btn => {
        btn.addEventListener('click', function(){
            document.querySelectorAll('.chartType-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            renderChart(btn.id.replace('-btn',''));
        });
    });
});
</script>
</c:if>

</body>
</html>