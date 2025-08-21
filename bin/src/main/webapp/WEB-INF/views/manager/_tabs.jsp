<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="currentPath" value="${pageContext.request.requestURI}" />

<style>
  .tabs { margin: 0 auto 20px; max-width: 1200px; }
  .tabs ul { list-style: none; padding: 0; display: flex; border-bottom: 2px solid #ddd; }
  .tabs li { margin-right: 20px; }
  .tabs a {
    display: block; padding: 10px 18px; text-decoration: none; color: #555; font-weight: 600;
    border-bottom: 3px solid transparent; transition: all .3s ease;
  }
  .tabs li.active a, .tabs a:hover { color: #3498db; border-color: #3498db; }
</style>

<%-- URL 기반 자동 활성화 (activeTab 모델값이 있으면 그 값을 우선 적용) --%>
<c:set var="isSales"     value="${fn:contains(currentPath, '/manager/salesview')}" />
<c:set var="isBooklist"  value="${fn:contains(currentPath, '/manager/booklist')}" />
<c:set var="isMembers"   value="${fn:contains(currentPath, '/manager/managerview')}" />

<c:if test="${not empty activeTab}">
  <c:set var="isSales"     value="${activeTab == 'salesview'}" />
  <c:set var="isBooklist"  value="${activeTab == 'booklist'}" />
  <c:set var="isMembers"   value="${activeTab == 'managerview'}" />
 
</c:if>

<div class="tabs">
  <ul>
    <li class="${isSales ? 'active' : ''}">
      <a href="${pageContext.request.contextPath}/manager/salesview" id="tab-salesview">판매 현황</a>
    </li>
    <li class="${isBooklist ? 'active' : ''}">
      <a href="${pageContext.request.contextPath}/manager/booklist" id="tab-booklist">책 목록</a>
    </li>
    <li class="${isMembers ? 'active' : ''}">
      <a href="${pageContext.request.contextPath}/manager/managerview" id="tab-managerview">회원 목록</a>
    </li>
  </ul>
</div>
