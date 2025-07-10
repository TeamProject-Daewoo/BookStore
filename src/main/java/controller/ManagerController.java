package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import service.ManagerService;
import vo.Book;

@Controller
@RequestMapping("/manager")
public class ManagerController {
	
    @Autowired
    ManagerService managerService;

	@RequestMapping("index")
	public String index(Model model) {
		model.addAttribute("page", "user/" + "index");
		return "index"; 
	}
	
	@RequestMapping("cart")
	public String cart(Model model) {
		model.addAttribute("page", "user/" + "cart");
		return "cart"; 
	}

    @GetMapping("/insertform")
    public String insertForm(Model model) {
        model.addAttribute("page", "manager/insertform");
        return "index";
    }

    @PostMapping("/insert")
    public String insertBook(@ModelAttribute Book book, RedirectAttributes redirectAttributes) {
        try {
            managerService.saveBook(book);
            redirectAttributes.addFlashAttribute("successMessage", "책이 성공적으로 추가되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "책 추가 중 오류가 발생했습니다: " + e.getMessage());
        }
        return "redirect:/manager/booklist";
    }

    @GetMapping("/bookeditform")
    public String bookEditForm(@RequestParam("id") int id, Model model, RedirectAttributes redirectAttributes) {
        Book book = managerService.getBook(id);
        if (book == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "책을 찾을 수 없습니다.");
            return "redirect:/manager/booklist";
        }
        model.addAttribute("book", book);
        model.addAttribute("page", "manager/bookeditform");
        return "index";
    }

    @PostMapping("/bookedit")
    public String bookEdit(@ModelAttribute Book book, RedirectAttributes redirectAttributes) {
        try {
            managerService.updateBook(book);
            redirectAttributes.addFlashAttribute("successMessage", "책 정보가 성공적으로 수정되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "책 정보 수정 중 오류가 발생했습니다: " + e.getMessage());
        }
        return "redirect:/manager/booklist";
    }

    @GetMapping("/bookdelete")
    public String bookDelete(@RequestParam("id") int id, RedirectAttributes redirectAttributes) {
        try {
            managerService.deleteBook(id);
            redirectAttributes.addFlashAttribute("successMessage", "책이 성공적으로 삭제되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "책 삭제 중 오류가 발생했습니다: " + e.getMessage());
        }
        return "redirect:/manager/booklist";
    }

    @GetMapping("/booklist")
    public String bookList(Model model) {
        model.addAttribute("list", managerService.getBookList());
        model.addAttribute("page", "manager/booklist");
        return "index";
    }
    
    @RequestMapping("loginform")
	public String loginForm(Model model) {
		model.addAttribute("page", "manager/loginform");
		return "index";
	}
	
	@RequestMapping("registerform")
	public String registerForm(Model model) {
		model.addAttribute("page", "manager/registerform");
		return "index";
	}

	@RequestMapping("login")
	public String login(@RequestParam("user_id") String user_id, @RequestParam("password") String password,
                        javax.servlet.http.HttpSession session, RedirectAttributes redirectAttributes) {
		vo.Member member = managerService.login(user_id, password);
		if (member != null) {
			session.setAttribute("login", member);
            redirectAttributes.addFlashAttribute("successMessage", "로그인 되었습니다.");
			return "redirect:/manager/booklist";
		}
        redirectAttributes.addFlashAttribute("errorMessage", "아이디 또는 비번이 틀렸습니다.");
		return "redirect:/manager/loginform";
	}

	@RequestMapping("logout")
	public String logout(javax.servlet.http.HttpSession session) {
		session.invalidate();
		return "redirect:/manager/booklist";
	}

	@RequestMapping("register")
	public String register(@ModelAttribute vo.Member member, RedirectAttributes redirectAttributes) {
		member.setRole("ROLE_ADMIN");
		boolean registered = managerService.registerMember(member);
		if (registered) {
			redirectAttributes.addFlashAttribute("successMessage", "회원가입이 완료되었습니다. 로그인해주세요.");
			return "redirect:/manager/loginform";
		} else {
			redirectAttributes.addFlashAttribute("errorMessage", "이미 존재하는 아이디입니다. 다른 아이디를 사용해주세요.");
			return "redirect:/manager/registerform";
		}
	}
}