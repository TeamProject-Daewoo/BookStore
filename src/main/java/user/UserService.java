package user;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.FileCopyUtils;

import cart.Cart;
import cart.CartMapper;
import data.Book;
import data.BookMapper;
import purchase.MyPurchaseView;
import purchase.Purchase;
import purchase.PurchaseMapper;

@Service
public class UserService {

	// =================================================================
	// Member, Cart, Purchase 관련 코드는 기존과 동일 (생략)
	// =================================================================
	
	//member 
	@Autowired
	private MemberMapper memberMapper;
	
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
	public int updateMember(Member member) {
		if(member.getId() == null) throw new IllegalArgumentException("Member ID가 null입니다.");
	    Member updatemember = memberMapper.findById(member.getId());
	    
	    updatemember.setUser_id(member.getUser_id());
	    updatemember.setName(member.getName());
	    updatemember.setEmail(member.getEmail());
	    updatemember.setPhone_number(member.getPhone_number());

	    if (member.getProfileImage() != null && member.getProfileImage().length > 0) {
	        updatemember.setProfileImage(member.getProfileImage());
	    }
	    
	    if (member.getPassword() != null && !member.getPassword().isEmpty()) {
	        updatemember.setPassword(member.getPassword());
	    }
	    
	    return memberMapper.update(updatemember);
	}
	@Transactional
	public int deleteMember(int id) {
		return memberMapper.delete(id);
	}
	@Transactional(readOnly = true)
	public int findId(String username) {
		Member member =  memberMapper.findByUsername(username);
		return member.getId();
	}

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
		Member existingMember = memberMapper.findByUserId(member.getUser_id());
		if(existingMember != null) return false;
		member.setRole("ROLE_USER");
		PasswordEncoder pe = new BCryptPasswordEncoder();
		member.setPassword(pe.encode(member.getPassword() ));

	    if(member.getProfileImage() == null || member.getProfileImage().length == 0) {
	        try {
	            ClassPathResource imgFile = new ClassPathResource("static/profileimage/default.jpg");
	            member.setProfileImage(FileCopyUtils.copyToByteArray(imgFile.getInputStream()));
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	    }
		memberMapper.save(member);
		return true; 
	}
	
	@Transactional
	public boolean registerAdmin(Member member) {
		Member existingMember = memberMapper.findByUserId(member.getUser_id());
		if(existingMember != null) return false;
		member.setRole("ROLE_ADMIN");
		PasswordEncoder pe = new BCryptPasswordEncoder();
		member.setPassword(pe.encode(member.getPassword() ));
		memberMapper.save(member);
		return true; 
	}
	
	@Transactional(readOnly = true)
	public boolean isUserIdExist(String userId) {
	    return memberMapper.findByUserId(userId) != null;
	}
	
	@Transactional(readOnly = true)
	public Member findByUsername(String username) {
		return memberMapper.findByUsername(username);
	}
	
	@Transactional(readOnly = true)
	public Member findById(int id) {
		return memberMapper.findById(id);
	}
	
	//book 
	@Autowired
	private BookMapper bookMapper;

    // <<-- 1. 새로운 NaverBookService를 주입받습니다.
    @Autowired
    private NaverBookService naverBookService;
	
    @Transactional
	public int saveBook(Book book) {
		return bookMapper.save(book);
	}

    // <<-- 2. getBook 메서드는 이제 ISBN을 기준으로 동작하는 새로운 메서드로 대체됩니다.
    @Transactional(readOnly = true)
    public Book getBook(int id) {
	 	return bookMapper.findById(id);
	}
	
    @Transactional(readOnly = true)
	public List<Book> getBookList() {
		return bookMapper.findAll();
	}

    // <<-- 3. 키워드 검색 메서드를 하이브리드 방식으로 수정합니다.
    @Transactional(readOnly = true)
	public List<Book> findByKeyword(String keyword) {
		// 3-1. 우선 내 DB에서 키워드로 검색합니다.
		List<Book> localResults = bookMapper.findByKeyword("%"+ keyword+ "%");
		
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
    @Transactional
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
	
    @Transactional
	public int updateBook(Book book) {
		return bookMapper.update(book);
	}
    @Transactional
	public int deleteBook(int id) {
		return bookMapper.delete(id);
	}
    @Transactional(readOnly = true)
	public List<Book> getExistBookList() {
		return bookMapper.findExistBook();
	}
	
	//cart 
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
	
	//purchase 
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
	
	@Transactional(readOnly = true)
	public List<MyPurchaseView> getMyPurchaseView(int id) {
		return purchaseMapper.findMyPurchaseView(id);
	}

	@Transactional(readOnly = true)
    public String getRoleByUsername(String username) {
        Member member = memberMapper.findByUsername(username);
        if (member != null) {
            return member.getRole();
        }
        return "ROLE_USER";
    }
    @Transactional(readOnly = true)
	public Member getMemberbyId(String userId) {
		return memberMapper.findByUserId(userId);
	}
	
}