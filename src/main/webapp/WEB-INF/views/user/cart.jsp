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
<title>장바구니</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<style>
	  .cart-item {
	    display: flex;
	    align-items: center;
	    justify-content: space-between;
	    border: 1px solid #ddd;
	    border-radius: 10px;
	    padding: 15px;
	    margin-bottom: 15px;
	    background-color: #f8f9fa;
	  }
	
	  .item-image {
	    width: 100px;
	    height: auto;
	    border-radius: 5px;
	    margin-right: 15px;
	  }
	
	  .item-details {
	    flex: 1;
	  }
      .item-details a { /* 링크 스타일 추가 */
        text-decoration: none;
        color: inherit;
      }
	
	  .item-quantity input[type="number"] {
	    width: 60px;
	    margin-right: 5px;
	  }
	
	  .cart-summary {
	    font-weight: bold;
	    font-size: 1.2rem;
	    text-align: right;
	    margin-top: 20px;
	    margin-bottom: 10px;
	  }
	
	  .btn-checkout {
	    width: 100%;
	    padding: 10px;
	    background-color: #28a745;
	    color: white;
	    border: none;
	    font-weight: bold;
	    border-radius: 5px;
	  }
	
	  .btn-continue-shopping {
	    display: inline-block;
	    margin-top: 20px;
	    text-decoration: none;
	    color: #007bff;
	  }
	
	  .empty-cart {
	    text-align: center;
	    padding: 30px;
	    font-size: 1.2rem;
	    color: #888;
	    border: 1px dashed #ccc;
	    border-radius: 10px;
	    background-color: #fcfcfc;
	  }
	</style>
</head>
<body>
	<div class="container my-5">
	  <h3 class="text-center mb-4">🛒 장바구니</h3>
	
	  <c:if test="${empty cartItems}">
	    <div class="empty-cart">장바구니가 비어 있습니다.</div>
	  </c:if>
	
	  <c:if test="${not empty cartItems}">
	    <div class="cart-items-list">
	      <c:forEach var="item" items="${cartItems}">
	        <div class="cart-item">
	          
	          <a href="${pageContext.request.contextPath}/user/bookdetail?isbn=${item.book.isbn}">
                <%-- 1. 이미지 경로를 로컬/API 경우에 따라 다르게 처리 --%>
                <c:choose>
                    <c:when test="${item.book.img.startsWith('http')}">
                        <img src="${item.book.img}" alt="${item.book.title}" class="item-image">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/resources/images/${item.book.img}" alt="${item.book.title}" class="item-image">
                    </c:otherwise>
                </c:choose>
              </a>

	          <div class="item-details">
	            <a href="${pageContext.request.contextPath}/user/bookdetail?isbn=${item.book.isbn}">
                    <h5>${item.book.title}</h5>
                </a>
	            <p class="mb-1">저자: ${item.book.author}</p>
	            <p class="mb-1">가격: <strong><fmt:formatNumber value="${item.book.price}" pattern="#,###" /> 원</strong></p>
	          </div>
	
	          <div class="item-quantity">
	            <form action="${pageContext.request.contextPath}/cart/updateQuantity" method="post" class="d-flex align-items-center">
	              <%-- 2. (핵심) 수량 변경은 우리 DB의 고유 id를 기준으로 동작 --%>
                  <input type="hidden" name="bookId" value="${item.book.id}">
	              <input type="number" name="quantity" value="${item.quantity}" min="1" class="form-control form-control-sm me-2" onchange="this.form.submit();">
	              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }" />
	            </form>
	          </div>
	
	          <div class="item-total">
	            <span>총액: <strong><fmt:formatNumber value="${item.itemTotal}" pattern="#,###" />원</strong></span>
	          </div>
	
	          <div class="item-actions mx-3">
	            <form action="${pageContext.request.contextPath}/cart/remove" method="post">
	              <%-- 3. (핵심) 삭제도 우리 DB의 고유 id를 기준으로 동작 --%>
                  <input type="hidden" name="bookId" value="${item.book.id}">
	              <button type="submit" class="btn btn-danger btn-sm">삭제</button>
	              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }" />
	            </form>
	          </div>
	        </div>
	      </c:forEach>
	    </div>
	
	    <div class="cart-summary">
	      총 주문 금액: <strong><fmt:formatNumber value="${cartTotal}" pattern="#,###" /> 원</strong>
	    </div>
	
	    <form action="${pageContext.request.contextPath}/purchase/cart" method="post">
	      <button type="submit" class="btn-checkout">✅ 주문하기</button>
	      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }" />
	    </form>
	  </c:if>
	
	  <div class="text-end">
	    <a href="${pageContext.request.contextPath}/user/booklist" class="btn-continue-shopping">← 계속 쇼핑하기</a>
	  </div>
	</div>

</body>
</html>