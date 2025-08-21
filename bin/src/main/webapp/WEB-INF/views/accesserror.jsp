<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>접근 불가</title>
<style>
    /* #accessError 영역에만 스타일 적용 */
    #accessError {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100vh;
        background-color: #f8f9fa;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    #accessError h1 {
        color: #dc3545;
        font-size: 2rem;
        margin-bottom: 20px;
        text-align: center;
    }

    #accessError a {
        text-decoration: none;
        padding: 10px 20px;
        background-color: #007bff;
        color: white;
        border-radius: 5px;
        transition: background-color 0.3s ease;
    }

    #accessError a:hover {
        background-color: #0056b3;
    }
</style>
</head>
<body>
    <div id="accessError">
        <h1>🚫 접근이 제한되었습니다</h1>
        <a href="/user/booklist">🏠 메인으로 돌아가기</a>
    </div>
</body>
</html>
