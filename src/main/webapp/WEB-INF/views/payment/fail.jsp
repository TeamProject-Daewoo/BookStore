<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- <html>, <head>, <body> 태그는 index.jsp에 있으므로 제거합니다. --%>

<style>
	.container {
		min-height: 800px;
	}
    /* 실패 메시지를 담을 컨테이너 스타일 */
    .fail-container {
        text-align: center;
        background-color: #fff;
        padding: 50px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        width: 100%;
        max-width: 600px; 
    }
    /* '결제 실패' 제목 스타일 (빨간색 계열) */
    .fail-container h2 {
        font-size: 36px;
        color: #dc3545; /* Bootstrap의 danger color */
        margin-bottom: 20px;
    }
    .fail-container p {
        font-size: 16px;
        color: #6c757d;
        margin-bottom: 30px;
    }
    /* 에러 상세 내용을 보여주는 박스 스타일 */
    .error-details {
        background-color: #f8d7da; /* Bootstrap의 danger-subtle 배경색 */
        border: 1px solid #f5c2c7; /* Bootstrap의 danger-border-subtle 색상 */
        color: #58151c;
        border-radius: 4px;
        padding: 15px;
        margin-top: 20px;
        margin-bottom: 30px;
        text-align: left;
        font-size: 14px;
        word-break: break-all;
    }
    .error-details strong {
        color: #58151c;
    }
    /* 버튼 커스텀 스타일 */
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
    <div class="fail-container">
        <h2>❌ 결제 실패</h2>
        <p>결제를 완료하지 못했습니다.<br>아래 실패 사유를 확인 후 다시 시도해주세요.</p>

        <div id="error-details-box" class="error-details" style="display: none;">
            <strong id="errorCode"></strong><br>
            <span id="errorMessage"></span><br>
            <span id="orderId"></span>
        </div>

        <div>
            <a href="<c:url value='/user/booklist'/>" class="btn btn-primary btn-custom">메인으로</a>
        </div>
    </div>
</main>

<script>
    // URL의 쿼리 파라미터에서 에러 정보를 추출합니다.
    const urlParams = new URLSearchParams(window.location.search);
    const code = urlParams.get("code");
    const message = urlParams.get("message");
    const orderId = urlParams.get("orderId");

    const errorBox = document.getElementById("error-details-box");
    const errorCodeEl = document.getElementById("errorCode");
    const errorMessageEl = document.getElementById("errorMessage");
    const orderIdEl = document.getElementById("orderId");
    
    // 에러 정보가 URL에 있는 경우에만 상세 정보 박스를 화면에 표시합니다.
    if (code && message && orderId) {
        errorBox.style.display = "block";
        errorCodeEl.textContent = "에러 코드: " + code;
        errorMessageEl.textContent = "실패 사유: " + message;
        orderIdEl.textContent = "주문 번호: " + orderId;
    }
</script>