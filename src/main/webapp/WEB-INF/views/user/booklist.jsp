<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Header</title>
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background-color: #fff;
    }

    /* 상단 헤더 */
    header {
      background-color: #f8f9fa;
      padding: 15px 30px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      border-bottom: 1px solid #ddd;
    }

    .logo {
      font-weight: bold;
      font-size: 24px;
      color: #007bff;
      text-decoration: none;
      cursor: pointer;
      user-select: none;
    }

    nav ul {
      list-style: none;
      margin: 0;
      padding: 0;
      display: flex;
      align-items: center;
      gap: 20px;
    }

    nav ul li a, nav ul li span {
      text-decoration: none;
      color: #333;
      font-size: 16px;
    }

    nav ul li a:hover {
      text-decoration: underline;
    }

    .cart {
      position: relative;
      font-weight: bold;
      color: #007bff;
    }

    .cart-count {
      position: absolute;
      top: -8px;
      right: -12px;
      background: red;
      color: white;
      border-radius: 50%;
      padding: 2px 7px;
      font-size: 12px;
      font-weight: normal;
      user-select: none;
    }

    /* 검색창 */
    .search-bar {
      display: flex;
      justify-content: center;
      margin: 20px 0 10px;
    }

    .search-container {
      display: flex;
      align-items: center;
      border: 1px solid #ccc;
      border-radius: 30px;
      padding: 5px 15px;
      background: #fff;
      width: 400px;
    }

    .search-dropdown {
      border: none;
      background: transparent;
      font-size: 16px;
      font-weight: bold;
      margin-right: 10px;
      cursor: pointer;
    }

    .search-input {
      border: none;
      outline: none;
      font-size: 16px;
      flex: 1; /* 수정된 부분 */
    }

    .search-button {
      display: flex;
      align-items: center;
      justify-content: center;
      background: transparent;
      border: none;
      cursor: pointer;
      padding: 0;
      height: 24px;
    }

    .search-button img {
      width: 20px;
      height: 20px;
      object-fit: contain;
    }

    /* 메뉴바 */
    .main-menu {
      display: flex;
      justify-content: center;
      gap: 20px;
      margin-bottom: 20px;
    }

    .main-menu a {
      text-decoration: none;
      font-weight: bold;
      color: #333;
      font-size: 15px;
    }

    .main-menu a:nth-child(1) { color: #00b050; }
    .main-menu a:nth-child(2) { color: #66cc33; }
  </style>
</head>
<body>

  <!-- 검색창 영역 -->
  <section class="search-bar">
    <form action="/search" method="get">
      <div class="search-container">
        <select class="search-dropdown" name="where">
          <option value="nexearch">통합검색</option>
          <option value="news">ebook</option>
          <option value="image">핫트랙</option>
        </select>
        <input type="text" class="search-input" name="query" placeholder="내 안의 아티스트를 다시 불러낸다" />
        <button type="submit" class="search-button">
          <img src="https://img.icons8.com/ios-filled/50/000000/search--v1.png" alt="검색" />
        </button>
      </div>
    </form>
  </section>

  <!-- 메뉴바 영역 -->
  <nav class="main-menu">
    <a href="#">베스트</a>
    <a href="#">신상품</a>
    <a href="#">이벤트</a>
    <a href="#">바로펀딩</a>
    <a href="#">PICKS</a>
    <a href="#">CASTing</a>
    <a href="#">컬처라운지</a>
  </nav>

</body>
</html>
