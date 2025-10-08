<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>베스트셀러</title>
    <style>
        /* 레이아웃 컨테이너 */
        body {
      font-family: sans-serif;
        }

        .bestseller-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }

        .bestseller-container h2 {
            text-align: center;
            font-size: 2em;
            margin-bottom: 30px;
            font-family: 'Noto Sans KR', sans-serif;
        }

        /* 탭 스타일 */
        .tabs {
            display: flex;
            margin-bottom: 20px;
            border-bottom: 2px solid #ccc;
        }
        .tab {
            padding: 10px 20px;
            cursor: pointer;
            font-weight: bold;
            border: 1px solid #ccc;
            border-bottom: none;
            background-color: #f9f9f9;
            margin-right: 5px;
            border-radius: 5px 5px 0 0;
        }
        .tab.active {
            background-color: #ffffff;
            border-bottom: 2px solid white;
        }

        /* 베스트셀러 리스트 스타일 */
        .bestseller-list { display: flex; flex-direction: column; gap: 15px; }
        .bestseller-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 5px;
            background-color: #fafafa;
        }

        /* 왼쪽 정보 섹션 */
        .bestseller-left {
            display: flex;
            align-items: center;
        }
        /* 링크에 밑줄 없애기 */
        .bestseller-left a {
            text-decoration: none;
            color: inherit;
            display: flex;
            align-items: center;
        }

        /* 랭크 및 랭크 변화 */
        .bestseller-rank-wrapper {
            position: relative;
            width: 50px;
            text-align: center;
        }
        .bestseller-rank {
            font-size: 1.5em;
            font-weight: bold;
        }
        .rank-change-badge {
            position: absolute;
            top: -12px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 0.75em;
            font-weight: bold;
            color: #ff4d4d;
        }
        .rank-change-badge.down {
            color: #4d79ff;
        }

        /* 책 정보 */
        .bestseller-img { width: 70px; height: 100px; object-fit: cover; margin-right: 15px; }
        .bestseller-info { display: flex; flex-direction: column; gap: 5px; }
        .bestseller-title { font-weight: bold; font-size: 1.1em; }
        .bestseller-author { font-size: 0.9em; color: #555; }
        .bestseller-sales { font-size: 0.9em; color: #888; }

        /* 버튼 영역 */
        .bestseller-buttons {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .bestseller-buttons button {
            padding: 5px 10px;
            border: none;
            border-radius: 4px;
            font-size: 0.9em;
            cursor: pointer;
        }
        .btn-cart {
            background-color: #ffcc00;
            color: #333;
        }
        .btn-buy {
            background-color: #4CAF50;
            color: white;
        }

        /* 탭 콘텐츠 숨김/표시 */
        .tab-content { display: none; }
        .tab-content.active { display: block; }
    </style>
</head>
<body>
    <div class="bestseller-container">
        <h2>베스트셀러</h2>

        <div class="tabs">
            <div class="tab active" onclick="showTab('today', event)">금일 베스트셀러</div>
            <div class="tab" onclick="showTab('week', event)">주간 베스트셀러</div>
            <div class="tab" onclick="showTab('month', event)">월간 베스트셀러</div>
        </div>

        <div id="tab-today" class="tab-content active">
            <div class="bestseller-list">
                <c:forEach var="b" items="${todayBestSellers}">
                    <div class="bestseller-item">
                        <div class="bestseller-left">
                            <a href="${pageContext.request.contextPath}/user/bookdetail?isbn=${b.isbn}">
                                <div class="bestseller-rank-wrapper">
                                    <div class="rank-change-badge ${b.rankChange < 0 ? 'down' : ''}">
                                        <c:choose>
                                            <c:when test="${b.rankChange > 0}">▲${b.rankChange}</c:when>
                                            <c:when test="${b.rankChange < 0}">▼${-b.rankChange}</c:when>
                                            <c:otherwise>NEW</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="bestseller-rank">${b.rank}</div>
                                </div>
                                <c:if test="${not empty b.img}">
                                    <c:choose>
                                        <c:when test="${b.img.startsWith('http')}">
                                            <img src="${b.img}" alt="${b.title}" class="bestseller-img"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/resources/images/${b.img}" alt="${b.title}" class="bestseller-img"/>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <div class="bestseller-info">
                                    <div class="bestseller-title">${b.title}</div>
                                    <div class="bestseller-author">${b.author}</div>
                                    <div class="bestseller-sales">판매량: ${b.totalSales}</div>
                                </div>
                            </a>
                        </div>
                        <div class="bestseller-buttons">
                            <form action="${pageContext.request.contextPath}/cart/add" method="post">
                                <input type="hidden" name="bookIsbn" value="${b.isbn}" />
                                <input type="hidden" name="quantity" value="1" />
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="btn-cart">장바구니</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/purchase/direct" method="post">
                                <input type="hidden" name="bookIsbn" value="${b.isbn}" />
                                <input type="hidden" name="quantity" value="1" />
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="btn-buy">바로구매</button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div id="tab-week" class="tab-content">
            <div class="bestseller-list">
                <c:forEach var="b" items="${weeklyBestSellers}">
                    <div class="bestseller-item">
                        <div class="bestseller-left">
                            <a href="${pageContext.request.contextPath}/user/bookdetail?isbn=${b.isbn}">
                                <div class="bestseller-rank-wrapper">
                                    <div class="rank-change-badge ${b.rankChange < 0 ? 'down' : ''}">
                                        <c:choose>
                                            <c:when test="${b.rankChange > 0}">▲${b.rankChange}</c:when>
                                            <c:when test="${b.rankChange < 0}">▼${-b.rankChange}</c:when>
                                            <c:otherwise>NEW</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="bestseller-rank">${b.rank}</div>
                                </div>
                                <c:if test="${not empty b.img}">
                                    <c:choose>
                                        <c:when test="${b.img.startsWith('http')}">
                                            <img src="${b.img}" alt="${b.title}" class="bestseller-img"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/resources/images/${b.img}" alt="${b.title}" class="bestseller-img"/>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <div class="bestseller-info">
                                    <div class="bestseller-title">${b.title}</div>
                                    <div class="bestseller-author">${b.author}</div>
                                    <div class="bestseller-sales">판매량: ${b.totalSales}</div>
                                </div>
                            </a>
                        </div>
                        <div class="bestseller-buttons">
                            <form action="${pageContext.request.contextPath}/cart/add" method="post">
                                <input type="hidden" name="bookIsbn" value="${b.isbn}" />
                                <input type="hidden" name="quantity" value="1" />
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="btn-cart">장바구니</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/purchase/direct" method="post">
                                <input type="hidden" name="bookIsbn" value="${b.isbn}" />
                                <input type="hidden" name="quantity" value="1" />
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="btn-buy">바로구매</button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div id="tab-month" class="tab-content">
            <div class="bestseller-list">
                <c:forEach var="b" items="${monthlyBestSellers}">
                    <div class="bestseller-item">
                        <div class="bestseller-left">
                            <a href="${pageContext.request.contextPath}/user/bookdetail?isbn=${b.isbn}">
                                <div class="bestseller-rank-wrapper">
                                    <div class="rank-change-badge ${b.rankChange < 0 ? 'down' : ''}">
                                        <c:choose>
                                            <c:when test="${b.rankChange > 0}">▲${b.rankChange}</c:when>
                                            <c:when test="${b.rankChange < 0}">▼${-b.rankChange}</c:when>
                                            <c:otherwise>NEW</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="bestseller-rank">${b.rank}</div>
                                </div>
                                <c:if test="${not empty b.img}">
                                    <c:choose>
                                        <c:when test="${b.img.startsWith('http')}">
                                            <img src="${b.img}" alt="${b.title}" class="bestseller-img"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/resources/images/${b.img}" alt="${b.title}" class="bestseller-img"/>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <div class="bestseller-info">
                                    <div class="bestseller-title">${b.title}</div>
                                    <div class="bestseller-author">${b.author}</div>
                                    <div class="bestseller-sales">판매량: ${b.totalSales}</div>
                                </div>
                            </a>
                        </div>
                        <div class="bestseller-buttons">
                            <form action="${pageContext.request.contextPath}/cart/add" method="post">
                                <input type="hidden" name="bookIsbn" value="${b.isbn}" />
                                <input type="hidden" name="quantity" value="1" />
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="btn-cart">장바구니</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/purchase/direct" method="post">
                                <input type="hidden" name="bookIsbn" value="${b.isbn}" />
                                <input type="hidden" name="quantity" value="1" />
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="btn-buy">바로구매</button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <script>
    function showTab(tab, event) {
        // 모든 탭 숨김
        document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
        document.querySelectorAll('.tab').forEach(el => el.classList.remove('active'));

        // 현재 탭 표시
        document.getElementById('tab-' + tab).classList.add('active');
        event.target.classList.add('active');
    }
    </script>
</body>
</html>