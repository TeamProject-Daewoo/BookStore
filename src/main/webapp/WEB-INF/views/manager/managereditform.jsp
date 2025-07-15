<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  .account-form {
    width: 90%;
    max-width: 600px;
    margin: 30px auto;
    padding: 25px;
    border: 1px solid #ccc;
    border-radius: 8px;
    font-family: sans-serif;
    background-color: #fff;
  }

  .account-form h2 {
    text-align: center;
    margin-bottom: 25px;
  }

  .form-row {
    display: flex;
    align-items: center;
    margin-bottom: 12px;
    padding-bottom: 12px;
    border-bottom: 1px solid #ddd; /* 구분선 추가 */
  }

  .form-label {
    width: 120px;
    font-weight: bold;
  }

  .form-input, .form-value {
    flex: 1;
  }

  .form-input input {
    width: 100%;
    padding: 10px 12px;
    font-size: 14px;
    line-height: 1.5;
    border: 1px solid #ccc;
    border-radius: 5px;
    box-sizing: border-box;
    height: 48px;
  }

  .form-value {
    padding: 10px 12px;
    height: 28px;
    font-size: 14px;
    border: 1px solid #ddd;
    border-radius: 5px;
    background-color: #f8f8f8;
    display: flex;
    align-items: center;
  }

  .form-actions {
    text-align: center;
    margin-top: 25px;
  }

  .btn {
    display: inline-block;
    padding: 10px 20px;
    margin: 0 5px;
    font-size: 14px;
    font-weight: bold;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    color: #fff;
  }

  .btn-edit {
    background-color: #28a745;
  }

  .btn-edit:hover {
    background-color: #218838;
  }

  .btn-reset {
    background-color: #dc3545;
  }

  .btn-reset:hover {
    background-color: #c82333;
  }
  
  .form-input {
   flex:1;
   position: relative;
  }
  .password-check-message {
  font-size: 13px;
  margin-left:8px;
  margin-top: 8px;
  display: none; /* 초기 숨김 */
}

 .password-check-message.match {
  color: green;
  display: block;
}

.password-check-message.mismatch {
  color: red;
  display: block;
}

.btn-delete {
  text-align:center;
  background-color: #b22222; /* 진한 빨간색 */
}

.btn-delete:hover {
  background-color: #7f1717;
}
h2 {
  text-align: center;
}
</style>
<h2>회원 정보 수정(관리자)</h2>
<form class="account-form" action="${pageContext.request.contextPath}/manager/manageredit?id=${member.id}" method="post" onsubmit="return confirm('수정하시겠습니까?');">
  

  <div class="form-row">
    <div class="form-label">이름</div>
    <div class="form-input">
      <input type="text" name="name" value="${member.name}" required>
    </div>
  </div>

  <div class="form-row">
    <div class="form-label">아이디</div>
    <div class="form-value">${member.user_id}</div>
  </div>

  <div class="form-row">
    <div class="form-label">이메일</div>
    <div class="form-input">
      <input type="email" name="email" value="${member.email}" required>
    </div>
  </div>

  <div class="form-row">
    <div class="form-label">비밀번호</div>
    <div class="form-input">
      <input type="password" name="password" placeholder="새 비밀번호 입력">
    </div>
  </div>

  <div class="form-row">
  <div class="form-label">비밀번호 확인</div>
  <div class="form-input">
    <input type="password" name="password_confirm" placeholder="새 비밀번호 재입력">
    <span class="password-check-message" id="passwordMessage"></span>
  </div>
</div>

  <div class="form-row">
    <div class="form-label">전화번호</div>
    <div class="form-input">
      <input type="text" name="phone_number" value="${member.phone_number}" required>
    </div>
  </div>

  <div class="form-row">
    <div class="form-label">가입일</div>
    <div class="form-value">${member.created_at}</div>
  </div>

  <div class="form-row">
    <div class="form-label">역할</div>
    <div class="form-value">${member.role}</div>
  </div>

  <div class="form-actions">
    <button type="submit" class="btn btn-edit">수정하기</button>
    <button type="reset" class="btn btn-reset">다시쓰기</button>
    <button type="button" class="btn btn-delete" onclick="history.back()">나가기</button>
  </div>
</form>
<script>
const form = document.querySelector('.account-form');
form.addEventListener('submit', function (e) {
    const pw = passwordInput.value.trim();
    const pwConfirm = passwordConfirmInput.value.trim();

    if (pw !== "" || pwConfirm !== "") {
      if (pw !== pwConfirm) {
        e.preventDefault();
        alert("비밀번호가 일치하지 않습니다. 다시 입력해주세요.");
        passwordInput.value = "";
        passwordConfirmInput.value = "";
        messageSpan.textContent = "";
        messageSpan.className = "password-check-message";
        messageSpan.style.display = "none";
        passwordInput.focus();
        return false;
      }
    }

    if (!confirm("수정하시겠습니까?")) {
      e.preventDefault();
    }
  });

  form.addEventListener('reset', function () {
    setTimeout(() => {
      messageSpan.textContent = "";
      messageSpan.className = "password-check-message";
      messageSpan.style.display = "none";
    }, 0);
    
    const pw = passwordInput.value.trim();
    const pwConfirm = passwordConfirmInput.value.trim();

    if ((pw !== "" || pwConfirm !== "") && pw !== pwConfirm) {
      alert("비밀번호가 일치하지 않습니다. 다시 확인해주세요.");
      e.preventDefault();
    }
  });
</script>
<script>
  //새 비밀번호 입력 내용 재확인
  const passwordInput = document.querySelector('input[name="password"]');
  const passwordConfirmInput = document.querySelector('input[name="password_confirm"]');
  const messageSpan = document.getElementById('passwordMessage');
 
  function checkPasswordMatch() {
    const pw = passwordInput.value.trim();
    const pwConfirm = passwordConfirmInput.value.trim();

    if (pw === "") {
      // 비밀번호 입력란이 비어있으면 메시지 숨김
      messageSpan.style.display = "none";
      messageSpan.textContent = "";
      messageSpan.className = "password-check-message";
      return;
    }

    if (pwConfirm === "" || pw !== pwConfirm) {
      // 재확인 비어있거나 다르면 빨간색 메시지 출력
      messageSpan.textContent = "일치하지 않습니다.";
      messageSpan.className = "password-check-message mismatch";
      messageSpan.style.display = "inline";
    } else {
      // 두 값 일치하면 초록색 메시지 출력
      messageSpan.textContent = "일치합니다";
      messageSpan.className = "password-check-message match";
      messageSpan.style.display = "inline";
    }
  }

  passwordInput.addEventListener('input', checkPasswordMatch);
  passwordConfirmInput.addEventListener('input', checkPasswordMatch);
  
  form.addEventListener('reset', function () {
	    setTimeout(() => {
	      messageSpan.textContent = "";
	      messageSpan.className = "password-check-message";
	      messageSpan.style.display = "none";
	    }, 0); // reset 후 DOM 반영 타이밍 맞추기 위해 setTimeout 사용
	  });
</script>