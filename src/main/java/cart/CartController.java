package cart;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List; // Changed from Map to List
import java.util.Map;

import javax.servlet.http.Cookie;
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

    
    //Principal 로그인중인 사용자 정보(username)
    private int getLoginedMemberId(Principal user) {
    	return memberMapper.findByUserId(user.getName()).getId();
    }
    
 // Autowired에 UserService 추가
    @Autowired
    private user.UserService userService;
    
    @Autowired
    private CookieService cookieService;
    
    @PostMapping("/addcookie")
    public String addToCart(@RequestParam String bookIsbn,
                            @RequestParam int quantity,
                            HttpServletRequest request,
                            HttpServletResponse response) {

    	Map<String, Integer> cartMap = cookieService.readCartCookie(request);

        // 기존 수량이 있으면 합산
        cartMap.put(bookIsbn, cartMap.getOrDefault(bookIsbn, 0) + quantity);

        cookieService.writeCartCookie(response, cartMap);

        return "redirect:/cart/cartview";
    }
    

    @GetMapping("/cartview")
    public String viewCart(HttpServletRequest request, Model model) {
        List<CartItem> cartItems = new ArrayList<>();

        // CookieService를 통해 쿠키 읽기
        Map<String, Integer> cartMap = cookieService.readCartCookie(request);

        for (Map.Entry<String, Integer> entry : cartMap.entrySet()) {
            String isbn = entry.getKey();
            int quantity = entry.getValue();

            // isbn으로 DB에서 Book 조회
            Book book = bookMapper.findByIsbn(isbn);
            if (book != null) {
                cartItems.add(new CartItem(book, quantity));
            }
        }

        // 총 합계 계산
        int totalPrice = cartItems.stream().mapToInt(CartItem::getItemTotal).sum();

        model.addAttribute("cartTotal", totalPrice);
        model.addAttribute("cartItems", cartItems);
        model.addAttribute("page", "user/cart");
        return "index";
    }
    
    @PostMapping("/updateQuantity")
    public String updateQuantity(
            @RequestParam("bookIsbn") String bookIsbn,
            @RequestParam("quantity") int quantity,
            HttpServletRequest request,
            HttpServletResponse response
    ) {
        cookieService.updateQuantity(request, response, bookIsbn, quantity);

        // 다시 장바구니 페이지로 리다이렉트
        return "redirect:/cart/cartview";
    }

    @PostMapping("/remove")
    public String deleteCartItem(@RequestParam("bookIsbn") String isbn,
            HttpServletRequest request,
            HttpServletResponse response) {
    	
    		cookieService.deleteCartItem(request, response, isbn);
    		
    		return "redirect:/cart/cartview";
    }
    
    @PostMapping("/deleteAll")
    public String deleteAllCartItems(HttpServletResponse response) {
        cookieService.deleteCartCookie(response);  // 쿠키 전체 삭제
        return "redirect:/cart/cartview";               // 삭제 후 장바구니 페이지로 리다이렉트
    }

    
    
}