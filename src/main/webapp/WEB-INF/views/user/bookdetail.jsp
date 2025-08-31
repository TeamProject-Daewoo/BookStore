<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>책 상세 정보</title>
<style>
   /* 스타일 코드는 변경사항이 없으므로 생략 */
   body {
      font-family: 'Segoe UI', 'Apple SD Gothic Neo', sans-serif;
      background-color: #f4f6f9;
      margin: 0;
      padding: 0;
      color: #333;
   }

   .book-detail-container {
      max-width: 960px;
      margin: 60px auto;
      padding: 30px;
      background-color: #fff;
      border-radius: 16px;
      box-shadow: 0 6px 18px rgba(0,0,0,0.08);
   }

   .book-main {
      display: flex;
      flex-wrap: wrap;
      gap: 32px;
   }

   .book-image {
      flex: 1 1 280px;
      display: flex;
      align-items: flex-start;
      justify-content: center;
   }

   .book-image img {
      max-width: 100%;
      border-radius: 12px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
   }

   .book-info {
	flex: 1 1 400px;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
	gap: 24px; /* 위쪽 내용과 버튼 간격 */
   }
   
   .book-header {
      flex-grow: 0; /* 위쪽 내용 고정 */
   }

   .book-header h2 {
      font-size: 26px;
      font-weight: 700;
      margin-bottom: 6px;
   }

   .book-header p {
      margin: 3px 0;
      font-size: 15px;
      color: #555;
   }

   .book-actions {
	margin-top: auto; /* 버튼 영역을 항상 맨 아래로 */
	display: flex;
	flex-direction: column;
	gap: 12px;
   }

   .quantity-selector {
      display: flex;
      align-items: center;
      gap: 8px;
   }

   .quantity-selector button {
      width: 36px;
      height: 36px;
      font-size: 18px;
      border: none;
      border-radius: 8px;
      background-color: #f1f3f5;
      cursor: pointer;
      transition: background 0.2s;
   }

   .quantity-selector button:hover {
      background-color: #dee2e6;
   }

   .quantity-selector input {
      width: 60px;
      height: 36px;
      text-align: center;
      border: 1px solid #ccc;
      border-radius: 8px;
      font-size: 15px;
   }

   .error-message {
      color: #e03131;
      font-size: 14px;
      font-weight: 500;
      display: none;
   }

   .btn {
      display: block;
      width: 100%;
      padding: 12px;
      border-radius: 8px;
      font-size: 16px;
      cursor: pointer;
      border: none;
      transition: background 0.2s, transform 0.1s;
   }

   .btn:active {
      transform: scale(0.97);
   }

   .btn-success {
      background-color: #40c057;
      color: #fff;
   }

   .btn-success:hover {
      background-color: #37b24d;
   }

   .btn-warning {
      background-color: #f59f00;
      color: #fff;
   }

   .btn-warning:hover {
      background-color: #e67700;
   }

   .book-description {
      margin-top: 40px;
      font-size: 15px;
      line-height: 1.7;
      color: #444;
   }

   .book-description strong {
      display: block;
      font-size: 18px;
      margin-bottom: 10px;
      font-weight: 600;
   }

   @media (max-width: 768px) {
      .book-main {
         flex-direction: column;
      }
   }
</style>

