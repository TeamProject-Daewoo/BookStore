<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Header</title>
<style>
/* 심플한 헤더 스타일 */
header {
	background-color: #f8f9fa;
	padding: 15px 30px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	font-family: Arial, sans-serif;
	border-bottom: 1px solid #ddd;
}

.logo {
	font-weight: bold;
	font-size: 24px;
	color: #007bff;
	cursor: pointer;
	user-select: none;
}

nav ul {
	list-style: none;
	margin: 0;
	padding: 0;
	display: flex;
	align-items: center;
	gap: 20px;
}

nav ul li a, nav ul li span {
	text-decoration: none;
	color: #333;
	font-size: 16px;
}

nav ul li a:hover {
	text-decoration: underline;
}

.cart {
	position: relative;
	font-weight: bold;
	color: #007bff;
}

.cart-count {
	position: absolute;
	top: -8px;
	right: -12px;
	background: red;
	color: white;
	border-radius: 50%;
	padding: 2px 7px;
	font-size: 12px;
	font-weight: normal;
	user-select: none;
}

.purchaselist {
	position: relative;
	font-weight: bold;
	color: #007bff;
}
</style>
</head>
<body>
	<header>
		<a href="/" class="logo">BookStore</a>
		<nav>
			<ul>
				<sec:authorize access="isAuthenticated()">
					<li><span>안녕하세요, <sec:authentication property="name" />님
					</span></li>
					<li>
						<form id="logoutForm" action="<c:url value='/logout' />"
							method="post">
							<input type="submit" value="로그아웃" /> <input type="hidden"
								name="${_csrf.parameterName}" value="${_csrf.token}" />
						</form>
					</li>

					<sec:authorize access="hasRole('ROLE_ADMIN')">
						<li>
							<button
								onclick="location.href='<c:url value='/manager/booklist' />'">
								관리자 페이지로 이동</button>
						</li>
					</sec:authorize>
				</sec:authorize>

				<sec:authorize access="!isAuthenticated()">
					<li><a href="<c:url value='/user/loginform' />">로그인</a></li>
					<li><a href="<c:url value='/user/registerform' />">회원가입</a></li>
				</sec:authorize>

				<!-- 로그인 시 권한이 manager일 때 구매내역 표시 -->
				<c:choose>
					<c:when test="">
						<a href="/manager/purchaselist" class="purchaselist">구매내역</a>
					</c:when>
					<c:otherwise>
						<a href="/cart" class="cart"> 장바구니 <span class="cart-count">
								<c:out
									value="${sessionScope.cartCount != null ? sessionScope.cartCount : 0}" />
						</span>
						</a>
					</c:otherwise>
				</c:choose>
				</li>
			</ul>
		</nav>
	</header>
</body>
</html>
