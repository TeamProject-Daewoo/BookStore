<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>
<style>
body {
	font-family: sans-serif;
}

.check-password-container {
	width: 400px;
	margin: 100px auto;
	padding: 20px;
	border: 1px solid #ccc;
	border-radius: 5px;
}

.error-message {
	text-align: center;
	margin-bottom: 10px;
	color: red;
}

.check-password-container h2 {
	text-align: center;
}

.check-password-container input[type="password"] {
	width: 100%;
	padding: 10px;
	margin: 10px 0;
	box-sizing: border-box;
}

.check-password-container input[type="submit"] {
	width: 100%;
	padding: 10px;
	background-color: #4CAF50;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}
</style>

<c:if test="${not empty error}">
	<script>
		window.onload = function() {
			alert("${error}");
		};
	</script>
</c:if>
</head>
<body>

<div class="check-password-container">
	<h2>비밀번호 확인</h2>

	<c:if test="${not empty error}">
		<div class="error-message">${error}</div>
	</c:if>

	<form action="<c:url value='/user/checkPassword'/>" method="post">
		<label for="currentPassword">비밀번호:</label>
		<input type="password" id="currentPassword" name="currentPassword" required>
		
		<input type="submit" value="확인">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	</form>
</div>

</body>
</html>
