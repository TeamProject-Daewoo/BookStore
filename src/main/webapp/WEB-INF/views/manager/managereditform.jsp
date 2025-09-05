<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  .account-form { width: 90%; max-width: 600px; margin: 30px auto; padding: 25px; border: 1px solid #ccc; border-radius: 8px; font-family: sans-serif; background-color: #fff; }
  .account-form h2 { text-align: center; margin-bottom: 25px; }
  .form-row { display: flex; align-items: center; margin-bottom: 12px; padding-bottom: 12px; border-bottom: 1px solid #ddd; }
  .form-label { width: 120px; font-weight: bold; }
  .form-input, .form-value { flex: 1; position: relative; }
  .form-input input { width: 100%; padding: 10px 12px; font-size: 14px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; height: 48px; }
  .form-value { padding: 10px 12px; height: 28px; font-size: 14px; border: 1px solid #ddd; border-radius: 5px; background-color: #f8f8f8; display: flex; align-items: center; }
  .form-actions { text-align: center; margin-top: 25px; }
  .btn { display: inline-block; padding: 10px 20px; margin: 0 5px; font-size: 14px; font-weight: bold; border: none; border-radius: 5px; cursor: pointer; color: #fff; }
  .btn-edit { background-color: #28a745; }
  .btn-edit:hover { background-color: #218838; }
  .btn-reset { background-color: #dc3545; }
  .btn-reset:hover { background-color: #c82333; }
  .btn-delete { background-color: #b22222; }
  .btn-delete:hover { background-color: #7f1717; }
  .password-check-message { font-size: 13px; margin-left:8px; margin-top: 8px; display: none; }
  .password-check-message.match { color: green; display: block; }
  .password-check-message.mismatch { color: red; display: block; }
  #profilePreview { width:150px; height:150px; border-radius:50%; object-fit:cover; margin-bottom:5px; display:block; margin-left:auto; margin-right:auto; }
  #profileImage { display:block; margin-left:auto; margin-right:auto; }
  #idMessage { font-size: 13px; margin-left:5px; margin-top:5px; display:block; }
  #checkIdBtn { color: #fff; border:none; border-radius:5px; cursor:pointer; }
  #checkIdBtn:hover { background-color:#0056b3; }
  h2 { text-align:center; }
</style>
<h2><strong>회원 정보 수정(관리자)</strong></h2>
<form class="account-form" action="${pageContext.request.contextPath}/manager/manageredit?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
  <!-- 프로필 이미지 -->
  <div class="form-row" style="flex-direction: column;">
    <c:choose>
      <c:when test="${not empty member.profileImage}">
        <img id="profilePreview" src="${pageContext.request.contextPath}/user/profileImage/${member.id}" alt="프로필 이미지">
      </c:when>
      <c:otherwise>
        <img id="profilePreview" src="${pageContext.request.contextPath}/resources/profileimage/default.jpg" alt="기본 이미지">
      </c:otherwise>
    </c:choose>
    <br>
    <input type="file" id="profileImage" name="profileImageFile" accept="image/*">
    <br>
  </div>

  <!-- 이름 -->
  <div class="form-row">
    <div class="form-label">이름</div>
    <div class="form-input">
      <input type="text" name="name" value="${member.name}" required>
    </div>
  </div>

  <!-- 아이디 -->
  <!-- 아이디 -->
<div class="form-row">
  <div class="form-label">아이디</div>
  <div class="form-input" style="display:flex; flex-direction: column; gap:5px;">
    <div style="display:flex; align-items:center; gap:8px;">
      <input type="text" id="user_id" name="user_id" value="${member.user_id}" required style="flex:1; max-width:360px;">
      <button type="button" id="checkIdBtn" class="btn" style="background-color:#007bff; padding:8px 12px; font-size:13px;">중복 확인</button>
    </div>
    <!-- 메시지 출력 span을 input 바로 아래로 이동 -->
    <span id="idMessage" class="message"></span>
  </div>
</div>

 

  <!-- 이메일 -->
  <div class="form-row">
    <div class="form-label">이메일</div>
    <div class="form-input">
      <input type="email" name="email" value="${member.email}" required>
    </div>
  </div>

  <!-- 비밀번호 -->
  <div class="form-row">
    <div class="form-label">비밀번호</div>
    <div class="form-input">
      <input type="password" name="password" placeholder="새 비밀번호 입력">
    </div>
  </div>

  <!-- 비밀번호 확인 -->
  <div class="form-row">
    <div class="form-label">비밀번호 확인</div>
    <div class="form-input">
      <input type="password" name="password_confirm" placeholder="새 비밀번호 재입력">
      <span class="password-check-message" id="passwordMessage"></span>
    </div>
  </div>

  <!-- 전화번호 -->
  <div class="form-row">
    <div class="form-label">전화번호</div>
    <div class="form-input">
      <input type="text" name="phone_number" value="${member.phone_number}" required>
    </div>
  </div>

  <!-- 가입일 -->
  <div class="form-row">
    <div class="form-label">가입일</div>
    <div class="form-value">${member.created_at}</div>
  </div>

  <!-- 역할 -->
  <div class="form-row">
    <div class="form-label">역할</div>
    <div class="form-input">
        <select name="role" style="width:100%; padding:10px 12px; border:1px solid #ccc; border-radius:5px; font-size:14px;">
            <option value="ROLE_USER" <c:if test="${member.role == 'ROLE_USER'}">selected</c:if>>사용자</option>
            <option value="ROLE_ADMIN" <c:if test="${member.role == 'ROLE_ADMIN'}">selected</c:if>>관리자</option>
        </select>
    </div>
	</div>

  <div class="form-actions">
    <button type="submit" class="btn btn-edit">수정하기</button>
    <button type="reset" class="btn btn-reset">다시쓰기</button>
    <button type="button" class="btn btn-delete" onclick="history.back()">나가기</button>
  </div>
  
  <input type="hidden" name="id" value=${member.id}>
</form>

<script>
  // 프로필 이미지 미리보기
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

  // 비밀번호 실시간 체크
  const passwordInput = document.querySelector('input[name="password"]');
  const passwordConfirmInput = document.querySelector('input[name="password_confirm"]');
  const messageSpan = document.getElementById('passwordMessage');

  function checkPasswordMatch() {
    const pw = passwordInput.value.trim();
    const pwConfirm = passwordConfirmInput.value.trim();
    if(pw === "") { messageSpan.style.display = "none"; return; }
    if(pw !== pwConfirm) {
      messageSpan.textContent = "일치하지 않습니다.";
      messageSpan.className = "password-check-message mismatch";
      messageSpan.style.display = "inline";
    } else {
      messageSpan.textContent = "일치합니다";
      messageSpan.className = "password-check-message match";
      messageSpan.style.display = "inline";
    }
  }

  passwordInput.addEventListener('input', checkPasswordMatch);
  passwordConfirmInput.addEventListener('input', checkPasswordMatch);

  // ID 중복 확인
  const currentUserId = "${member.user_id}";
  let idChecked = false;
  document.getElementById("checkIdBtn").addEventListener("click", function () {
    const userId = document.getElementById("user_id").value.trim();
    const idMessage = document.getElementById("idMessage");

    if (!userId) { idMessage.style.color="red"; idMessage.textContent="아이디를 입력하세요."; idChecked=false; return; }
    if(userId === currentUserId){ idMessage.style.color="blue"; idMessage.textContent="현재 아이디입니다."; idChecked=true; return; }

    fetch("${pageContext.request.contextPath}/user/checkId?user_id=" + encodeURIComponent(userId))
      .then(res => res.json())
      .then(data => {
        if(data.exists){ idMessage.style.color="red"; idMessage.textContent="이미 사용 중인 아이디입니다."; idChecked=false; }
        else { idMessage.style.color="green"; idMessage.textContent="사용 가능한 아이디입니다."; idChecked=true; }
      }).catch(()=>{ idMessage.style.color="red"; idMessage.textContent="아이디 확인 중 오류 발생"; idChecked=false; });
  });

  const form = document.querySelector('.account-form');
  form.addEventListener('submit', function(e){
    const pw = passwordInput.value.trim();
    const pwConfirm = passwordConfirmInput.value.trim();
    const userId = document.getElementById("user_id").value.trim();

    if((pw!=="" || pwConfirm!=="") && pw!==pwConfirm){
      e.preventDefault(); alert("비밀번호가 일치하지 않습니다."); return false;
    }

    if(userId !== currentUserId && !idChecked){
      e.preventDefault(); alert("아이디 중복 확인을 해주세요."); return false;
    }

    if(!confirm("수정하시겠습니까?")) e.preventDefault();
  });

  form.addEventListener('reset', function() {
    setTimeout(() => {
      messageSpan.textContent="";
      messageSpan.className="password-check-message";
      messageSpan.style.display="none";
      document.getElementById("idMessage").textContent="";
    }, 0);
  });
</script>