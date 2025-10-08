<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>게시글 보기</title>
  <style>
    #pageBody { font-family: sans-serif; background:#f4f4f4; }
    .view-wrap { width: 50%; margin: 20px auto; background:#fff; padding: 20px; border-radius:5px; box-shadow:0 2px 5px rgba(0,0,0,.1);}
    .view-row { margin: 10px 0; }
    .label { font-weight: bold; width: 80px; display:inline-block; }
    .content-box { margin-top:10px; padding:12px; border:1px solid #ddd; border-radius:4px; white-space:pre-wrap; line-height:1.5; background:#fff; }
    .btns { text-align:right; margin-top:15px; }
    .btn { display:inline-block; padding:8px 14px; border-radius:4px; text-decoration:none; background:#4CAF50; color:#fff; margin-left:8px; cursor:pointer; border:none; }
    .btn:hover { background:#45a049; }
    .post-title { font-size:26px; font-weight:bold; color:#333; margin-bottom:10px; border-bottom:2px solid #ddd; padding-bottom:10px; display:flex; align-items:center; justify-content:space-between; position:relative; }
    .post-info { font-size:14px; color:#888; margin-bottom:20px; display:flex; justify-content:space-between; align-items:center; }
    .comment-box { display:flex; gap:16px; padding:12px; border-bottom:1px solid #eee; position:relative; }
    .comment-img { flex-shrink:0; }
    .comment-img img { width:70px; height:70px; border-radius:50%; object-fit:cover; }
    .comment-content { flex:1; display:flex; flex-direction:column; gap:6px; }
    .comment-header { display:flex; justify-content:space-between; gap:16px; }
    .comment-body p { margin:0; line-height:1.4; }
    .menu-button { background:none; border:none; font-size:20px; cursor:pointer; padding:0; }
    .menu-box { display:none; position:absolute; right:0; top:24px; background:#fff; border:1px solid #ccc; border-radius:6px; box-shadow:0 2px 8px rgba(0,0,0,0.15); min-width:100px; z-index:10; }
    .menu-box button { display:block; width:100%; border:none; background:none; padding:8px; cursor:pointer; text-align:left; font-size:14px; }
    .menu-box button.delete { color:red; }
    .menu-box button:hover { background:#f5f5f5; }
    .menu-box button.delete:hover { background:#ffeaea; }
    .edit-form { margin-top:8px; }
  </style>
</head>
<body id="pageBody">

<div class="view-wrap">

  <!-- 게시글 제목 + 액션 버튼 -->
  <div class="post-title">
      <span><c:out value="${post.title}"/></span>

      <c:if test="${post.user_id == user or fn:contains(userRoles, 'ROLE_ADMIN')}">
          <div style="position:relative;">
    		<button class="menu-button">⋮</button>
		<div class="menu-box">
    		<form action="${pageContext.request.contextPath}/board/edit" method="get" style="margin:0;">
        		<input type="hidden" name="id" value="${post.id}" />
        		<button type="submit">수정</button>
    		</form>
    
    		<form action="${pageContext.request.contextPath}/board/delete" method="post" style="margin:0;">
        		<input type="hidden" name="id" value="${post.id}" />
        		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        		<button type="submit" class="delete" onclick="return confirm('삭제하시겠습니까?');">삭제</button>
    		</form>
		</div>
          </div>
      </c:if>
  </div>

  <!-- 작성자, 작성일, 조회수 -->
  <div class="post-info"> 
    <div style="display:flex; align-items:center; gap:8px;"> 
      <c:out value="${post.author}"/> 
      <img src="<c:url value='/user/profileImageByUsername/${post.user_id}' />" 
      alt="프로필 이미지" style="width:30px; height:30px; border-radius:50%; object-fit:cover;"> &nbsp;|&nbsp; 
      <c:out value="${post.createdAt}"/> 
    </div> 
    조회 <c:out value="${post.viewCount}"/> 
  </div>

  <!-- 내용 -->
  <div class="view-row">
      <div class="label">내용</div>
      <div class="content-box"><c:out value="${post.content}"/></div>
  </div>

  <!-- 목록 버튼 -->
  <div class="btns">
      <a class="btn" href="${pageContext.request.contextPath}/board/main">목록</a>
  </div>

  <br><br><br>

  <!-- 댓글 작성 -->
  <h3 style="margin-bottom:20px;">💬 댓글 작성</h3>

  <sec:authorize access="isAuthenticated()">
      <form action="${pageContext.request.contextPath}/board/addComment" method="post" style="margin-bottom:30px;">
          <input type="hidden" name="boardId" value="${post.id}">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
          <div style="margin-top:12px;">
              <textarea name="content" rows="4" placeholder="댓글을 작성해주세요." style="width:100%; padding:8px; border-radius:8px; border:1px solid #ccc;" required></textarea>
          </div>
          <button type="submit" class="btn btn-success" style="margin-top:12px; width:120px;">댓글 등록</button>
      </form>
  </sec:authorize>

  <sec:authorize access="!isAuthenticated()">
      <p>로그인 후 댓글을 작성할 수 있습니다.</p>
  </sec:authorize>

  <hr style="margin:20px 0;">

  <!-- 댓글 목록 -->
  <h4>댓글 목록</h4>
  <c:forEach var="comment" items="${comments}">
      <div class="comment-box">
          <div class="comment-img">
              <img src="<c:url value='/user/profileImageByUsername/${comment.userId}' />" alt="프로필 이미지">
          </div>
          <div class="comment-content">
              <div class="comment-header">
                  <div style="display:flex; align-items:center; gap:8px;">
                      <strong style="font-size:16px;">${comment.userId}</strong>
                  </div>

                  <div style="flex:1"></div>

                  <span style="font-size:12px; color:#888;">
                      <fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd" />
                  </span>

                  <c:if test="${comment.userId == user or fn:contains(userRoles, 'ROLE_ADMIN')}">
                      <div style="position:relative;">
                          <button class="menu-button">⋮</button>
                          <div class="menu-box">
                              <button type="button"
                                  class="edit-btn"
                                  data-comment-id="${comment.commentId}"
                                  data-comment-content="${fn:escapeXml(comment.content)}">
                                  수정
                              </button>
                              <form action="${pageContext.request.contextPath}/board/commentDelete" method="post" style="margin:0;">
                                  <input type="hidden" name="commentId" value="${comment.commentId}" />
                                  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                  <button type="submit" class="delete">삭제</button>
                              </form>
                          </div>
                      </div>
                  </c:if>
              </div>
              <div class="comment-body">
                  <p>${comment.content}</p>
              </div>
          </div>
      </div>
  </c:forEach>

  <c:if test="${empty comments}">
      <p>아직 등록된 댓글이 없습니다.</p>
  </c:if>

</div>

<script>
const contextPath = '${pageContext.request.contextPath}';
const csrfParameter = '${_csrf.parameterName}';
const csrfToken = '${_csrf.token}';

// 메뉴 토글
document.querySelectorAll('.menu-button').forEach(btn => {
    btn.addEventListener('click', function(e) {
        e.stopPropagation();
        const menu = btn.nextElementSibling;
        menu.style.display = (menu.style.display === 'block') ? 'none' : 'block';
    });
});
document.addEventListener('click', function(e) {
    document.querySelectorAll('.menu-box').forEach(menu => {
        if (!menu.contains(e.target)) menu.style.display = 'none';
    });
});

// 댓글 인라인 수정
// 댓글 인라인 수정
document.querySelectorAll('.edit-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        const commentBox = btn.closest('.comment-box');
        const commentBody = commentBox.querySelector('.comment-body');

        // 기존 폼 제거
        const existingForm = commentBox.querySelector('.edit-form');
        if (existingForm) existingForm.remove();

        commentBody.style.display = 'none';

        // 폼 생성
        const form = document.createElement('form');
        form.className = 'edit-form';
        form.method = 'post';
        form.action = `${contextPath}/board/commentEdit`;

        const textarea = document.createElement('textarea');
        textarea.name = 'content';
        textarea.rows = 3;
        textarea.style.width = '100%';
        textarea.style.padding = '8px';
        textarea.style.borderRadius = '4px';
        textarea.style.border = '1px solid #ccc';
        textarea.value = btn.dataset.commentContent;

        const hidden = document.createElement('input');
        hidden.type = 'hidden';
        hidden.name = 'commentId';
        hidden.value = btn.dataset.commentId;

        const csrf = document.createElement('input');
        csrf.type = 'hidden';
        csrf.name = csrfParameter;
        csrf.value = csrfToken;

        // ✅ 여기서 boardId hidden 추가
        const boardIdInput = document.createElement('input');
        boardIdInput.type = 'hidden';
        boardIdInput.name = 'boardId';
        boardIdInput.value = '${post.id}';  // JSP EL로 현재 게시글 ID

        const div = document.createElement('div');
        div.style.marginTop = '6px';
        div.style.display = 'flex';
        div.style.gap = '6px';

        const saveBtn = document.createElement('button');
        saveBtn.type = 'submit';
        saveBtn.className = 'btn';
        saveBtn.innerText = '저장';

        const cancelBtn = document.createElement('button');
        cancelBtn.type = 'button';
        cancelBtn.className = 'btn';
        cancelBtn.innerText = '취소';
        cancelBtn.onclick = function() {
            form.remove();
            commentBody.style.display = 'block';
        };

        div.appendChild(saveBtn);
        div.appendChild(cancelBtn);

        form.appendChild(csrf);
        form.appendChild(hidden);
        form.appendChild(boardIdInput); // ← 여에 추가
        form.appendChild(textarea);
        form.appendChild(div);

        commentBody.parentNode.insertBefore(form, commentBody.nextSibling);
    });
});

</script>

</body>
</html>
