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
  .daily-sum, .monthly-sum, .yearly-sum, .total-sum {
  width: 250px;
  padding: 20px;
  margin: 15px;
  border-radius: 15px;
  font-size: 18px;
  font-weight: bold;
  text-align: center;
  color: #fff;
  box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.daily-sum {
  background: linear-gradient(150deg, #f0a8a8, #fa004b);
}

.monthly-sum {
  background: linear-gradient(150deg, #0084d6, #7eeaec);
}

.yearly-sum {
  background: linear-gradient(150deg, #f5ff70, #ffa742);
}

.total-sum {
  background: linear-gradient(150deg, #aeffa8, #0cc64d);
}

.daily-sum:hover, .monthly-sum:hover, .yearly-sum:hover, .total-sum:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 14px rgba(0,0,0,0.15);
}
.total-sum-div {
	max-width:1200px;
	width: 95%;
	margin:32px auto;
}
.total-sum-title {
	margin: auto;
}
.infor-view {
	width: 95%;
	margin:32px auto;
	display: flex;
	justify-content: space-between;
}
.sales-chart {
	width: 42%;
}
.sales-chart-graph {
  position: relative;
  width: 100%;
  max-width: 150px;
}
@media (min-width: 768px) {
  .sales-chart-graph {
    max-width: 225px;
  }
}
@media (min-width: 1200px) {
  .sales-chart-graph {
    max-width: 300px;
  }
}
.toggle-view {
	margin-left: auto;
  	display: flex;
 	align-items: center;
}

.toggle-view-label {
	color: gray;
	margin-right: 5px;
}

#toggleViewBtn {
  appearance: none;
  position: relative;
  border: max(2px, 0.1em) solid gray;
  border-radius: 1.25em;
  width: 2.25em;
  height: 1.25em;
}

#toggleViewBtn::before {
  content: "";
  position: absolute;
  left: 0;
  width: 1em;
  height: 1em;
  border-radius: 50%;
  transform: scale(0.8);
  background-color: gray;
  transition: left 250ms linear;
}

#toggleViewBtn:checked {
  background-color: rgb(46, 204, 113);
  border-color: rgb(46, 204, 113);
}

#toggleViewBtn:checked::before {
  background-color: white;
  left: 1em;
}

#toggleViewBtn:focus-visible {
  outline-offset: max(2px, 0.1em);
  outline: max(2px, 0.1em) solid lightgray;
}

#toggleViewBtn:enabled:hover {
  box-shadow: 0 0 0 max(4px, 0.2em) lightgray;
}

.chart {
	width: 56%;
}
  .empty-list {
    width:95%; max-width:1200px; font-family:sans-serif;
    font-size:30px; font-weight:bold; text-align:center; color:#FF2F2F;
  }
  .dash-grid {
    width:95%; max-width:1200px; margin:32px auto; display:grid; grid-template-columns:1fr 1fr; gap:24px;
  }
  .card {
    background:#fff; border:1px solid #eee; border-radius:16px; padding:16px; box-shadow:0 2px 8px rgba(0,0,0,.04);
  }
