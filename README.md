# BookStore 프로젝트

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
  
 
