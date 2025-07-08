package user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
		model.addAttribute("page", MAIN_URL + "booklist");
		//model.addAttribute("books", service.getBookList());
		return "index";
	}
	
	@RequestMapping("user/bookdetail")
	public String bookDetail(@RequestParam int id, Model model) {
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
