<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <title>결제</title>
    <script src="https://js.tosspayments.com/v2/standard"></script>
    <style>
        body { font-family: sans-serif; 
        }
        h2 {
            font-family: "Apple SD Gothic Neo", "Noto Sans KR", sans-serif;
            max-width: 480px; /* 전체 콘텐츠 너비 통일 */
            margin: 4rem auto 2rem auto; /* 위쪽, 좌우, 아래쪽 여백 */
            text-align: center;
            font-size: 28px;
            font-weight: 600;
            color: #333d4b;
        }

        /* 주문 정보 요약 (h2 바로 다음에 오는 div) */
        h2 + div {
            font-family: "Apple SD Gothic Neo", "Noto Sans KR", sans-serif;
            max-width: 480px;
            margin: 1.5rem auto;
            padding: 25px;
            background-color: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e5e8eb;
            box-sizing: border-box;
        }
        
        /* 주문 정보 내부 p 태그 */
        h2 + div p {
            display: flex;
            justify-content: space-between;
            margin: 12px 0;
            font-size: 16px;
            color: #5a6775;
        }
        
        h2 + div p b {
            font-weight: 500;
            color: #333d4b;
        }

        /* 토스페이먼츠 위젯이 렌더링될 영역 */
        #payment-method, #agreement {
            max-width: 480px; /* 전체 너비 통일 */
            margin: 25px auto;
            text-align: left;
        }

        /* 결제하기 버튼 */
        #payment-button {
            display: block; /* 너비를 100%로 설정하기 위해 block으로 변경 */
            width: 100%;
            max-width: 480px; /* 전체 너비 통일 */
            margin: 20px auto;
            margin-bottom: 50px;
            background-color: #0064ff;
            color: white;
            border: none;
            padding: 15px 20px;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s ease-in-out;
        }
        #payment-button:hover {
            background-color: #0053d1;
        }
    </style>
</head>
<body>
    <h2>결제</h2>

    <div>
      <p><b>상품명:</b> ${orderName}</p>
      <p><b>구매자명:</b> ${customerName}</p>
      <p><b>결제금액:</b> ${totalAmount}원</p>
    </div>

    <div id="payment-method"></div>

    <div id="agreement"></div>

    <button id="payment-button">결제하기</button>

    <script>
      // JavaScript 로직은 변경 없이 그대로 유지됩니다.
      main();
      console.log("1. main 호출");

      async function main() {
    	  console.log("2. main 호출됨");
        const orderId = "${orderId}";
        const orderName = "${orderName}";
        const customerName = "${customerName}";
        const totalAmount = ${totalAmount};

        // ✅ 테스트용 클라이언트 키
        const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
        const tossPayments = TossPayments(clientKey);

        // ✅ 비회원 결제 (고객키 불필요)
        const widgets = tossPayments.widgets({
          customerKey: customerName,
        });
        
        console.log("2. 위젯 인스턴스 생성 완료");

        // ✅ 결제 금액 설정
        await widgets.setAmount({
          currency: "KRW",
          value: totalAmount,
        });
        console.log("3. 결제 금액 설정 완료");

        // ✅ 결제 UI 렌더링
        await Promise.all([
          widgets.renderPaymentMethods({
            selector: "#payment-method",
            variantKey: "DEFAULT",
          }),
          widgets.renderAgreement({
            selector: "#agreement",
            variantKey: "AGREEMENT",
          }),
        ]);

        console.log("4. UI 렌더링 완료");

        // ✅ 결제 요청
        const button = document.getElementById("payment-button");
        console.log("5. 결제 버튼 확인:", button);
        button.addEventListener("click", async () => {
          try {
            await widgets.requestPayment({
              orderId,
              orderName,
              successUrl: window.location.origin + "/confirm-payment",
              failUrl: window.location.origin + "/purchase/fail",
              customerName,
            });
          } catch (error) {
            console.error("결제 요청 중 오류:", error);
            alert("결제가 취소되었거나 오류가 발생했습니다.");
          }
        });
      }
    </script>
</body>
</html>