<script>
   // 스크립트 코드는 변경사항 없습니다.
   function updateTotalPrice() {
      var price = parseFloat('${book.price}');
      var quantity = document.getElementById('quantity').value;
      var totalPrice = price * quantity;
      document.getElementById('total-price').innerText =
         totalPrice.toLocaleString() + ' 원';
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
         <div class="book-image">
             <%-- 1. 이미지 경로를 로컬/API 경우에 따라 다르게 처리 --%>
             <c:choose>
                <c:when test="${book.img.startsWith('http')}">
                   <img src="${book.img}" alt="책 표지">
                </c:when>
                <c:otherwise>
                   <img src="${pageContext.request.contextPath}/resources/images/${book.img}" alt="책 표지">
                </c:otherwise>
             </c:choose>
         </div>

         <div class="book-info">
            <div class="book-header">
               <h2>${book.title}</h2>
               <p><strong>저자:</strong> ${book.author}</p>
               <p><strong>가격:</strong> <fmt:formatNumber value="${book.price}" pattern="#,###" /> 원</p>
            </div>

            <c:if test="${book.stock > 0}">
               <div class="book-actions">
                  <p><strong>재고:</strong> ${book.stock}</p>
                  <div class="quantity-selector">
                     <button type="button" onclick="changeQuantity('decrement')">−</button>
                     <input type="number" id="quantity" value="1" min="1"
                        max="${book.stock}" onchange="updateTotalPrice()">
                     <button type="button" onclick="changeQuantity('increment')">＋</button>
                  </div>

                  <p><strong>총 금액:</strong> <span id="total-price"><fmt:formatNumber value="${book.price}" pattern="#,###" /> 원</span></p>
                  <div id="error-message" class="error-message">🚫 선택한 수량이 재고를 초과했습니다.</div>

                  <%-- 2. 장바구니 담기는 우리 DB에 책을 '등록'하는 개념이므로 isbn을 보냄 --%>
                  <form action="${pageContext.request.contextPath}/cart/add" method="post">
                     <input type="hidden" name="bookIsbn" value="${book.isbn}">
                     <input type="hidden" name="quantity" id="cart-quantity-input" value="1">
                     <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                     <button type="submit" class="btn btn-success">🛒 장바구니 담기</button>
                  </form>
				
                  <%-- 바로 구매 기능도 마찬가지로 isbn을 보냅니다. (purchase controller 수정 필요) --%>
                  <form action="/purchase/direct" method="post">
                     <input type="hidden" name="bookIsbn" value="${book.isbn}">
                     <input type="hidden" name="quantity" id="buy-now-quantity-input" value="1">
                     <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                     <button type="submit" class="btn btn-warning">⚡ 바로 구매</button>
                  </form>
               </div>
            </c:if>

            <c:if test="${book.stock <= 0}">
               <div class="book-actions">
                  <p class="error-message" style="display: block;">🚫 재고가 없습니다!</p>
               </div>
            </c:if>
         </div>
      </div>

      <div class="book-description">
         <strong>책 설명</strong>
         <p>${book.description}</p>
      </div>
   </div>
   
   <c:if test="${not empty book.id}">
       <div class="book-review-container" style="max-width: 960px; margin: 40px auto; padding: 20px; background-color: #fff; border-radius: 16px; box-shadow: 0 6px 18px rgba(0,0,0,0.08);">
    
           <h3 style="margin-bottom: 20px;">📖 리뷰</h3>
    
           <sec:authorize access="isAuthenticated()">
               <form action="${pageContext.request.contextPath}/user/addReview" method="post" style="margin-bottom: 30px;">
                   <%-- 3. 리뷰는 우리 DB에 저장된 책의 고유 id를 기준으로 작성 --%>
                   <input type="hidden" name="bookId" value="${book.id}"> 
                   <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    
                   <label for="rating"><strong>평점:</strong></label>
                   <select name="rating" id="rating" style="margin-left: 8px; padding: 4px 8px; border-radius: 6px;">
                       <option value="5">★★★★★</option>
                       <option value="4">★★★★</option>
                       <option value="3">★★★</option>
                       <option value="2">★★</option>
                       <option value="1">★</option>
                   </select>
    
                   <div style="margin-top: 12px;">
                       <textarea name="content" rows="4" placeholder="리뷰를 작성해주세요." style="width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #ccc;" required></textarea>
                   </div>
    
                   <button type="submit" class="btn btn-success" style="margin-top: 12px; width: 120px;">리뷰 등록</button>
               </form>
           </sec:authorize>
    
           <sec:authorize access="!isAuthenticated()">
               <p>로그인 후 리뷰를 작성할 수 있습니다.</p>
           </sec:authorize>
    
           <hr style="margin: 20px 0;">
    
           <h4>리뷰 목록</h4>
           <c:if test="${not empty reviews}">
               <c:forEach var="review" items="${reviews}">
                   	       <div style="display: flex; gap: 16px; padding: 12px; border-bottom: 1px solid #eee;">
	           <!-- 왼쪽: 프로필 이미지 -->
	           <div style="flex-shrink: 0;">
	               <img src="<c:url value='/user/profileImageByUsername/${review.userId}' />"
     				alt="프로필 이미지"
     				style="width:70px; height:70px; border-radius:50%; object-fit:cover;">
	           </div>

			   <!-- 오른쪽: 리뷰 내용 -->
			   <div style="flex:1; display:flex; flex-direction:column; gap:6px;">
			       
				<!-- 헤더: 닉네임 + 별점 + 날짜 + 수정/삭제 버튼 -->
				<div style="display:flex; align-items:center; justify-content:space-between; gap:16px;">

				    <!-- 왼쪽: 닉네임 + 별점 -->
				    <div style="display:flex; align-items:center; gap:8px;">
				        <strong style="font-size:16px;">${review.userId}</strong>
				        <span style="color:#f5c518;">
				            <c:forEach var="i" begin="1" end="5">
				                <c:choose>
				                    <c:when test="${i <= review.rating}">★</c:when>
				                    <c:otherwise>☆</c:otherwise>
				                </c:choose>
				            </c:forEach>
				        </span>
				    </div>

				    <!-- 가운데: 빈 공간 (flex로 자동 확장) -->
				    <div style="flex:1"></div>

				    <!-- 오른쪽: 날짜 -->
				    <span style="font-size:12px; color:#888; white-space:nowrap; margin-right:8px;">
				        <fmt:formatDate value="${review.createdAt}" pattern="yyyy-MM-dd" />
				    </span>

				    <!-- 오른쪽 끝: 점 3개 버튼 -->
				    <c:if test="${review.userId == user or pageContext.request.isUserInRole('ROLE_ADMIN')}">
				        <div style="position:relative;">
				            <button onclick="toggleMenu(this)" 
				                    style="background:none; border:none; font-size:20px; cursor:pointer;">⋮</button>
				            <div class="review-menu" style="display:none; position:absolute; right:0; top:24px; 
				                 background:#fff; border:1px solid #ccc; border-radius:6px; 
				                 box-shadow:0 2px 8px rgba(0,0,0,0.15); min-width:100px; z-index:10;">
				                <form action="/user/reviewEdit" method="get" style="margin:0;">
				                    <input type="hidden" name="reviewId" value="${review.reviewId}" />
				                    <button type="submit" style="display:block; width:100%; border:none; background:none; padding:8px; cursor:pointer; text-align:left;">수정</button>
				                </form>
				                <form action="/user/reviewDelete" method="post" style="margin:0;">
				                    <input type="hidden" name="reviewId" value="${review.reviewId}" />
				                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				                    <button type="submit" style="display:block; width:100%; border:none; background:none; padding:8px; cursor:pointer; color:red; text-align:left;">삭제</button>
				                </form>
				            </div>
				        </div>
				    </c:if>

				</div>


			       <!-- 리뷰 내용 -->
			       <p style="margin:0; line-height:1.4;">${review.content}</p>
			   </div>
	       </div>
               </c:forEach>
           </c:if>
           <c:if test="${empty reviews}">
               <p>아직 등록된 리뷰가 없습니다.</p>
           </c:if>
       </div>
   </c:if>

   <script>
	  function toggleMenu(btn) {
	          const menu = btn.nextElementSibling;
	          menu.style.display = (menu.style.display === 'block') ? 'none' : 'block';
	      }

	      // 클릭 외부 영역 시 메뉴 닫기
	      document.addEventListener('click', function(e) {
	          const menus = document.querySelectorAll('.review-menu');
	          menus.forEach(menu => {
	              if (!menu.contains(e.target) && !menu.previousElementSibling.contains(e.target)) {
	                  menu.style.display = 'none';
	              }
	          });
	      });
   </script>
</body>
</html>