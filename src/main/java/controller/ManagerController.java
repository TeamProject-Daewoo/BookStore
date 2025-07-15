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
    
    @RequestMapping("/purchaselist")
    public String buyList(Model model) {
        model.addAttribute("purchaseList", managerService.getPurchaseView());
        System.out.println(managerService.getPurchaseView());
        model.addAttribute("page", "manager/purchaselist");
        return "index";
    }
    
    @GetMapping("/managerview")
	public String managerList(Model model) {
	    model.addAttribute("members", managerService.getMemberList());
	    return "manager/managerview";  // managerview.jsp만 반환
	}
	
	@GetMapping("/managereditform")
    public String managerEditForm(@RequestParam("id") int id, Model model, RedirectAttributes redirectAttributes) {
        Member member = managerService.getMember(id);
        if (member == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "계정 정보를 찾을 수 없습니다.");
            return "redirect:/manager/booklist";
        }
        model.addAttribute("member", member);
        model.addAttribute("page", "manager/managereditform");
        return "index";
    }
	
	@PostMapping("/manageredit")
	    public String managerEdit(@ModelAttribute Member member, RedirectAttributes redirectAttributes, javax.servlet.http.HttpSession session) {
		try {
	        // 1. 기존 회원 정보 조회
	        Member existingMember = managerService.getMember(member.getId());

	        if (existingMember == null) {
	            redirectAttributes.addFlashAttribute("errorMessage", "계정 정보를 찾을 수 없습니다.");
	            return "redirect:/manager/booklist";
	        }

	        // 2. 비밀번호 변경 여부 확인
	        String newPassword = member.getPassword();
	        if (newPassword == null || newPassword.trim().isEmpty()) {
	            // 비어있으면 기존 비밀번호 유지
	            member.setPassword(existingMember.getPassword());
	        }

	        // 4. 업데이트
	        managerService.updateMember(member);
	        
	        Member updated = managerService.getMember(member.getId());
	        session.setAttribute("login", updated);
	        
	        redirectAttributes.addFlashAttribute("successMessage", "계정 정보가 성공적으로 수정되었습니다.");
	        return "redirect:/manager/booklist";

	    } catch (Exception e) {
	        redirectAttributes.addFlashAttribute("errorMessage", "계정 정보 수정 중 오류가 발생했습니다: " + e.getMessage());
	        return "redirect:/manager/managereditform";
	    }
		
	 }
	 

    @GetMapping("/managerdelete")
    public String mangerDelete(@RequestParam("id") int id, RedirectAttributes redirectAttributes, javax.servlet.http.HttpSession session) {
        try {
            managerService.deleteMember(id);
	        
            redirectAttributes.addFlashAttribute("successMessage", "계정이 성공적으로 삭제되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "계정 삭제 중 오류가 발생했습니다: " + e.getMessage());
        }
        return "redirect:/manager/loginform";
    }
}