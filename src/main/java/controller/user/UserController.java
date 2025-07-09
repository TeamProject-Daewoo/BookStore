package controller.user;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import service.user.UserService;
import vo.Book;

@Controller
public class UserController {
	
	@Autowired
	UserService service;
	final static String MAIN_URL = "user/";
	
//	@RequestMapping("index")
//	public String index(Model model) {
//		model.addAttribute("page", "index");
//		return "index"; 
//	}

	@RequestMapping("user/booklist")
	public String bookList(Model model) {
	    List<Book> books = service.getBookList(); // Book 목록 받아오기
	    model.addAttribute("books", books);       // JSP로 전달
	    model.addAttribute("page", MAIN_URL + "booklist"); // 서브페이지 include용
	    return "index"; // index.jsp 안에 booklist.jsp가 include될 것
	}
	
	@RequestMapping("user/bookdetail")
	public String bookDetail(@RequestParam int id, Model model) {
	    // id로 책 정보를 조회
	    Book book = service.getBook(id);
	    
	    // 이미지 경로 생성 (static/images/ 경로와 책 이미지 파일명 결합)
	    String imagePath = "/static/images/" + book.getImg();  // "혼모.jpg"와 결합하여 /static/images/혼모.jpg로 만듦
	    
	    // 책 정보와 이미지 경로, 페이지 정보를 모델에 추가
	    model.addAttribute("book", book);
	    model.addAttribute("imagePath", imagePath);  // 이미지 경로 추가
	    model.addAttribute("page", MAIN_URL + "bookdetail");
	    
	    // imagePath를 확인하기 위해 로그 출력
	    System.out.println("Image Path: " + imagePath);  // 콘솔에서 경로 확인
	    
	    return "index";  // index.jsp에서 bookdetail.jsp를 include하도록 처리
	}
	
	@RequestMapping("user/loginform")
	public String loginForm(Model model) {
		model.addAttribute("page", MAIN_URL + "loginform");
		return "index";
	}
	
	@RequestMapping("user/cart")
	public String cart(Model model) {
		model.addAttribute("page", MAIN_URL + "cart");
		//model.addAttribute("carts", service.getCartList());
		return "index";
	}
	
	@RequestMapping("user/purchase")
	public String purchase(Model model) {
		model.addAttribute("page", MAIN_URL + "purchase");
		return "index";
	}
	
	@RequestMapping("user/registerform")
	public String registerForm(Model model) {
		model.addAttribute("page", MAIN_URL + "registerform");
		return "index";
	}	
}