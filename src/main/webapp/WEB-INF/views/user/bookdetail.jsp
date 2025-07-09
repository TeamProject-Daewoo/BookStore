<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>책 상세 정보</title>
  <style>
    body {
      font-family: 'Arial', sans-serif;
      background-color: #f8f9fa;
      margin: 0;
      padding: 0;
      color: #333;
    }
    .book-detail-container {
      max-width: 1200px;
      margin: 50px auto;
      padding: 30px;
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }
    h3 {
      text-align: center;
      font-size: 36px;
      font-weight: bold;
      color: #0056b3;
      margin-bottom: 30px;
    }
    .book-detail-wrapper {
      display: flex;
      gap: 40px;
      flex-wrap: wrap;
      justify-content: space-between;
      align-items: flex-start;
    }
    .book-info {
      flex: 1;
      min-width: 300px;
    }
    .book-info p {
      font-size: 18px;
      margin: 10px 0;
    }
    .book-info strong {
      color: #333;
    }
    .book-img {
      max-width: 400px;
      width: 100%;
      height: auto;
      border-radius: 8px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      margin: 0 auto;
    }
    .book-price-stock {
      flex: 1;
      min-width: 200px;
      font-size: 20px;
      font-weight: bold;
      color: #333;
    }
    .book-price-stock p {
      margin: 10px 0;
      font-size: 24px;
      color: #e74c3c;
    }
    .book-price-stock strong {
      color: #333;
    }
    .quantity-selector {
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .quantity-selector button {
      padding: 10px;
      font-size: 18px;
      font-weight: bold;
      background-color: #f1f1f1;
      border: 1px solid #ccc;
      border-radius: 5px;
      cursor: pointer;
      transition: background-color 0.3s;
    }
    .quantity-selector button:hover {
      background-color: #007bff;
      color: #fff;
    }
    .quantity-selector input {
      width: 40px;
      text-align: center;
      font-size: 18px;
      border: 1px solid #ccc;
      padding: 5px;
      border-radius: 5px;
    }
    .book-price-stock .btn {
      display: inline-block;
      padding: 12px 20px;
      margin-top: 30px; /* 버튼을 아래로 내리기 위해 간격 조정 */
      font-size: 16px;
      font-weight: bold;
      text-align: center;
      border-radius: 8px;
      border: none;
      cursor: pointer;
      transition: background-color 0.3s;
    }
    .book-price-stock .btn-cart {
      background-color: #007bff;
      color: #fff;
    }
    .book-price-stock .btn-cart:hover {
      background-color: #0056b3;
    }
    .book-price-stock .btn-buy {
      background-color: #e74c3c;
      color: #fff;
    }
    .book-price-stock .btn-buy:hover {
      background-color: #c0392b;
    }
    .error-message {
      color: #e74c3c;
      font-size: 16px;
      margin-top: 10px;
      display: none; /* 초기에는 숨김 처리 */
    }
    @media (max-width: 768px) {
      .book-detail-wrapper {
        flex-direction: column;
        align-items: center;
      }
      .book-info,
      .book-price-stock {
        text-align: center;
      }
    }
  </style>
  <script>
    function updateTotalPrice() {
      var price = parseFloat('${book.price}');  // 책 가격
      var quantity = document.getElementById('quantity').value;  // 선택한 수량
      var totalPrice = price * quantity;  // 총 금액 계산
      document.getElementById('total-price').innerText = totalPrice.toLocaleString() + ' 원';  // 총 금액 표시
      document.getElementById('cart-quantity-input').value = quantity; // Update hidden input
      document.getElementById('buy-now-quantity-input').value = quantity; // Update hidden input for buy now

      // 재고 수를 초과하는 수량을 선택한 경우 알림 띄우기
      var stock = parseInt('${book.stock}');
      if (quantity > stock) {
        document.getElementById('error-message').style.display = 'block'; // 재고 초과 경고
        document.getElementById('quantity').value = stock; // 수량을 재고로 리셋
      } else {
        document.getElementById('error-message').style.display = 'none'; // 경고 메시지 숨기기
      }
    }

    function changeQuantity(change) {
      var quantityInput = document.getElementById('quantity');
      var currentQuantity = parseInt(quantityInput.value);
      var stock = parseInt('${book.stock}');

      // 수량 변경
      if (change === 'increment' && currentQuantity < stock) {
        currentQuantity += 1;
      } else if (change === 'decrement' && currentQuantity > 1) {
        currentQuantity -= 1;
      }
      quantityInput.value = currentQuantity;
      document.getElementById('cart-quantity-input').value = currentQuantity; // Update hidden input
      document.getElementById('buy-now-quantity-input').value = currentQuantity; // Update hidden input for buy now

      updateTotalPrice();  // 총 금액 업데이트
    }
  </script>
</head>
<body>

  <div class="book-detail-container">
    <h3>${book.title}</h3>

    <div class="book-detail-wrapper">
      <!-- 왼쪽: 저자, 설명 -->
      <div class="book-info">
        <p><strong>저자:</strong> ${book.author}</p>
        <p><strong>설명:</strong> ${book.description}</p>
      </div>

      <!-- 가운데: 책 표지 이미지 -->
      <div class="book-img-wrapper">
        <img src="${imagePath}" alt="책 표지" class="book-img" />
      </div>

      <!-- 오른쪽: 가격, 재고 -->
      <div class="book-price-stock">
        <p><strong>가격:</strong> ${book.price} 원</p>
        <p><strong>재고:</strong> ${book.stock}</p>

        <!-- 수량 선택 -->
        <div class="quantity-selector">
          <button onclick="changeQuantity('decrement')">-</button>
          <input type="number" id="quantity" value="1" min="1" max="${book.stock}" onchange="updateTotalPrice()" />
          <button onclick="changeQuantity('increment')">+</button>
        </div>

        <!-- 총 금액 -->
        <p><strong>총 금액:</strong> <span id="total-price">${book.price} 원</span></p>

        <!-- 재고 초과 경고 메시지 -->
        <div id="error-message" class="error-message">선택한 수량이 재고를 초과했습니다.</div>

        <!-- 장바구니 버튼 -->
        <form action="${pageContext.request.contextPath}/cart/add" method="post">
            <input type="hidden" name="bookId" value="${book.id}">
            <input type="hidden" name="quantity" id="cart-quantity-input" value="1">
            <button type="submit" class="btn btn-cart" id="add-to-cart-btn">장바구니에 담기</button>
        </form>

        <!-- 바로 구매 버튼 -->
        <form action="${pageContext.request.contextPath}/purchase/direct" method="post" style="display:inline-block;">
            <input type="hidden" name="bookId" value="${book.id}">
            <input type="hidden" name="quantity" id="buy-now-quantity-input" value="1">
            <button type="submit" class="btn btn-buy">바로 구매</button>
        </form>
      </div>
    </div>
  </div>

</body>
</html>
