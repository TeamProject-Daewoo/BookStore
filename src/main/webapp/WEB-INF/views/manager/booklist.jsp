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
        .container { width: 90%; margin: 50px auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; margin-top: 0px; }
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
       .tabs {
      		font-size: 13px; line-height: 20px;
      		margin-top: 25px;
  			
    		}
    	.tabs ul {
      		margin:0; list-style:none; padding: 0 6%;
      		overflow: hidden;
    	}
    	.tabs ul li {
      		float: left;
      		margin: 0;
    	}
    	.tabs ul li a {
      		background: #f6f6f6;
      		font-weight: bold;
      		text-align: center;
      		display: block;
      		border: 1px solid #e0e0e0;
      		color: #909090;
      		text-shadow: 0 1px 0 rgba(255,255,255, 0.75);
      		padding: 6px 18px; margin: 0 5px -1px 0;
      		border-top-left-radius: 10px;
      		border-top-right-radius: 10px;
      		text-decoration:none;
    	}
    	.tabs ul li a:hover {
      		border-color: rgb(214, 241, 207);
      		color: #606060;
    	}
    	.tabs ul li.active a {
      		background: #fff;
      		border-color: #d4d4d4;
      		border-bottom: 1px solid #fff;
      		color: #dd390d;
      		margin-top: -4px;
      		padding-top: 10px;
    	}
    </style>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        var successMessage = "${successMessage}";
        var errorMessage = "${errorMessage}";

        if (successMessage && successMessage !== "") {
            alert(successMessage);
        }
        if (errorMessage && errorMessage !== "") {
            alert(errorMessage);
        }

        const accountTab = document.getElementById('accountTab');
        const container = document.getElementById('content-container');

        if(accountTab) {
            accountTab.addEventListener('click', function(e) {
                e.preventDefault();  // 페이지 이동 막기

                // Ajax로 계정 정보 내용만 로드
                fetch(this.href)
                .then(resp => {
                    if (!resp.ok) throw new Error('네트워크 오류');
                    return resp.text();
                })
                .then(html => {
                    container.innerHTML = html;

                    // 탭 활성화 클래스 처리 (책 목록 탭은 비활성, 계정 탭은 활성)
                    const tabs = document.querySelectorAll('.tabs ul li');
                    tabs.forEach(li => li.classList.remove('active'));
                    this.parentElement.classList.add('active');
                })
                .catch(err => {
                    container.innerHTML = '<p class="text-danger">내용 로드 실패</p>';
                    console.error(err);
                });
            });
        }
    });
    </script>
</head>
<body>
<div>
	<div class="tabs">
  		<ul>
  		<br>
    		<li class="active"><a href="${pageContext.request.contextPath}/manager/booklist">책 목록</a></li>
      		<li><a href="${pageContext.request.contextPath}/manager/managerview" id="accountTab">회원 목록</a></li>
  		</ul>
	</div>
    <div class="container" id="content-container">
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
</div>
</body>
</html>