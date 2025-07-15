<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <style>
        body { font-family: sans-serif; }
        .register-container { width: 400px; margin: 50px auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; }
        .register-container h2 { text-align: center; }
        .register-container label { display: block; margin-top: 10px; }
        .register-container input[type="text"],
        .register-container input[type="password"],
        .register-container input[type="email"] {
            width: calc(100% - 22px); /* Adjust for padding and border */
            padding: 10px;
            margin: 5px 0 10px 0;
            box-sizing: border-box;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .register-container input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
        }
        .register-container input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: #e74c3c;
            font-size: 14px;
            margin-top: 10px;
            text-align: center;
        }
        .success-message {
            color: #28a745;
            font-size: 14px;
            margin-top: 10px;
            text-align: center;
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
    <div class="register-container">
        <h2>회원가입</h2>
        <form action="${pageContext.request.contextPath}/user/register" method="post">

            <label for="user_id">아이디:</label>
            <input type="text" id="user_id" name="user_id" required>
            
            <label for="name">이름:</label>
            <input type="text" id="name" name="name" required>

            <label for="email">이메일:</label>
            <input type="email" id="email" name="email" required>
            
            <label for="password">비밀번호:</label>
            <input type="password" id="password" name="password" required>

            <label for="phone_number">전화번호:</label>
            <input type="text" id="phone_number" name="phone_number" required>
            
            <input type="submit" value="회원가입">
        </form>
    </div>
</body>
</html>