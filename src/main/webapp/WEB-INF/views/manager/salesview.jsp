<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
  h2 { text-align:center; font-family:sans-serif; margin:30px 0; }
  table {
    width:95%; max-width:1200px; margin:0 auto; border-collapse:collapse;
    font-family:sans-serif; font-size:14px; box-shadow:0 2px 8px rgba(0,0,0,.1); background:#fff;
  }
  thead { background:#343a40; color:#fff; border-bottom:2px solid #dee2e6; }
  th, td { padding:12px 15px; border-bottom:1px solid #ddd; text-align:center; }
  th:nth-child(1), td:nth-child(1) { text-align:left; }
  th:nth-child(4), td:nth-child(4) { text-align:right; }
  tbody tr:hover { background:#eef5ff; }
  .total-sum {
    width:95%; max-width:1200px; margin:0 auto 30px; font-family:sans-serif;
    font-size:48px; font-weight:bold; text-align:center; color:#2a5298;
  }
  .empty-list {
    width:95%; max-width:1200px; margin:100px auto; padding: 100; font-family:sans-serif;
    font-size:48px; font-weight:bold; text-align:center; color:#FF2F2F;
  }
  .dash-grid {
    width:95%; max-width:1200px; margin:32px auto; display:grid; grid-template-columns:1fr 1fr; gap:24px;
  }
  .card {
    background:#fff; border:1px solid #eee; border-radius:16px; padding:16px; box-shadow:0 2px 8px rgba(0,0,0,.04);
  }
  .card h3 { margin:0 0 12px; color:#333; text-align:left; font-family:sans-serif; }
  .chart-buttons button { border: 1px solid #ccc; background-color: #f0f0f0; padding: 5px 12px; border-radius: 15px; cursor: pointer; font-size: 0.9em; }
  .chart-buttons button.active { background-color: #6c7ae0; color: white; border-color: #6c7ae0; font-weight: bold; }
  canvas { width:100%; height:360px; }
</style>

<div class="container">
<h2>판매 현황</h2>

<div class="total-sum"></div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

  <div class="dash-grid">
    <div class="card">
      <h3 class="salesChartTitle">최근 7일 일별 판매금액</h3>
      <div class="chart-buttons">
      	  <!-- 통계 추가할 때 클래스명 'chartType-btn'으로 하기(script에서 동적 처리) -->
          <button id="daily-btn" onclick="changeChartType('daily')">일별</button>
          <button id="month-btn" onclick="changeChartType('month')">월별</button>
      </div>
      <canvas id="recentSale"></canvas>
    </div>
    <div class="card">
      <h3>책별 판매량 Top5 (수량)</h3>
      <canvas id="topBooks"></canvas>
    </div>
  </div>

<table>
  <thead>
    <tr>
      <th>ID</th>
      <th>구매자명</th>
      <th>제목</th>
      <th>합계 가격</th>
      <th>구매날짜</th>
    </tr>
  </thead>
  <tbody></tbody>
</table>
</div>
<h3 class='empty-list' style="display: none">판매된 책이 없습니다!</h3>

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

function recentSalesRender(result, chartType) {
	// 1. 차트 데이터를 담을 공통 변수 선언
	let labels, amounts, datasetLabel;

	// 2. chartType에 따라 변수에 데이터 할당
	switch(chartType) {
		case "daily": {
			datasetLabel = '일별 판매금액';

			// 최근 7일 날짜 배열 생성
			const today = new Date();
			const days = [];
			for (let i = 6; i >= 0; i--) {
				const d = new Date(today);
				d.setDate(today.getDate() - i);
				const y  = d.getFullYear();
				const m  = String(d.getMonth() + 1).padStart(2, '0');
				const dd = String(d.getDate()).padStart(2, '0');
				days.push(y + '-' + m + '-' + dd);
			}

			// 일별 매출 집계
			const dailyAmountMap = {};
			for (const day of days) dailyAmountMap[day] = 0;

			result.purchase.forEach(function (p) {
				const d = new Date(p.order_date);
				const key = d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
				if (dailyAmountMap.hasOwnProperty(key)) {
					dailyAmountMap[key] += Number(p.total_price || 0);
				}
			});

			// 최종 데이터 할당
			labels  = days.map(d => d.slice(5)); // 'MM-DD' 형식
			amounts = days.map(d => dailyAmountMap[d]);
			break;
		}
		case "month": {
			datasetLabel = '월별 판매금액';

			// 최근 7개월 배열 생성
			const today = new Date();
			const months = [];
			for (let i = 6; i >= 0; i--) {
				const d = new Date(today);
				d.setMonth(today.getMonth() - i);
				const y = d.getFullYear();
				const m = String(d.getMonth() + 1).padStart(2, '0');
				months.push(y + '-' + m);
			}

			// 월별 매출 집계
			const monthlyAmountMap = {};
			for (const month of months) monthlyAmountMap[month] = 0;

			result.purchase.forEach(function (p) {
				const d = new Date(p.order_date);
				const key = d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0');
				if (monthlyAmountMap.hasOwnProperty(key)) {
					monthlyAmountMap[key] += Number(p.total_price || 0);
				}
			});
		
			//최종 데이터 할당
			labels = months; // 'YYYY-MM' 형식
			amounts = months.map(m => monthlyAmountMap[m]);
			break;
		}
	}

   	let chartDiv = document.getElementById('recentSale');
   	if(charts[0]) charts[0].destroy();
   	charts[0] = new Chart(chartDiv.getContext('2d'), {
		type: 'line',
		data: {
			labels: labels,
			datasets: [{ 
				label: datasetLabel,
				data: amounts,
				tension: 0.3, 
				fill: true 
			}]
		},
		options: {
			plugins: { tooltip: { callbacks: { label: function (i) { return '₩ ' + Number(i.raw || 0).toLocaleString(); } } } },
			scales:  { y: { ticks: { callback: function (v) { return '₩ ' + Number(v).toLocaleString(); } } } }
		}
  	});
}

function topBooksRender(result) {
	var bookQtyMap = {};
    result.purchase.forEach(function (p) {
      (p.bookList || []).forEach(function (b) {
        var t = b.book_title || '제목없음';
        var q = Number(b.quantity || 0);
        bookQtyMap[t] = (bookQtyMap[t] || 0) + q;
      });
    });
    var topEntries = Object.keys(bookQtyMap).map(function (k) { return [k, bookQtyMap[k]]; })
                   .sort(function (a,b) { return b[1]-a[1]; }).slice(0,5);
    var topLabels = topEntries.map(function (e) { return e[0]; });
    var topQty    = topEntries.map(function (e) { return e[1]; });

    // 차트 렌더링
    let chartDiv = document.getElementById('topBooks');
		if(charts[1]) charts[1].destroy();
		charts[1] = new Chart(chartDiv.getContext('2d'), {
		      type: 'bar',
		      data: { labels: topLabels, datasets: [{ label: '판매수량', data: topQty }] },
		      options: {
		        indexAxis: 'y',
		        plugins: { tooltip: { callbacks: { label: function (i) { return Number(i.raw || 0).toLocaleString() + ' 개'; } } } },
		        scales:  { x: { ticks: { callback: function (v) { return Number(v).toLocaleString() + ' 개'; } } } }
		      }
		});
}

let charts = [];
//초기 활성화 시킬 버튼
let chartType = "daily";
document.getElementById(chartType+"-btn").classList.toggle("active", true);
function changeChartType(newType) {
	chartType = newType;
	const titleEl = document.getElementsByClassName("salesChartTitle")[0];
	//newType에 맞는 버튼만 활성화 표시
    document.getElementById("daily-btn").classList.toggle("active", chartType === "daily");
    document.getElementById("month-btn").classList.toggle("active", chartType === "month");
    titleEl.textContent = (chartType === "daily") ? '최근 7일 일별 판매금액' : '최근 7개월 월별 판매금액';
    render(true);
}
/**
 * 합계, 차트, 테이블 모두 랜더링  
 *
 * @param {boolean} onlyrecentSale 최근 판매 현황 차트만 랜더링 여부
 * @return {void}
 */
function render(onlyrecentSale) {
	fetch("/api/renderSalesList", {
		method: 'GET',
		headers : {"Accept": "application/json"}
	})
	.then(response => response.json())
	.then(result => {
		//console.log(result);
	    if(result.purchase.length === 0) {
	    	document.getElementsByClassName("container")[0].style.display = "none";
	    	document.getElementsByClassName("empty-list")[0].style.display = "block";
	    	return;
	    } else {
	    	document.getElementsByClassName("container")[0].style.display = "block";
	    	document.getElementsByClassName("empty-list")[0].style.display = "none";
	    }
	    
		const tbody = document.querySelector("tbody");
	    tbody.textContent = "";
	  	//총합계
	  	document.getElementsByClassName("total-sum")[0].textContent = "전체 판매 합계:"+result.totalSum;
		
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
	    
	    //최근 판매 현황
	 	recentSalesRender(result, chartType);
	    //일별/월별 판매만 랜더링
	 	if(onlyrecentSale) return;
	 	topBooksRender(result);
	});
  }

//render();
socket.onmessage = (message) => render(false);

</script>
