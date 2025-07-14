<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    .fullpage-wrapper {
        min-height: calc(100vh - 120px); /* header/footer 높이에 맞게 조절 */
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 40px;
        box-sizing: border-box;
    }
    .success-container {
        max-width: 600px;
        background: #fff;
        padding: 40px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        text-align: center;
    }
    .success-container h3 {
        color: #28a745;
        font-size: 36px;
        margin-bottom: 20px;
    }
    .success-container p {
        font-size: 18px;
        color: #555;
        margin-bottom: 30px;
    }
    .btn-home {
        display: inline-block;
        padding: 12px 25px;
        background-color: #007bff;
        color: #fff;
        text-decoration: none;
        border-radius: 5px;
        font-size: 16px;
        font-weight: bold;
        transition: background-color 0.3s;
    }
    .btn-home:hover {
        background-color: #0056b3;
    }
</style>

<div class="fullpage-wrapper">
    <div class="success-container">
        <h3>구매가 성공적으로 완료되었습니다!</h3>
        <p>주문해 주셔서 감사합니다. 곧 배송될 예정입니다.</p>
        <a href="${pageContext.request.contextPath}/user/booklist" class="btn-home">홈으로 돌아가기</a>
    </div>
</div>
