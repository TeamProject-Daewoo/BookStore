package cart;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import data.Book;
import data.BookMapper;

@Service
public class CartService {

    @Autowired
    private CartMapper cartMapper;

    @Autowired
    private BookMapper bookMapper; // To get book details for CartItem

    @Transactional
    public void addItemToCart(int memberId, Book book, int quantity) {
        Cart existingCart = cartMapper.findByMemberIdAndBookId(memberId, book.getId());

        if (existingCart != null) {
            // Update quantity if item already exists
        	int addCount = quantity+existingCart.getQuantity();
        	//재고 넘칠 때 예외처리
            existingCart.setQuantity(addCount > book.getStock() ? book.getStock() : addCount);
            cartMapper.update(existingCart);
        } else {
            // Add new item to cart
            Cart newCart = new Cart();
            // Assuming 'id' for Cart is auto-generated or handled by DB
            // For now, let's set a dummy ID or rely on DB auto-increment
            // If 'id' is not auto-generated, you might need a sequence or UUID
            // For simplicity, I'll omit setting 'id' here, assuming DB handles it.
            newCart.setMember_id(memberId);
            newCart.setBook_id(book.getId());
            newCart.setQuantity(quantity);
            cartMapper.save(newCart);
        }
    }

    @Transactional(readOnly = true)
    public List<CartItem> getCartItems(int memberId) {
        List<Cart> carts = cartMapper.findByMemberId(memberId);
        List<CartItem> cartItems = new ArrayList<>();
        for (Cart cart : carts) {
            Book book = bookMapper.findById(cart.getBook_id());
            if (book != null) {
                cartItems.add(new CartItem(book, cart.getQuantity()));
            }
        }
        return cartItems;
    }

    @Transactional
    public void updateItemQuantity(int memberId, int bookId, int quantity) {
        if (quantity <= 0) {
            cartMapper.deleteByMemberIdAndBookId(memberId, bookId);
        } else {
        	int stock = bookMapper.findById(bookId).getStock();
            cartMapper.updateQuantity(memberId, bookId, quantity > stock ? stock : quantity);
        }
    }

    @Transactional
    public void removeItemFromCart(int memberId, int bookId) {
        cartMapper.deleteByMemberIdAndBookId(memberId, bookId);
    }

    @Transactional
    public void clearCart(int memberId) {
        cartMapper.deleteAllByMemberId(memberId);
    }

    public int calculateCartTotal(int memberId) {
        List<CartItem> cartItems = getCartItems(memberId);
        return cartItems.stream()
                .mapToInt(CartItem::getItemTotal)
                .sum();
    }
}