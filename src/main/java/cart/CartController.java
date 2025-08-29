package cart;

import java.security.Principal;
import java.util.List; // Changed from Map to List

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import data.Book;
import data.BookMapper;
import user.MemberMapper;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @Autowired
    private BookMapper bookMapper;
    
    @Autowired
    private MemberMapper memberMapper;

//    private int getMemberIdFromSession(HttpSession session) {
//        Member member = (vo.Member) session.getAttribute("login");
//        if (member == null) {
//            throw new IllegalStateException("User not logged in. 'login' attribute (Member object) not found in session.");
//        }
//        return member.getId(); // Assuming Member object has an getId() method
//    }
    
    //Principal 로그인중인 사용자 정보(username)
    private int getLoginedMemberId(Principal user) {
    	return memberMapper.findByUserId(user.getName()).getId();
    }
    
 // Autowired에 UserService 추가
    @Autowired
    private user.UserService userService;
    
    @PostMapping("/add")
    // int bookId 대신 String bookIsbn을 받도록 수정
    public String addItemToCart(@RequestParam("bookIsbn") String bookIsbn,
                                @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                                Principal user,
                                RedirectAttributes redirectAttributes) {
        
    	int memberId = getLoginedMemberId(user);
        
        // id로 찾던 부분을 isbn으로 찾는 하이브리드 메서드로 교체
        Book book = userService.getBookByIsbn(bookIsbn);
        
        if (book == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Book not found.");
            return "redirect:/user/booklist"; // 에러 시 책 목록으로 이동
        }
        if (quantity <= 0) {
            redirectAttributes.addFlashAttribute("errorMessage", "Quantity must be at least 1.");
            // 상세 페이지로 돌아갈 때도 isbn을 사용
            return "redirect:/user/bookdetail?isbn=" + bookIsbn;
        }

        // book 객체에는 이제 DB에 저장된 id가 확실히 존재합니다.
        cartService.addItemToCart(memberId, book, quantity);
        redirectAttributes.addFlashAttribute("successMessage", book.getTitle() + " added to cart!");
        return "redirect:/cart";
    }


    @GetMapping
    public String viewCart(Principal user, Model model) {
        int memberId = getLoginedMemberId(user);

        List<CartItem> cartItems = cartService.getCartItems(memberId);
        
        model.addAttribute("cartItems", cartItems);
        model.addAttribute("cartTotal", cartService.calculateCartTotal(memberId));
        model.addAttribute("page", "user/cart");
        return "index";
    }

    @PostMapping("/updateQuantity")
    public String updateCartItemQuantity(@RequestParam("bookId") int bookId,
                                         @RequestParam("quantity") int quantity,
                                         Principal user,
                                         RedirectAttributes redirectAttributes) {
        int memberId = getLoginedMemberId(user);

        cartService.updateItemQuantity(memberId, bookId, quantity);
        redirectAttributes.addFlashAttribute("successMessage", "Cart updated successfully.");
        return "redirect:/cart";
    }

    @PostMapping("/remove")
    public String removeCartItem(@RequestParam("bookId") int bookId,
                                 Principal user,
                                 RedirectAttributes redirectAttributes) {
        int memberId = getLoginedMemberId(user);

        cartService.removeItemFromCart(memberId, bookId);
        redirectAttributes.addFlashAttribute("successMessage", "Item removed from cart.");
        return "redirect:/cart";
    }
}