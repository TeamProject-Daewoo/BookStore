<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>구매하기</title>
    <style>
        body {
            font-family: sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }
        .purchase-container {
            max-width: 800px;
            margin: 20px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        h3 {
            text-align: center;
            font-size: 32px;
            color: #0056b3;
            margin-bottom: 30px;
        }
        .order-summary, .delivery-address {
            margin-bottom: 30px;
            border: 1px solid #eee;
            padding: 20px;
            border-radius: 8px;
        }
        .order-summary h4, .delivery-address h4 {
            color: #0056b3;
            margin-top: 0;
            margin-bottom: 15px;
            font-size: 22px;
        }
        .order-item {
            display: flex;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px dashed #eee;
        }
        .order-item:last-child {
            border-bottom: none;
        }
        .item-details {
            flex-grow: 1;
        }
        .item-details p {
            margin: 0;
            font-size: 15px;
        }
        .item-quantity, .item-price {
            width: 80px;
            text-align: right;
            font-size: 15px;
        }
        .total-amount {
            text-align: right;
            font-size: 24px;
            font-weight: bold;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 2px solid #0056b3;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input[type="text"],
        .form-group textarea {
            width: calc(100% - 22px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 16px;
        }
        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }
        .btn-confirm-purchase {
            display: block;
            width: 100%;
            padding: 15px;
            background-color: #28a745;
            color: #fff;
            text-align: center;
            border-radius: 8px;
            text-decoration: none;
            font-size: 20px;
            font-weight: bold;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn-confirm-purchase:hover {
            background-color: #218838;
        }
        .error-message {
            color: #e74c3c;
            font-size: 16px;
            margin-top: 10px;
            text-align: center;
        }
        .success-message {
            color: #28a745;
            font-size: 16px;
            margin-top: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="purchase-container">
        <h3>구매하기</h3>

        <c:if test="${not empty errorMessage}">
            <div class="error-message">${errorMessage}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="success-message">${successMessage}</div>
        </c:if>

        <div class="order-summary">
            <h4>주문 요약</h4>
            <c:forEach var="item" items="${itemsToPurchase}">
                <div class="order-item">
                    <div class="item-details">
                        <p>${item.book.title} (${item.book.author})</p>
                    </div>
                    <div class="item-quantity">${item.quantity}개</div>
                    <div class="item-price">${item.book.price * item.quantity} 원</div>
                </div>
            </c:forEach>
            <div class="total-amount">
                총 결제 금액: ${totalAmount} 원
            </div>
        </div>
        <div class="delivery-address">
            <h4>배송지 정보</h4>
            <form action="${pageContext.request.contextPath}/purchase/confirm" method="post">
                <input type="hidden" name="purchaseType" value="${purchaseType}">
                <c:if test="${purchaseType eq 'direct'}">
                    <input type="hidden" name="bookId" value="${itemsToPurchase[0].book.id}">
                    <input type="hidden" name="quantity" value="${itemsToPurchase[0].quantity}">
                </c:if>
                <div class="form-group">
    				<label for="receiverName">받는 사람:</label>
    				<input type="text" id="receiverName" name="receiverName" 
           				value="${delivery != null ? delivery.receiverName : ''}" required>
				</div>
				<div class="form-group">
    				<label for="address">주소:</label>
    				<input type="text" id="address" name="address" 
           				value="${delivery != null ? delivery.address : ''}" required>
				</div>
				<div class="form-group">
    				<label for="phoneNumber">연락처:</label>
    				<input type="text" id="phoneNumber" name="phoneNumber" 
           				value="${delivery != null ? delivery.phoneNumber : ''}" required>
				</div>
                <div class="form-group">
    			<div style="display: flex; align-items: center; gap: 10px;">
        				<label for="deliveryMessage" style="margin: 0;">배송 메시지 (선택 사항):</label>
        				<select id="deliveryMessageSelect">
           				<option value="">-- 선택하세요 --</option>
            			<option value="문 앞에 놓아주세요">문 앞에 놓아주세요</option>
            			<option value="경비실에 맡겨주세요">경비실에 맡겨주세요</option>
            			<option value="배송 전 연락 부탁드립니다">배송 전 연락 부탁드립니다</option>
            			<option value="파손 주의">파손 주의</option>
            			<option value="기타">기타 (직접 입력)</option>
        				</select>
    			</div>
    			<textarea id="deliveryMessage" name="deliveryMessage" style="width:100%;margin-top:10px;"><c:out value="${delivery != null ? delivery.deliveryMessage : ''}"/></textarea>
				</div>
                <button type="submit" class="btn-confirm-purchase">결제하기</button>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }" />
            </form>
        </div>
    </div>
    <script>
    document.getElementById('deliveryMessageSelect').addEventListener('change', function() {
        const textarea = document.getElementById('deliveryMessage');
        if (this.value === '기타' || this.value === '') {
            textarea.value = ''; // 기타나 빈 값이면 직접 입력
            textarea.readOnly = false;
        } else {
            textarea.value = this.value; // 선택한 메시지를 textarea에 채움
            textarea.readOnly = true;    // 수정 못 하게 잠금
        }
    });
    </script>
</body>
</html>