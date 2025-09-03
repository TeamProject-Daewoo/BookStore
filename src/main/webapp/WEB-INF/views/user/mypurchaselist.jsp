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
	width: 100%;
	margin: 20px auto;
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
  width: 100%;             /* 화면 거의 다 차지 */
  max-width: 1600px;      /* 필요시 조정 */
  display: grid;
  gap: 24px;
  margin: 0 auto;          /* 가운데 정렬 */
}

.dash-grid-graphs {
    display: flex;
    gap: 24px;
    width: 100%;
    max-width: 1600px;
    margin: 20px auto;
}
.dash-grid-graphs .graph-card:first-child {
    flex: 2;      /* 왼쪽 그래프: 2fr */
}

.dash-grid-graphs .graph-card:last-child {
    flex: 1.2;    /* 오른쪽 그래프: 1.2fr */
}

.dash-grid-graphs .graph-card {
    flex: 1;                /* 두 그래프가 동일한 폭 */
    min-width: 0;           /* overflow 방지 */
    padding: 24px;
    background: #fff;
    border-radius: 16px;
    border: 1px solid #eee;
    box-shadow: 0 12px 24px rgba(0,0,0,0.25);
    display: flex;
    flex-direction: column;
}
.dash-grid-graphs .graph-card h3 {
    margin-bottom: 12px;
    color: #333;
    text-align: left;
    font-family: sans-serif;
}
#categoryChart {
    height: 250px !important; /* 원하는 높이로 조정 */
}
.amount-cards {
    display: flex;
    justify-content: space-between; /* 카드 간격 균등 */
    gap: 30px;                     /* 카드 사이 간격 */
    margin: 20px 0;                /* 위/아래 여백 */
}

.amount-cards .card {
    flex: 1;                        /* 넓이 균등 */
    min-width: 0;                    /* overflow 방지 */
}

.card {
  background: #fff;
  border: 1px solid #eee;
  border-radius: 16px;
  padding: 24px;           /* 기존보다 padding 늘려서 크게 */
  box-shadow: 0 12px 24px rgba(0,0,0,0.25);
  min-height: 400px;       /* 카드 높이 고정 */
  display: flex;
  flex-direction: column;
}
.card h3 { 
	margin:0 0 12px; color:#333; text-align:left; font-family:sans-serif; 
}


/* 금액 표시 카드만 작게 */
.total-card {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  font-size: 24px;      /* 기존 186px → 작게 조정 */
  padding: 20px;        /* 기존 50px → 작게 */
  border-radius: 16px;
  background: linear-gradient(135deg, #6c7ae0, #42a5f5);
  color: white;
  box-shadow: 0 6px 12px rgba(0,0,0,0.25);
  transition: transform 0.3s, box-shadow 0.3s;
  min-height: 130px;     /* 높이 조정 */
}
.total-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0,0,0,0.3);
}

.total-content .total-icon {
  font-size: 24px;      /* 기존 40px → 작게 */
  margin-bottom: 8px;
}

.total-content .total-label {
  font-size: 20px;      /* 기존 20px → 작게 */
  margin-bottom: 4px;
}

