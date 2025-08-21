package user;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import cart.Cart;
import cart.CartMapper;
import data.Book;
import data.BookMapper;
import purchase.MyPurchaseView;
import purchase.Purchase;
import purchase.PurchaseMapper;

@Service
public class UserService {
	
	//member 
	@Autowired
	private MemberMapper memberMapper;
	
	public int saveMember(Member member) {
		return memberMapper.save(member);
	}
	public Member getMember(int id) {
		return memberMapper.findById(id);
	}
	public List<Member> getMemberList() {
		return memberMapper.findAll();
	}
	public int updateMember(Member member) {
		
		Member updatemember = memberMapper.findById(member.getId());
		
		updatemember.setUser_id(member.getUser_id());
		updatemember.setName(member.getName());
		updatemember.setEmail(member.getEmail());
		updatemember.setPhone_number(member.getPhone_number());
		
		return memberMapper.update(updatemember);
	}
	public int deleteMember(int id) {
		return memberMapper.delete(id);
	}
	public int findId(String username) {
		Member member =  memberMapper.findByUsername(username);
		return member.getId();
	}

	public Member login(String user_id, String password) {
		Member member = memberMapper.findByUserId(user_id);
		if (member != null && member.getPassword().equals(password)) {
			return member;
		}
		return null;
	}

	public boolean registerMember(Member member) {
		// user_id 鈺곕똻�삺占쎈릭筌롳옙 false
		Member existingMember = memberMapper.findByUserId(member.getUser_id());
		if(existingMember != null) return false;
		member.setRole("ROLE_USER");
		PasswordEncoder pe = new BCryptPasswordEncoder();
		member.setPassword(pe.encode(member.getPassword() ));
		memberMapper.save(member);
		return true; // Registration successful
	}
	
	public boolean registerAdmin(Member member) {
		// user_id 鈺곕똻�삺占쎈릭筌롳옙 false
		Member existingMember = memberMapper.findByUserId(member.getUser_id());
		if(existingMember != null) return false;
		member.setRole("ROLE_ADMIN");
		PasswordEncoder pe = new BCryptPasswordEncoder();
		member.setPassword(pe.encode(member.getPassword() ));
		memberMapper.save(member);
		return true; // Registration successful
	}
	
	public boolean isUserIdExist(String userId) {
	    return memberMapper.findByUserId(userId) != null;
	}
	
	public Member findByUsername(String username) {
		return memberMapper.findByUsername(username);
	}
	
	public Member findById(int id) {
		return memberMapper.findById(id);
	}
	
	//book 
	@Autowired
	private BookMapper bookMapper;
	
	public int saveBook(Book book) {
		return bookMapper.save(book);
	}
	public Book getBook(int id) {
		return bookMapper.findById(id);
	}
	public List<Book> getBookList() {
		return bookMapper.findAll();
	}
	public List<Book> findByKeyword(String keyword) {
		return bookMapper.findByKeyword(keyword);
	}
	public int updateBook(Book book) {
		return bookMapper.update(book);
	}
	public int deleteBook(int id) {
		return bookMapper.delete(id);
	}
	public List<Book> getExistBookList() {
		return bookMapper.findExistBook();
	}
	
	//cart 
	@Autowired
	private CartMapper cartMapper;
	
	public int saveCart(Cart cart) {
		return cartMapper.save(cart);
	}
	public Cart getCart(int id) {
		return cartMapper.findById(id);
	}
	public List<Cart> getCartList() {
		return cartMapper.findAll();
	}
	public int updateCart(Cart cart) {
		return cartMapper.update(cart);
	}
	public int deleteCart(int id) {
		return cartMapper.delete(id);
	}
	
	//purchase 
	@Autowired
	private PurchaseMapper purchaseMapper;
	
	public int savePurchase(Purchase purchase) {
		return purchaseMapper.save(purchase);
	}
	public Purchase getPurchase(int id) {
		return purchaseMapper.findById(id);
	}
	public List<Purchase> getPurchaseList() {
		return purchaseMapper.findAll();
	}
	public int updatePurchase(Purchase purchase) {
		return purchaseMapper.update(purchase);
	}
	public int deletePurchase(int id) {
		return purchaseMapper.delete(id);
	}
	
	public List<MyPurchaseView> getMyPurchaseView(int id) {
		List<MyPurchaseView> result = new ArrayList<>();
		
		for (Purchase p : purchaseMapper.findByUserId(id)) {
			
			result.add(
				MyPurchaseView.builder()
				.price(purchaseMapper.getTotalPrice(p.getId()))
				.book_title(bookMapper.findById(p.getBook_id()).getTitle())
				.quantity(p.getQuantity())
				.img(bookMapper.findById(p.getBook_id()).getImg())
				.order_date(p.getOrder_date())
				.build()
			);
		}
		return result;
	}


	
}