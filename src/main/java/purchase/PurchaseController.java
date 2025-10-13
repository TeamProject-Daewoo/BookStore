package purchase;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import bestseller.BestsellerService;
import cart.CartItem;
import cart.CartMapper;
import cart.CartService;
import cart.CookieService;
import data.Book;
import data.BookMapper;
import user.MemberMapper;
import user.UserService; // <<-- UserService 임포트 추가

@Controller
@RequestMapping("/purchase")
public class PurchaseController {

    @Autowired
    private PurchaseService purchaseService;
    
    // <<-- BookMapper 대신 UserService를 사용하도록 변경 -->>
    @Autowired
    private UserService userService;

    @Autowired
    private CartService cartService;
    
    @Autowired
    private CookieService cookieService;
    
    @Autowired
    private MemberMapper memberMapper;
    
    @Autowired
    private CartMapper cartMapper;
    
    @Autowired
    private BookMapper bookMapper;
    
    @Autowired
    private BestsellerService bestsellerService;

    private int getLoginedMemberId(Principal user) {
    	return memberMapper.findByUserId(user.getName()).getId();
    }

    // <<-- 1. '바로 구매' 메서드 수정 -->>
    @PostMapping("/direct")
    // int bookId 대신 String bookIsbn을 받습니다.
    public String directPurchase(@RequestParam("bookIsbn") String bookIsbn,
                                 @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                                 RedirectAttributes redirectAttributes) {
    	try {
            // 1. RedirectAttributes에 파라미터를 추가합니다.
            CheckoutRequestDto checkoutDto = new CheckoutRequestDto();
            checkoutDto.setType("direct");
            checkoutDto.setBookIsbn(bookIsbn);
            checkoutDto.setQuantity(quantity);
            
            redirectAttributes.addFlashAttribute("checkoutRequestDto", checkoutDto);

            // 2. URL 경로만 깔끔하게 지정합니다.
            return "redirect:/purchase/checkout";

        } catch (IllegalArgumentException e) {
            // FlashAttribute는 URL에 보이지 않는 일회성 메시지 전달에 사용됩니다. (잘 사용하고 계십니다)
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());

            // 에러 발생 시에도 addAttribute를 사용하면 코드가 일관성 있어집니다.
            redirectAttributes.addFlashAttribute("isbn", bookIsbn);
            return "redirect:/user/bookdetail";
        }
    }

    // 장바구니 구매는 bookId/Isbn을 직접 다루지 않으므로 기존 코드 유지
    @PostMapping("/cart")
    public String cartPurchase(RedirectAttributes redirectAttributes) {
        try {
            redirectAttributes.addFlashAttribute("successMessage", "Proceeding to checkout with cart items.");
            return "redirect:/purchase/checkout?type=cart";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error preparing cart for purchase: " + e.getMessage());
            return "redirect:/cart";
        }
    }

    // <<-- 2. '결제 페이지' 메서드 수정 -->>
    @GetMapping("/checkout")
    public String checkout(@ModelAttribute CheckoutRequestDto checkoutDto,
                           Principal user,
                           Model model,
                           RedirectAttributes redirectAttributes,
                           HttpServletRequest request
    		) {
    	
    	String type = checkoutDto.getType();
    	String bookIsbn = checkoutDto.getBookIsbn();
    	Integer quantity = checkoutDto.getQuantity();
    	String orderName = "";
    	
        int memberId = getLoginedMemberId(user);

        List<CartItem> itemsToPurchase = null;
        int totalAmount = 0;

        if ("direct".equals(type) && bookIsbn != null && quantity != null) {
            // bookMapper.findById 대신 userService.getBookByIsbn을 사용합니다.
            // 이 메서드는 책이 DB에 없으면 API로 가져와 저장까지 해줍니다.
            Book book = userService.getBookByIsbn(bookIsbn); 
            if (book == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Book not found for direct purchase.");
                return "redirect:/user/booklist";
            }
            CartItem directItem = new CartItem(book, quantity);
            itemsToPurchase = new ArrayList<>(Collections.singletonList(directItem));
            
            totalAmount = directItem.getItemTotal();
            
            if (!itemsToPurchase.isEmpty()) {
                orderName = itemsToPurchase.get(0).getBook().getTitle();
            }
            
        } else if ("cart".equals(type)) {
        	
        	List<CartItem> cartItems = new ArrayList<>();

            // CookieService를 통해 쿠키 읽기
            Map<String, Integer> cartMap = cookieService.readCartCookie(request);

            for (Map.Entry<String, Integer> entry : cartMap.entrySet()) {
                String isbn = entry.getKey();
                int cookie_quantity = entry.getValue();

                // isbn으로 DB에서 Book 조회
                Book book = bookMapper.findByIsbn(isbn);
                
                if (book != null) {
                    cartItems.add(new CartItem(book, cookie_quantity));
                }
            }
            
            itemsToPurchase = cartItems;
            
            totalAmount = cartItems.stream().mapToInt(CartItem::getItemTotal).sum();
            
            if (!itemsToPurchase.isEmpty()) {
                orderName = itemsToPurchase.get(0).getBook().getTitle();
                if (itemsToPurchase.size() > 1) {
                    orderName += " 외 " + (itemsToPurchase.size() - 1) + "건";
                }
            }
            
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid purchase type or missing parameters.");
            return "redirect:/user/booklist";
        }

        if (itemsToPurchase == null || itemsToPurchase.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "No items to purchase.");
            return "redirect:/user/booklist";
        }
        
        String orderId = UUID.randomUUID().toString();

        String recentOrderId = purchaseService.getMostRecentOrderIdByMemberId(memberId);
        
        Delivery delivery = null;
        if (recentOrderId != null) {
            delivery = purchaseService.getDeliveryInfoByOrderId(recentOrderId);
        }
        
        model.addAttribute("delivery", delivery);
        model.addAttribute("itemsToPurchase", itemsToPurchase);
        model.addAttribute("totalAmount", totalAmount);
        model.addAttribute("purchaseType", type);
        model.addAttribute("page", "/user/purchase");
        return "index";
    }
    
    @GetMapping("/payment")
    public String paymentPage(
            // checkout.jsp의 form에서 넘어오는 모든 데이터를 @RequestParam으로 받습니다.
            @RequestParam String purchaseType,
            @RequestParam(required = false) String bookIsbn,
            @RequestParam(required = false) Integer quantity,
            @RequestParam String receiverName,
            @RequestParam String address,
            @RequestParam String phoneNumber,
            @RequestParam(required = false) String deliveryMessage,
            
            Principal user,
            Model model,
            RedirectAttributes redirectAttributes,
            HttpServletRequest request,
            HttpSession session
    ) {
        try {
            int memberId = getLoginedMemberId(user);
            List<CartItem> itemsToPurchase = null;
            int totalAmount = 0;
            String orderName = "";

            if ("direct".equals(purchaseType) && bookIsbn != null && quantity != null) {
                // bookMapper.findById 대신 userService.getBookByIsbn을 사용합니다.
                // 이 메서드는 책이 DB에 없으면 API로 가져와 저장까지 해줍니다.
                Book book = userService.getBookByIsbn(bookIsbn);
                if (book == null) {
                    redirectAttributes.addFlashAttribute("errorMessage", "Book not found for direct purchase.");
                    return "redirect:/user/booklist";
                }
                CartItem directItem = new CartItem(book, quantity);
                itemsToPurchase = new ArrayList<>(Collections.singletonList(directItem));
                
                totalAmount = directItem.getItemTotal();
                
                if (!itemsToPurchase.isEmpty()) {
                    orderName = itemsToPurchase.get(0).getBook().getTitle();
                }
                
            } //else if ("cart".equals(purchaseType)) {
//            	
//            	List<CartItem> cartItems = new ArrayList<>();
//
//                // CookieService를 통해 쿠키 읽기
//                Map<String, Integer> cartMap = cookieService.readCartCookie(request);
//                
//             // --- ❗️ 디버깅 코드 추가 ---
//                System.out.println("=========================================");
//                System.out.println("읽어온 장바구니 쿠키 내용: " + cartMap);
//                System.out.println("=========================================");
//
//                for (Map.Entry<String, Integer> entry : cartMap.entrySet()) {
//                    String isbn = entry.getKey();
//                    int cookie_quantity = entry.getValue();
//
//                    // isbn으로 DB에서 Book 조회
//                    Book book = bookMapper.findByIsbn(isbn);
//                    
//                    if (book != null) {
//                        cartItems.add(new CartItem(book, cookie_quantity));
//                    }
//                }
//                
//                itemsToPurchase = cartItems;
//                
//                totalAmount = cartItems.stream().mapToInt(CartItem::getItemTotal).sum();
//                
//                if (!itemsToPurchase.isEmpty()) {
//                    orderName = itemsToPurchase.get(0).getBook().getTitle();
//                    if (itemsToPurchase.size() > 1) {
//                        orderName += " 외 " + (itemsToPurchase.size() - 1) + "건";
//                    }
//                }
//                
//            } else {
//                throw new IllegalArgumentException("Invalid purchase type");
//            }
//            
//            // 2. PENDING 상태의 주문을 생성합니다.
            String orderId = UUID.randomUUID().toString();
//            purchaseService.createPendingOrder(memberId, orderId, itemsToPurchase);
//            
            Delivery deliveryInfo = new Delivery(memberId, orderId, receiverName, address, phoneNumber, deliveryMessage);
            session.setAttribute("pendingOrderId", orderId);
            session.setAttribute("pendingDeliveryInfo", deliveryInfo);

            // 4. 토스 결제 UI가 있는 JSP 페이지로 필요한 정보를 전달합니다.
            model.addAttribute("orderId", orderId);
            model.addAttribute("orderName", orderName);
            model.addAttribute("customerName", user.getName());
//            model.addAttribute("totalAmount", totalAmount);
            model.addAttribute("page", "/payment/checkout");
            // 5. 'payment.jsp' 뷰를 렌더링합니다.
            return "index";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "결제 진행 중 오류가 발생했습니다.");
            return "redirect:/purchase/checkout"; // 오류 발생 시 이전 페이지로
        }
    }

    // <<-- 3. '구매 확정' 메서드 수정 -->>
