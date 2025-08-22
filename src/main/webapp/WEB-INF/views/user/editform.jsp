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
#checkPasswordBtn,
#checkIdBtn {
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
        <h2>개인정보 수정</h2>
        <br>
    <form id="registerForm" action="${pageContext.request.contextPath}/user/infoupdate?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
    	<div class="form-group" style="flex-direction: column; align-items: center;">
    		<c:choose>
    		<c:when test="${not empty user.profileImage}">
        		<img id="profilePreview" src="${pageContext.request.contextPath}/user/profileImage/${user.id}" 
             		alt="프로필 이미지" style="width:150px; height:150px; border-radius:50%; object-fit:cover; margin-bottom:5px;">
    		</c:when>
    		<c:otherwise>
        		<img id="profilePreview" src="${pageContext.request.contextPath}/resources/profileimage/default.jpg" 
             		alt="기본 이미지" style="width:150px; height:150px; border-radius:50%; object-fit:cover; margin-bottom:5px;">
    		</c:otherwise>
			</c:choose>
			</div>
			<div class="form-group" style="flex-direction: column; align-items: center;">
   		 <input type="file" id="profileImage" name="profileImageFile" accept="image/*">
   		 </div>
    	<br>
        <div class="form-group">
            <label for="user_id">아이디:</label>
            <input type="text" id="user_id" name="user_id" value=${user.user_id} required>
            <button type="button" id="checkIdBtn">중복 확인</button>
        </div>
        <!-- 메시지 출력용 span -->
		<div class="form-group" style="margin-left:160px;">
            <span id="idMessage" class="message" ></span>
        </div>

        <div class="form-group">
            <label for="name">이름:</label>
            <input type="text" id="name" name="name" value=${user.name} required>
        </div>

        <div class="form-group">
            <label for="email">이메일:</label>
            <input type="email" id="email" name="email" value=${user.email} required>
        </div>

		
		<div class="form-group">
    		<label for="currentPassword">현재 비밀번호:</label>
    		<input type="password" id="currentPassword" name="currentPassword" placeholder="현재 비밀번호 입력">
		</div>

		<div class="form-group">
    		<label for="newPassword">새 비밀번호:</label>
    		<input type="password" id="newPassword" name="newPassword" placeholder="새 비밀번호 입력">
		</div>

		<div class="form-group">
    		<label for="confirmPassword">새 비밀번호 확인:</label>
    		<input type="password" id="confirmPassword" name="confirmPassword" placeholder="새 비밀번호 확인">
		</div>
		
		<!-- 메시지 출력용 span -->
        <div class="form-group" style="margin-left: 160px;">
    		<span id="passwordMessage" style="font-size: 14px;"></span>
		</div>

        <div class="form-group">
            <label for="phone_number">전화번호:</label>
            <input type="text" id="phone_number" name="phone_number" value=${user.phone_number} required>
        </div>
		<br>
		<input type="hidden" name="id" value=${user.id}>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
        <input type="submit" value="개인정보 수정">
    </form>
    
    </div>
</body>

<script>

//이미지 미리보기 기능
document.getElementById("profileImage").addEventListener("change", function(e){
    const file = e.target.files[0];
    if (file) {
        const reader = new FileReader();
        reader.onload = function(ev) {
            document.getElementById("profilePreview").src = ev.target.result;
        }
        reader.readAsDataURL(file);
    }
});

//현재 로그인한 사용자 ID (서버에서 렌더링해 넣어야 함)
const currentUserId = "${user.user_id}"; // JSP나 템플릿에서 주입

let idChecked = false; // 중복 확인 여부

// ID 중복 확인
document.getElementById("checkIdBtn").addEventListener("click", function () {
    const userId = document.getElementById("user_id").value.trim();
    const idMessage = document.getElementById("idMessage");

    if (!userId) {
        idMessage.style.color = "red";
        idMessage.textContent = "아이디를 입력하세요.";
        idChecked = false;
        return;
    }

    if (userId === currentUserId) {
        idMessage.style.color = "blue";
        idMessage.textContent = "현재 아이디입니다.";
        idChecked = true; // 내 아이디니까 중복 확인 필요 없음
        return;
    }

    // 다른 아이디일 경우 서버 확인
    fetch("${checkIdUrl}?user_id=" + encodeURIComponent(userId))
        .then(response => response.json())
        .then(data => {
            if (data.exists) {
                idMessage.style.color = "red";
                idMessage.textContent = "이미 사용 중인 아이디입니다.";
                idChecked = false;
            } else {
                idMessage.style.color = "green";
                idMessage.textContent = "사용 가능한 아이디입니다.";
                idChecked = true;
            }
        })
        .catch(() => {
            idMessage.style.color = "red";
            idMessage.textContent = "아이디 확인 중 오류가 발생했습니다.";
            idChecked = false;
        });
});

// 폼 제출
document.getElementById("registerForm").addEventListener("submit", function(e) {
    const newPassword = document.getElementById("newPassword").value.trim();
    const confirmPassword = document.getElementById("confirmPassword").value.trim();
    const currentPassword = document.getElementById("currentPassword").value.trim();

    // 새 비밀번호가 입력되었을 경우
    if (newPassword || confirmPassword) {
        if (!currentPassword) {
            e.preventDefault();
            alert("새 비밀번호를 변경하려면 현재 비밀번호를 입력해주세요.");
            return;
        }
        if (newPassword !== confirmPassword) {
            e.preventDefault();
            alert("새 비밀번호와 확인 비밀번호가 일치하지 않습니다.");
            return;
        }
    }
    
    const userId = document.getElementById("user_id").value.trim();

    // 내 아이디와 동일하면 바로 제출
    if (userId === currentUserId) return;

    // 다른 아이디인데 중복 체크 안 했으면 제출 막기
    if (!idChecked) {
        e.preventDefault();
        alert("아이디 중복 확인을 해주세요.");
    }
});

const newPasswordInput = document.getElementById("newPassword");
const confirmPasswordInput = document.getElementById("confirmPassword");
const passwordMessage = document.getElementById("passwordMessage");

// 새 비밀번호와 확인 비밀번호 입력 시 실시간 체크
function checkPasswordMatch() {
    const newPassword = newPasswordInput.value.trim();
    const confirmPassword = confirmPasswordInput.value.trim();

    if (!newPassword && !confirmPassword) {
        passwordMessage.textContent = "";
        return;
    }

    if (newPassword === confirmPassword) {
        passwordMessage.style.color = "green";
        passwordMessage.textContent = "비밀번호가 일치합니다.";
    } else {
        passwordMessage.style.color = "red";
        passwordMessage.textContent = "비밀번호가 일치하지 않습니다.";
    }
}

newPasswordInput.addEventListener("input", checkPasswordMatch);
confirmPasswordInput.addEventListener("input", checkPasswordMatch);
</script>
<!-- 현재 미밀번호 틀릴 경우 -->
<c:if test="${not empty error}">
<script>
    window.onload = function() {
        alert("${error}");
    };
</script>
</c:if>

<c:if test="${not empty message}">
<script>
    window.onload = function() {
        alert("${message}");
    };
</script>
</c:if>

</html>