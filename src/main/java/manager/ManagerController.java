package manager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import data.Book;
import review.Review;
import review.ReviewService;
import user.Member;

@Controller
@RequestMapping("/manager")
public class ManagerController {
	
    @Autowired
    ManagerService managerService;
    
    @Autowired
    ReviewService reviewService;
    
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
    public String bookList(Model model, String keyword) {
        model.addAttribute("page", MAIN_URL +"booklist");

        List<Book> books;
        if (keyword != null && !keyword.isEmpty()) {
            books = managerService.findByKeyword(keyword); // ✅ DB + API 결과
        } else {
            books = managerService.getExistBookList(); // ✅ DB 데이터
        }

        Map<String, Object> pageList = new HashMap<>();
        pageList.put("list", books);
        pageList.put("totalCount", books.size());
        pageList.put("currentPage", 1);
        pageList.put("totalPage", 1);

        model.addAttribute("pageList", pageList);
        model.addAttribute("keyword", keyword);
        model.addAttribute("activeTab", "booklist");
        return "index";
    }
    
 // <<-- 1. bookDetail 메서드 수정 -->>
    @RequestMapping("bookdetail")
    // 파라미터를 int id 대신 String isbn으로 받습니다.
    public String bookDetail(@RequestParam String isbn, Model model, Authentication authentication) {
        // ISBN으로 책 정보를 가져오는 하이브리드 메서드를 호출합니다.
        Book book = managerService.getBookByIsbn(isbn);
        
        // 만약 책 정보가 DB에 저장된 후라면, book.getId()로 리뷰 조회가 가능합니다.
        if (book != null && book.getId() != null) {
			List<Review> reviews = reviewService.getReviewsByBookId(book.getId());
            model.addAttribute("reviews", reviews);
            
            // 평균 평점 계산
            double averageRating = 0.0;
            if (!reviews.isEmpty()) {
                averageRating = reviews.stream()
                                       .mapToInt(Review::getRating)
                                       .average()
                                       .orElse(0.0);
            }
            model.addAttribute("averageRating", averageRating);
        }

        // 네이버 API는 이미지 전체 URL을 제공하므로 경로를 따로 만들 필요가 없습니다.
        // book.getImg()에 전체 URL이 들어있습니다.
        // String imagePath = "/static/images/" + book.getImg(); 

        if(authentication != null) {
            model.addAttribute("user", authentication.getName());
        }

        model.addAttribute("book", book);
        // model.addAttribute("imagePath", imagePath);
        model.addAttribute("page", MAIN_URL + "bookdetail");

        return "index";
    }
    
    @GetMapping("/managerview")
	public String managerList(Model model) {
	    model.addAttribute("members", managerService.getMemberList());
	    model.addAttribute("page", MAIN_URL+"managerview");
	    model.addAttribute("activeTab", "managerview");
	    return "index";
	}
    
    @GetMapping("/managereditform/{id}")
    public String managerEditForm(@PathVariable("id") int id, Model model, RedirectAttributes redirectAttributes) {
        Member member = managerService.getMember(id);
        if (member == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "회원 정보를 찾을 수 없습니다.");
            return "redirect:/manager/booklist";
        }
        model.addAttribute("member", member);
        model.addAttribute("page", MAIN_URL+"managereditform");
        return "index";
    }
	
    @PostMapping("/manageredit")
    public String managerEdit(
            @ModelAttribute Member member,
            @RequestParam(value="profileImageFile", required=false) MultipartFile profileImageFile,
            RedirectAttributes redirectAttributes,
            HttpSession session) {

        try {
            // 기존 회원 정보 가져오기
            Member existingMember = managerService.getMember(member.getId());
            if (existingMember == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "회원 정보를 찾을 수 없습니다.");
                return "redirect:/manager/booklist";
            }

            // 비밀번호 처리 (입력 없으면 기존 비밀번호 유지)
            if (member.getPassword() == null || member.getPassword().trim().isEmpty()) {
                member.setPassword(existingMember.getPassword());
            }

            // 프로필 이미지 처리
            if (profileImageFile != null && !profileImageFile.isEmpty()) {
                // 새 이미지 업로드 시
                member.setProfileImage(profileImageFile.getBytes());
            } else {
                // 새 이미지 없으면 기존 이미지 유지
                member.setProfileImage(existingMember.getProfileImage());
            }

            // 역할 처리
            if (member.getRole() == null || member.getRole().trim().isEmpty()) {
                member.setRole(existingMember.getRole());
            }

            // DB 업데이트
            managerService.updateManager(member);

            // 세션 갱신
            Member updated = managerService.getMember(member.getId());
            session.setAttribute("login", updated);

            redirectAttributes.addFlashAttribute("successMessage", "회원 정보가 성공적으로 수정되었습니다.");
            return "redirect:/manager/booklist";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "회원 정보 수정 중 오류가 발생하였습니다: " + e.getMessage());
            return "redirect:/manager/managereditform/" + member.getId();
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
    public String dashboard(Model model) {
        //model.addAttribute("purchaseList", managerService.getPurchaseView());
        //model.addAttribute("totalsum", managerService.getTotalSum());
        model.addAttribute("page", MAIN_URL+"salesview");
        model.addAttribute("activeTab", "salesview");
        return "index";
    }
    
}