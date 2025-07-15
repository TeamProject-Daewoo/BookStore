package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.BookMapper;
import repository.CartMapper;
import vo.Book;
import vo.Cart;
import vo.CartItem;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CartService {

    @Autowired
    private CartMapper cartMapper;

    @Autowired
    private BookMapper bookMapper; // To get book details for CartItem

    public void addItemToCart(int memberId, Book book, int quantity) {
        Cart existingCart = cartMapper.findByMemberIdAndBookId(memberId, book.getId());

        if (existingCart != null) {
            // Update quantity if item already exists
            existingCart.setQuantity(existingCart.getQuantity() + quantity);
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

    public void updateItemQuantity(int memberId, int bookId, int quantity) {
        if (quantity <= 0) {
            cartMapper.deleteByMemberIdAndBookId(memberId, bookId);
        } else {
        	int stock = bookMapper.findById(bookId).getStock();
            cartMapper.updateQuantity(memberId, bookId, quantity > stock ? stock : quantity);
        }
    }

    public void removeItemFromCart(int memberId, int bookId) {
        cartMapper.deleteByMemberIdAndBookId(memberId, bookId);
    }

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