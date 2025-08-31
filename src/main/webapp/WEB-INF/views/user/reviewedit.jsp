<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>
<div class="book-review-container" style="max-width: 960px; margin: 40px auto; padding: 20px; 
     background-color: #fff; border-radius: 16px; box-shadow: 0 6px 18px rgba(0,0,0,0.08);">

    <h3 style="margin-bottom: 20px;">✏️ 리뷰 수정</h3>

    <form action="/user/reviewEdit" method="post" style="margin-bottom: 30px;">
        <input type="hidden" name="reviewId" value="${review.reviewId}" />
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

        <!-- 평점 선택 -->
        <label for="editRating"><strong>평점:</strong></label>
        <select name="rating" id="editRating" style="margin-left: 8px; padding: 4px 8px; border-radius: 6px;">
                   <option value="5">★★★★★</option>
                   <option value="4">★★★★</option>
                   <option value="3">★★★</option>
                   <option value="2">★★</option>
                   <option value="1">★</option>
        </select>

        <!-- 내용 수정 -->
        <div style="margin-top: 12px;">
            <textarea name="content" rows="4" placeholder="리뷰를 수정해주세요."
                      style="width: 100%; padding: 8px; border-radius: 8px; border: 1px solid #ccc;" required>${review.content}</textarea>
        </div>

        <!-- 버튼 -->
        <div style="margin-top: 12px; display: flex; gap: 8px;">
            <button type="submit" class="btn btn-success" style="width: 120px;">수정 완료</button>
            <button type="button" onclick="history.back()" class="btn btn-warning" style="width: 120px;">취소</button>
        </div>
    </form>
</div>
</body>
</html>