.carousel-control-prev-icon,
.carousel-control-next-icon {
  filter: invert(100%) sepia(100%) saturate(0%) hue-rotate(0deg) brightness(100%) contrast(100%);
}
.sales-chart-graph {
  position: relative; 
}
.carousel-control-prev,
.carousel-control-next {
  position: absolute;
  top: 65%;
  transform: translateY(-50%);
  height: 70%;
}

  .card h3 { margin:0 0 12px; color:#333; text-align:left; font-family:sans-serif; }
  .chart-buttons button { border: 1px solid #ccc; background-color: #f0f0f0; padding: 5px 12px; border-radius: 15px; cursor: pointer; font-size: 0.9em; }
  .chart-buttons button.active { background-color: #6c7ae0; color: white; border-color: #6c7ae0; font-weight: bold; }
  .chart-buttons button.active:hover { background-color: #5c7ade; }
  .chart-buttons button:not(.active):hover { background-color: #e0e0e0; }
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
  canvas { width:100%; height:360px; }
</style>

<div class="container">
<div class="total-sum-div">
	<div class="card">
		<h3 class="total-sum-title">기간별 매출액</h3>
		<div style="display: flex">
			<div class="daily-sum"></div>
			<div class="monthly-sum"></div>
			<div class="yearly-sum"></div>
			<div class="total-sum"></div>
		</div>
	</div>
</div>
<div class="infor-view">
	<div class="sales-chart">
		<div class="card" style="align-items: center;">
			<h3 class="sales-chart-title">책별 매출액</h3>
			<div class="toggle-view">
				<span class="toggle-view-label">판매량 보기</span>
				<input id="toggleViewBtn" role="switch" type="checkbox" />
			</div>
			<div class="sales-chart-graph">
				<canvas id="SalesByGroup"></canvas>
			</div>
			<button class="carousel-control-prev" type="button">
		      <span class="carousel-control-prev-icon"></span>
		    </button>
		    <button class="carousel-control-next" type="button">
		      <span class="carousel-control-next-icon"></span>
		    </button>
		</div>
	</div>
	<div class="chart">
		<div class="card">
			<h3 class="">차트</h3>
		</div>
	</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

  <div class="dash-grid">
    <div class="card">
      <h3 class="sales-chart-title">최근 7일 일별 판매금액</h3>
      <div class="chart-buttons">
      	  <!-- 통계 추가할 때 클래스명 'chartType-btn'으로 하기(script에서 동적 처리) -->
          <button id="daily-btn" onclick="changeChartType('daily')">일별</button>
          <button id="month-btn" onclick="changeChartType('month')">월별</button>
          <button id="year-btn" onclick="changeChartType('year')">연도별</button>
      </div>
      <canvas id="recentSale"></canvas>
    </div>
    <div class="card">
      <h3>책별 판매량 Top5</h3>
      <canvas id="topBooks"></canvas>
    </div>
  </div>
  
  <div class="table-container">
	<div class="table-header">
	<select id="orderSelect">
	  <option value="p.order_date">날짜</option>
	  <option value="p.id">ID</option>
	  <option value="b.price">가격</option>
	</select>
	<button id="orderToggle" type="button" data-order="desc">
	  <span id="orderText">▼내림차순</span>
	</button>
	<div class="search-box">
	  	<input type="text" name="keyword" placeholder="제목 또는 구매자명 검색">
	    <button>검색</button>
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
</div>

<input type="hidden" id="_csrf" name="_csrf" value="${_csrf.token}">
<input type="hidden" id="_csrf_header" value="${_csrf.headerName}">

<script>
const toggle = document.getElementById('orderToggle');
const orderSelect = document.getElementById('orderSelect');
orderSelect.addEventListener('change', () => {
	render({'table':''});
});
const searchBtn = document.querySelector('.search-box button');
searchBtn.addEventListener('click', () => {
	render({'table':''});
});
const inputBox = document.querySelector('.search-box input[name=keyword]');
toggle.addEventListener('click', () => {
    const current = toggle.dataset.order;
    const next = current === 'asc' ? 'desc' : 'asc';
    toggle.dataset.order = next;
    toggle.textContent = next === 'asc' ? '▲오름차순' : '▼내림차순';
    render({'table':''});
});

//salesChart 목록
let salesChartPage = 0;
const salesChartList = {0:["book", "책"], 1:["category", "카테고리"], 2:["author", "작가"]};
['prev', 'next'].forEach((page) => {
	document.getElementsByClassName('carousel-control-'+page)[0].addEventListener('click', () => {
		salesChartPage += (page === 'prev') ? -1 : 1;
		salesChartPage = (salesChartPage+3)%3;
		render({'salesByGroup':''});
	});
})

//salesChart 매출액/판매량 전환 버튼
let isViewCount = false;
const salesViewToggle = document.getElementById("toggleViewBtn");
salesViewToggle.addEventListener('click', () => {
	isViewCount = !isViewCount;
	render({'salesByGroup':''});
});


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

/* ============= 차트 랜더링 함수 ============= */
function recentSalesRender(result, chartType) {
	// 1. 차트 데이터를 담을 공통 변수 선언
	let labels, amounts, datasetLabel;
	const today = new Date();
	let tempDate = [];
	const amountMap = {};
	const dateCount = 7;
	
	// 2. chartType에 따라 변수에 데이터 할당
	switch(chartType) {
		case "daily": {
			datasetLabel = '일별 매출액';
			for (let i = dateCount-1; i >= 0; i--) {
				const d = new Date(today);
				d.setDate(today.getDate() - i);
				const y  = d.getFullYear();
				const m  = String(d.getMonth() + 1).padStart(2, '0');
				const dd = String(d.getDate()).padStart(2, '0');
				tempDate.push(y + '-' + m + '-' + dd);
			}

			// 일별 매출 집계
			for (const day of tempDate) amountMap[day] = 0;
			
			result.purchase.forEach(function (p) {
				const d = new Date(p.purchaseList.order_date);
				const key = d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
				if (amountMap.hasOwnProperty(key)) {
					amountMap[key] += Number(p.purchaseList.total_price || 0);
				}
			});

			// 최종 데이터 할당
			labels = tempDate.map(d => d.slice(5)); // 'MM-DD' 형식
			break;
		}
		case "month": {
			datasetLabel = '월별 매출액';
			for (let i = dateCount-1; i >= 0; i--) {
				const d = new Date(today);
				d.setMonth(today.getMonth() - i);
				const y = d.getFullYear();
				const m = String(d.getMonth() + 1).padStart(2, '0');
				tempDate.push(y + '-' + m);
			}

			// 월별 매출 집계
			for (const month of tempDate)
				amountMap[month] = 0;

			result.purchase.forEach(function (p) {
				const d = new Date(p.purchaseList.order_date);
				const key = d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0');
				if (amountMap.hasOwnProperty(key)) {
					amountMap[key] += Number(p.purchaseList.total_price || 0);
				}
			});
		
			//최종 데이터 할당
			labels = tempDate;
			break;
		}
		case "year": {
		    datasetLabel = '연도별 매출액';

		    const currentYear = today.getFullYear();
		    for (let i = dateCount-1; i >= 0; i--)
		    	tempDate.push(currentYear - i);

		    const yearlyAmountMap = {};
		    for (const year of tempDate)
		    	amountMap[year] = 0;
		    
		    result.purchase.forEach(function (p) {
		        const d = new Date(p.purchaseList.order_date);
		        const year = d.getFullYear();
		        if (amountMap.hasOwnProperty(year))
		        	amountMap[year] += Number(p.purchaseList.total_price || 0);
		    });

		    labels = Object.keys(amountMap).sort();
		}
	}
	
	amounts = tempDate.map(d => amountMap[d]);

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

function tableRender(result) {
	const tbody = document.querySelector("tbody");
    tbody.textContent = "";
    
    if(result.purchase.length === 0) {
    	const tr = document.createElement('tr');
        tr.className = 'empty-list';

        const td = document.createElement('td');
        td.setAttribute('colspan', '5');
        td.textContent = '해당하는 구매내역이 없습니다!';
        td.style.textAlign = 'center';

        tr.appendChild(td);
        tbody.appendChild(tr);
        return;
    }
	result.purchase.forEach(purchase => {
	      const tr = document.createElement("tr");

	      const p = purchase.purchaseList
	      // id
	      let td = document.createElement("td");
	      td.textContent = p.id;
	      tr.appendChild(td);

	      // member_name
	      td = document.createElement("td");
	      td.textContent = p.member_name;
	      tr.appendChild(td);

	      // bookList 내부
	      td = document.createElement("td");
		  getBookInfor(purchase.bookList, td);
		  tr.appendChild(td);

	      // total_price
	      td = document.createElement("td");
	      td.textContent = p.total_price;
	      tr.appendChild(td);

	      // order_date 변환 (timestamp → yyyy-MM-dd)
	      td = document.createElement("td");
	      const dateObj = new Date(p.order_date);
	      td.textContent = dateObj.toISOString().split("T")[0];
	      tr.appendChild(td);

	      tbody.appendChild(tr);
	    });
}

function salesByGroupRender(result, chartType) {
	let chartDiv = document.getElementById('SalesByGroup');
	if (charts[2]) charts[2].destroy();
	const salesMap = {};
	let colorList = [];
	let labelName, data;
	document.getElementsByClassName('sales-chart-title')[0].textContent = salesChartList[salesChartPage][1] + "별 "+((isViewCount) ? "판매량" : "매출액");
	switch (chartType) {
		case "book":
			data = "book_title";
			labelName = '책별 ';
			colorList = [
            	'rgb(0, 76, 153)',   // 진한 파랑
            	'rgb(0, 102, 204)',  // 기본 파랑
            	'rgb(0, 128, 255)',  // 밝은 파랑
            	'rgb(51, 153, 255)', // 하늘색 파랑
            	'rgb(102, 178, 255)',// 연한 파랑
            	'rgb(0, 191, 255)',  // 딥 스카이 블루
            	'rgb(70, 130, 180)', // 스틸 블루
            	'rgb(30, 144, 255)', // 도저 블루
            	'rgb(135, 206, 250)' // 라이트 스카이 블루
            ]
			break;
		case "category":
			data = "category";
			labelName = '카테고리별 ';
			colorList = [
				'rgb(255, 140, 0)',   // 다크 오렌지
				'rgb(255, 165, 0)',   // 오렌지
				'rgb(255, 200, 0)',   // 골드 계열
				'rgb(255, 215, 0)',   // 선명한 노랑
				'rgb(255, 239, 130)'  // 연한 노랑
            ]
			break;
		case "author":
			data = "author";
			labelName = '작가별 ';
			colorList = [
				'rgb(0, 128, 0)',     // 기본 그린
				'rgb(34, 139, 34)',   // 포레스트 그린
				'rgb(46, 204, 113)',  // 에메랄드
				'rgb(60, 179, 113)',  // 미디엄 시그린
				'rgb(144, 238, 144)', // 연두색
				'rgb(100, 200, 100)'  // 연한 녹색
            ]
			break;
	}
	
	const isbns = {}
	labelName += (isViewCount) ? '판매량' : '매출액';
	result.purchase.forEach((p) => {
		for (let b of p.bookList) {
			const d = b[data];
			isbns[b[data]] = b["isbn"];
			if(chartType === 'category' && d === '기타') continue;
			if(isViewCount) {
				var q = Number(b.quantity || 0);
		        salesMap[d] = (salesMap[d] || 0) + q;
			}
			else {
				const price = Number(p.purchaseList.total_price || 0);
		    	salesMap[d] = salesMap.hasOwnProperty(d) ? price+salesMap[d] : price;
			}
		};
	});
	 
	const labels = Object.keys(salesMap);
	const tempLabels = labels.map(text => {
	    // 12자 이상이면 자르고 ... 붙임
	    return text.length > 12 ? text.substring(0, 12) + '...' : text;
	});
	const amounts = labels.map(price => salesMap[price]);
	
	charts[2] = new Chart(chartDiv.getContext('2d'), {
	    type: 'pie',
	    data: {
	        labels: tempLabels,
	        datasets: [{
	            label: labelName,
	            data: amounts,
	            backgroundColor: colorList,
	            hoverOffset: 4
	        }]
	    },
	    options: {
	    	responsive: true,
	    	onClick: (event, elements) => {
	    		 if (elements.length > 0) {
	    		 	const clickedElementIndex = elements[0].index;
	             	const clickedLabel = labels[clickedElementIndex];
	    		 	console.log(clickedLabel);
	    		 }
	    	},
	        plugins: {
	            legend: {
	            	position: 'left',
	                labels: {
	                  usePointStyle: true,
	                  pointStyle: 'rect'
	                }
	            },
	            tooltip: {
	                callbacks: {
	                    label: function(context) {
	                    	const label = labels[context.dataIndex]
	                        const value = Number(context.raw || 0).toLocaleString();
	                        return (isViewCount) ? value+'개' : '₩ ' + value;
	                    }
	                }
	            }
	        }
	    }
	});
}
/* ============= 차트 랜더링 함수 ============= */

let charts = [];
//초기 활성화 시킬 버튼
let chartType = "daily";
document.getElementById(chartType+"-btn").classList.toggle("active", true);
function changeChartType(newType) {
	chartType = newType;
	const titleEl = document.getElementsByClassName("sales-chart-title")[0];
	//newType에 맞는 버튼만 활성화 표시
    document.getElementById("daily-btn").classList.toggle("active", chartType === "daily");
    document.getElementById("month-btn").classList.toggle("active", chartType === "month");
    document.getElementById("year-btn").classList.toggle("active", chartType === "year");
    titleEl.textContent = (chartType === "daily") ? '최근 7일 일별 판매금액' : (chartType === "month") ? '최근 7개월 월별 판매금액' : "최근 7년 연도별 판매금액";
    render({recentSales:''});
}
/**
 * 전달 받은 요소들 랜더링  
 *
 * @param {{'recentSales':'', 'topBooks':'', 'table':'', 'salesByGroup':''}} 랜더링할 항목들 객체 형태로 전달
 * @return {void}
 */
function render(renderElements) {
	 const csrfToken = document.getElementById("_csrf").value;
	 const csrfHeader = document.getElementById("_csrf_header").value;
	 
	fetch("/api/renderSalesList", {
		method: 'POST',
		headers : {
			"Content-Type": "application/json",
		    "Accept": "application/json",
		    [csrfHeader]: csrfToken
		},
		body: JSON.stringify({ 
			"keyword":inputBox.value, 
			"orderItem":orderSelect.value, 
			"order":toggle.dataset.order
		})
	})
	.then(response => response.json())
	.then(result => {
		console.log(result);
		
	  	//총합계 랜더링
	  	const salesMap = {
	  		"daily-sum":["당일", "daily"],
	  		"monthly-sum":["월", "monthly"], 
	  		"yearly-sum": ["연", "yearly"], 
	  		"total-sum": ["총", "total"]
	  	}
	  	for (const key in salesMap)
	  		document.getElementsByClassName(key)[0].textContent = salesMap[key][0]+" 매출액 \\"+result.totalSum[salesMap[key][1]].toLocaleString();
	  	//테이블 랜더링
	  	if("table" in renderElements)
	   		tableRender(result);
	    //최근 판매 현황 랜더링 
	    if("recentSales" in renderElements)
	 		recentSalesRender(result, chartType);
	    //top5 랜더링
	 	if("topBooks" in renderElements)
	 		topBooksRender(result);
	    if("salesByGroup" in renderElements)
	 		salesByGroupRender(result, salesChartList[salesChartPage][0]);
	});
	window.addEventListener('resize', () => {
	    charts[2].resize();
	});
  }

//render();
socket.onmessage = (message) => render({'recentSales':'', 'topBooks':'', 'table':'', 'salesByGroup':''});

</script>
