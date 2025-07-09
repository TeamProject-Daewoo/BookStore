package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import repository.BookMapper;
import repository.PurchaseMapper;
import vo.Book;
import vo.CartItem;
import vo.Purchase;

import java.util.List;

@Service
public class PurchaseService {

    @Autowired
    private PurchaseMapper purchaseMapper;

    @Autowired
    private BookMapper bookMapper;

    @Autowired
    private CartService cartService; // To clear cart after purchase

    @Transactional
    public void directPurchase(int memberId, int bookId, int quantity) {
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
        // order_date will be set by SYSDATE in mapper

        purchaseMapper.save(purchase);

        // Update book stock
        book.setStock(book.getStock() - quantity);
        bookMapper.update(book);
    }

    @Transactional
    public void cartPurchase(int memberId) {
        List<CartItem> cartItems = cartService.getCartItems(memberId);
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
            // order_date will be set by SYSDATE in mapper

            purchaseMapper.save(purchase);

            // Update book stock
            book.setStock(book.getStock() - quantity);
            bookMapper.update(book);
        }

        // Clear the cart after successful purchase
        cartService.clearCart(memberId);
    }
}
