<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>책 목록 (관리자)</title>
<style>
  /* 전체 기본 폰트, 배경 */
  body {
  	/* 한 가지 폰트로 통일! 페이지 이동할 때마다 크기 오차 생김  */
    /* font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; */
    font-family: sans-serif;
    background: #f7f8fa;
    margin: 0px;
    color: #333;
  }

  /* 탭 영역 */
  .tabs {
    margin-bottom: 20px;
  }

  .tabs ul {
    list-style: none;
    padding: 0;
    display: flex;
    border-bottom: 2px solid #ddd;
  }

  .tabs ul li {
    margin-right: 20px;
  }

  .tabs ul li a {
    display: block;
    padding: 10px 18px;
    text-decoration: none;
    color: #555;
    font-weight: 600;
    border-bottom: 3px solid transparent;
    transition: all 0.3s ease;
  }

  .tabs ul li.active a,
  .tabs ul li a:hover {
    color: #3498db;
    border-color: #3498db;
  }

  /* 컨테이너 영역 */
  .container {
    background: white;
    padding: 20px 25px;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  }

  h2 {
    margin-top: 0;
    margin-bottom: 15px;
    color: #2c3e50;
  }

  /* 새 책 추가 버튼 */
  .add-button {
    display: inline-block;
    margin-bottom: 15px;
    padding: 8px 14px;
    background-color: #2ecc71;
    color: white;
    text-decoration: none;
    border-radius: 5px;
    font-weight: 600;
    transition: background-color 0.3s ease;
  }

  .add-button:hover {
    background-color: #27ae60;
  }

  /* 테이블 스타일 */
  table {
    width: 100%;
    border-collapse: collapse;
    font-size: 14px;
  }

  thead {
    background-color: #3498db;
    color: white;
  }

  thead th {
    padding: 12px 10px;
    text-align: left;
  }

  tbody tr:nth-child(even) {
    background-color: #f9f9f9;
  }

  tbody tr:hover {
    background-color: #f1f7ff;
  }

  tbody td {
    padding: 10px;
    border-bottom: 1px solid #ddd;
    vertical-align: middle;
  }

  /* 설명 칸 줄임 처리 (길면 ... 처리) */
  tbody td:nth-child(7) {
    max-width: 200px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  /* 이미지 칸은 이미지 썸네일로 보여주기 */
  tbody td:nth-child(6) {
    padding: 6px;
  }
  tbody td:nth-child(6) img {
    max-width: 60px;
    max-height: 60px;
    object-fit: cover;
    border-radius: 4px;
  }

  /* 관리(수정/삭제) 버튼 */
  .actions a {
    margin-right: 8px;
    padding: 6px 12px;
    border-radius: 4px;
    font-size: 13px;
    color: white;
    text-decoration: none;
    font-weight: 600;
  }

  .actions a:first-child {
    background-color: #2980b9;
  }

  .actions a:last-child {
    background-color: #c0392b;
  }

  .actions a:hover {
    opacity: 0.85;
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

        const container = document.getElementById('content-container');
        const tabs = document.querySelectorAll('.tabs ul li');

        function setupTabClick(tabId) {
            const tab = document.getElementById(tabId);
            if (tab) {
                tab.addEventListener('click', function(e) {
                    e.preventDefault();
                    fetch(this.href)
                        .then(resp => {
                            if (!resp.ok) throw new Error('네트워크 오류');
                            return resp.text();
                        })
                        .then(html => {
                            container.innerHTML = html;
                            tabs.forEach(li => li.classList.remove('active'));
                            this.parentElement.classList.add('active');
                        })
                        .catch(err => {
                            container.innerHTML = '<p class="text-danger">내용 로드 실패</p>';
                            console.error(err);
                        });
                });
            }
        }

        // 계정정보 + 구매내역 탭 모두 적용
        setupTabClick('accountTab');
        setupTabClick('salesview');
    });

    </script>
</head>
<body>
<div>
   <div class="tabs">
        <ul>
        <br>
        <li><a href="${pageContext.request.contextPath}/manager/salesview" id="salesview"">판매 현황</a></li>
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