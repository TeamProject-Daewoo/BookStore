<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시판</title>
    <style>
        #pageBody {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }
        #pageTitle, #formTitle {
            text-align: center;
        }
        #boardTable {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        #boardTable th, #boardTable td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        #boardTable th {
            background-color: #4CAF50;
            color: white;
        }
        #boardTable tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        #writeForm {
            width: 60%;
            margin: 20px auto;
            background: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        #writeForm label {
            display: block;
            margin: 10px 0 5px;
            font-weight: bold;
        }
        #titleInput, #contentInput {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            resize: none;
        }
        #submitBtn {
            display: block;
            width: 100%;
            padding: 10px;
            margin-top: 15px;
            background-color: #4CAF50;
            border: none;
            color: white;
            font-size: 16px;
            cursor: pointer;
            border-radius: 4px;
        }
        #submitBtn:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body id="pageBody">
    <h1 id="pageTitle">게시판</h1>

    <!-- 글 목록 -->
    <table id="boardTable">
        <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td>예시 제목</td>
                <td>홍길동</td>
                <td>2025-08-15</td>
            </tr>
        </tbody>
    </table>

    <!-- 글 작성 폼 -->
    <h2 id="formTitle">글 작성</h2>
	<div id="formContainer">
	    <form id="writeForm">
	        <label for="titleInput">제목</label>
	        <input type="text" id="titleInput" name="title">
	        
	        <label for="contentInput">내용</label>
	        <textarea id="contentInput" name="content" rows="5"></textarea>
	        
	        <button id="submitBtn" type="submit">작성</button>
    	</form>
	</div>
</body>
</html>
