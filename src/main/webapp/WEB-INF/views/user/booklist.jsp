<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>책 상세 정보</title>
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background-color: #fff;
      font-size: 18px;
    }
    .book-detail-container {
      width: 90%;
      margin: 50px auto;
      padding: 40px;
      border: 1px solid #ddd;
      border-radius: 8px;
      background-color: #f9f9f9;
      display: flex;
      justify-content: space-between;
      gap: 30px;
    }
    .book-info {
      flex: 1;
      padding-right: 20px;
      text-align: left;
    }
    .book-img {
      width: 300px;
      height: auto;
      display: block;
      margin: 20px auto;
    }
    .book-info h3 {
      font-size: 28px;
      color: #007bff;
      text-align: center;
    }
    .book-info p {
      font-size: 22px;
      margin-bottom: 15px;
    }
    .book-price-stock {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      font-size: 22px;
    }
    .book-price-stock p {
      margin: 10px 0;
    }
  </style>
</head>
<body>

  <div class="book-detail-container">
    <!-- 제목을 맨 위에 중앙에 배치 -->
    <h3 style="font-size: 36px;">${book.title}</h3>

    <div style="display: flex; width: 100%; justify-content: space-between; gap: 30px;">
      <!-- 왼쪽: 저자, 설명 -->
      <div class="book-info">
        <p><strong>저자:</strong> ${book.author}</p>
        <p><strong>설명:</strong> ${book.description}</p>
      </div>

      <!-- 가운데: 책 표지 이미지 -->
      <img src="${imagePath}" alt="책 표지" class="book-img" />

      <!-- 오른쪽: 가격, 재고 -->
      <div class="book-price-stock">
        <p><strong>가격:</strong> ${book.price}</p>
        <p><strong>재고:</strong> ${book.stock}</p>
      </div>
    </div>
  </div>

</body>
</html>
