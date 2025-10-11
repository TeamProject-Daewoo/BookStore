<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>책 상세 정보</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
<style>
body { font-family: 'Segoe UI', 'Apple SD Gothic Neo', sans-serif; background-color: #f4f6f9; margin: 0; padding: 0; color: #333; }
.book-detail-container { max-width: 960px; margin: 60px auto; padding: 30px; background-color: #fff; border-radius: 16px; box-shadow: 0 6px 18px rgba(0,0,0,0.08); }
.book-main { display: flex; flex-wrap: wrap; gap: 32px; }
.book-image { flex: 1 1 280px; display: flex; align-items: flex-start; justify-content: center; }
.book-image img { max-width: 100%; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); object-fit: cover; }
.book-info { flex: 1 1 400px; display: flex; flex-direction: column; justify-content: space-between; gap: 24px; }
.book-header h2 { font-size: 26px; font-weight: 700; margin-bottom: 6px; }
.book-header p { margin: 3px 0; font-size: 15px; color: #555; }
.book-actions { margin-top: auto; display: flex; flex-direction: column; gap: 12px; }
.quantity-selector { display: flex; align-items: center; gap: 8px; }
.quantity-selector button { width: 36px; height: 36px; font-size: 18px; border: none; border-radius: 8px; background-color: #f1f3f5; cursor: pointer; transition: background 0.2s; }
.quantity-selector button:hover { background-color: #dee2e6; }
.quantity-selector input { width: 60px; height: 36px; text-align: center; border: 1px solid #ccc; border-radius: 8px; font-size: 15px; }
.error-message { color: #e03131; font-size: 14px; font-weight: 500; display: none; }
.btn { display: block; width: 100%; padding: 12px; border-radius: 8px; font-size: 16px; cursor: pointer; border: none; transition: background 0.2s, transform 0.1s; }
.btn:active { transform: scale(0.97); }
.btn-success { background-color: #40c057; color: #fff; }
.btn-success:hover { background-color: #37b24d; }
.btn-warning { background-color: #f59f00; color: #fff; }
.btn-warning:hover { background-color: #e67700; }
.book-description { margin-top: 40px; font-size: 15px; line-height: 1.7; color: #444; }
.book-description strong { display: block; font-size: 18px; margin-bottom: 10px; font-weight: 600; }
@media (max-width: 768px) { .book-main { flex-direction: column; } }
.book-review-container { max-width: 960px; margin: 40px auto; padding: 20px; background-color: #fff; border-radius: 16px; box-shadow: 0 6px 18px rgba(0,0,0,0.08); }
.review-menu { display: none; position: absolute; right: 0; top: 24px; background: #fff; border: 1px solid #ccc; border-radius: 6px; box-shadow: 0 2px 8px rgba(0,0,0,0.15); min-width: 100px; z-index: 10; }
.amount-cards { display: flex; justify-content: space-between; gap: 15px; margin: 20px 0; }
.amount-cards .card { flex: 1; min-width: 0; }
.card { background: #fff; border: 1px solid #eee; border-radius: 16px; padding: 24px; box-shadow: 0 12px 24px rgba(0,0,0,0.25); min-height: 400px; display: flex; flex-direction: column; }
.card h3 { margin: 0 0 12px; color: #333; text-align: left; }
/* 그래프 카드 스타일 */
.card.graph-card {
    border-radius: 16px;
    box-shadow: 0 6px 18px rgba(0,0,0,0.08);
    background-color: #fff;
    min-height: 325px;
    padding: 24px;
    background: linear-gradient(145deg, #ffffff, #f1f4f8);
    border-radius: 16px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
    transition: transform 0.2s, box-shadow 0.2s;
    position:realtive
}

.graph-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 28px rgba(0, 0, 0, 0.12);
}

.graph-card h3 {
    font-size: 18px;
    color: #333;
    margin-bottom: 20px;
    font-weight: 600;
}

#ratingChart {
    border-radius: 12px;
    background-color: #fff;
    padding: 12px;
}
.total-card { display: flex; align-items: center; justify-content: center; flex-direction: column; font-size: 24px; padding: 5px; border-radius: 16px; background: linear-gradient(135deg, #6c7ae0, #42a5f5); color: white; box-shadow: 0 6px 12px rgba(0,0,0,0.25); transition: transform 0.3s, box-shadow 0.3s; min-height: 130px; }
.total-card:hover { transform: translateY(-4px); box-shadow: 0 8px 16px rgba(0,0,0,0.3); }
.total-content { display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; }
.total-content .total-icon { font-size: 24px; margin-bottom: 8px; }
.total-content .total-label { font-size: 20px; margin-bottom: 4px; }
.total-content .total-amount { font-size: 26px; }
.daily-card { min-height: 100px; background: linear-gradient(135deg, #6c7ae0, #42a5f5); } /* 블루 */
.month-card { min-height: 100px; background: linear-gradient(135deg, #f0932b, #eb4d4b); } /* 오렌지-레드 */
.year-card { min-height: 100px; background: linear-gradient(135deg, #6ab04c, #badc58); } /* 그린 */
.count-card { min-height: 100px; background: linear-gradient(135deg, #ff4757, #ff6b81); } /* 핑크-레드 */
.chart-buttons button { border: 1px solid #ccc; background-color: #f0f0f0; padding: 5px 12px; border-radius: 15px; cursor: pointer; font-size: 0.9em; }
.chart-buttons button.active { background-color: #6c7ae0; color: white; border-color: #6c7ae0; font-weight: bold; }
.search-box { display: flex; gap: 8px; width: 100%; max-width: 400px; padding: 6px 10px; background: #fff; border: 1px solid #ddd; border-radius: 99px; box-shadow: 0 2px 6px rgba(0,0,0,.05); }
.search-box input { flex: 1; border: none; outline: none; font-size: 14px; padding: 8px 10px; border-radius: 99px; }
.search-box input::placeholder { color: #aaa; }
.search-box button { border: none; background: #2563eb; color: white; font-size: 14px; font-weight: 500; padding: 8px 16px; border-radius: 99px; cursor: pointer; transition: background 0.2s ease; }
.search-box button:hover { background: #1d4ed8; }
table { width: 95%; max-width: 1200px; margin: 0 auto; border-collapse: collapse; font-family: sans-serif; font-size: 14px; box-shadow: 0 2px 8px rgba(0,0,0,.1); background: #fff; }
thead { background: #343a40; color: #fff; border-bottom: 2px solid #dee2e6; }
th, td { padding: 12px 15px; border-bottom: 1px solid #ddd; text-align: center; }
th:nth-child(1), td:nth-child(1) { text-align: left; }
th:nth-child(4), td:nth-child(4) { text-align: right; }
.actions a { margin-right: 10px; text-decoration: none; color: #fff; margin-bottom: 8px;}
.add-button { display: inline-block; align-self: flex-start; padding: 10px 15px; background-color: #28a745; color: white; text-decoration: none; border-radius: 5px; margin-top: 20px; }
.add-button:hover { background-color: #218838; }
.book-img { width: 80px; height: auto; border-radius: 5px; object-fit: cover; }
#dailyAmount {
    width: 100%;
    height: 100%;          /* 부모 높이를 채우도록 */
}
</style>

<script>
//수량 변경 및 총 가격 계산
function updateTotalPrice() {
    var price = parseFloat('${book.price}');
    var quantityInput = document.getElementById('quantity');
    var quantity = parseInt(quantityInput.value) || 1;
    var stock = parseInt('${book.stock}');

    if(stock <= 0){
        quantity = 0;
        document.getElementById('error-message').style.display = 'block';
    } else if(quantity > stock){
        quantity = stock;
        document.getElementById('error-message').style.display = 'block';
    } else {
        document.getElementById('error-message').style.display = 'none';
    }

    quantityInput.value = quantity;
    document.getElementById('cart-quantity-input').value = quantity;
    document.getElementById('buy-now-quantity-input').value = quantity;

    var totalPrice = price * quantity;
    document.getElementById('total-price').innerText = totalPrice.toLocaleString() + ' 원';
}

function changeQuantity(change) {
    var quantityInput = document.getElementById('quantity');
    var currentQuantity = parseInt(quantityInput.value) || 1;
    var stock = parseInt('${book.stock}');

    if(change === 'increment' && currentQuantity < stock) {
        currentQuantity += 1;
    } else if(change === 'decrement' && currentQuantity > 1) {
        currentQuantity -= 1;
    }

    quantityInput.value = currentQuantity;
    document.getElementById('cart-quantity-input').value = currentQuantity;
    document.getElementById('buy-now-quantity-input').value = currentQuantity;

    updateTotalPrice();
}
</script>
</head>

<body>
   <div class="book-detail-container">
      <div class="book-main">
         <div class="book-image">
             <%-- 1. 이미지 경로를 로컬/API 경우에 따라 다르게 처리 --%>
             <c:choose>
                <c:when test="${book.img.startsWith('http')}">
                   <img src="${book.img}" alt="책 표지">
                </c:when>
                <c:otherwise>
                   <img src="${pageContext.request.contextPath}/resources/images/${book.img}" alt="책 표지">
                </c:otherwise>
             </c:choose>
         </div>

         <div class="book-info">
            <div class="book-header">
               <h2>${book.title}</h2>
               <p><strong>저자:</strong> ${book.author}</p>
               <p><strong>가격:</strong> <fmt:formatNumber value="${book.price}" pattern="#,###" /> 원</p>
               <p><strong>재고:</strong> ${book.stock}</p>
            </div>
    			<span style="color:#f5c518; font-size: 24px; line-height: 1;">
    <c:choose>
        <c:when test="${not empty reviews}">
            <c:set var="roundedRating" value="${averageRating - (averageRating % 1)}"/>
            <c:forEach var="i" begin="1" end="5">
                <c:choose>
                    <c:when test="${i <= roundedRating}">★</c:when>
                    <c:otherwise>☆</c:otherwise>
                </c:choose>
            </c:forEach>
            (<fmt:formatNumber value="${averageRating}" pattern="#0.0"/>점)[${reviews.size()}]
        </c:when>
        <c:otherwise>
            <c:forEach var="i" begin="1" end="5">
                <span style="color:#ccc; font-size: 24px;">★</span>
            </c:forEach>
            (0점, 0건)
        </c:otherwise>
    </c:choose>
</span>
			<div class="card graph-card">
    				<h3 style="margin-bottom: 16px; font-size: 18px; color: #333;">별점별 리뷰 비율</h3>
    				<canvas id="ratingChart" style="width:100%; height:225px;"></canvas>
			</div>
            <c:if test="${book.stock > 0}">
   				<div class="book-actions">
     				<div class="actions" style="display:flex; justify-content: space-between;">
    					<a href="${pageContext.request.contextPath}/manager/bookeditform?id=${book.id}" 
       					class="btn btn-primary">✏ 수정</a>
    					<a href="${pageContext.request.contextPath}/manager/bookdelete?id=${book.id}" 
       					class="btn btn-danger"
       					onclick="return confirm('정말로 이 책을 삭제하시겠습니까?');">🗑 삭제</a>
					</div>
   				</div>
			</c:if>

            <c:if test="${book.stock <= 0}">
               <div class="book-actions">
                  <p class="error-message" style="display: block;">🚫 재고가 없습니다!</p>
               </div>
            </c:if>
         </div>
      </div>

      <div class="book-description">
         <strong>책 설명</strong>
         <p>${book.description}</p>
      </div>
      
<hr style="margin: 30px 0; border: none; border-top: 1px solid #ddd;">
      <div class="dash-grid">
    	<div class="amount-cards">
    <!-- 일별 구매 금액 카드 -->
    <div class="card total-card daily-card">
        <div class="total-content">
            <span class="total-label">당일 판매 권수</span>
            <span id="dailyAmountCard" class="total-amount">₩ 0</span>
        </div>
    </div>

    <!-- 월별 구매 금액 카드 -->
    <div class="card total-card month-card">
        <div class="total-content">
            <span class="total-label">월 판매 권수</span>
            <span id="monthAmountCard" class="total-amount">₩ 0</span>
        </div>
    </div>

    <!-- 연별 구매 금액 카드 -->
    <div class="card total-card year-card">
        <div class="total-content">
            <span class="total-label">연 판매 권수</span>
            <span id="yearAmountCard" class="total-amount">₩ 0</span>
        </div>
    </div>
    
    <!-- 총 결제 건수 카드 -->
    <div class="card total-card count-card">
        <div class="total-content">
            <span class="total-label">총 판매 권수</span>
            <span id="totalCountCard" class="total-amount">0건</span>
        </div>
    </div>
</div>
    		
		</div>
		  <!-- 기존 구매 금액 추이 그래프 -->
    <div class="card graph-card">
        <h3 id="chartTitle">최근 7일 일별 판매 권수</h3>
        <div class="chart-buttons">
            <button id="daily-btn" class="chartType-btn active">일별</button>
			<button id="month-btn" class="chartType-btn">월별</button>
			<button id="year-btn" class="chartType-btn">연별</button>
        </div>
        <canvas id="dailyAmount" style="width:100%; height:325px"></canvas>
    </div>
   </div>
   


   <c:if test="${not empty book.id}">
    <div class="book-review-container" style="max-width: 960px; margin: 40px auto; padding: 20px; background-color: #fff; border-radius: 16px; box-shadow: 0 6px 18px rgba(0,0,0,0.08);">
    
        <h3 style="margin-bottom: 20px;">📖 리뷰</h3>

        <hr style="margin: 20px 0;">

        <h4>리뷰 목록</h4>
        <c:if test="${not empty reviews}">
            <c:forEach var="review" items="${reviews}">
                <div style="display: flex; gap: 16px; padding: 12px; border-bottom: 1px solid #eee;">
                    <!-- 왼쪽: 프로필 이미지 -->
                    <div style="flex-shrink: 0;">
                        <img src="<c:url value='/user/profileImageByUsername/${review.userId}' />"
                             alt="프로필 이미지"
                             style="width:70px; height:70px; border-radius:50%; object-fit:cover;">
                    </div>

                    <!-- 오른쪽: 리뷰 내용 -->
                    <div style="flex:1; display:flex; flex-direction:column; gap:6px;">
                        <!-- 헤더: 닉네임 + 별점 + 날짜 + 수정/삭제 버튼 -->
                        <div style="display:flex; align-items:center; justify-content:space-between; gap:16px;">
                            <!-- 왼쪽: 닉네임 + 별점 -->
                            <div style="display:flex; align-items:center; gap:8px;">
                                <strong style="font-size:16px;">${review.userId}</strong>
                                <span style="color:#f5c518;">
                                    <c:forEach var="i" begin="1" end="5">
                                        <c:choose>
                                            <c:when test="${i <= review.rating}">★</c:when>
                                            <c:otherwise>☆</c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </span>
                            </div>

                            <!-- 가운데: 빈 공간 -->
                            <div style="flex:1"></div>

                            <!-- 오른쪽: 날짜 -->
                            <span style="font-size:12px; color:#888; white-space:nowrap; margin-right:8px;">
                                <fmt:formatDate value="${review.createdAt}" pattern="yyyy-MM-dd" />
                            </span>

                            <!-- 수정/삭제 버튼 -->
                            <c:if test="${review.userId == user or pageContext.request.isUserInRole('ROLE_ADMIN')}">
                                <div style="position:relative;">
                                    <button onclick="toggleMenu(this)" 
                                            style="background:none; border:none; font-size:20px; cursor:pointer;">⋮</button>
                                    <div class="review-menu" style="display:none; position:absolute; right:0; top:24px; 
                                         background:#fff; border:1px solid #ccc; border-radius:6px; 
                                         box-shadow:0 2px 8px rgba(0,0,0,0.15); min-width:100px; z-index:10;">
                                        <form action="/manager/reviewEdit" method="get" style="margin:0;">
                                            <input type="hidden" name="reviewId" value="${review.reviewId}" />
                                            <button type="submit" style="display:block; width:100%; border:none; background:none; padding:8px; cursor:pointer; text-align:left;">수정</button>
                                        </form>
                                        <form action="/manager/reviewDelete" method="post" style="margin:0;">
                                            <input type="hidden" name="reviewId" value="${review.reviewId}" />
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit" style="display:block; width:100%; border:none; background:none; padding:8px; cursor:pointer; color:red; text-align:left;">삭제</button>
                                        </form>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <!-- 리뷰 내용 -->
                        <p style="margin:0; line-height:1.4;">${review.content}</p>
                    </div>
                </div>
            </c:forEach>
        </c:if>
        <c:if test="${empty reviews}">
            <p>아직 등록된 리뷰가 없습니다.</p>
        </c:if>
    </div>
</c:if>

<script>
document.addEventListener('DOMContentLoaded', function () {
    // ----------------------------
    // 1. 판매 데이터 차트 (기존 daily/month/year)
    // ----------------------------
     // 페이지 로드 시 realPurchases 배열 초기화
    const realPurchases = [
        <c:forEach var="p" items="${purchaseList}" varStatus="st">
        {
            category: "${p.category}",
            quantity: ${p.quantity},
            order_ts: ${p.order_date.time}
        }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    var ctx = document.getElementById('dailyAmount')?.getContext('2d');
    var chart;

    function aggregateData(type) {
        let map = {};
        let today = new Date();

        if(type === 'daily'){
            for(let i=6; i>=0; i--){
                let d = new Date(today);
                d.setDate(today.getDate() - i);
                let key = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
                map[key] = 0;
            }
        } else if(type === 'month'){
            for(let i=5; i>=0; i--){
                let d = new Date(today.getFullYear(), today.getMonth()-i, 1);
                let key = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0');
                map[key] = 0;
            }
        } else if(type === 'year'){
            for(let i=5; i>=0; i--){
                let year = today.getFullYear() - i;
                map[year] = 0;
            }
        }

        let total = 0;
        const purchases = [...realPurchases]; // 실시간 데이터 복사본 사용

        purchases.forEach(p => {
            let d = new Date(Number(p.order_ts));
            let key;
            if(type === 'daily') key = d.getUTCFullYear() + '-' + String(d.getUTCMonth()+1).padStart(2,'0') + '-' + String(d.getUTCDate()).padStart(2,'0');
            else if(type === 'month') key = d.getUTCFullYear() + '-' + String(d.getUTCMonth()+1).padStart(2,'0');
            else key = d.getUTCFullYear();
            if(map.hasOwnProperty(key)){
                map[key] += Number(p.quantity || 0);
                total += Number(p.quantity || 0);
            }
        });

        let labels = Object.keys(map).sort();
        let data = labels.map(k => map[k]);
        return { labels, data, total };
    }
    
 	
 
    function renderChart(type){
        const agg = aggregateData(type);
        const dailyTotal = aggregateData('daily').data.slice(-1)[0] || 0;
        const monthTotal = aggregateData('month').data.slice(-1)[0] || 0;
        const yearTotal = aggregateData('year').data.slice(-1)[0] || 0;
        const totalCount = [...realPurchases].reduce((acc,p)=>acc+Number(p.quantity||0),0);

        document.getElementById('dailyAmountCard').textContent = dailyTotal + '권';
        document.getElementById('monthAmountCard').textContent = monthTotal + '권';
        document.getElementById('yearAmountCard').textContent = yearTotal + '권';
        document.getElementById('totalCountCard').textContent = totalCount + '권';

        document.getElementById('chartTitle').textContent = 
            type === 'daily' ? '일별 판매 권수' :
            type === 'month' ? '월별 판매 권수' :
            '연별 판매 권수';

        if(chart) chart.destroy();  // 기존 차트 삭제
        chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: agg.labels,
                datasets: [{
                    label: type === 'daily' ? '일별 판매 권수' :
                           type === 'month' ? '월별 판매 권수' :
                           '연별 판매 권수',
                    data: agg.data,
                    fill: true,
                    borderColor: 'rgba(54, 162, 235, 1)',
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    tension: 0.3
                }]
            },
            options: {
                responsive: false,
                maintainAspectRatio: false,
                scales: { y: { beginAtZero: true } },
                plugins: { tooltip: { callbacks: { label: ctx => ctx.parsed.y + '권' } } }
            }
        });
        chart.resize();  // 차트 리사이즈
        
    }

    renderChart('daily');  // 처음 로드될 때 차트 렌더링

    document.querySelectorAll('.chartType-btn').forEach(btn => {
        btn.addEventListener('click', function(){
            document.querySelectorAll('.chartType-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            renderChart(btn.id.replace('-btn',''));
        });
    });

    // ----------------------------
    // 2. 리뷰 평점 차트
    // ----------------------------
 	// 서버에서 전달한 JSON 문자열을 JS 배열로 변환
    let reviewData = [];
    <% if (request.getAttribute("reviewJson") != null) { %>
        reviewData = JSON.parse('<%= request.getAttribute("reviewJson") %>');
    <% } %>

    // 별점 카운트 초기화 (1~5)
    const ratingData = [0,0,0,0,0];

    // 안전하게 반복하며 갯수 집계
    reviewData.forEach(r => {
        let rating = Number(r.rating) || 0;
        if(rating >= 1 && rating <= 5) ratingData[rating-1] += 1;
    });

    // 총 리뷰 수 및 퍼센트 계산
    const totalReviews = ratingData.reduce((a,b)=>a+b,0);
    const ratingPercent = totalReviews > 0
        ? ratingData.map(r => (r/totalReviews*100).toFixed(1))
        : [0,0,0,0,0];

    // 차트 그리기
    const ratingCtx = document.getElementById('ratingChart').getContext('2d');
    new Chart(ratingCtx, {
        type: 'bar',
        data: {
            labels: ['★','★★','★★★','★★★★','★★★★★'],
            datasets: [{
                label: '리뷰 비율',
                data: ratingPercent,
                backgroundColor: ['#ff6b6b','#ff8787','#ffa8a8','#ffd6d6','#ffe3e3'],
                borderRadius: 8,
                borderSkipped: false
            }]
        },
        options: {
            indexAxis: 'y',
            scales: {
                x: {
                    beginAtZero:true,
                    max:100,
                    ticks:{
                        callback: v => v + '%',
                        color:'#000',
                        font:{ size:13, weight:'600', family:"'Segoe UI', sans-serif" }
                    },
                    grid:{ color:'#eee', drawBorder:false }
                },
                y: {
                    ticks:{
                        color:'#000',
                        font:{ size:14, weight:'600', family:"'Segoe UI', sans-serif" }
                    },
                    grid:{ drawTicks:false, color:'#f5f5f5', drawBorder:false }
                }
            },
            plugins: {
                legend:{ display:false },
                tooltip:{ callbacks:{ label: ctx => ctx.parsed.x + '%' } },
                datalabels:{
                    anchor:'center',
                    align:'right',
                    formatter: v => v+'%',
                    color:'#000',
                    font:{ weight:'700', size:13, family:"'Segoe UI', sans-serif" },
                    offset:6
                }
            },
            interaction:{ intersect:false, mode:'nearest' },
            animation:{ duration:1000, easing:'easeOutQuart' },
        },
        plugins:[ChartDataLabels]
    });
});
</script>


</body>
</html>