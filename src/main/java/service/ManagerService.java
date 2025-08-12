package service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import repository.BookMapper;
import repository.CartMapper;
import repository.MemberMapper;
import repository.PurchaseMapper;
import vo.Book;
import vo.Cart;
import vo.Member;
import vo.Purchase;
import vo.PurchaseView;
import vo.SalesView;

@Service
public class ManagerService {

	// member
	@Autowired
	private MemberMapper memberMapper;

	public Member login(String user_id, String password) {
		Member member = memberMapper.findByUserId(user_id);
		if (member != null && member.getPassword().equals(password)) {
			return member;
		}
		return null;
	}

	public boolean registerMember(Member member) {
		// Check if user already exists
		if (memberMapper.findByUserId(member.getUser_id()) != null) {
			return false; // User already exists
		}
		// Save new member
		memberMapper.save(member);
		return true;
	}

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

	// book
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

	// cart
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

	// purchase
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

	public List<PurchaseView> getPurchaseView() {

		Map<Integer, PurchaseView> viewMap = new LinkedHashMap<>();

		for (Purchase p : purchaseMapper.findAll()) {
			int id = p.getId();

			if (!viewMap.containsKey(id)) {
				PurchaseView view = 
						PurchaseView.builder()
						.id(p.getId())
						.member_id(p.getMember_id())
						.member_name(memberMapper.findById(p.getMember_id())
						.getName()).order_date(p.getOrder_date())
						.total_price(purchaseMapper.getTotalPrice(purchaseMapper.getOrder_idById(id)))
						.build();
				
				viewMap.put(id, view);
			}
			
			PurchaseView.BookDetail bookDetail = 
					PurchaseView.BookDetail.builder()
					.book_id(p.getBook_id())
					.book_title(bookMapper.findById(p.getBook_id()).getTitle())
					.quantity(p.getQuantity())
					.build();

			viewMap.get(id).getBookList().add(bookDetail);
		}

		return new ArrayList<>(viewMap.values());
	}

	public int getTotalSum() {
		int totalsum = 0;
		
		for(Purchase p : purchaseMapper.findAll()) {
			int order_id = p.getOrder_id();
			
			totalsum += purchaseMapper.getTotalPrice(order_id);
		}
		
		return totalsum;
	}

	public SalesView getSalesView() {
		return new SalesView(getPurchaseView(), getTotalSum());
	}
}
