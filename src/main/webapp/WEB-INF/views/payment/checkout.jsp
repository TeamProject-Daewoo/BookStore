<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8" />
    <title>토스페이먼츠 결제 페이지</title>
    <script src="https://js.tosspayments.com/v2/standard"></script>
    <style>
      body {
        font-family: "Noto Sans KR", sans-serif;
        padding: 40px;
        text-align: center;
      }
      #payment-method, #agreement {
        width: 360px;
        margin: 20px auto;
        text-align: left;
      }
      button {
        background-color: #0064ff;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 6px;
        font-size: 16px;
        cursor: pointer;
      }
    </style>
  </head>
  <body>
    <h2>토스페이먼츠 결제 테스트</h2>

    <div>
      <p><b>주문번호:</b> ${orderId}</p>
      <p><b>상품명:</b> ${orderName}</p>
      <p><b>구매자명:</b> ${customerName}</p>
      <p><b>결제금액:</b> ${totalAmount}원</p>
    </div>

    <!-- 결제 UI -->
    <div id="payment-method"></div>

    <!-- 이용약관 UI -->
    <div id="agreement"></div>

    <!-- 결제 버튼 -->
    <button id="payment-button">결제하기</button>

    <script>
      main();

      async function main() {
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

        // ✅ 결제 금액 설정
        await widgets.setAmount({
          currency: "KRW",
          value: totalAmount,
        });

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

        // ✅ 결제 요청
        const button = document.getElementById("payment-button");
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
