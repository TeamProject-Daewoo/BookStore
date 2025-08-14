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
  .dash-grid {
    width:95%; max-width:1200px; margin:32px auto; display:grid; grid-template-columns:1fr 1fr; gap:24px;
  }
  .card {
    background:#fff; border:1px solid #eee; border-radius:16px; padding:16px; box-shadow:0 2px 8px rgba(0,0,0,.04);
  }
  .card h3 { margin:0 0 12px; color:#333; text-align:left; font-family:sans-serif; }
  canvas { width:100%; height:360px; }
</style>

<h2>판매 현황</h2>

<div class="total-sum">
  전체 판매 합계:
  <strong><fmt:formatNumber value="${totalsum}" type="number"/></strong> 원
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<c:if test="${not empty purchaseList}">
  <div class="dash-grid">
    <div class="card">
      <h3>최근 7일 일별 판매금액</h3>
      <canvas id="dailyAmount"></canvas>
    </div>
    <div class="card">
      <h3>책별 판매량 Top5 (수량)</h3>
      <canvas id="topBooks"></canvas>
    </div>
  </div>
</c:if>

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
  <tbody>
    <c:forEach var="purchase" items="${purchaseList}">
      <tr>
        <td>${purchase.order_id}</td>
        <td><c:out value="${purchase.member_name}"/></td>
        <td>
          <c:forEach var="book" items="${purchase.bookList}">
            <c:out value="${book.book_title}"/> ( ${book.quantity} 개 )<br/>
          </c:forEach>
        </td>
        <td><fmt:formatNumber value="${purchase.total_price}" type="number"/></td>
        <td><fmt:formatDate value="${purchase.order_date}" pattern="yyyy-MM-dd"/></td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<c:if test="${not empty purchaseList}">
<script>
document.addEventListener('DOMContentLoaded', function () {
  // JSP -> JS 배열 (order_ts: epoch ms)
  var purchases = [
    <c:forEach var="p" items="${purchaseList}" varStatus="st">
      {
        order_id: ${p.order_id},
        member_name: "<c:out value='${p.member_name}'/>",
        total_price: ${p.total_price},
        order_ts: ${p.order_date.time},
        bookList: [
          <c:forEach var="b" items="${p.bookList}" varStatus="st2">
            { book_title: "<c:out value='${b.book_title}'/>", quantity: ${b.quantity} }<c:if test="${!st2.last}">,</c:if>
          </c:forEach>
        ]
      }<c:if test="${!st.last}">,</c:if>
    </c:forEach>
  ];

  // 최근 7일 YYYY-MM-DD 라벨 (템플릿 리터럴 사용 안함)
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

  // 1) 일별 판매금액 합계
  var dailyAmountMap = {};
  for (var k = 0; k < days.length; k++) dailyAmountMap[days[k]] = 0;

  purchases.forEach(function (p) {
    var d = new Date(p.order_ts);
    var key = d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
    if (dailyAmountMap.hasOwnProperty(key)) {
      dailyAmountMap[key] += Number(p.total_price || 0);
    }
  });

  var dailyLabels  = days.map(function (d) { return d.slice(5); }); // MM-DD
  var dailyAmounts = days.map(function (d) { return dailyAmountMap[d]; });

  // 2) 책별 판매량(수량) Top5
  var bookQtyMap = {};
  purchases.forEach(function (p) {
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

  // 차트 렌더
  var el1 = document.getElementById('dailyAmount');
  if (el1) {
    new Chart(el1.getContext('2d'), {
      type: 'line',
      data: { labels: dailyLabels, datasets: [{ label: '판매금액', data: dailyAmounts, tension: 0.3, fill: true }] },
      options: {
        plugins: { tooltip: { callbacks: { label: function (i) { return '₩ ' + Number(i.raw || 0).toLocaleString(); } } } },
        scales:  { y: { ticks: { callback: function (v) { return '₩ ' + Number(v).toLocaleString(); } } } }
      }
    });
  }

  var el2 = document.getElementById('topBooks');
  if (el2) {
    new Chart(el2.getContext('2d'), {
      type: 'bar',
      data: { labels: topLabels, datasets: [{ label: '판매수량', data: topQty }] },
      options: {
        indexAxis: 'y',
        plugins: { tooltip: { callbacks: { label: function (i) { return Number(i.raw || 0).toLocaleString() + ' 개'; } } } },
        scales:  { x: { ticks: { callback: function (v) { return Number(v).toLocaleString() + ' 개'; } } } }
      }
    });
  }
});
socket.onstart = () => render();
socket.onmessage = (message) => render();
</script>
</c:if>
