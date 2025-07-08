package service.user;

import java.lang.reflect.Member;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import repository.*;
import vo.*;

@Service
public class UserService {
	
	//member 包府
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
		return memberMapper.update(member);
	}
	public int deleteMember(int id) {
		return memberMapper.delete(id);
	}
	
	//book 包府
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
	public int updateBook(Book book) {
		return bookMapper.update(book);
	}
	public int deleteBook(int id) {
		return bookMapper.delete(id);
	}
	
	//cart 包府
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
	
	//purchase 包府
	@Autowired
	private PurchaseMapper purchaseMapper;
	
	public int saveBook(Purchase purchase) {
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
}
