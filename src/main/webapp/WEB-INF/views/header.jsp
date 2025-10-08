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

    /* ===== 1. CSS 수정된 부분 시작 ===== */
	#categoryMenu {
	  display: none;          /* JS로 제어하기 위해 기본 숨김 (이것만 남깁니다) */
	  position: absolute;     
	  background: white;
	  list-style: none;
	  padding: 1rem;
	  margin: 0;
	  box-shadow: 0 2px 6px rgba(0,0,0,0.2);
	  z-index: 3000;
      
      /* 3열 그리드 레이아웃 설정 (display: grid; <-- 이 줄을 삭제!) */
	  width: 600px;
	  grid-template-columns: repeat(3, 1fr);
	  gap: 5px 10px;
	}
    /* ===== 1. CSS 수정된 부분 끝 ===== */

	#categoryMenu li a {
	  display: block;
	  padding: 0.5rem 1rem;
	  text-decoration: none;
	  color: black;
      white-space: nowrap; /* 글자가 두 줄로 나뉘는 것 방지 */
	}

	#categoryMenu li a:hover {
	  background-color: #f1f1f1;
      border-radius: 4px; /* 호버 시 약간 둥글게 */
	}

  </style>
</head>
<body>
	<header>
	  <nav class="navbar navbar-expand-lg navbar-light bg-light px-4">
	    <a class="navbar-brand fw-bold" href="<c:url value='/user/booklist'/>">📚 책숲</a>

	    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav"
	            aria-controls="mainNav" aria-expanded="false" aria-label="Toggle navigation">
	      <span class="navbar-toggler-icon"></span>
	    </button>

	    <div id="mainNav" class="collapse navbar-collapse justify-content-between">
	      
	      <ul class="navbar-nav me-auto gap-3">
	        <li class="nav-item" id="categoryDropdown">
			    <a href="#" class="nav-link">카테고리 ▼</a>
			    <ul id="categoryMenu">
			        <li><a class="dropdown-item" href="<c:url value='/category/novel'/>">소설</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/poem-essay'/>">시/에세이</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/economy-management'/>">경제/경영</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/self-development'/>">자기계발</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/humanities'/>">인문</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/history'/>">역사</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/social-politics'/>">사회/정치</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/science'/>">자연/과학</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/art-culture'/>">예술/대중문화</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/religion'/>">종교</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/preschool'/>">유아</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/children'/>">어린이</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/home-cooking'/>">가정/요리</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/travel'/>">여행</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/language'/>">국어/외국어</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/computer-it'/>">컴퓨터/IT</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/teen'/>">청소년</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/test-prep'/>">수험서/자격증</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/comics'/>">만화</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/magazine'/>">잡지</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/foreign-books'/>">외국도서</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/health-hobby'/>">건강/취미</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/highschool-reference'/>">고등학교 참고서</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/middleschool-reference'/>">중학교 참고서</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/elementary-reference'/>">초등학교 참고서</a></li>
			        <li><a class="dropdown-item" href="<c:url value='/category/used-books'/>">중고도서</a></li>
			    </ul>
			</li>

	        <li class="nav-item">
	          <a class="nav-link" href="<c:url value='/bestseller/main'/>">베스트셀러</a>
	        </li>

	        <li class="nav-item">
	          <a class="nav-link" href="<c:url value='/board/main'/>">게시판</a>
	        </li>
	      </ul>

	      <ul class="navbar-nav align-items-center gap-3">

	        <sec:authorize access="isAuthenticated()">
	          <li class="nav-item">
    			<span class="navbar-text">
	              안녕하세요.  <sec:authentication property="name" />님
	            </span>
	          </li>
	           <li class="nav-item">
	            <sec:authorize access="isAuthenticated()">
  				<li class="nav-item">
        			<img src="<c:url value='/user/profileImageByUsername/${pageContext.request.userPrincipal.name}' />"
         			alt="프로필 이미지"
         			style="width:40px; height:40px; border-radius:50%; object-fit:cover;">
  				</li>
				</sec:authorize>
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
	          <a href="<c:url value='/cart/cartview'/>" class="nav-link d-flex align-items-center">
	            🛒 장바구니
	            <span class="cart-count"><c:out value="${cartCount}" /></span>
	          </a>
	        </li>
	      </ul>
	    </div>
	  </nav>

	  <c:if test="${page != null and fn:startsWith(page, 'manager/')}">
	    <jsp:include page="/WEB-INF/views/manager/_tabs.jsp" />
	  </c:if>
	</header>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

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

/* ===== 2. JavaScript 수정된 부분 시작 ===== */
dropdown.addEventListener('mouseenter', () => {
  menu.style.display = 'grid'; // 'block' 대신 'grid'로 변경
});

dropdown.addEventListener('mouseleave', () => {
  menu.style.display = 'none';
});
/* ===== 2. JavaScript 수정된 부분 끝 ===== */

</script>
</body>
</html>