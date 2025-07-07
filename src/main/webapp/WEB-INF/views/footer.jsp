<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Footer</title>
  <style>
    footer {
      background-color: #f8f9fa;
      border-top: 1px solid #ddd;
      padding: 30px 40px;
      font-family: Arial, sans-serif;
      font-size: 14px;
      color: #555;
      user-select: none;
    }
    footer .top-section {
      display: flex;
      justify-content: space-between;
      margin-bottom: 20px;
    }
    footer .links {
      display: flex;
      gap: 40px;
    }
    footer .links ul {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    footer .links ul li {
      margin-bottom: 8px;
    }
    footer .links ul li a {
      color: #555;
      text-decoration: none;
    }
    footer .links ul li a:hover {
      text-decoration: underline;
    }
    footer .company-info {
      line-height: 1.6;
      color: #777;
    }
    footer .company-info strong {
      color: #333;
    }
    footer .bottom-section {
      border-top: 1px solid #ddd;
      padding-top: 15px;
      text-align: center;
      color: #999;
      font-size: 12px;
    }
  </style>
</head>
<body>
<footer>
  <div class="top-section">
    <div class="links">
      <ul>
        <li><strong>고객센터</strong></li>
        <li><a href="#">1:1 문의</a></li>
        <li><a href="#">공지사항</a></li>
        <li><a href="#">자주 묻는 질문</a></li>
      </ul>
      <ul>
        <li><strong>회사 소개</strong></li>
        <li><a href="#">회사 소개</a></li>
        <li><a href="#">인재 채용</a></li>
        <li><a href="#">제휴 문의</a></li>
      </ul>
      <ul>
        <li><strong>정책 안내</strong></li>
        <li><a href="#">이용 약관</a></li>
        <li><a href="#">개인정보 처리방침</a></li>
        <li><a href="#">전자금융거래 이용약관</a></li>
      </ul>
    </div>
    <div class="company-info">
      <p><strong>교보문고(주)</strong> | 대표: 홍길동 | 사업자등록번호: 123-45-67890</p>
      <p>주소: 서울특별시 종로구 세종대로 123 | 고객센터: 02-000-0000 | 이메일: help@kyobobook.co.kr</p>
      <p>통신판매업 신고번호: 2025-서울종로-00000 | 개인정보 보호책임자: 홍길동</p>
    </div>
  </div>
  <div class="bottom-section">
    &copy; 2025 Kyobo Book Centre. All rights reserved.
  </div>
</footer>
</body>
</html>
