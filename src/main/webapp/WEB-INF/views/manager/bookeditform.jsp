<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>책 수정</title>
    <style>
        body { font-family: sans-serif; }
        .container { width: 600px; margin: 50px auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; }
        h2 { text-align: center; }
        label { display: block; margin-top: 10px; }
        input[type="text"],
        input[type="number"],
        textarea {
            width: calc(100% - 22px);
            padding: 10px;
            margin: 5px 0 10px 0;
            box-sizing: border-box;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
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
        <h2>책 정보 수정</h2>
        <form action="${pageContext.request.contextPath}/manager/bookedit" method="post" onsubmit="return confirm('수정하시겠습니까?');">
            <input type="hidden" name="id" value="${book.id}">

            <label for="title">제목:</label>
            <input type="text" id="title" name="title" value="${book.title}" required>

            <label for="author">저자:</label>
            <input type="text" id="author" name="author" value="${book.author}" required>

            <label for="price">가격:</label>
            <input type="number" id="price" name="price" value="${book.price}" required min="0">

            <label for="stock">재고:</label>
            <input type="number" id="stock" name="stock" value="${book.stock}" required min="0">

            <label for="img">이미지 파일명:</label>
            <input type="text" id="img" name="img" value="${book.img}" placeholder="예: book_image.jpg" required>

			<label for="category">카테고리:</label>
			<select id="category" name="category" required>
   				<option value="">-- 선택 --</option>
    			<option value="소설" ${book.category == '소설' ? 'selected' : ''}>소설</option>
    			<option value="IT/컴퓨터" ${book.category == 'IT/컴퓨터' ? 'selected' : ''}>IT/컴퓨터</option>
    			<option value="경제/경영" ${book.category == '경제/경영' ? 'selected' : ''}>경제/경영</option>
    			<option value="기타" ${book.category == '기타' ? 'selected' : ''}>기타</option>
			</select>

            <label for="description">설명:</label>
            <textarea id="description" name="description" rows="5">${book.description}</textarea>

            <input type="submit" value="정보 수정">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }" />
        </form>
    </div>
</body>
</html>