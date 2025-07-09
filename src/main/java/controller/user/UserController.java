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
	//@RequestParam int id ���Ŀ� �Ű������� ���� �ޱ�
	public String bookDetail(Model model) {
		model.addAttribute("page", MAIN_URL + "bookdetail");
		//model.addAttribute("book", service.getBook(id));
		return "index";
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