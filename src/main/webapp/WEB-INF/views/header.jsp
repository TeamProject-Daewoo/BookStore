<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Header</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .navbar .cart-count {
      background-color: red;
      color: #fff;
      font-size: 0.75rem;
      padding: 2px 6px;
      border-radius: 50%;
      margin-left: 4px;
    }
	#categoryMenu {
	  display: none;          /* 기본 숨김 */
	  position: absolute;     
	  background: white;
	  list-style: none;
	  padding: 0.5rem 0;
	  margin: 0;
	  box-shadow: 0 2px 6px rgba(0,0,0,0.2);
	  z-index: 3000;
	}

	#categoryMenu li a {
	  display: block;
	  padding: 0.5rem 1rem;
	  text-decoration: none;
	  color: black;
	}

	#categoryMenu li a:hover {
	  background-color: #f1f1f1;
	}

  </style>
</head>
<body>
	<header>
	  <nav class="navbar navbar-expand-lg navbar-light bg-light px-4">
	    <!-- 왼쪽 로고 -->
	    <a class="navbar-brand fw-bold" href="<c:url value='/user/booklist'/>">📚 BookStore</a>

	    <!-- 모바일 토글 버튼 -->
	    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav"
	            aria-controls="mainNav" aria-expanded="false" aria-label="Toggle navigation">
	      <span class="navbar-toggler-icon"></span>
	    </button>

	    <div id="mainNav" class="collapse navbar-collapse justify-content-between">
	      
	      <!-- 가운데 메뉴 -->
	      <ul class="navbar-nav me-auto gap-3">
	        <!-- 카테고리 드롭다운 -->
			<li class="nav-item" id="categoryDropdown">
			    <a href="#" class="nav-link">카테고리 ▼</a>
			    <ul class="dropdown-menu" id="categoryMenu">
			      <li><a class="dropdown-item" href="<c:url value='/category/novel'/>">소설</a></li>
			      <li><a class="dropdown-item" href="<c:url value='/category/it'/>">IT/컴퓨터</a></li>
			      <li><a class="dropdown-item" href="<c:url value='/category/economy'/>">경제/경영</a></li>
			      <li><hr class="dropdown-divider"></li>
			      <li><a class="dropdown-item" href="<c:url value='/category/etc'/>">기타</a></li>
			    </ul>
			  </li>

	        <!-- 베스트셀러 -->
	        <li class="nav-item">
<<<<<<< HEAD
	          <a class="nav-link" href="<c:url value='/book/bestseller'/>">베스트셀러</a>
=======
	          <a class="nav-link" href="<c:url value='/bestseller/main'/>">베스트셀러</a>
>>>>>>> 0480e12 (bestseller 구현)
	        </li>

	        <!-- 게시판 -->
	        <li class="nav-item">
	          <a class="nav-link" href="<c:url value='/board/main'/>">게시판</a>
	        </li>
	      </ul>

	      <!-- 오른쪽 메뉴 -->
	      <ul class="navbar-nav align-items-center gap-3">

	        <sec:authorize access="isAuthenticated()">
	          <li class="nav-item">
	            <span class="navbar-text">
	              안녕하세요, <sec:authentication property="name" />님
	            </span>
	          </li>
	          <li class="nav-item">
	              <a class="nav-link" href="<c:url value='/user/mypage/${pageContext.request.userPrincipal.name}'/>">내 정보</a>
	          </li>
	          <li class="nav-item">
	            <form id="logoutForm" action="<c:url value='/logout' />" method="post" class="d-inline">
	              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	              <a href="#" onclick="document.getElementById('logoutForm').submit(); return false;" class="nav-link">로그아웃</a>
	            </form>
	          </li>

	          <sec:authorize access="hasRole('ROLE_ADMIN')">
	            <li class="nav-item">
	              <a class="nav-link" href="<c:url value='/manager/booklist'/>">관리자 페이지</a>
	            </li>
	          </sec:authorize>
	        </sec:authorize>

	        <sec:authorize access="!isAuthenticated()">
	          <li class="nav-item"><a class="nav-link" href="<c:url value='/user/loginform'/>">로그인</a></li>
	          <li class="nav-item"><a class="nav-link" href="<c:url value='/user/registerform'/>">회원가입</a></li>
	        </sec:authorize>

	        <li class="nav-item position-relative">
	          <a href="<c:url value='/cart'/>" class="nav-link d-flex align-items-center">
	            🛒 장바구니
	            <span class="cart-count"><c:out value="${cartCount}" /></span>
	          </a>
	        </li>
	      </ul>
	    </div>
	  </nav>

	  <!-- 관리자 영역일 때만 공통 탭 노출 -->
	  <c:if test="${page != null and fn:startsWith(page, 'manager/')}">
	    <jsp:include page="/WEB-INF/views/manager/_tabs.jsp" />
	  </c:if>
	</header>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- (선택) AJAX로 탭 본문 로드하고 싶으면 _tabs.jsp의 a에 data-ajax="true" 추가 -->
<script>
document.addEventListener('click', function (e) {
  var a = e.target.closest('.tabs a[data-ajax="true"]');
  if (!a) return;

  var container = document.getElementById('content-container');
  if (!container) return;

  e.preventDefault();
  fetch(a.href, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
    .then(function (r) { if (!r.ok) throw new Error('네트워크 오류'); return r.text(); })
    .then(function (html) {
      container.innerHTML = html;

      // 삽입된 <script> 실행 (Chart.js/대시보드 스크립트 등)
      container.querySelectorAll('script').forEach(function (old) {
        var s = document.createElement('script');
        if (old.src) { s.src = old.src; s.async = false; } else { s.text = old.textContent; }
        document.body.appendChild(s);
        old.remove();
      });

      // 활성 탭 표시
      document.querySelectorAll('.tabs li').forEach(function (li) { li.classList.remove('active'); });
      a.parentElement.classList.add('active');
    })
    .catch(function (err) {
      container.innerHTML = '<p class="text-danger">내용 로드 실패</p>';
      console.error(err);
    });
});

const dropdown = document.getElementById('categoryDropdown');
const menu = document.getElementById('categoryMenu');

dropdown.addEventListener('mouseenter', () => {
  menu.style.display = 'block';
});

dropdown.addEventListener('mouseleave', () => {
  menu.style.display = 'none';
});

</script>
</body>
</html>
