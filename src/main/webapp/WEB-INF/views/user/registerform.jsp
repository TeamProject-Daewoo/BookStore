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
.register-container { 
    width: 600px; 
    margin: 50px auto; 
    padding: 30px; 
    border: 1px solid #ccc; 
    border-radius: 5px; 
}
.register-container h2 { text-align: center; margin-bottom: 30px; }

.form-group {
    display: flex;
    align-items: center;
    margin-bottom: 15px;
}
.form-group label {
    width: 150px; /* 레이블 고정 너비 */
    margin-right: 10px;
    text-align: left; /* 왼쪽 정렬 */
    font-weight: bold;
}
.form-group input[type="text"],
.form-group input[type="password"],
.form-group input[type="email"] {
    flex: 1; /* 남은 공간 차지 */
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    box-sizing: border-box;
}
#checkPasswordBtn {
    margin-left: 10px;
    padding: 5px 10px;
    cursor: pointer;
    border-radius: 4px;
    border: 1px solid #ccc;
    background-color: #f1f1f1;
}
.register-container input[type="submit"] {
    width: 100%;
    padding: 12px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin-top: 20px;
    font-size: 16px;
}
.register-container input[type="submit"]:hover {
    background-color: #0056b3;
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
        <br>
    <form id="registerForm" action="${pageContext.request.contextPath}/user/register" method="post">
        <div class="form-group">
            <label for="user_id">아이디:</label>
            <input type="text" id="user_id" name="user_id" required>
        </div>

        <div class="form-group">
            <label for="name">이름:</label>
            <input type="text" id="name" name="name" required>
        </div>

        <div class="form-group">
            <label for="email">이메일:</label>
            <input type="email" id="email" name="email" required>
        </div>

        <div class="form-group">
            <label for="password">비밀번호:</label>
            <input type="password" id="password" name="password" required>
        </div>

        <div class="form-group">
            <label for="passwordConfirm">비밀번호 확인:</label>
            <input type="password" id="passwordConfirm" name="passwordConfirm" required>
            <button type="button" id="checkPasswordBtn">비밀번호 확인</button>
        </div>
		<!-- 메시지 출력용 span -->
        <div class="form-group" style="margin-left: 160px;">
    		<span id="passwordMessage" style="font-size: 14px;"></span>
		</div>

        <div class="form-group">
            <label for="phone_number">전화번호:</label>
            <input type="text" id="phone_number" name="phone_number" required>
        </div>
		<br>
        <input type="submit" value="회원가입">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>
    
    </div>
</body>

<script>
const messageSpan = document.getElementById("passwordMessage");

//비밀번호 확인 버튼 클릭 이벤트
document.getElementById("checkPasswordBtn").addEventListener("click", function() {
 const password = document.getElementById("password").value;
 const confirm = document.getElementById("passwordConfirm").value;
 if(password === "" || confirm === "") {
     messageSpan.style.color = "red";
     messageSpan.textContent = "비밀번호를 입력해주세요.";
     return;
 }
 if(password === confirm){
     messageSpan.style.color = "green";
     messageSpan.textContent = "비밀번호가 일치합니다!";
 } else {
     messageSpan.style.color = "red";
     messageSpan.textContent = "비밀번호가 일치하지 않습니다.";
     document.getElementById("passwordConfirm").focus();
 }
});

//폼 제출 시에는 alert만
document.getElementById("registerForm").addEventListener("submit", function(e) {
    const password = document.getElementById("password").value;
    const confirm = document.getElementById("passwordConfirm").value;

    if(password === "" || confirm === "" || password !== confirm){
        e.preventDefault();
        alert("비밀번호가 비어있거나 일치하지 않습니다.");
        document.getElementById("passwordConfirm").focus();
    }
});
</script>

</html>