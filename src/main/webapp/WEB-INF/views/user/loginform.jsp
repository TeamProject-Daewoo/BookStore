<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<style>
body {
	font-family: sans-serif;
}

.login-container {
	width: 300px;
	margin: 100px auto;
	padding: 20px;
	border: 1px solid #ccc;
	border-radius: 5px;
}

.login-container h2 {
	text-align: center;
}

.login-container input[type="text"], .login-container input[type="password"]
	{
	width: 100%;
	padding: 10px;
	margin: 10px 0;
	box-sizing: border-box;
}

.login-container input[type="submit"] {
	width: 100%;
	padding: 10px;
	background-color: #4CAF50;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}
</style>

<c:if test="${not empty result}">
	<script>
		window.onload = function() {
			alert("${result}");
			location.replace(location.pathname);
		};
	</script>
</c:if>
</head>
<body>
	<div class="login-container">
		<h2>로그인</h2>
		<form action="<c:url value='/login'/>" method="post">
			<label for="username">아이디:</label> <input type="text" id="username"
				name="username" required> <label for="password">비밀번호:</label>
			<input type="password" id="password" name="password" required>

			<input type="submit" value="로그인"> <input type="hidden"
				name="${_csrf.parameterName}" value="${_csrf.token }" />
		</form>
		<div style="text-align: center; margin-top: 10px;">
			<a href="/manager/loginform">관리자 로그인</a>
		</div>
	</div>
</body>
</html>