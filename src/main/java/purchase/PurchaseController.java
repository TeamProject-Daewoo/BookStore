package purchase;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
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
            // bookIsbn과 quantity를 checkout 페이지로 전달합니다.
            return "redirect:/purchase/checkout?type=direct&bookIsbn=" + bookIsbn + "&quantity=" + quantity;
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            // 에러 발생 시 bookdetail 페이지로 돌아갈 때도 isbn을 사용합니다.
            return "redirect:/user/bookdetail?isbn=" + bookIsbn;
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
    public String checkout(@RequestParam("type") String type,
                           // Integer bookId 대신 String bookIsbn을 받습니다.
                           @RequestParam(value = "bookIsbn", required = false) String bookIsbn, 
                           @RequestParam(value = "quantity", required = false) Integer quantity,
                           Principal user,
                           Model model,
                           RedirectAttributes redirectAttributes,
                           HttpServletRequest request
    		) {
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
            
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid purchase type or missing parameters.");
            return "redirect:/user/booklist";
        }

        if (itemsToPurchase == null || itemsToPurchase.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "No items to purchase.");
            return "redirect:/user/booklist";
        }

        Integer recentOrderId = purchaseService.getMostRecentOrderIdByMemberId(memberId);
        Delivery delivery = null;
        if (recentOrderId != null) {
            delivery = purchaseService.getDeliveryInfoByOrderId(recentOrderId);
        }
        model.addAttribute("delivery", delivery);
        
        model.addAttribute("itemsToPurchase", itemsToPurchase);
        model.addAttribute("totalAmount", totalAmount);
        model.addAttribute("purchaseType", type);
        model.addAttribute("page", "user/purchase");
        return "index";
    }

    // <<-- 3. '구매 확정' 메서드 수정 -->>
    @PostMapping("/confirm")
    public String confirmPurchase(@RequestParam("purchaseType") String purchaseType,
                                  // Integer bookId 대신 String bookIsbn을 받습니다.
                                  @RequestParam(value = "bookIsbn", required = false) String bookIsbn,
                                  @RequestParam(value = "quantity", required = false) Integer quantity,
                                  @RequestParam("receiverName") String receiverName,
                                  @RequestParam("address") String address,
                                  @RequestParam("phoneNumber") String phoneNumber,
                                  @RequestParam(value = "deliveryMessage", required = false) String deliveryMessage,
                                  Principal user,
                                  RedirectAttributes redirectAttributes,
                                  HttpServletRequest request,
                                  HttpServletResponse response,
                                  Principal principal
    		) {
        int memberId = getLoginedMemberId(user);
        try {
        	
        	int orderId;
        	
        	if ("direct".equals(purchaseType) && bookIsbn != null && quantity != null) {
                // 구매 확정 시에도 isbn으로 책 정보를 가져옵니다.
                Book book = userService.getBookByIsbn(bookIsbn);
                if(book == null || book.getId() == null) {
                    throw new IllegalArgumentException("Book not found or could not be saved.");
                }
                // DB에 저장된 book의 id를 사용하여 구매를 진행합니다.
        	    orderId = purchaseService.directPurchase(memberId, book.getId(), quantity);
        	    cartService.removeItemFromCart(memberId, book.getId());
        	    
        	} else if ("cart".equals(purchaseType)) {
        		
        		
        	    orderId = purchaseService.cartPurchase(principal.getName(), request, response);
        	    
        	} else {
        	    redirectAttributes.addFlashAttribute("errorMessage", "Invalid purchase type or missing parameters for confirmation.");
        	    return "redirect:/user/booklist";
        	}
            
            purchaseService.saveOrUpdateDelivery(new Delivery(memberId, orderId, receiverName, address, phoneNumber, deliveryMessage));
            
            redirectAttributes.addFlashAttribute("successMessage", "Purchase completed successfully!");
            return "redirect:/purchase/success";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/purchase/checkout?type=" + purchaseType + (bookIsbn != null ? "&bookIsbn=" + bookIsbn + "&quantity=" + quantity : "");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "An unexpected error occurred during purchase: " + e.getMessage());
            return "redirect:/purchase/checkout?type=" + purchaseType + (bookIsbn != null ? "&bookIsbn=" + bookIsbn + "&quantity=" + quantity : "");
        }
    }

    @GetMapping("/success")
    public String purchaseSuccess(Model model) {
    	bestsellerService.updateBestSellers();
        model.addAttribute("page", "user/purchase_success");
        return "index";
    }
}