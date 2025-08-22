package purchase;

import java.security.Principal;
import java.util.ArrayList; // For List.of() alternative if Java < 9
import java.util.Collections; // For List.of() alternative if Java < 9
import java.util.List;

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
import data.Book;
import data.BookMapper;
import user.MemberMapper;

@Controller
@RequestMapping("/purchase")
public class PurchaseController {

    @Autowired
    private PurchaseService purchaseService;

    @Autowired
    private BookMapper bookMapper;

    @Autowired
    private CartService cartService;
    
    @Autowired
    private MemberMapper memberMapper;
    
    @Autowired
    private CartMapper cartMapper;
    
    @Autowired
    private BestsellerService bestsellerService;

//    private int getMemberIdFromSession(HttpSession session) {
//        vo.Member member = (vo.Member) session.getAttribute("login");
//        if (member == null) {
//            throw new IllegalStateException("User not logged in. 'login' attribute (Member object) not found in session.");
//        }
//        return member.getId();
//    }
    
  //Principal 로그인중인 사용자 정보(username)
    private int getLoginedMemberId(Principal user) {
    	return memberMapper.findByUserId(user.getName()).getId();
    }

    // Direct purchase from book detail/list
    @PostMapping("/direct")
    public String directPurchase(@RequestParam("bookId") int bookId,
                                 @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                                 RedirectAttributes redirectAttributes) {
        try {
        	//두 번 구매되어 제거함
            //purchaseService.directPurchase(memberId, bookId, quantity);
            redirectAttributes.addFlashAttribute("successMessage", "Proceeding to checkout with cart items.");
            return "redirect:/purchase/checkout?type=direct&bookId=" + bookId + "&quantity=" + quantity; // Redirect to checkout page
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/bookDetail?id=" + bookId;
        }
    }

    // Purchase all items from cart
    @PostMapping("/cart")
    public String cartPurchase(RedirectAttributes redirectAttributes) {
        try {
            // No direct purchase here, just prepare for checkout
            // The actual purchase will happen on /purchase/confirm
            redirectAttributes.addFlashAttribute("successMessage", "Proceeding to checkout with cart items.");
            return "redirect:/purchase/checkout?type=cart"; // Redirect to checkout page
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error preparing cart for purchase: " + e.getMessage());
            return "redirect:/cart";
        }
    }

    // Display checkout page
    @GetMapping("/checkout")
    public String checkout(@RequestParam("type") String type,
                           @RequestParam(value = "bookId", required = false) Integer bookId,
                           @RequestParam(value = "quantity", required = false) Integer quantity,
                           Principal user,
                           Model model,
                           RedirectAttributes redirectAttributes) {
        int memberId = getLoginedMemberId(user);

        List<CartItem> itemsToPurchase = null;
        int totalAmount = 0;

        if ("direct".equals(type) && bookId != null && quantity != null) {
            Book book = bookMapper.findById(bookId);
            if (book == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Book not found for direct purchase.");
                return "redirect:/books";
            }
            CartItem directItem = new CartItem(book, quantity);
            // Use Arrays.asList or new ArrayList<>(Collections.singletonList()) for Java < 9
            itemsToPurchase = new ArrayList<>(Collections.singletonList(directItem));
            totalAmount = directItem.getItemTotal();
        } else if ("cart".equals(type)) {
            itemsToPurchase = cartService.getCartItems(memberId);
            totalAmount = cartService.calculateCartTotal(memberId);
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid purchase type or missing parameters.");
            return "redirect:/books";
        }

        if (itemsToPurchase == null || itemsToPurchase.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "No items to purchase.");
            return "redirect:/books";
        }

        // 최근 주문 ID 조회 (PurchaseService에 구현 필요)
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

    // Confirm and finalize purchase
    @PostMapping("/confirm")
    public String confirmPurchase(@RequestParam("purchaseType") String purchaseType,
                                  @RequestParam(value = "bookId", required = false) Integer bookId,
                                  @RequestParam(value = "quantity", required = false) Integer quantity,
                                  @RequestParam("receiverName") String receiverName,
                                  @RequestParam("address") String address,
                                  @RequestParam("phoneNumber") String phoneNumber,
                                  @RequestParam(value = "deliveryMessage", required = false) String deliveryMessage,
                                  // Add address parameters here
                                  Principal user,
                                  RedirectAttributes redirectAttributes) {
        int memberId = getLoginedMemberId(user);
        try {
        	
        	int orderId;
        	
        	if ("direct".equals(purchaseType) && bookId != null && quantity != null) {
        	    orderId = purchaseService.directPurchase(memberId, bookId, quantity);
        	    cartService.removeItemFromCart(memberId, bookId);
        	} else if ("cart".equals(purchaseType)) {
        	    orderId = purchaseService.cartPurchase(memberId);
        	} else {
        	    redirectAttributes.addFlashAttribute("errorMessage", "Invalid purchase type or missing parameters for confirmation.");
        	    return "redirect:/books";
        	}
            
            // 배송 정보 저장
            purchaseService.saveOrUpdateDelivery(new Delivery(memberId, orderId, receiverName, address, phoneNumber, deliveryMessage));
            
            redirectAttributes.addFlashAttribute("successMessage", "Purchase completed successfully!");
            return "redirect:/purchase/success";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/purchase/checkout?type=" + purchaseType + (bookId != null ? "&bookId=" + bookId + "&quantity=" + quantity : "");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "An unexpected error occurred during purchase: " + e.getMessage());
            return "redirect:/purchase/checkout?type=" + purchaseType + (bookId != null ? "&bookId=" + bookId + "&quantity=" + quantity : "");
        }
    }

    @GetMapping("/success")
    public String purchaseSuccess(Model model) {
    	bestsellerService.updateBestSellers();
        model.addAttribute("page", "user/purchase_success");
        return "index";
    }
}
