<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>요청 제한 알림</title>
    <style>
    body { 
        background-color: #f9f9f9; 
        display: flex; 
        justify-content: center; 
        align-items: center; 
        height: 100vh; 
        margin: 0; 
        font-family: 'Pretendard', -apple-system, sans-serif; 
    }

    .error-container { 
        background: white; 
        padding: 40px; 
        border-radius: 16px; 
        box-shadow: 0 10px 25px rgba(0,0,0,0.05); 
        text-align: center; 
        max-width: 400px;
        width: 90%;
    }

    .icon { font-size: 50px; margin-bottom: 20px; }

    h1 { color: #333; font-size: 24px; margin-bottom: 10px; }
    p { color: #666; line-height: 1.6; margin-bottom: 30px; }

    .btn-retry {
        display: inline-block;
        background-color: #4A90E2;
        color: white;
        padding: 12px 30px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        transition: all 0.3s ease;
        border: none;
        cursor: pointer;
        font-size: 16px;
    }

    .btn-retry:hover {
        background-color: #357ABD;
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(74, 144, 226, 0.3);
    }

    .btn-retry:active {
        transform: translateY(0);
    }
</style>
</head>
<body>
    <div class="error-container">
    	<div class="icon">🛡️</div>
    	<h1>잠시 쉬어가세요!</h1>
    	<p>보안을 위해 짧은 시간 동안 많은 요청을 제한하고 있습니다<br> 
    	잠시 후 다시 시도해 주세요</p>
    
    	<button class="btn-retry" onclick="history.back()">이전 화면으로 돌아가기</button>
	</div>
</body>
</html>