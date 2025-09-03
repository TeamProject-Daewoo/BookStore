<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>

  table {
    width: 95%;
    max-width: 1200px;
    margin: 0 auto;
    border-collapse: collapse;
    font-family: 'Segoe UI', sans-serif;
    font-size: 14px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }

  thead {
    background-color: #black ;
    border-bottom: 2px solid #dee2e6;
  }

  th, td {
    padding: 12px 15px;
    text-align: center;
    border-bottom: 1px solid #ddd;
  }

  tbody tr:hover {
    background-color: #eef5ff;
  }

  .actions a {
    display: inline-block;
    padding: 6px 12px;
    margin: 2px;
    border-radius: 4px;
    font-weight: bold;
    text-decoration: none;
    color: white;
    font-size: 13px;
  }

  .actions a:first-child {
    background-color: #28a745;
  }

  .actions a:first-child:hover {
    background-color: #218838;
  }

  .actions a:last-child {
    background-color: #dc3545;
  }

  .actions a:last-child:hover {
    background-color: #c82333;
  }
</style>

<table>
  <thead>
    <tr>
      <th>ID</th>
      <th>프로필</th>
      <th>유저 ID</th>
      <th>이름</th>
      <th>이메일</th>
      <th>전화번호</th>
      <th>생성일자</th>
      <th>권한</th>
      <th>관리</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="account" items="${members}">
      <tr>
        <td>${account.id}</td>
         <!-- 이미지 -->
        <td>
          <img src="${pageContext.request.contextPath}/user/profileImage/${account.id}" 
               alt="프로필 이미지" style="width:50px; height:50px; border-radius:50%; object-fit:cover;">
        </td>
        <td>${account.user_id}</td>
        <td>${account.name}</td>
        <td>${account.email}</td>
        <td>${account.phone_number}</td>
        <td>${account.created_at}</td>
        <td>${account.role}</td>
        <td class="actions">
          <a href="${pageContext.request.contextPath}/manager/managereditform?id=${account.id}">수정</a>
          <a href="${pageContext.request.contextPath}/manager/managerdelete?id=${account.id}" 
             onclick="return confirm('정말로 이 회원을 삭제하시겠습니까?');">삭제</a>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>
<br>