//    @PostMapping("/confirm")
//    public String confirmPurchase(@RequestParam("purchaseType") String purchaseType,
//                                  // Integer bookId 대신 String bookIsbn을 받습니다.
//                                  @RequestParam(value = "bookIsbn", required = false) String bookIsbn,
//                                  @RequestParam(value = "quantity", required = false) Integer quantity,
//                                  @RequestParam("receiverName") String receiverName,
//                                  @RequestParam("address") String address,
//                                  @RequestParam("phoneNumber") String phoneNumber,
//                                  @RequestParam(value = "deliveryMessage", required = false) String deliveryMessage,
//                                  Principal user,
//                                  RedirectAttributes redirectAttributes,
//                                  HttpServletRequest request,
//                                  HttpServletResponse response,
//                                  Principal principal
//    		) {
//        int memberId = getLoginedMemberId(user);
//        try {
//        	
//        	int orderId;
//        	
//        	if ("direct".equals(purchaseType) && bookIsbn != null && quantity != null) {
//                // 구매 확정 시에도 isbn으로 책 정보를 가져옵니다.
//                Book book = userService.getBookByIsbn(bookIsbn);
//                if(book == null || book.getId() == null) {
//                    throw new IllegalArgumentException("Book not found or could not be saved.");
//                }
//                // DB에 저장된 book의 id를 사용하여 구매를 진행합니다.
//        	    orderId = purchaseService.directPurchase(memberId, book.getId(), quantity);
//        	    //DB -> 쿠키 삭제
//        	    //cartService.removeItemFromCart(memberId, book.getId());
//        	    cookieService.deleteCartCookie(response);
//        	    
//        	} else if ("cart".equals(purchaseType)) {
//        		
//        		
//        	    orderId = purchaseService.cartPurchase(principal.getName(), request, response);
//        	    
//        	} else {
//        	    redirectAttributes.addFlashAttribute("errorMessage", "Invalid purchase type or missing parameters for confirmation.");
//        	    return "redirect:/user/booklist";
//        	}
//            
//            purchaseService.saveOrUpdateDelivery(new Delivery(memberId, orderId, receiverName, address, phoneNumber, deliveryMessage));
//            
//            redirectAttributes.addFlashAttribute("successMessage", "Purchase completed successfully!");
//            return "redirect:/purchase/success";
//        } catch (IllegalArgumentException e) {
//            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
//            return "redirect:/purchase/checkout?type=" + purchaseType + (bookIsbn != null ? "&bookIsbn=" + bookIsbn + "&quantity=" + quantity : "");
//        } catch (Exception e) {
//            redirectAttributes.addFlashAttribute("errorMessage", "An unexpected error occurred during purchase: " + e.getMessage());
//            return "redirect:/purchase/checkout?type=" + purchaseType + (bookIsbn != null ? "&bookIsbn=" + bookIsbn + "&quantity=" + quantity : "");
//        }
//    }

    @GetMapping("/success")
    public String purchaseSuccess(Model model) {
    	bestsellerService.updateBestSellers();
        model.addAttribute("page", "payment/success");
        return "index";
    }
    
    @GetMapping("/fail")
    public String purchaseFail(Model model) {
    	bestsellerService.updateBestSellers();
        model.addAttribute("page", "payment/payfail");
        return "index";
    }
}