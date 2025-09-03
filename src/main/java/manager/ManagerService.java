package manager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cart.Cart;
import cart.CartMapper;
import data.Book;
import data.BookMapper;
import purchase.BookDetailFragment;
import purchase.Purchase;
import purchase.PurchaseFragment;
import purchase.PurchaseMapper;
import purchase.PurchaseQueryResult;
import purchase.PurchaseView;
import purchase.SalesView;
import purchase.SumList;
import restapi.SearchRequest;
import review.Review;
import review.ReviewService;
import user.Member;
import user.MemberMapper;
import user.NaverBookService;

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

    @Autowired
    private NaverBookService naverBookService;
    
	public int saveBook(Book book) {
		return bookMapper.save(book);
	}

	public Book getBook(int id) {
		return bookMapper.findById(id);
	}
	
	public List<Book> getExistBookList() {
		return bookMapper.findExistBook();
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
    
	// <<-- 3. 키워드 검색 메서드를 하이브리드 방식으로 수정합니다.
		public List<Book> findByKeyword(String keyword) {
			// 3-1. 우선 내 DB에서 키워드로 검색합니다.
			List<Book> localResults = bookMapper.findByKeyword(keyword);
			
			// 3-2. 네이버 API를 호출하여 결과를 가져옵니다.
			List<Book> apiResults = naverBookService.searchBooks(keyword);
			
			// 3-3. (중요) API 결과 중에서 이미 내 DB에 있는 책(ISBN 기준)은 제외하여 중복을 방지합니다.
	        Map<String, Book> localBooksByIsbn = localResults.stream()
	            .filter(book -> book.getIsbn() != null && !book.getIsbn().isEmpty())
	            .collect(Collectors.toMap(Book::getIsbn, book -> book));

	        List<Book> uniqueApiResults = apiResults.stream()
	            .filter(apiBook -> !localBooksByIsbn.containsKey(apiBook.getIsbn()))
	            .collect(Collectors.toList());
			
			// 3-4. DB 결과와 (중복이 제거된) API 결과를 합쳐서 반환합니다.
			List<Book> finalResults = new ArrayList<>();
			finalResults.addAll(localResults);
			finalResults.addAll(uniqueApiResults);
			
			return finalResults;
		}
		
		// <<-- 4. 책 상세 정보를 가져오는 새로운 메서드를 정의합니다. (ISBN 기반)
	    public Book getBookByIsbn(String isbn) {
	        // 4-1. 먼저 우리 DB에서 ISBN으로 책을 찾아봅니다.
	        Book book = bookMapper.findByIsbn(isbn);

	        // 4-2. DB에 책이 존재하면, 그 정보를 바로 반환합니다.
	        if (book != null) {
	            return book;
	        } 
	        // 4-3. DB에 책이 없으면, 네이버 API에 상세 정보를 요청합니다.
	        else {
	            Book newBookFromApi = naverBookService.searchBookByIsbn(isbn);

	            if (newBookFromApi != null) {
	            	if ("기타".equals(newBookFromApi.getCategory()) && newBookFromApi.getLink() != null) {
	                    String scrapedCategory = naverBookService.scrapeCategoryFromUrl(newBookFromApi.getLink());
	                    if (scrapedCategory != null) {
	                        // 스크래핑으로 얻은 카테고리로 다시 분류
	                        newBookFromApi.setCategory(naverBookService.classifyCategory(scrapedCategory));
	                    }
	                }
	                // 4-4. API에서 받아온 새로운 책 정보를 우리 DB에 저장(INSERT)합니다.
	                // 이렇게 하면 다음부터는 DB에서 바로 조회가 가능해집니다.
	                bookMapper.save(newBookFromApi);
	                // 저장 후 반환
	                return newBookFromApi;
	            }
	        }
	        return null; // DB와 API 양쪽 모두에서 책을 찾지 못한 경우
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

	@Autowired
	ReviewService reviewService;
	
	//fetch POST 요청
	public List<PurchaseView> getPurchaseView(SearchRequest searchReq) {
		System.out.println("db 요청");
		//SQL Injection 검증
		Set<String> checkList = new HashSet<String>(Arrays.asList("p.order_date", "p.id", "b.price"));
		if(!checkList.contains(searchReq.getOrderItem()) || 
			(!searchReq.getOrder().equals("asc") && !searchReq.getOrder().equals("desc"))) {
			throw new IllegalArgumentException("Invaild");
		}
		
		Map<Integer, PurchaseView> viewMap = new LinkedHashMap<>();
		
		for (PurchaseQueryResult result : purchaseMapper.getPurchaseView(searchReq)) {
			int orderId = result.getOrder_id();
            PurchaseView purchaseView = viewMap.get(orderId);
            
            System.out.println("==============================");
            System.out.println(result);
            if (purchaseView == null) {
                purchaseView = new PurchaseView();
                purchaseView.setPurchaseList(
            		new PurchaseFragment(
	                    result.getId(), 
	                    result.getMember_id(), 
	                    result.getMember_name(), 
	                    result.getOrder_date(), 
	                    result.getTotal_price(), 
	                    result.getOrder_id()
	                )
            	);
                viewMap.put(orderId, purchaseView);
            }

            purchaseView.getBookList().add(
            	new BookDetailFragment(
                    result.getBook_id(),
                    result.getBook_title(),
                    result.getQuantity(),
                    result.getAuthor(),
                    result.getCategory(),
                    result.getIsbn(),
                    result.getRating()
            	)
            );
        }
		return new ArrayList<>(viewMap.values());
	}

	public SalesView getSalesView(SearchRequest searchReq) {
		return new SalesView(getPurchaseView(searchReq), purchaseMapper.getTotalList());
	}

	
}
