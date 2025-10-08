package purchase;

import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.util.Base64;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import cart.CookieService;
import data.Book;
import data.BookMapper;
import user.MemberMapper;

@Controller
public class WidgetController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Autowired
    private PurchaseService purchaseService;
    
    @Autowired
    private CookieService cookieService;
    
    @Autowired
    private MemberMapper memberMapper;
    
    @Autowired
    private BookMapper bookMapper;
    
    @RequestMapping("/payment")
    public String payment(Model model) {
    	model.addAttribute("page", "payment/checkout");
    	return "index";
    }

    @GetMapping("/confirm-payment")
    public String confirmPayment(
    		@RequestParam String paymentKey,
            @RequestParam String orderId,
            @RequestParam Long amount,
            RedirectAttributes redirectAttributes,
            Principal user,
            HttpServletResponse response, // 쿠키 삭제용
            HttpSession session
    ) {
        try {
        	
        	String sessionOrderId = (String) session.getAttribute("pendingOrderId");
            Delivery deliveryInfo = (Delivery) session.getAttribute("pendingDeliveryInfo");

            // ❗️ 2. 세션에 정보가 없거나, 토스로부터 받은 orderId와 일치하지 않으면 비정상적인 접근으로 처리
            if (sessionOrderId == null || deliveryInfo == null || !sessionOrderId.equals(orderId)) {
                redirectAttributes.addFlashAttribute("errorMessage", "잘못된 결제 요청이거나 세션이 만료되었습니다.");
                return "redirect:/";
            }
            
            // 1. DB에서 'orderId'로 'PENDING' 상태의 주문 정보를 조회합니다.
        	List<Purchase> orderItems = purchaseService.findPendingOrderItemsByOrderId(orderId);
        	int memberId = getLoginedMemberId(user);

            // 2. 주문 정보 검증
            // 2-1. 주문 항목이 하나도 없는 경우
            if (orderItems == null || orderItems.isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "주문 정보를 찾을 수 없습니다.");
                return "redirect:/";
            }
            
            // 2-2. 주문자가 일치하는지 확인 (리스트의 첫 번째 항목으로 확인)
            if (orderItems.get(0).getMember_id() != memberId) {
                redirectAttributes.addFlashAttribute("errorMessage", "주문 정보에 접근할 권한이 없습니다.");
                return "redirect:/";
            }

            // 2-3. "DB에 저장된 데이터 기준"으로 실제 총액을 계산하여 금액 위변조 여부 검증
            long totalAmountFromDB = purchaseService.calculateTotalAmount(orderItems);
            if (totalAmountFromDB != amount) {
                redirectAttributes.addFlashAttribute("errorMessage", "결제 금액이 일치하지 않습니다. (위변조 시도 감지)");
                // ❗️결제 금액 불일치 시, 토스페이먼츠에 '결제 취소 API'를 호출하는 로직을 추가하는 것이 좋습니다.
                return "redirect:/purchase/checkout"; 
            }
            
            for (Purchase item : orderItems) {
                Book book = bookMapper.findById(item.getBook_id());
                if (book.getStock() < item.getQuantity()) {
                    redirectAttributes.addFlashAttribute("errorMessage", "결제하는 동안 " + book.getTitle() + " 상품의 재고가 소진되었습니다.");
                    // TODO: 이 경우 토스페이먼츠에 결제 취소 API를 바로 호출해주는 것이 좋습니다.
                    return "redirect:/purchase/fail";
                }
            }

            // 3. 토스페이먼츠 결제 승인 API 호출 (기존 코드를 여기에 통합)
            String widgetSecretKey = "test_gsk_docs_OaPz8L5KdmQXkzRz3y47BMw6";
            Base64.Encoder encoder = Base64.getEncoder();
            byte[] encodedBytes = encoder.encode((widgetSecretKey + ":").getBytes(StandardCharsets.UTF_8));
            String authorizations = "Basic " + new String(encodedBytes);

            URL url = new URL("https://api.tosspayments.com/v1/payments/confirm");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestProperty("Authorization", authorizations);
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestMethod("POST");
            connection.setDoOutput(true);

            JSONObject obj = new JSONObject();
            obj.put("paymentKey", paymentKey);
            obj.put("orderId", orderId);
            obj.put("amount", amount);

            OutputStream outputStream = connection.getOutputStream();
            outputStream.write(obj.toString().getBytes("UTF-8"));

            int code = connection.getResponseCode();
            boolean isSuccess = code == 200;
           

            // 4. API 호출 결과에 따른 최종 처리
            if (isSuccess) {
                // 성공 시: DB 주문 상태를 'COMPLETED'로 업데이트
            	purchaseService.completePurchase(orderId, paymentKey);
                
                // ❗️결제가 성공했으므로, 구매 유형(cart/direct)과 관계없이 장바구니 쿠키를 삭제합니다.
                // (직접 구매 시에는 어차피 쿠키가 없으므로 아무 영향이 없습니다.)
                cookieService.deleteCartCookie(response);

                purchaseService.saveOrUpdateDelivery(deliveryInfo);
                
                purchaseService.decreaseStockForOrder(orderItems);
                
                redirectAttributes.addFlashAttribute("successMessage", "결제가 성공적으로 완료되었습니다!");
                return "redirect:/purchase/success";
            } else {
                // 실패 시: 에러 메시지와 함께 실패 페이지 또는 다시 결제 페이지로
                JSONParser parser = new JSONParser();
                Reader reader = new InputStreamReader(connection.getErrorStream(), StandardCharsets.UTF_8);
                JSONObject jsonObject = (JSONObject) parser.parse(reader);
                redirectAttributes.addFlashAttribute("errorMessage", "결제 승인 실패: " + jsonObject.get("message"));
                return "redirect:/purchase/fail"; // 실패 페이지로 이동
            }

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "결제 처리 중 오류가 발생했습니다: " + e.getMessage());
            System.out.println("@@@@@@@결제오류@@@@@@@");
            System.out.println(e.getMessage());
            return null;
        }
    }

    private int getLoginedMemberId(Principal user) {
    	return memberMapper.findByUserId(user.getName()).getId();
    }
}