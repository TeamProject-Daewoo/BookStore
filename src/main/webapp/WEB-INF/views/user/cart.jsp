<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장바구니</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
            color: #333;
        }
        .cart-container {
            max-width: 900px;
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
        .cart-item {
            display: flex;
            align-items: center;
            border-bottom: 1px solid #eee;
            padding: 15px 0;
        }
        .cart-item:last-child {
            border-bottom: none;
        }
        .item-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 4px;
            margin-right: 20px;
        }
        .item-details {
            flex-grow: 1;
        }
        .item-details h4 {
            margin: 0 0 5px 0;
            font-size: 18px;
            color: #333;
        }
        .item-details p {
            margin: 0;
            font-size: 14px;
            color: #666;
        }
        .item-quantity, .item-price, .item-total {
            width: 100px;
            text-align: right;
            font-size: 16px;
            font-weight: bold;
        }
        .cart-summary {
            text-align: right;
            margin-top: 30px;
            font-size: 20px;
            font-weight: bold;
            border-top: 2px solid #0056b3;
            padding-top: 20px;
        }
        .empty-cart {
            text-align: center;
            font-size: 18px;
            color: #666;
            padding: 50px 0;
        }
        .btn-checkout {
            display: block;
            width: 200px;
            margin: 30px auto 0;
            padding: 15px;
            background-color: #28a745;
            color: #fff;
            text-align: center;
            border-radius: 8px;
            text-decoration: none;
            font-size: 18px;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        .btn-checkout:hover {
            background-color: #218838;
        }
        .btn-continue-shopping:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="cart-container">
        <h3>장바구니</h3>

        <c:if test="${empty cartItems}">
            <div class="empty-cart">장바구니가 비어 있습니다.</div>
        </c:if>

        <c:if test="${not empty cartItems}">
            <div class="cart-items-list">
                <c:forEach var="item" items="${cartItems}">
                    <div class="cart-item">
                        <img src="${pageContext.request.contextPath}/resources/images/${item.book.img}" alt="${item.book.title}" class="item-image">
                        <div class="item-details">
                            <h4>${item.book.title}</h4>
                            <p>저자: ${item.book.author}</p>
                            <p>가격: ${item.book.price} 원</p>
                        </div>
                        <div class="item-quantity">
                            <form action="${pageContext.request.contextPath}/cart/updateQuantity" method="post" style="display:inline-block;">
                                <input type="hidden" name="bookId" value="${item.book.id}">
                                <input type="number" name="quantity" value="${item.quantity}" min="1" style="width: 50px; text-align: center;">
                                <button type="submit">수정</button>
                            </form>
                        </div>
                        <div class="item-total">총액: ${item.itemTotal} 원</div>
                        <div class="item-actions">
                            <form action="${pageContext.request.contextPath}/cart/remove" method="post" style="display:inline-block; margin-left: 10px;">
                                <input type="hidden" name="bookId" value="${item.book.id}">
                                <button type="submit" style="background-color: #dc3545; color: white; border: none; padding: 5px 10px; cursor: pointer;">삭제</button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="cart-summary">
                총 주문 금액: ${cartTotal} 원
            </div>

            <form action="${pageContext.request.contextPath}/purchase/cart" method="post">
                <button type="submit" class="btn-checkout">주문하기</button>
            </form>
            <a href="${pageContext.request.contextPath}/user/booklist" class="btn-continue-shopping">계속 쇼핑하기</a>
        </c:if>
    </div>
</body>
</html>