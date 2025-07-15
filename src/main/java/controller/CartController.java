package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.ui.Model;
import repository.BookMapper;
import repository.MemberMapper;
import service.CartService;
import vo.*;

import javax.servlet.http.HttpSession;

import java.security.Principal;
import java.util.List; // Changed from Map to List

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
    private int getLoginedMemberId(Principal user) {
    	return memberMapper.findByUserId(user.getName()).getId();
    }
    
    @PostMapping("/add")
    public String addItemToCart(@RequestParam("bookId") int bookId,
                                @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                                Principal user,
                                RedirectAttributes redirectAttributes) {
        
    	int memberId = getLoginedMemberId(user);
        Book book = bookMapper.findById(bookId);
        if (book == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Book not found.");
            return "redirect:/books";
        }

        if (quantity <= 0) {
            redirectAttributes.addFlashAttribute("errorMessage", "Quantity must be at least 1.");
            return "redirect:/bookDetail?id=" + bookId;
        }

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
        return "user/cart";
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