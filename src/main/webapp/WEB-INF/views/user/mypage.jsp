<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.Calendar, java.util.Date" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<title>내 프로필</title>
<style>
body {
    font-family: 'Apple SD Gothic Neo', 'Segoe UI', sans-serif;
    background-color: #f8f9fa;
    margin: 0;
    padding: 0;
}

/* 프로필 카드 */
.profile-container {
    max-width: 1000px;
    margin: 60px auto;
    padding: 30px 40px;
    background-color: #fff;
    border: 1px solid #dee2e6;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.profile-main {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 20px;
    margin-bottom: 20px;
}

.profile-header h2 {
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

.profile-item {
    font-size: 16px;
    margin-top: 10px;
}

.profile-item span {
    font-weight: bold;
}

/* 구매 목록 */
.purchase-container {
    max-width: 1000px;
    margin: 40px auto;
    padding: 30px 40px;
    background-color: #fff;
    border: 1px solid #dee2e6;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.purchase-container h2 {
    text-align: center;
    margin-bottom: 20px;
    font-size: 24px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
}

th, td {
    border: 1px solid #dee2e6;
    padding: 10px;
    text-align: left;
}

th {
    background-color: #f1f3f5;
    font-weight: 600;
}

tr:nth-child(even) {
    background-color: #f9f9f9;
}

tr:hover {
    background-color: #e9ecef;
}

.book-img {
    width: 70px;
    height: auto;
    border-radius: 5px;
    object-fit: cover;
}

.add-button {
    display: inline-block;
    padding: 10px 20px;
    background-color: #28a745;
    color: white;
    text-decoration: none;
    border-radius: 6px;
    margin-top: 20px;
    text-align: center;
}

.add-button:hover {
    background-color: #218838;
}

/* 대시보드 카드 */
.dash-grid {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 20px;
    margin-bottom: 20px;
}

.card {
    background: #fff;
    border: 1px solid #eee;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 2px 8px rgba(0,0,0,.05);
}

.card h3 {
    margin: 0 0 12px;
    font-size: 18px;
    color: #333;
}

#totalAmount {
    font-size: 20px;
    font-weight: bold;
    text-align: center;
}

/* 반응형 */
@media (max-width: 768px) {
    .profile-main {
        flex-direction: column;
        align-items: flex-start;
    }
    .dash-grid {
        grid-template-columns: 1fr;
    }
}
</style>
<c:if test="${not empty message}">
	<script>
		window.onload = function() {
			alert("${message}");
			location.replace(location.pathname);
		};
	</script>
</c:if>
</head>
<body>

<sec:authentication property="name" var="username"/>

<!-- 프로필 -->
<div class="profile-container">
    <div class="profile-main">
        <div>
            <h2>${username}님</h2>
        </div>
        <a href="<c:url value='/user/checkPasswordform'/>" class="btn-edit">개인정보 수정</a>
    </div>
</div>

<!-- 구매 목록 -->
<div class="purchase-container">
	<h1>구매 목록</h1>
    <jsp:include page="mypurchaselist.jsp" />
</div>

</body>
</html>
