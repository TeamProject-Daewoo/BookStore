<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
     body {
      font-family: sans-serif;
    }
	/* 부모 컨테이너가 최소 높이를 갖도록 설정 */
	.container {
		min-height: 800px;
	}
    .success-container {
        text-align: center;
        background-color: #fff;
        padding: 50px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        /* * [수정됨] 
         * margin 속성은 Flexbox 정렬에 의해 제어되므로 제거합니다.
         * 너비를 지정하여 너무 커지지 않게 합니다.
        */
        width: 100%;
        max-width: 600px; 
    }
    .success-container h2 {
        font-size: 36px;
        color: #28a745;
        margin-bottom: 20px;
    }
    .success-container p {
        font-size: 16px;
        color: #6c757d;
        margin-bottom: 30px;
    }
    .button-group {
        display: flex;
        gap: 15px;
        justify-content: center;
    }
    .btn-custom {
        padding: 12px 25px;
        text-decoration: none;
        font-weight: bold;
        transition: transform 0.2s;
    }
    .btn-custom:hover {
        transform: translateY(-2px);
    }
</style>

<main class="container d-flex justify-content-center align-items-center">
    <div class="success-container">
        <h2>🎉 결제 완료</h2>
        <p id="orderIdText">주문이 성공적으로 처리되었습니다.</p>
        <div class="button-group">
            <a href="<c:url value='/user/booklist'/>" class="btn btn-primary btn-custom">메인으로</a>
            <a href="<c:url value='/user/mypage/orders'/>" class="btn btn-secondary btn-custom">구매 내역 확인</a>
        </div>
    </div>
</main>

<script>
    const urlParams = new URLSearchParams(window.location.search);
    const paymentKey = urlParams.get("paymentKey");
    const orderId = urlParams.get("orderId");
    const amount = urlParams.get("amount");

    // 서버로 최종 결제 승인 요청
    async function confirmPayment() {
        const requestData = {
            paymentKey: paymentKey,
            orderId: orderId,
            amount: amount,
        };
        const response = await fetch("<c:url value='/purchase/confirm-payment'/>", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(requestData),
        });
        if (!response.ok) {
            const json = await response.json();
            window.location.href = `<c:url value='/purchase/fail'/>?message=${json.message}&code=${json.code}&orderId=${orderId}`;
        }
        else {
        	/* 결제 성공 하면 소켓으로 실시간 통신 */
        	const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        	const host = window.location.host;
        	const socket = new WebSocket(protocol+"//"+host+"/salesSocket");

        	 socket.onopen = () => {
        	     socket.send("소켓 전달");
        	 };
        }
    }
    
    confirmPayment();

    // 화면에 주문번호 표시
    const orderIdElement = document.getElementById("orderIdText");
    if (orderId) {
        orderIdElement.textContent = "주문번호: " + orderId;
    }
    
    
</script>