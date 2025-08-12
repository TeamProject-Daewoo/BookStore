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
import vo.Member;

@Controller
@RequestMapping("/manager")
public class ManagerController {
	
    @Autowired
    ManagerService managerService;
    
    final static String MAIN_URL = "manager/";

    @GetMapping("/insertform")
    public String insertForm(Model model) {
        model.addAttribute("page", MAIN_URL+"insertform");
        return "index";
    }

    @PostMapping("/insert")
    public String insertBook(@ModelAttribute Book book, RedirectAttributes redirectAttributes) {
        try {
            managerService.saveBook(book);
            redirectAttributes.addFlashAttribute("successMessage", "책을 성공적으로 추가하였습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "책 추가 중 오류가 발생하였습니다: " + e.getMessage());
        }
        return "redirect:/"+MAIN_URL+"booklist";
    }

    @GetMapping("/bookeditform")
    public String bookEditForm(@RequestParam("id") int id, Model model, RedirectAttributes redirectAttributes) {
        Book book = managerService.getBook(id);
        if (book == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "책을 찾을 수 없습니다.");
            return "redirect:/manager/booklist";
        }
        model.addAttribute("book", book);
        model.addAttribute("page", MAIN_URL+"bookeditform");
        return "index";
    }

    @PostMapping("/bookedit")
    public String bookEdit(@ModelAttribute Book book, RedirectAttributes redirectAttributes) {
        try {
            managerService.updateBook(book);
            redirectAttributes.addFlashAttribute("successMessage", "책 정보가 성공적으로 수정되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "책 정보 수정 중 오류가 발생하였습니다: " + e.getMessage());
        }
        return "redirect:/"+MAIN_URL+"booklist";
    }

    @GetMapping("/bookdelete")
    public String bookDelete(@RequestParam("id") int id, RedirectAttributes redirectAttributes) {
        try {
            managerService.deleteBook(id);
            redirectAttributes.addFlashAttribute("successMessage", "책이 성공적으로 삭제되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "책 삭제 중 오류가 발생하였습니다: " + e.getMessage());
        }
        return "redirect:/"+MAIN_URL+"booklist";
    }

    @GetMapping("/booklist")
    public String bookList(Model model) {
        model.addAttribute("list", managerService.getBookList());
        model.addAttribute("page", MAIN_URL+"booklist");
        return "index";
    }
    
    @RequestMapping("/purchaselist")
    public String buyList(Model model) {
        model.addAttribute("purchaseList", managerService.getPurchaseView());
        model.addAttribute("page", MAIN_URL+"purchaselist");
        return "index";
    }
    
    @GetMapping("/managerview")
	public String managerList(Model model) {
	    model.addAttribute("members", managerService.getMemberList());
	    return MAIN_URL+"managerview";  // managerview.jsp留� 諛섑솚
	}
	
	@GetMapping("/managereditform")
    public String managerEditForm(@RequestParam("id") int id, Model model, RedirectAttributes redirectAttributes) {
        Member member = managerService.getMember(id);
        if (member == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "회원 정보를 찾을 수 없습니다.");
            return "redirect:/"+MAIN_URL+"booklist";
        }
        model.addAttribute("member", member);
        model.addAttribute("page", MAIN_URL+"managereditform");
        return "index";
    }
	
	@PostMapping("/manageredit")
	    public String managerEdit(@ModelAttribute Member member, RedirectAttributes redirectAttributes, javax.servlet.http.HttpSession session) {
		try {
	        // 1. 湲곗〈 �쉶�썝 �젙蹂� 議고쉶
	        Member existingMember = managerService.getMember(member.getId());

	        if (existingMember == null) {
	            redirectAttributes.addFlashAttribute("errorMessage", "회원 정보를 찾을 수 없습니다.");
	            return "redirect:/"+MAIN_URL+"booklist";
	        }

	        // 2. 鍮꾨�踰덊샇 蹂�寃� �뿬遺� �솗�씤
	        String newPassword = member.getPassword();
	        if (newPassword == null || newPassword.trim().isEmpty()) {
	            // 鍮꾩뼱�엳�쑝硫� 湲곗〈 鍮꾨�踰덊샇 �쑀吏�
	            member.setPassword(existingMember.getPassword());
	        }

	        // 4. �뾽�뜲�씠�듃
	        managerService.updateMember(member);
	        
	        Member updated = managerService.getMember(member.getId());
	        session.setAttribute("login", updated);
	        
	        redirectAttributes.addFlashAttribute("successMessage", "회원 정보가 성공적으로 수정되었습니다.");
	        return "redirect:/"+MAIN_URL+"booklist";

	    } catch (Exception e) {
	        redirectAttributes.addFlashAttribute("errorMessage", "회원 정보 수정 중 오류가 발생하였습니다: " + e.getMessage());
	        return "redirect:/"+MAIN_URL+"managereditform";
	    }
		
	 }

    @GetMapping("/managerdelete")
    public String mangerDelete(@RequestParam("id") int id, RedirectAttributes redirectAttributes, javax.servlet.http.HttpSession session) {
        try {
            managerService.deleteMember(id);
	        
            redirectAttributes.addFlashAttribute("successMessage", "회원이 성공적으로 삭제되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "회원 삭제 중 오류가 발생하였습니다: " + e.getMessage());
        }
        return "redirect:/"+MAIN_URL+"booklist";
    }
    
    @GetMapping("/salesview")
	public String salesview() {
    	return MAIN_URL+"salesview";
	}
    
}