<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>마이페이지</title>
<style>
body {
    font-family: 'Apple SD Gothic Neo', 'Segoe UI', sans-serif;
    background-color: #f8f9fa;
    margin: 0;
    padding: 0;
}

/* 전체 페이지 레이아웃 */
.page-container {
    display: flex;
    max-width: 1400px;
    margin: 40px auto;
    gap: 20px;
    padding: 0 20px;
}

/* 좌측 메뉴 */
.sidebar {
    width: 220px;
    background-color: #fff;
    border: 1px solid #dee2e6;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    flex-shrink: 0;
}

.sidebar h3 {
    font-size: 18px;
    margin-bottom: 15px;
    border-bottom: 1px solid #dee2e6;
    padding-bottom: 5px;
}

.sidebar ul {
    list-style: none;
    padding: 0;
    margin: 0;
}

.sidebar ul li {
    margin-bottom: 12px;
}

.sidebar ul li a {
    text-decoration: none;
    color: #333;
    font-size: 14px;
}

.sidebar ul li a:hover {
    color: #2563eb;
}

/* 메인 영역 */
.main-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 30px;
}

/* 프로필 카드 */
.profile-container {
    background-color: #fff;
    border: 1px solid #dee2e6;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    padding: 30px 40px;
}

.profile-main {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
}

.profile-main h2 {
    font-size: 26px;
    margin: 0;
}

.btn-edit {
    padding: 8px 16px;
    background-color: #28a745;
    color: white;
    border: none;
    border-radius: 6px;
    text-decoration: none;
    font-size: 14px;
}

.btn-edit:hover {
    background-color: #218838;
}

/* 구매 목록 카드 */
.purchase-container {
    background-color: #fff;
    border: 1px solid #dee2e6;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    padding: 30px 40px;
}

.purchase-container h1 {
    font-size: 24px;
    margin-bottom: 20px;
    border-bottom: 1px solid #dee2e6;
    padding-bottom: 10px;
}

/* 반응형 */
@media (max-width: 1024px) {
    .page-container {
        flex-direction: column;
    }
    .sidebar {
        width: 100%;
    }
}
</style>
</head>
<body>

<sec:authentication property="name" var="username"/>

<div class="page-container">

    <!-- 좌측 메뉴 -->
    <div class="sidebar">
        <h3>마이페이지</h3>
        <ul>
            <li><a href="#">프로필</a></li>
            <li><a href="#">구매 내역</a></li>
            <li><a href="#">쿠폰/포인트</a></li>
            <li><a href="#">설정</a></li>
        </ul>
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="main-content">

        <!-- 프로필 카드 -->
        <div class="profile-container">
            <div class="profile-main">
                <h2>${username}님</h2>
                <a href="<c:url value='/user/checkPasswordform'/>" class="btn-edit">개인정보 수정</a>
            </div>
        </div>

        <!-- 구매 목록 카드 -->
        <div class="purchase-container">
            <h1>구매 목록</h1>
            <jsp:include page="mypurchaselist.jsp" />
        </div>

    </div>
</div>

</body>
</html>
