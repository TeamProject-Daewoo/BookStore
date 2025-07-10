<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매 내역</title>
    <style>
        body { font-family: sans-serif; }
        .container { width: 90%; margin: 50px auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; }
        h2 { text-align: center; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .actions a { margin-right: 10px; text-decoration: none; color: #007bff; }
        .actions a:hover { text-decoration: underline; }
        .add-button {
            display: inline-block;
            padding: 10px 15px;
            background-color: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 20px;
        }
        .add-button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
<div class="container">
        <h2>구매 목록</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>구매자ID</th>
                    <th>구매자명</th>
                    <th>상품ID</th>
                    <th>제목</th>
                    <th>수량</th>
                    <th>구매날짜</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="purchase" items="${purchaseList}">
                    <tr>
                        <td>${purchase.id}</td>
                        <td>${purchase.member_id}</td>
                        <td>${purchase.member_name}</td>
                        <td>${purchase.book_id}</td>
                        <td>${purchase.book_title}</td>
                        <td>${purchase.quantity}</td>
                       	<td><fmt:formatDate value="${purchase.order_date}" pattern="yyyy-MM-dd" /></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <a class="add-button" href="${pageContext.request.contextPath}/manager/booklist">돌아가기</a>
    </div>
</body>
</html>