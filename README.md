# 📖 책숲 BookForest

> **도서 판매 웹사이트**

---

## 🚀 1. 프로젝트 소개
사용자와 관리자가 모두 이용할 수 있는 종합 도서 판매 플랫폼입니다. 사용자는 도서 검색, 상세 조회, 장바구니 담기, 도서 구매, 리뷰 작성 등의 기능을 이용할 수 있습니다. 관리자는 도서 등록·수정·삭제, 재고 관리, 주문 내역 관리, 사용자 관리 등 플랫폼 운영에 필요한 다양한 관리 기능을 제공받습니다.

---

## ✨ 2. 주요 기능

### 👤 User (사용자)
- **도서 조회 및 검색**: 전체 도서 목록 확인 및 키워드 검색 기능
- **회원가입 및 마이페이지**: 일반 사용자 및 관리자 가입, 내 정보 수정
- **장바구니 및 주문**: 상품 담기, 수량 변경, 직접 구매 및 장바구니 결제 기능
- **게시판 및 리뷰**: 게시글 작성 및 도서 리뷰 관리

### 🛠 Manager (관리자)
- **도서 관리**: 신규 도서 등록, 정보 수정 및 삭제
- **회원 관리**: 전체 회원 목록 조회 및 권한/정보 관리
- **현황 파악**: 도서 판매 현황 확인

---

## 🛠 3. 기술 스택

### Backend
- **Language**: Java 1.8
- **Framework**: Spring Framework 5.3.33 / Spring Web MVC 5.3.8
- **Security**: Spring Security 5.8.10
- **ORM/Library**: MyBatis 3.5.19, Lombok, Jackson, Jsoup
- **Database**: MySQL 8.0.33
- **Connection Pool**: HikariCP 6.3.0

### Frontend
- **View**: JSP (JSTL 1.2)
- **Framework**: Vue.js (상세 버전 미기입)

### Infrastructure & DevOps
- **Cloud**: AWS (Elastic Beanstalk, S3)
- **CI/CD**: GitHub Actions
- **Build Tool**: Maven

---

## 📂 4. 프로젝트 구조

