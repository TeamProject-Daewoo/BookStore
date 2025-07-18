# BookStore

## Manager
### 도서 관리 기능 (BookAdmin과 동일)

+ GET /insertform: 도서 등록 폼으로 이동

+ POST /insert: 도서 등록

+ GET /bookeditform?id={id}: 도서 수정 폼으로 이동

+ POST /bookedit: 도서 정보 수정

+ GET /bookdelete?id={id}: 도서 삭제

+ GET /booklist: 도서 목록 조회

### 구매 내역 조회 (PaymentAdmin과 유사)

+ REQUEST /purchaselist: 결제 내역 목록 조회

### 관리자(회원) 관리

+ GET /managerview: 회원 목록 조회

+ GET /managereditform?id={id}: 회원 수정 폼으로 이동

+ POST /manageredit: 회원 정보 수정

+ GET /managerdelete?id={id}: 회원 삭제


## User
### 도서 기능

GET /booklist: 도서 목록 조회 (검색어 포함 가능)

GET /bookdetail?id={id}: 도서 상세 정보 조회

### 회원 관련 기능

+ GET /registerform: 사용자 회원가입 폼

+ POST /register: 사용자 회원가입 처리

+ GET /adminregisterform: 관리자 회원가입 폼

+ POST /adminregister: 관리자 회원가입 처리

### 로그인/로그아웃

+ GET /loginform: 로그인 폼

+ GET /login?error=true: 로그인 실패 시 메시지 포함

+ GET /logout: 로그아웃 처리 후 도서 목록으로 이동

### 결제 관련

+ GET /purchase: 구매 페이지 이동

+ GET /mypurchaselist: 현재 로그인한 사용자의 구매 내역 조회


## Cart
+ POST /add : 장바구니에 상품 추가 (bookId, quantity 포함)

+ GET / : 로그인한 사용자 장바구니 목록 조회

+ POST /updateQuantity : 장바구니 상품 수량 변경 (bookId, quantity 포함)

+ POST /remove : 장바구니에서 상품 삭제 (bookId 포함)




## Purchase
+ POST /direct : 도서 상세/목록에서 바로 구매 요청 (bookId, quantity 포함) → 결제 페이지로 이동

+ POST /cart : 장바구니 전체 상품 구매 준비 → 결제 페이지로 이동

+ GET /checkout : 결제 페이지 조회 (type: direct 또는 cart, bookId 및 quantity 포함 가능)

+ POST /confirm : 결제 확정 처리 (직접 구매 또는 장바구니 구매)

+ GET /success : 결제 성공 페이지 표시
