package controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
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
@RequestMapping("user")		//index �럹�씠吏� �뾾�쓣 �떆 異붽�
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
	    pageList.put("list", keyword != null ? service.findByKeyword(keyword) : service.getBookList());
	    pageList.put("totalCount", service.getBookList().size());
	    pageList.put("currentPage", 1);
	    pageList.put("totalPage", 1);
	    model.addAttribute("pageList", pageList);
	    return "index";
	}
	
	@RequestMapping("bookdetail")
	public String bookDetail(@RequestParam int id, Model model) {
		// id濡� 梨� �젙蹂대�� 議고쉶
	    Book book = service.getBook(id);
	    
	    // �씠誘몄� 寃쎈줈 �깮�꽦 (static/images/ 寃쎈줈�� 梨� �씠誘몄� �뙆�씪紐� 寃고빀)
	    String imagePath = "/static/images/" + book.getImg();  // "�샎紐�.jpg"�� 寃고빀�븯�뿬 /static/images/�샎紐�.jpg濡� 留뚮벀
	    
	    // 梨� �젙蹂댁� �씠誘몄� 寃쎈줈, �럹�씠吏� �젙蹂대�� 紐⑤뜽�뿉 異붽�
	    model.addAttribute("book", book);
	    model.addAttribute("imagePath", imagePath);  // �씠誘몄� 寃쎈줈 異붽�
	    model.addAttribute("page", MAIN_URL + "bookdetail");
	    
	    // imagePath瑜� �솗�씤�븯湲� �쐞�빐 濡쒓렇 異쒕젰
	    System.out.println("Image Path: " + imagePath);  // 肄섏넄�뿉�꽌 寃쎈줈 �솗�씤
	    
	    
	    return "index";  // index.jsp�뿉�꽌 bookdetail.jsp瑜� include�븯�룄濡� 泥섎━
	}
	
	@RequestMapping("loginform")
	public String loginForm(Model model) {
		model.addAttribute("page", MAIN_URL + "loginform");
		return "index";
	}
	
	@GetMapping("login")
	public String loginPage(@RequestParam(value = "error", required = false) String error, Model model) {
	    if (error != null) {
	        model.addAttribute("loginError", "아이디 또는 비밀번호가 잘못되었습니다.");
	    }
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
//	            redirectAttributes.addFlashAttribute("successMessage", "愿�由ъ옄 " + member.getName() +"�떂 �뼱�꽌�삤�꽭�슂.");
//				return "redirect:/"+"manager/"+"booklist";
//			}
//			else if(member.getRole().equals("ROLE_USER")) {
//				session.setAttribute("login", member);
//	            redirectAttributes.addFlashAttribute("successMessage", member.getName() +"�떂 �뼱�꽌�삤�꽭�슂.");
//				return "redirect:/"+MAIN_URL+"booklist";
//			}
//		}
//        redirectAttributes.addFlashAttribute("errorMessage", "�븘�씠�뵒 �삉�뒗 鍮꾨쾲�씠 ���졇�뒿�땲�떎.");
//		return "redirect:/"+MAIN_URL+"loginform";
//	}


//	@RequestMapping("logout")
//	public String logout(HttpSession session) {
//		session.invalidate();
//		return "redirect:/"+MAIN_URL+"booklist";
//	}


	@RequestMapping("register")
	public String register(@ModelAttribute Member member, RedirectAttributes redirectAttributes) {
		boolean registered = service.registerMember(member);
		String result = (registered) ? "�쉶�썝媛��엯�씠 �셿猷뚮릺�뿀�뒿�땲�떎. 濡쒓렇�씤�빐二쇱꽭�슂." : "�씠誘� 議댁옱�븯�뒗 �븘�씠�뵒�엯�땲�떎. �떎瑜� �븘�씠�뵒瑜� �궗�슜�빐二쇱꽭�슂.";
		//�궫�엯 寃곌낵�뿉 �뵲�씪 硫붿꽭吏��� �럹�씠吏� 寃곗젙
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
	
	@RequestMapping("mypurchaselist")
	public String mypurchaselist(Model model) {
		 Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		    String username = "";

		    // 인증 객체에서 사용자 이름 추출
		    if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
		        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
		        username = userDetails.getUsername();
		    } else {
		        // 예외 또는 기타 처리
		        username = authentication.getName(); // 보통 이 경우에도 username이 들어 있음
		    }
		    int id = service.findId(username);
		model.addAttribute("purchaseList", service.getMyPurchaseView(id));
		model.addAttribute("page", MAIN_URL + "mypurchaselist");
		return "index";
	}
}