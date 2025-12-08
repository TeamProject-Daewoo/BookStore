package purchase;

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.log;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cart.CartItem;
import cart.CartService;
import cart.CookieService;
import data.Book;
import data.BookMapper;
import lombok.extern.slf4j.Slf4j;
import user.UserService;

@Slf4j
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

//    @Transactional
//    public int directPurchase(int memberId, int bookId, int quantity) {
//    	
//    	int orderId = generateOrderId();
//    	
//        Book book = bookMapper.findById(bookId);
//        if (book == null) {
//            throw new IllegalArgumentException("Book not found.");
//        }
//        if (book.getStock() < quantity) {
//            throw new IllegalArgumentException("Not enough stock for book: " + book.getTitle());
//        }
//
//        // Create purchase record
//        Purchase purchase = new Purchase();
//        purchase.setMember_id(memberId);
//        purchase.setBook_id(bookId);
//        purchase.setQuantity(quantity);
//        purchase.setOrder_id(orderId);
//        // order_date will be set by SYSDATE in mapper
//
//        purchaseMapper.save(purchase);
//
//        // Update book stock
//        book.setStock(book.getStock() - quantity);
//        bookMapper.update(book);
//        
//        return orderId;
//    }

    

//	@Transactional
//    public int cartPurchase(String userId, HttpServletRequest request, HttpServletResponse response) {
//		
//		int memberId = userService.getMemberbyId(userId).getId();
//		
//		List<CartItem> cartItems = new ArrayList<>();
//
//        // CookieService를 통해 쿠키 읽기
//        Map<String, Integer> cartMap = cookieService.readCartCookie(request);
//
//        for (Map.Entry<String, Integer> entry : cartMap.entrySet()) {
//            String isbn = entry.getKey();
//            int cookie_quantity = entry.getValue();
//
//            // isbn으로 DB에서 Book 조회
//            Book book = bookMapper.findByIsbn(isbn);
//            
//            if (book != null) {
//                cartItems.add(new CartItem(book, cookie_quantity));
//            }
//        }
//        
//        String orderId = generateOrderId();
//        
//        if (cartItems.isEmpty()) {
//            throw new IllegalArgumentException("Cart is empty.");
//        }
//
//        for (CartItem item : cartItems) {
//            Book book = item.getBook();
//            int quantity = item.getQuantity();
//
//            if (book.getStock() < quantity) {
//                throw new IllegalArgumentException("Not enough stock for book: " + book.getTitle());
//            }
//
//            // Create purchase record
//            Purchase purchase = new Purchase();
//            purchase.setMember_id(memberId);
//            purchase.setBook_id(book.getId());
//            purchase.setQuantity(quantity);
//            purchase.setOrder_id(orderId);
//            // order_date will be set by SYSDATE in mapper
//
//            purchaseMapper.save(purchase);
//
//            // Update book stock
//            book.setStock(book.getStock() - quantity);
//            bookMapper.update(book);
//        }
//
//        // Clear the cart after successful purchase
//        cookieService.deleteCartCookie(response);
//        
//        return orderId;
//    }
	
	

    @Transactional(readOnly = true)
    public Delivery getDeliveryInfoByOrderId(String orderId) {
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

    @Transactional(readOnly = true)
    public String getMostRecentOrderIdByMemberId(int memberId) {
        return purchaseMapper.findMostRecentOrderIdByMemberId(memberId);
    }
    
    @Transactional
    public void createPendingOrder(int memberId, String orderId, List<CartItem> itemsToPurchase) {
        try {
        	if (itemsToPurchase == null || itemsToPurchase.isEmpty()) {
                throw new IllegalArgumentException("주문할 상품이 없습니다.");
            }

            List<Purchase> purchaseList = new ArrayList<>();

            for (CartItem item : itemsToPurchase) {
                Book book = item.getBook();
                int quantity = item.getQuantity();

                // 재고 확인
                if (book.getStock() < quantity) {
                    throw new IllegalArgumentException("재고가 부족한 상품이 있습니다: " + book.getTitle());
                }

                // Purchase 객체 생성
                Purchase purchase = new Purchase();
                purchase.setMember_id(memberId);
                purchase.setBook_id(book.getId());
                purchase.setQuantity(quantity);
                purchase.setOrder_id(orderId);
                purchase.setStatus("PENDING");
                
                purchaseList.add(purchase);
            }

            // 2. 리스트에 담긴 모든 구매 항목을 DB에 한 번에 저장 (Batch Insert)
            if (!purchaseList.isEmpty()) {
                purchaseMapper.savePurchaseList(purchaseList);
            }
		} catch (Exception e) {
			log.error("createPendingOrder에서 심각한 오류 발생!", e);
	        e.printStackTrace();
	        System.out.println("==============================================");
	        throw e;
		} 
    }

    @Transactional(readOnly = true)
	public List<Purchase> findPendingOrderItemsByOrderId(String orderId) {
		return purchaseMapper.findPendingByOrderId(orderId);
	}
	
    @Transactional(readOnly = true)
	public long calculateTotalAmount(List<Purchase> orderItems) {
        long totalAmount = 0;
        for (Purchase item : orderItems) {
            // 각 항목의 책 정보를 DB에서 다시 조회하여 가격을 가져옵니다.
            Book book = bookMapper.findById(item.getBook_id());
            if (book != null) {
                totalAmount += (long) book.getPrice() * item.getQuantity();
            }
        }
        return totalAmount;
    }

    // 3. 주문 완료 처리 메서드 (orderId에 해당하는 모든 항목의 상태를 변경)
    @Transactional
    public void completePurchase(String orderId, String paymentKey) {
        purchaseMapper.updateStatusToCompleted(orderId, paymentKey);
    }

    @Transactional
    public void cleanupOldPendingPurchases() {
        // 매퍼를 호출하여 10분 이상 지난 PENDING 주문을 삭제합니다.
        int deletedRows = purchaseMapper.deleteOldPendingPurchases(10); // 10분 기준
        if (deletedRows > 0) {
            log.info("{}개의 오래된 PENDING 주문 행이 삭제되었습니다.", deletedRows);
        }
    }

    @Transactional
	public void decreaseStockForOrder(List<Purchase> orderItems) {
		
        for (Purchase item : orderItems) {
            int bookId = item.getBook_id();
            int quantity = item.getQuantity();
            
            Book book = bookMapper.findById(bookId);

            // 재고 확인
            if (book.getStock() < quantity) {
                throw new IllegalArgumentException("재고가 부족한 상품이 있습니다: " + book.getTitle());
            }

            // 재고 업데이트 (DB에서 직접 차감)
            book.setStock(book.getStock() - quantity);
            bookMapper.update(book);
        }
		
		
	}
}