.total-content .total-amount {
  font-size: 26px;      /* 기존 28px → 작게 */
}
.total-content {
    display: flex;
    flex-direction: column;
    align-items: center;   /* 수평 중앙 */
    justify-content: center; /* 수직 중앙 */
    text-align: center;    /* 텍스트 정렬 */
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
  canvas { width:100%; height:360px;}
  .empty-list {
    width: 95%;               /* 테이블 넓이 맞춤 */
    max-width: 1200px;
    font-family: sans-serif;  /* 글꼴 */
    font-size: 30px;          /* 글자 크기 */
    font-weight: bold;        /* 굵게 */
    text-align: center;       /* 가운데 정렬 */
    color: #FF2F2F;           /* 빨간색 */
}
</style>
</head>
<body>
	<div class="container">
	<!-- 총 구매 금액 카드 -->
    <div class="card total-card">
        <div class="total-content">
            <div class="total-icon">💰</div>
            <span class="total-label">총 구매 금액</span>
            <span id="totalAmount" class="total-amount">₩ 0</span>
        </div>
    </div>
		<div class="dash-grid">
    	<div class="amount-cards">
    <!-- 일별 구매 금액 카드 -->
    <div class="card total-card daily-card">
        <div class="total-content">
            <span class="total-label">당일 구매액</span>
            <span id="dailyAmountCard" class="total-amount">₩ 0</span>
        </div>
    </div>

    <!-- 월별 구매 금액 카드 -->
    <div class="card total-card month-card">
        <div class="total-content">
            <span class="total-label">월 구매액</span>
            <span id="monthAmountCard" class="total-amount">₩ 0</span>
        </div>
    </div>

    <!-- 연별 구매 금액 카드 -->
    <div class="card total-card year-card">
        <div class="total-content">
            <span class="total-label">연 구매액</span>
            <span id="yearAmountCard" class="total-amount">₩ 0</span>
        </div>
    </div>
    
    <!-- 총 결제 건수 카드 -->
    <div class="card total-card count-card">
        <div class="total-content">
            <span class="total-label">총 결제 건수</span>
            <span id="totalCountCard" class="total-amount">0건</span>
        </div>
    </div>
</div>
    		
		</div>
		<div class="dash-grid-graphs">
    <!-- 기존 구매 금액 추이 그래프 -->
    <div class="card graph-card">
        <h3 id="chartTitle">최근 7일 일별 구매 금액</h3>
        <div class="chart-buttons">
            <button id="daily-btn" class="chartType-btn active" onclick="changeChartType('daily')">일별</button>
            <button id="month-btn" class="chartType-btn" onclick="changeChartType('month')">월별</button>
            <button id="year-btn" class="chartType-btn" onclick="changeChartType('year')">연별</button>
        </div>
        <canvas id="dailyAmount"></canvas>
    </div>

    <!-- 카테고리별 파이 차트 카드 -->
		<div class="card graph-card" style="flex:1.2;">
    <h3>카테고리별 구매 수</h3>
    <canvas id="categoryChart"></canvas>
	</div>
</div>
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
				 <c:choose>
                <c:when test="${not empty purchaseList}">
                    <c:forEach var="purchase" items="${purchaseList}" varStatus="status">
                        <tr>
                            <td>${status.index + 1}</td>
                            <td>${purchase.book_title}</td>
                            <td><img class="book-img" src="${purchase.img}" alt="책 이미지"/></td>
                            <td>${purchase.quantity}</td>
                            <td>${purchase.price}원</td>
                            <td><fmt:formatDate value="${purchase.order_date}" pattern="yyyy-MM-dd"/></td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr class="empty-list">
                        <td colspan="6" style="text-align:center;">해당하는 구매내역이 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
			</tbody>
		</table>	
</div>

<!-- 그래프 JS -->
<script>
document.addEventListener('DOMContentLoaded', function () {
    // =============================================
    // 1. JSP에서 넘어온 실제 구매 데이터
    // =============================================
    const realPurchases = [
        <c:forEach var="p" items="${purchaseList}" varStatus="st">
        {
            category: "${p.category}",
            quantity: ${p.quantity},
            amount: ${p.price * p.quantity},
            order_ts: ${p.order_date.time}
        }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    const purchases = realPurchases.length > 0 
        ? realPurchases 
        : [{ amount: 0, order_ts: new Date().getTime(), category: '기타', quantity: 0 }];

    // KST 기준으로 날짜만 비교하는 함수
    function isSameDayKST(ts1, ts2) {
        const d1 = new Date(ts1);
        const d2 = new Date(ts2);
        const kst1 = new Date(d1.getTime() + 9*60*60*1000);
        const kst2 = new Date(d2.getTime() + 9*60*60*1000);
        return kst1.getFullYear() === kst2.getFullYear() &&
               kst1.getMonth() === kst2.getMonth() &&
               kst1.getDate() === kst2.getDate();
    }

    function isSameMonthKST(ts1, ts2) {
        const d1 = new Date(ts1);
        const d2 = new Date(ts2);
        const kst1 = new Date(d1.getTime() + 9*60*60*1000);
        const kst2 = new Date(d2.getTime() + 9*60*60*1000);
        return kst1.getFullYear() === kst2.getFullYear() &&
               kst1.getMonth() === kst2.getMonth();
    }

    function isSameYearKST(ts1, ts2) {
        const d1 = new Date(ts1);
        const d2 = new Date(ts2);
        const kst1 = new Date(d1.getTime() + 9*60*60*1000);
        const kst2 = new Date(d2.getTime() + 9*60*60*1000);
        return kst1.getFullYear() === kst2.getFullYear();
    }

    // =============================================
    // 2. 카테고리별 구매 수량 집계
    // =============================================
    var categoryCounts = {};
    purchases.forEach(p => {
        const cat = p.category || '기타';
        const qty = Number(p.quantity || 0);
        categoryCounts[cat] = (categoryCounts[cat] || 0) + qty;
    });

    var categoryLabels = Object.keys(categoryCounts);
    var categoryData = Object.values(categoryCounts);

    var ctxCategory = document.getElementById('categoryChart').getContext('2d');
    new Chart(ctxCategory, {
        type: 'bar',
        data: {
            labels: categoryLabels,
            datasets: [{
                label: '카테고리별 구매 수량',
                data: categoryData,
                backgroundColor: 'rgba(75, 192, 192, 0.6)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        },
        options: { scales: { y: { beginAtZero: true } } }
    });

    // =============================================
    // 3. Line Chart: 일/월/연별 구매 금액 추이
    // =============================================
    var ctx = document.getElementById('dailyAmount').getContext('2d');
    var chart;

    function aggregateData(type){
        const today = new Date();
        const labels = [];
        const data = [];
        let total = 0;
        let count = 0;

        purchases.forEach(p => {
            const d = new Date(p.order_ts);
            let key;
            if(type === 'daily'){
                key = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
            } else if(type === 'month'){
                key = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0');
            } else if(type === 'year'){
                key = d.getFullYear();
            }
            if(!labels.includes(key)){
                labels.push(key);
                data.push(0);
            }
        });

        purchases.forEach(p => {
            const amount = Number(p.amount || 0);
            const d = new Date(p.order_ts);
            let key;
            if(type === 'daily'){
                key = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
            } else if(type === 'month'){
                key = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0');
            } else if(type === 'year'){
                key = d.getFullYear();
            }
            const idx = labels.indexOf(key);
            if(idx !== -1){
                data[idx] += amount;
                total += amount;
                count += 1;
            }
        });

        return { labels, data, total, count };
    }

    function renderChart(type){
        const agg = aggregateData(type);

        // KST 기준으로 카드 업데이트
        let dailyTotal = 0, monthTotal = 0, yearTotal = 0;
        const now = new Date();
        purchases.forEach(p=>{
            if(isSameDayKST(p.order_ts, now)) dailyTotal += Number(p.amount || 0);
            if(isSameMonthKST(p.order_ts, now)) monthTotal += Number(p.amount || 0);
            if(isSameYearKST(p.order_ts, now)) yearTotal += Number(p.amount || 0);
        });

        const totalAll = purchases.reduce((acc, p) => acc + Number(p.amount || 0), 0);
        const totalCount = purchases.length;

        document.getElementById('dailyAmountCard').textContent = dailyTotal > 0 ? '₩' + dailyTotal.toLocaleString() : '(-)';
        document.getElementById('monthAmountCard').textContent = monthTotal > 0 ? '₩' + monthTotal.toLocaleString() : '(-)';
        document.getElementById('yearAmountCard').textContent = yearTotal > 0 ? '₩' + yearTotal.toLocaleString() : '(-)';
        document.getElementById('totalAmount').textContent = totalAll > 0 ? '₩' + totalAll.toLocaleString() : '(-)';
        document.getElementById('totalCountCard').textContent = totalCount + '건';
        document.getElementById('chartTitle').textContent = type === 'daily' ? '일별 구매 추이' :
                                                            type === 'month' ? '월별 구매 추이' : '연별 구매 추이';

        if(chart) chart.destroy();
        chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: agg.labels,
                datasets: [{
                    label: type === 'daily' ? '일별 구매 금액' :
                           type === 'month' ? '월별 구매 금액' : '연별 구매 금액',
                    data: agg.data,
                    fill: true,
                    borderColor: 'rgba(54, 162, 235, 1)',
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    tension: 0.3
                }]
            },
            options: {
                scales: { y: { beginAtZero: true, ticks: { callback: v => '₩ ' + Number(v).toLocaleString() } } },
                plugins: { tooltip: { callbacks: { label: ctx => '₩ ' + Number(ctx.parsed.y).toLocaleString() } } }
            }
        });
    }

    renderChart('daily');
    document.querySelectorAll('.chartType-btn').forEach(btn => {
        btn.addEventListener('click', function(){
            document.querySelectorAll('.chartType-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            renderChart(btn.id.replace('-btn',''));
        });
    });
});

</script>


</body>
</html>