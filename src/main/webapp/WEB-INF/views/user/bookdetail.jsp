<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>책 상세 정보</title>
  <style>

	.quantity-selector {
	  display: flex;
	  justify-content: flex-start;
	  align-items: center;
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
	  .quantity-selector {
	    justify-content: center !important;
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
  <div class="container my-5 book-detail-container">
    <div class="card shadow-lg rounded-4 p-4 book-detail-wrapper">
      <h3 class="text-center mb-4">${book.title}</h3>

      <div class="row g-4 align-items-start">
        <!-- 왼쪽: 책 정보 -->
        <div class="col-md-4 book-info">
          <div class="mb-3"><strong>저자:</strong> ${book.author}</div>
          <div><strong>설명:</strong> ${book.description}</div>
        </div>

        <!-- 가운데: 이미지 -->
        <div class="col-md-4 text-center">
          <img src="${imagePath}" alt="책 표지" class="img-fluid rounded shadow-sm" style="max-height: 300px;" />
        </div>

        <!-- 오른쪽: 가격, 수량, 버튼 -->
        <div class="col-md-4 book-price-stock">
          <c:if test="${book.stock > 0}">
            <p><strong>가격:</strong> ${book.price} 원</p>
            <p><strong>재고:</strong> ${book.stock}</p>

		<div class="quantity-selector d-flex gap-2 my-2">
		  <button class="btn btn-outline-secondary" onclick="changeQuantity('decrement')">-</button>
		  <input type="number" id="quantity" class="form-control text-center" style="width: 80px;"
		         value="1" min="1" max="${book.stock}" onchange="updateTotalPrice()" />
		  <button class="btn btn-outline-secondary" onclick="changeQuantity('increment')">+</button>
		</div>

            <p><strong>총 금액:</strong> <span id="total-price">${book.price} 원</span></p>

            <div id="error-message" class="alert alert-danger py-1 d-none" role="alert">
              선택한 수량이 재고를 초과했습니다.
            </div>

            <form action="/cart/add" method="post" class="mb-2">
              <input type="hidden" name="bookId" value="${book.id}">
              <input type="hidden" name="quantity" id="cart-quantity-input" value="1">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }" />
              <button type="submit" class="btn btn-success w-100">🛒 장바구니에 담기</button>
            </form>

            <form action="/purchase/direct" method="post">
              <input type="hidden" name="bookId" value="${book.id}">
              <input type="hidden" name="quantity" id="buy-now-quantity-input" value="1">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }" />
              <button type="submit" class="btn btn-warning w-100">⚡ 바로 구매</button>
            </form>
          </c:if>

          <c:if test="${book.stock <= 0}">
            <div class="alert alert-danger text-center fs-4">🚫 재고가 없습니다!</div>
          </c:if>
        </div>
      </div>
    </div>
  </div>
</body>

</html>
