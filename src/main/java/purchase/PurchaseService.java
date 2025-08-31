package purchase;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cart.CartItem;
import cart.CartService;
import cart.CookieService;
import data.Book;
import data.BookMapper;
import user.UserService;

@Service
public class PurchaseService {
	
	@Autowired
	private UserService userService;

    @Autowired
    private PurchaseMapper purchaseMapper;

    @Autowired
    private BookMapper bookMapper;

    @Autowired
    private CartService cartService; // To clear cart after purchase
    
    @Autowired
    private CookieService cookieService;
    
    private int generateOrderId() {
		
		return (int)(System.currentTimeMillis() / 1000);
	}

    @Transactional
    public int directPurchase(int memberId, int bookId, int quantity) {
    	
    	int orderId = generateOrderId();
    	
        Book book = bookMapper.findById(bookId);
        if (book == null) {
            throw new IllegalArgumentException("Book not found.");
        }
        if (book.getStock() < quantity) {
            throw new IllegalArgumentException("Not enough stock for book: " + book.getTitle());
        }

        // Create purchase record
        Purchase purchase = new Purchase();
        purchase.setMember_id(memberId);
        purchase.setBook_id(bookId);
        purchase.setQuantity(quantity);
        purchase.setOrder_id(orderId);
        // order_date will be set by SYSDATE in mapper

        purchaseMapper.save(purchase);

        // Update book stock
        book.setStock(book.getStock() - quantity);
        bookMapper.update(book);
        
        return orderId;
    }

    

	@Transactional
    public int cartPurchase(String userId, HttpServletRequest request, HttpServletResponse response) {
		
		int memberId = userService.getMemberbyId(userId).getId();
		
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
        
        int orderId = generateOrderId();
        
        if (cartItems.isEmpty()) {
            throw new IllegalArgumentException("Cart is empty.");
        }

        for (CartItem item : cartItems) {
            Book book = item.getBook();
            int quantity = item.getQuantity();

            if (book.getStock() < quantity) {
                throw new IllegalArgumentException("Not enough stock for book: " + book.getTitle());
            }

            // Create purchase record
            Purchase purchase = new Purchase();
            purchase.setMember_id(memberId);
            purchase.setBook_id(book.getId());
            purchase.setQuantity(quantity);
            purchase.setOrder_id(orderId);
            // order_date will be set by SYSDATE in mapper

            purchaseMapper.save(purchase);

            // Update book stock
            book.setStock(book.getStock() - quantity);
            bookMapper.update(book);
        }

        // Clear the cart after successful purchase
        cookieService.deleteCartCookie(response);
        
        return orderId;
    }
	
	

    public Delivery getDeliveryInfoByOrderId(int orderId) {
        return purchaseMapper.findByOrderId(orderId);
    }

    @Transactional
    public void saveOrUpdateDelivery(Delivery deliveryInfo) {
        Delivery existing = purchaseMapper.findByOrderId(deliveryInfo.getOrderId());
        if (existing != null) {
        	purchaseMapper.deliveryupdate(deliveryInfo);
        } else {
        	purchaseMapper.deliveryinsert(deliveryInfo);
        }
    }

    public Integer getMostRecentOrderIdByMemberId(int memberId) {
        return purchaseMapper.findMostRecentOrderIdByMemberId(memberId);
    }
}
