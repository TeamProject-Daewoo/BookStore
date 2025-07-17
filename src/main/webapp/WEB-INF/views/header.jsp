<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Header</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .navbar .cart-count {
      background-color: red;
      color: white;
      font-size: 0.75rem;
      padding: 2px 6px;
      border-radius: 50%;
      margin-left: 4px;
    }
  </style>
</head>
<body>

  <header>
    <nav class="navbar navbar-expand-lg navbar-light bg-light px-4">
      <a class="navbar-brand fw-bold" href="/user/booklist">📚 BookStore</a>
      <div class="collapse navbar-collapse justify-content-end">
        <ul class="navbar-nav align-items-center gap-3">

          <sec:authorize access="isAuthenticated()">
            <li class="nav-item">
              <span class="navbar-text">
                안녕하세요, <sec:authentication property="name" />님
              </span>
            </li>
            <li class="nav-item">
              <form id="logoutForm" action="<c:url value='/logout' />" method="post" class="d-inline">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <button type="submit" class="btn btn-outline-danger btn-sm">로그아웃</button>
              </form>
            </li>

            <sec:authorize access="hasRole('ROLE_ADMIN')">
              <li class="nav-item">
                <button onclick="location.href='<c:url value='/manager/booklist' />'" class="btn btn-outline-primary btn-sm">
                  관리자 페이지
                </button>
              </li>
            </sec:authorize>
          </sec:authorize>

          <sec:authorize access="!isAuthenticated()">
            <li class="nav-item">
              <a class="nav-link" href="<c:url value='/user/loginform' />">로그인</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="<c:url value='/user/registerform' />">회원가입</a>
            </li>
          </sec:authorize>

          <sec:authorize access="hasRole('ROLE_ADMIN')">
            <li class="nav-item">
              <a href="/manager/purchaselist" class="nav-link">구매내역</a>
            </li>
          </sec:authorize>

          <li class="nav-item position-relative">
            <a href="/cart" class="nav-link d-flex align-items-center">
              🛒 장바구니
              <span class="cart-count">
                <c:out value="${cartCount}" />
              </span>
            </a>
          </li>
        </ul>
      </div>
    </nav>
  </header>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
