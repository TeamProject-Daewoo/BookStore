<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!-- Bootstrap CSS 필요 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
	font-family: sans-serif;
}
</style>

<div class="container min-vh-100 d-flex justify-content-center align-items-center py-5">
  <div class="bg-white p-5 rounded shadow text-center" style="max-width: 600px; width: 100%;">
    <h3 class="text-success mb-4">구매가 성공적으로 완료되었습니다!</h3>
    <p class="text-muted fs-5 mb-4">주문해 주셔서 감사합니다. 곧 배송될 예정입니다.</p>
    <a href="${pageContext.request.contextPath}/user/booklist" class="btn btn-primary fw-bold px-4 py-2">
      홈으로 돌아가기
    </a>
  </div>
</div>
<script>
/* <중요!> 배포 환경일 때 웹 소켓 */
const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
const host = window.location.host;
const socket = new WebSocket(protocol+"//"+host+"/salesSocket");

/* <중요!> 로컬 환경일 때 웹 소켓 */
//const socket = new WebSocket("ws://localhost:8888/salesSocket");
 socket.onopen = () => {
     socket.send("소켓 전달");
 };
</script>