```text
src
├── main
│   ├── java
│   │   ├── bestseller      # 베스트셀러 데이터 처리 및 뷰 관리
│   │   ├── board           # 게시판 CRUD 로직
│   │   ├── cart            # 장바구니 및 쿠키 서비스
│   │   ├── category        # 도서 카테고리 분류
│   │   ├── login           # Spring Security 기반 인증/인가 설정
│   │   ├── purchase        # 결제 시스템 및 주문 스케줄러
│   │   ├── restapi         # 비동기 처리를 위한 REST 컨트롤러
│   │   └── user            # 사용자 관리 및 네이버 도서 API 연동
│   ├── resources           # DB 접속 정보 및 API 키 설정 (properties)
│   └── webapp
│       └── WEB-INF
│           ├── views       # JSP 페이지 구성 (Board, Manager, User 등)
│           └── web.xml     # 서블릿 및 필터 설정

## 📂 5. 엔드포인트 목록
## 기본페이지
- `GET /`  
  도서 목록 페이지로 이동(user/booklist)

##  Manager 기능

### 도서 관리 (BookAdmin과 동일)
- `GET /insertform`  
  도서 등록 폼으로 이동  
- `POST /insert`  
  도서 등록 처리  
- `GET /bookeditform?id={id}`  
  도서 수정 폼으로 이동  
- `POST /bookedit`  
  도서 정보 수정 처리  
- `GET /bookdelete?id={id}`  
  도서 삭제 처리  
- `GET /booklist`  
  도서 목록 조회  
- `GET /salesview`
  도서 판매 현황

### 관리자(회원) 관리
- `GET /managerview`  
  회원 목록 조회  
- `GET /managereditform?id={id}`  
  회원 수정 폼으로 이동  
- `POST /manageredit`  
  회원 정보 수정 처리  
- `GET /managerdelete?id={id}`  
  회원 삭제 처리  

---

##  User 기능

### 도서 기능
- `GET /booklist`  
  도서 목록 조회 (검색어 포함)  
- `GET /bookdetail?id={id}`  
  도서 상세 정보 조회  

### 회원 관련 기능
- `GET /registerform`  
  사용자 회원가입 폼  
- `POST /register`  
  사용자 회원가입 처리  
- `GET /adminregisterform`  
  관리자 회원가입 폼  
- `POST /adminregister`  
  관리자 회원가입 처리  
- `GET /mypage/{username}`  
  내 정보  
- `GET /checkPasswordform`  
  내 정보 수정 시 비밀번호 확인 폼  
- `GET /editform/{id}`  
  내 정보 수정 폼  

### 로그인 / 로그아웃
- `GET /loginform`  
  로그인 폼  
- `GET /login?error=true`  
  로그인 실패 시 메시지 포함  
- `GET /logout`  
  로그아웃 처리 후 도서 목록으로 이동  

### 결제 관련
- `GET /purchase`  
  구매 페이지 이동  
- `GET /mypurchaselist`  
  현재 로그인한 사용자의 구매 내역 조회  

---

##  Cart 기능

- `POST /add`  
  장바구니에 상품 추가 (`bookId`, `quantity` 포함)  
- `GET /`  
  로그인한 사용자 장바구니 목록 조회  
- `POST /updateQuantity`  
  장바구니 상품 수량 변경 (`bookId`, `quantity` 포함)  
- `POST /remove`  
  장바구니에서 상품 삭제 (`bookId` 포함)  

---

##  Purchase 기능

- `POST /direct`  
  도서 상세/목록에서 바로 구매 요청 (`bookId`, `quantity` 포함) → 결제 페이지 이동  
- `POST /cart`  
  장바구니 전체 상품 구매 준비 → 결제 페이지 이동  
- `GET /checkout`  
  결제 페이지 조회 (`type`: direct 또는 cart, `bookId` 및 `quantity` 포함 가능)  
- `POST /confirm`  
  결제 확정 처리 (직접 구매 또는 장바구니 구매)  
- `GET /success`  
  결제 성공 페이지 표시  

---

##   기능

- `POST /direct`  
  도서 상세/목록에서 바로 구매 요청 (`bookId`, `quantity` 포함) → 결제 페이지 이동  
- `POST /cart`  
  장바구니 전체 상품 구매 준비 → 결제 페이지 이동  
- `GET /checkout`  
  결제 페이지 조회 (`type`: direct 또는 cart, `bookId` 및 `quantity` 포함 가능)  
- `POST /confirm`  
  결제 확정 처리 (직접 구매 또는 장바구니 구매)  
- `GET /success`  
  결제 성공 페이지 표시  

---

## 카테고리

- `GET /category/{category}`  
  카테고리에 따른 책 목록  
  
---

## 게시판

- `GET /main`  
  게시글 목록(자신이 작성한 글은 별 표시)  

- `GET /write`  
  게시글 작성(작성자는 아이디로 자동 기입)  
  
- `POST /write`  
  게시글 작성 처리   

- `GET /view?id={id}`  
  게시글 상세보기(자신이 작성한 게시글만 수정,삭제 가능 단, 관리자는 모든 글 삭제 가능)  

- `POST /edit?id={id}`  
  게시글 수정 폼  

- `POST /edit`  
  게시글 수정 처리  

- `POST /delete`  
  게시글 삭제 처리  
  

---


##  Manager 기능

### 도서 관리 (BookAdmin과 동일)
- `GET /insertform`  
  도서 등록 폼으로 이동  
- `POST /insert`  
  도서 등록 처리  
- `GET /bookeditform?id={id}`  
  도서 수정 폼으로 이동  
- `POST /bookedit`  
  도서 정보 수정 처리  
- `GET /bookdelete?id={id}`  
  도서 삭제 처리  
- `GET /booklist`  
  도서 목록 조회  
- `GET /salesview`
  도서 판매 현황

### 관리자(회원) 관리
- `GET /managerview`  
  회원 목록 조회  
- `GET /managereditform?id={id}`  
  회원 수정 폼으로 이동  
- `POST /manageredit`  
  회원 정보 수정 처리  
- `GET /managerdelete?id={id}`  
  회원 삭제 처리  

---

##  User 기능

### 도서 기능
- `GET /booklist`  
  도서 목록 조회 (검색어 포함)  
- `GET /bookdetail?id={id}`  
  도서 상세 정보 조회  

### 회원 관련 기능
- `GET /registerform`  
  사용자 회원가입 폼  
- `POST /register`  
  사용자 회원가입 처리  
- `GET /adminregisterform`  
  관리자 회원가입 폼  
- `POST /adminregister`  
  관리자 회원가입 처리  
- `GET /mypage/{username}`  
  내 정보  
- `GET /checkPasswordform`  
  내 정보 수정 시 비밀번호 확인 폼  
- `GET /editform/{id}`  
  내 정보 수정 폼  

### 로그인 / 로그아웃
- `GET /loginform`  
  로그인 폼  
- `GET /login?error=true`  
  로그인 실패 시 메시지 포함  
- `GET /logout`  
  로그아웃 처리 후 도서 목록으로 이동  

### 결제 관련
- `GET /purchase`  
  구매 페이지 이동  
- `GET /mypurchaselist`  
  현재 로그인한 사용자의 구매 내역 조회  

---

##  Cart 기능

- `POST /add`  
  장바구니에 상품 추가 (`bookId`, `quantity` 포함)  
- `GET /`  
  로그인한 사용자 장바구니 목록 조회  
- `POST /updateQuantity`  
  장바구니 상품 수량 변경 (`bookId`, `quantity` 포함)  
- `POST /remove`  
  장바구니에서 상품 삭제 (`bookId` 포함)  

---

##  Purchase 기능

- `POST /direct`  
  도서 상세/목록에서 바로 구매 요청 (`bookId`, `quantity` 포함) → 결제 페이지 이동  
- `POST /cart`  
  장바구니 전체 상품 구매 준비 → 결제 페이지 이동  
- `GET /checkout`  
  결제 페이지 조회 (`type`: direct 또는 cart, `bookId` 및 `quantity` 포함 가능)  
- `POST /confirm`  
  결제 확정 처리 (직접 구매 또는 장바구니 구매)  
- `GET /success`  
  결제 성공 페이지 표시  

---

##   기능

- `POST /direct`  
  도서 상세/목록에서 바로 구매 요청 (`bookId`, `quantity` 포함) → 결제 페이지 이동  
- `POST /cart`  
  장바구니 전체 상품 구매 준비 → 결제 페이지 이동  
- `GET /checkout`  
  결제 페이지 조회 (`type`: direct 또는 cart, `bookId` 및 `quantity` 포함 가능)  
- `POST /confirm`  
  결제 확정 처리 (직접 구매 또는 장바구니 구매)  
- `GET /success`  
  결제 성공 페이지 표시  

---

## 카테고리

- `GET /category/{category}`  
  카테고리에 따른 책 목록  
  
---

## 게시판

- `GET /main`  
  게시글 목록(자신이 작성한 글은 별 표시)  

- `GET /write`  
  게시글 작성(작성자는 아이디로 자동 기입)  
  
- `POST /write`  
  게시글 작성 처리   

- `GET /view?id={id}`  
  게시글 상세보기(자신이 작성한 게시글만 수정,삭제 가능 단, 관리자는 모든 글 삭제 가능)  

- `POST /edit?id={id}`  
  게시글 수정 폼  

- `POST /edit`  
  게시글 수정 처리  

- `POST /delete`  
  게시글 삭제 처리  
  
