<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>책 목록 (관리자)</title>
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
            margin-bottom: 20px;
        }
        .add-button:hover {
            background-color: #218838;
        }
        .message {
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 5px;
            text-align: center;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
    <script>
        window.onload = function() {
            var successMessage = "${successMessage}";
            var errorMessage = "${errorMessage}";

            if (successMessage && successMessage !== "") {
                alert(successMessage);
            }
            if (errorMessage && errorMessage !== "") {
                alert(errorMessage);
            }
        };
    </script>
</head>
<body>
    <div class="container">
        <h2>책 목록 (관리자)</h2>
        <a href="${pageContext.request.contextPath}/manager/insertform" class="add-button">새 책 추가</a>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>제목</th>
                    <th>저자</th>
                    <th>가격</th>
                    <th>재고</th>
                    <th>이미지</th>
                    <th>설명</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="book" items="${list}">
                    <tr>
                        <td>${book.id}</td>
                        <td>${book.title}</td>
                        <td>${book.author}</td>
                        <td>${book.price}</td>
                        <td>${book.stock}</td>
                        <td>${book.img}</td>
                        <td>${book.description}</td>
                        <td class="actions">
                            <a href="${pageContext.request.contextPath}/manager/bookeditform?id=${book.id}">수정</a>
                            <a href="${pageContext.request.contextPath}/manager/bookdelete?id=${book.id}" onclick="return confirm('정말로 이 책을 삭제하시겠습니까?');">삭제</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>