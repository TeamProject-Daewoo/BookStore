<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 실패</title>
    <style>
        body { font-family: sans-serif; background-color: #f8f9fa; color: #333; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
        .fail-container { text-align: center; background-color: #fff; padding: 40px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); max-width: 500px; width: 100%; }
        h3 { font-size: 32px; color: #dc3545; margin-top: 0; }
        p { font-size: 18px; color: #666; }
        .error-details { background-color: #f1f1f1; border: 1px solid #ddd; border-radius: 4px; padding: 15px; margin-top: 20px; text-align: left; font-size: 14px; word-break: break-all; }
        .error-details strong { color: #333; }
        .buttons { margin-top: 30px; display: flex; gap: 10px; justify-content: center; }
        .btn { display: inline-block; padding: 12px 25px; border-radius: 5px; text-decoration: none; font-size: 16px; font-weight: bold; border: none; cursor: pointer; transition: background-color 0.3s; }
        .btn-retry { background-color: #007bff; color: white; }
        .btn-retry:hover { background-color: #0056b3; }
        .btn-home { background-color: #6c757d; color: white; }
        .btn-home:hover { background-color: #5a6268; }
    </style>
</head>
<body>
    <div class="fail-container">
        <h3>결제 실패</h3>
        <p>결제를 완료하지 못했습니다.<br>아래 실패 사유를 확인 후 다시 시도해주세요.</p>

        <div class="error-details">
            <strong>에러 코드:</strong> <c:out value="${errorCode}" /><br>
            <strong>실패 사유:</strong> <c:out value="${errorMessage}" /><br>
            <strong>주문 번호:</strong> <c:out value="${orderId}" />
        </div>

        <div class="buttons">
            <button class="btn btn-retry" onclick="history.back()">다시 시도하기</button>
            <a href="${pageContext.request.contextPath}/" class="btn btn-home">홈으로 돌아가기</a>
        </div>
    </div>
</body>
</html>