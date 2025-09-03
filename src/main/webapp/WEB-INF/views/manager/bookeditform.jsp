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
        .container { width: 900px; margin: 50px auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; }
        h2 { text-align: center; }
        label { display: block; margin-top: 10px; }
        input[type="text"],
        input[type="number"],
        textarea,
        select { 
            width: 100%;
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

        /* Flexbox 스타일: 이미지와 경로는 왼쪽에, 나머지 입력 필드는 오른쪽에 배치 */
        .form-container {
            display: flex;
            justify-content: space-between;
        }

        /* 이미지 미리보기와 경로 */
        .img-container {
            width: 45%;
            text-align: center;
        }
        #imagePreview {
            margin-top: 10px;
            max-width: 100%;
            height: auto;
            border: 1px solid #ddd;
            padding: 5px;
        }

        /* 나머지 입력 필드 */
        .form-fields {
            width: 50%;
        }

        /* "정보 수정" 버튼은 하단에 위치 */
        .submit-container {
            margin-top: 20px;
            text-align: center;
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

            // 이미지 URL 미리보기 설정
            var imgInput = document.getElementById('img');
            var imgPreview = document.getElementById('imagePreview');

            if (imgInput.value) {
                imgPreview.src = imgInput.value; // 초기 이미지 URL로 미리보기
            }

            // 파일 선택 후 미리보기
            imgInput.addEventListener('input', function() {
                var imgUrl = imgInput.value;
                imgPreview.src = imgUrl ? imgUrl : ''; // URL을 이미지 미리보기로 표시
            });
        };
    </script>
</head>
<body>
	<br>
	<h2><strong>책 정보 수정</strong></h2>
    <div class="container">
        <form action="${pageContext.request.contextPath}/manager/bookedit" method="post" onsubmit="return confirm('수정하시겠습니까?');">
            <input type="hidden" name="id" value="${book.id}">
            <input type="hidden" name="isbn" value="${book.isbn}">

            <div class="form-container">
                <!-- 왼쪽: 이미지 미리보기 및 경로 -->
                <div class="img-container">
                    <label for="img">이미지 경로(URL 또는 파일명):</label>
                    <input type="text" id="img" name="img" value="${book.img}" required readonly>
                    <img id="imagePreview" src="" alt="이미지 미리보기" />
                </div>

                <!-- 오른쪽: 나머지 입력 필드들 -->
                <div class="form-fields">
                    <div class="form-group">
                        <label for="title">제목:</label>
                        <textarea id="title" name="title" rows="3" required maxlength="500">${book.title}</textarea>
                    </div>

                    <div class="form-group">
                        <label for="author">저자:</label>
                        <input type="text" id="author" name="author" value="${book.author}" required>
                    </div>

                    <div class="form-group">
                        <label for="price">가격:</label>
                        <input type="number" id="price" name="price" value="${book.price}" required min="0">
                    </div>

                    <div class="form-group">
                        <label for="stock">재고:</label>
                        <input type="number" id="stock" name="stock" value="${book.stock}" required min="0">
                    </div>

                    <div class="form-group">
                        <label for="category">카테고리:</label>
                        <select id="category" name="category" required>
                            <option value="">-- 선택 --</option>
                            <option value="소설" ${book.category == '소설' ? 'selected' : ''}>소설</option>
                            <option value="IT/컴퓨터" ${book.category == 'IT/컴퓨터' ? 'selected' : ''}>IT/컴퓨터</option>
                            <option value="경제/경영" ${book.category == '경제/경영' ? 'selected' : ''}>경제/경영</option>
                            <option value="기타" ${book.category == '기타' ? 'selected' : ''}>기타</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="description">설명:</label>
                        <textarea id="description" name="description" rows="5">${book.description}</textarea>
                    </div>
                </div>
            </div>

            <!-- "정보 수정" 버튼을 하단에 배치 -->
            <div class="submit-container">
                <input type="submit" value="정보 수정">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }" />
            </div>
        </form>
    </div>
</body>
</html>
