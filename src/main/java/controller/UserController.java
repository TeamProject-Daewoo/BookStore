package controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import service.UserService;
import vo.Book;
import vo.Member;

@Controller
@RequestMapping("user")		//index 페이지 없을 시 추가
public class UserController {
	
	@Autowired
	UserService service;
	final static String MAIN_URL = "user/";
	
//	@RequestMapping("index")
//	public String index(Model model) {
//		model.addAttribute("page", "index");
//		return "index"; 
//	}

	@RequestMapping("booklist")
	public String bookList(Model model, String keyword) {
	    model.addAttribute("page", MAIN_URL + "booklist");
	    Map<String, Object> pageList = new HashMap<>();
	    pageList.put("list", keyword != null ? service.findByKeyword(keyword) : service.getExistBookList());
	    pageList.put("totalCount", service.getBookList().size());
	    pageList.put("currentPage", 1);
	    pageList.put("totalPage", 1);
	    model.addAttribute("pageList", pageList);
	    return "index";
	}
	
	@RequestMapping("bookdetail")
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
	
	@RequestMapping("loginform")
	public String loginForm(Model model) {
		model.addAttribute("page", MAIN_URL + "loginform");
		return "index";
	}
	
//	@RequestMapping("cart")
//	public String cart(Model model) {
//		model.addAttribute("page", MAIN_URL + "cart");
//		//model.addAttribute("carts", service.getCartList());
//		return "index";
//	}
	
	@RequestMapping("purchase")
	public String purchase(Model model) {
		model.addAttribute("page", MAIN_URL + "purchase");
		return "index";
	}
	
	@RequestMapping("registerform")
	public String registerForm(Model model) {
		model.addAttribute("page", MAIN_URL + "registerform");
		return "index";
	}

//	@RequestMapping("user/login")
//	public String login(@RequestParam("user_id") String user_id, @RequestParam("password") String password,
//                        HttpSession session, RedirectAttributes redirectAttributes) {
//		Member member = service.login(user_id, password);
//		if (member != null) {
//			if(member.getRole().equals("ROLE_ADMIN")) {
//				session.setAttribute("login", member);
//	            redirectAttributes.addFlashAttribute("successMessage", "관리자 " + member.getName() +"님 어서오세요.");
//				return "redirect:/"+"manager/"+"booklist";
//			}
//			else if(member.getRole().equals("ROLE_USER")) {
//				session.setAttribute("login", member);
//	            redirectAttributes.addFlashAttribute("successMessage", member.getName() +"님 어서오세요.");
//				return "redirect:/"+MAIN_URL+"booklist";
//			}
//		}
//        redirectAttributes.addFlashAttribute("errorMessage", "아이디 또는 비번이 틀렸습니다.");
//		return "redirect:/"+MAIN_URL+"loginform";
//	}


	@RequestMapping("logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/"+MAIN_URL+"booklist";
	}


	@RequestMapping("register")
	public String register(@ModelAttribute Member member, RedirectAttributes redirectAttributes) {
		boolean registered = service.registerMember(member);
		String result = (registered) ? "회원가입이 완료되었습니다. 로그인해주세요." : "이미 존재하는 아이디입니다. 다른 아이디를 사용해주세요.";
		//삽입 결과에 따라 메세지와 페이지 결정
		redirectAttributes.addFlashAttribute("result", result);
		return "redirect:/"+MAIN_URL+((registered) ? "loginform" : "registerform");
	}
	
	@RequestMapping("adminregisterform")
	public String adminregisterForm(Model model) {
		model.addAttribute("page", MAIN_URL + "adminregisterform");
		return "index";
	}
	
	@RequestMapping("adminregister")
	public String adminregister(@ModelAttribute Member member) {
		boolean registered = service.registerAdmin(member);
		return "redirect:/"+MAIN_URL+((registered) ? "loginform" : "adminregisterform");
	}
}