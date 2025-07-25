<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
   uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>책 상세 정보</title>
<style>
body {
   font-family: 'Apple SD Gothic Neo', 'Segoe UI', sans-serif;
   background-color: #f8f9fa;
   margin: 0;
   padding: 0;
}

.book-detail-container {
   max-width: 1000px;
   margin: 60px auto;
   padding: 40px;
   background-color: #ffffff;
   border: 1px solid #dee2e6;
   border-radius: 10px;
}

.book-main {
   display: flex;
   flex-wrap: wrap;
   gap: 40px;
}

.book-image {
   flex: 1 1 280px;
   display: flex;
   align-items: flex-start;
   justify-content: center;
}

.book-image img {
   max-width: 100%;
   height: auto;
   border-radius: 8px;
   border: 1px solid #ddd;
}

.book-info {
   flex: 1 1 400px;
   display: flex;
   flex-direction: column;
   justify-content: space-between;
   gap: 30px;
}

.book-header h2 {
   font-size: 24px;
   font-weight: 600;
   margin-bottom: 10px;
}

.book-header p {
   margin: 4px 0;
   font-size: 15px;
   color: #444;
}

.book-actions {
   display: flex;
   flex-direction: column;
   gap: 10px;
}

.quantity-selector {
   display: flex;
   align-items: center;
   gap: 6px;
}

.quantity-selector button {
   width: 32px;
   height: 32px;
   padding: 0;
   font-size: 16px;
   border: 1px solid #ccc;
   background-color: #fff;
   border-radius: 4px;
   cursor: pointer;
}

.quantity-selector input {
   width: 48px;
   height: 32px;
   text-align: center;
   border: 1px solid #ccc;
   border-radius: 4px;
   font-size: 15px;
}

.error-message {
   color: #e74c3c;
   font-size: 14px;
   display: none;
}

.btn {
   display: block;
   width: 100%;
   padding: 10px;
   border-radius: 4px;
   font-size: 15px;
   cursor: pointer;
   border: 1px solid #ccc;
   background-color: #f8f9fa;
}

.btn:hover {
   background-color: #e9ecef;
}

.btn-success {
   background-color: #28a745;
   color: #fff;
   border-color: #28a745;
}

.btn-success:hover {
  background-color: #218838;
}


.btn-warning {
  background-color: #ffc107;
  color: #fff;
  border-color: #ffc107;
}

.btn-warning:hover {
  background-color: #e0a800;
}

.book-description {
   margin-top: 40px;
   font-size: 15px;
   line-height: 1.6;
   color: #333;
}

.book-description strong {
   display: block;
   font-size: 17px;
   margin-bottom: 8px;
}

@media ( max-width : 768px) {
   .book-main {
      flex-direction: column;
   }
}
</style>

<script>
   function updateTotalPrice() {
      var price = parseFloat('${book.price}');
      var quantity = document.getElementById('quantity').value;
      var totalPrice = price * quantity;
      document.getElementById('total-price').innerText = totalPrice
            .toLocaleString()
            + ' 원';
      document.getElementById('cart-quantity-input').value = quantity;
      document.getElementById('buy-now-quantity-input').value = quantity;

      var stock = parseInt('${book.stock}');
      if (quantity > stock) {
         document.getElementById('error-message').style.display = 'block';
         document.getElementById('quantity').value = stock;
      } else {
         document.getElementById('error-message').style.display = 'none';
      }
   }

   function changeQuantity(change) {
      var quantityInput = document.getElementById('quantity');
      var currentQuantity = parseInt(quantityInput.value);
      var stock = parseInt('${book.stock}');

      if (change === 'increment' && currentQuantity < stock) {
         currentQuantity += 1;
      } else if (change === 'decrement' && currentQuantity > 1) {
         currentQuantity -= 1;
      }

      quantityInput.value = currentQuantity;
      document.getElementById('cart-quantity-input').value = currentQuantity;
      document.getElementById('buy-now-quantity-input').value = currentQuantity;

      updateTotalPrice();
   }
</script>
</head>

<body>
   <div class="book-detail-container">
      <div class="book-main">
         <!-- 이미지 -->
         <div class="book-image">
            <img src="${imagePath}" alt="책 표지">
         </div>

         <!-- 오른쪽 정보 -->
         <div class="book-info">
            <!-- 상단: 제목/저자/가격 -->
            <div class="book-header">
               <h2>${book.title}</h2>
               <p>
                  <strong>저자:</strong> ${book.author}
               </p>
               <p>
                  <strong>가격:</strong> ${book.price} 원
               </p>
            </div>

            <!-- 하단: 재고/수량/금액/버튼 -->
            <c:if test="${book.stock > 0}">
               <div class="book-actions">
                  <p>
                     <strong>재고:</strong> ${book.stock}
                  </p>
                  <div class="quantity-selector">
                     <button type="button" onclick="changeQuantity('decrement')">−</button>
                     <input type="number" id="quantity" value="1" min="1"
                        max="${book.stock}" onchange="updateTotalPrice()">
                     <button type="button" onclick="changeQuantity('increment')">＋</button>
                  </div>

                  <p>
                     <strong>총 금액:</strong> <span id="total-price"></span>
                  </p>
                  <div id="error-message" class="error-message">선택한 수량이 재고를
                     초과했습니다.</div>

                  <form action="/cart/add" method="post">
                     <input type="hidden" name="bookId" value="${book.id}"> <input
                        type="hidden" name="quantity" id="cart-quantity-input" value="1">
                     <input type="hidden" name="${_csrf.parameterName}"
                        value="${_csrf.token}" />
                     <button type="submit" class="btn btn-success">🛒 장바구니에
                        담기</button>
                  </form>

                  <form action="/purchase/direct" method="post">
                     <input type="hidden" name="bookId" value="${book.id}"> <input
                        type="hidden" name="quantity" id="buy-now-quantity-input"
                        value="1"> <input type="hidden"
                        name="${_csrf.parameterName}" value="${_csrf.token}" />
                     <button type="submit" class="btn btn-warning">⚡ 바로 구매</button>
                  </form>
               </div>
            </c:if>

            <c:if test="${book.stock <= 0}">
               <div class="book-actions">
                  <div class="error-message">🚫 재고가 없습니다!</div>
               </div>
            </c:if>
         </div>
      </div>

      <!-- 책 설명 -->
      <div class="book-description">
         <strong>책 설명</strong> ${book.description}
      </div>
   </div>

   <script>
      updateTotalPrice();
   </script>
</body>
</html>
