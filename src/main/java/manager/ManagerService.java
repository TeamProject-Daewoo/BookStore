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
import org.springframework.transaction.annotation.Transactional;

import cart.Cart;
import cart.CartMapper;
import data.Book;
import data.BookMapper;
import purchase.BookDetailFragment;
import purchase.MyPurchaseView;
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

	@Transactional(readOnly = true)
	public Member login(String user_id, String password) {
		Member member = memberMapper.findByUserId(user_id);
		if (member != null && member.getPassword().equals(password)) {
			return member;
		}
		return null;
	}

	@Transactional
	public boolean registerMember(Member member) {
		// Check if user already exists
		if (memberMapper.findByUserId(member.getUser_id()) != null) {
			return false; // User already exists
		}
		// Save new member
		memberMapper.save(member);
		return true;
	}

	@Transactional
	public int saveMember(Member member) {
		return memberMapper.save(member);
	}

	@Transactional(readOnly = true)
	public Member getMember(int id) {
		return memberMapper.findById(id);
	}

	@Transactional(readOnly = true)
	public List<Member> getMemberList() {
		return memberMapper.findAll();
	}

	@Transactional
	public int updateManager(Member member) {
	    return memberMapper.updateManager(member);
	}

	@Transactional
	public int deleteMember(int id) {
		return memberMapper.delete(id);
	}

	// book
	@Autowired
	private BookMapper bookMapper;

    @Autowired
    private NaverBookService naverBookService;
    
    @Transactional
	public int saveBook(Book book) {
		return bookMapper.save(book);
	}

    @Transactional(readOnly = true)
	public Book getBook(int id) {
		return bookMapper.findById(id);
	}
	
    @Transactional(readOnly = true)
	public List<Book> getExistBookList() {
		return bookMapper.findExistBook();
	}
	
    @Transactional(readOnly = true)
	public List<Book> getBookList() {
		return bookMapper.findAll();
	}

    @Transactional
	public int updateBook(Book book) {
		return bookMapper.update(book);
	}

    @Transactional
	public int deleteBook(int id) {
		return bookMapper.delete(id);
	}
    
	// <<-- 3. Ű���� �˻� �޼��带 ���̺긮�� ������� �����մϴ�.
    @Transactional(readOnly = true)
	public List<Book> findByKeyword(String keyword) {
		// 3-1. �켱 �� DB���� Ű����� �˻��մϴ�.
		List<Book> localResults = bookMapper.findByKeyword(keyword);
		
		// 3-2. ���̹� API�� ȣ���Ͽ� ����� �����ɴϴ�.
		List<Book> apiResults = naverBookService.searchBooks(keyword);
		
		// 3-3. (�߿�) API ��� �߿��� �̹� �� DB�� �ִ� å(ISBN ����)�� �����Ͽ� �ߺ��� �����մϴ�.
        Map<String, Book> localBooksByIsbn = localResults.stream()
            .filter(book -> book.getIsbn() != null && !book.getIsbn().isEmpty())
            .collect(Collectors.toMap(Book::getIsbn, book -> book));

        List<Book> uniqueApiResults = apiResults.stream()
            .filter(apiBook -> !localBooksByIsbn.containsKey(apiBook.getIsbn()))
            .collect(Collectors.toList());
		
		// 3-4. DB ����� (�ߺ��� ���ŵ�) API ����� ���ļ� ��ȯ�մϴ�.
		List<Book> finalResults = new ArrayList<>();
		finalResults.addAll(localResults);
		finalResults.addAll(uniqueApiResults);
		
		return finalResults;
	}
	
	// <<-- 4. å �� ������ �������� ���ο� �޼��带 �����մϴ�. (ISBN ���)
    @Transactional
    public Book getBookByIsbn(String isbn) {
        // 4-1. ���� �츮 DB���� ISBN���� å�� ã�ƺ��ϴ�.
        Book book = bookMapper.findByIsbn(isbn);

        // 4-2. DB�� å�� �����ϸ�, �� ������ �ٷ� ��ȯ�մϴ�.
        if (book != null) {
            return book;
        } 
        // 4-3. DB�� å�� ������, ���̹� API�� �� ������ ��û�մϴ�.
        else {
            Book newBookFromApi = naverBookService.searchBookByIsbn(isbn);

            if (newBookFromApi != null) {
            	if ("��Ÿ".equals(newBookFromApi.getCategory()) && newBookFromApi.getLink() != null) {
                    String scrapedCategory = naverBookService.scrapeCategoryFromUrl(newBookFromApi.getLink());
                    if (scrapedCategory != null) {
                        // ��ũ�������� ���� ī�װ��� �ٽ� �з�
                        newBookFromApi.setCategory(naverBookService.classifyCategory(scrapedCategory));
                    }
                }
                // 4-4. API���� �޾ƿ� ���ο� å ������ �츮 DB�� ����(INSERT)�մϴ�.
                // �̷��� �ϸ� �������ʹ� DB���� �ٷ� ��ȸ�� ���������ϴ�.
                bookMapper.save(newBookFromApi);
                // ���� �� ��ȯ
                return newBookFromApi;
            }
        }
        return null; // DB�� API ���� ��ο��� å�� ã�� ���� ���
    }
	    
	// cart
	@Autowired
	private CartMapper cartMapper;

	@Transactional
	public int saveCart(Cart cart) {
		return cartMapper.save(cart);
	}

	@Transactional(readOnly = true)
	public Cart getCart(int id) {
		return cartMapper.findById(id);
	}

	@Transactional(readOnly = true)
	public List<Cart> getCartList() {
		return cartMapper.findAll();
	}

	@Transactional
	public int updateCart(Cart cart) {
		return cartMapper.update(cart);
	}

	@Transactional
	public int deleteCart(int id) {
		return cartMapper.delete(id);
	}

	// purchase
	@Autowired
	private PurchaseMapper purchaseMapper;

	@Transactional
	public int savePurchase(Purchase purchase) {
		return purchaseMapper.save(purchase);
	}

	@Transactional(readOnly = true)
	public Purchase getPurchase(int id) {
		return purchaseMapper.findById(id);
	}

	@Transactional(readOnly = true)
	public List<Purchase> getPurchaseList() {
		return purchaseMapper.findAll();
	}

	@Transactional
	public int updatePurchase(Purchase purchase) {
		return purchaseMapper.update(purchase);
	}

	@Transactional
	public int deletePurchase(int id) {
		return purchaseMapper.delete(id);
	}

	@Autowired
	ReviewService reviewService;
	
	//fetch POST ��û
	
	@Transactional(readOnly = true)
	public List<PurchaseView> getPurchaseView(SearchRequest searchReq) {
		System.out.println("db ��û");
		//SQL Injection ����
		Set<String> checkList = new HashSet<String>(Arrays.asList("p.order_date", "p.id", "b.price"));
		if(!checkList.contains(searchReq.getOrderItem()) || 
			(!searchReq.getOrder().equals("asc") && !searchReq.getOrder().equals("desc"))) {
			throw new IllegalArgumentException("Invaild");
		}
		
		Map<String, PurchaseView> viewMap = new LinkedHashMap<>();
		
		for (PurchaseQueryResult result : purchaseMapper.getPurchaseView(searchReq)) {
			String orderId = result.getOrder_id();
            PurchaseView purchaseView = viewMap.get(orderId);
            
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

	@Transactional(readOnly = true)
	public SalesView getSalesView(SearchRequest searchReq) {
		return new SalesView(getPurchaseView(searchReq), purchaseMapper.getTotalList());
	}

	@Transactional(readOnly = true)
	public Object getMyPurchaseView(int id) {
		List<MyPurchaseView> result = new ArrayList<>();
		
		for (Purchase p : purchaseMapper.findByBookId(id)) {
			
			result.add(
				MyPurchaseView.builder()
				.price(purchaseMapper.getTotalPrice(p.getId()))
				.book_title(bookMapper.findById(p.getBook_id()).getTitle())
				.quantity(p.getQuantity())
				.img(bookMapper.findById(p.getBook_id()).getImg())
				.order_date(p.getOrder_date())
				.category(bookMapper.findById(p.getBook_id()).getCategory())
				.build()
			);
		}
		return result;
	}

	
}