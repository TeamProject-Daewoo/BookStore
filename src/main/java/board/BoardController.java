package board;

import lombok.RequiredArgsConstructor;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

	@Autowired
    private final BoardService boardService;  // ★ BoardService 주입

    private static final String MAIN_URL = "board/";

    @GetMapping("/main")
    public String boardMain(Model model,
                            @RequestParam(defaultValue = "1") int page,
                            @RequestParam(defaultValue = "10") int size) {
        List<Board> posts = boardService.findPage(page, size);  // var → List<Board>
        int totalCount = boardService.countAll();
        int totalPages = (int) Math.ceil((double) totalCount / size);

        model.addAttribute("posts", posts);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("size", size);
        model.addAttribute("page", "board/main");
        return "index";
    }


    // 작성 폼
    @GetMapping("/write")
    public String writeForm(Model model) {
        model.addAttribute("page", MAIN_URL + "write");
        return "index";
    }

    // 작성 저장
    @PostMapping("/write")
    public String writeSubmit(@RequestParam String title,
                              @RequestParam String author,
                              @RequestParam String content,
                              java.security.Principal principal) {
    	
    	System.out.println(author);
        String userId = principal.getName(); // 로그인한 user_id

        Board post = Board.builder()
                .title(title)
                .author(author)
                .content(content)
                .user_id(userId)
                .build();

        boardService.save(post);
        return "redirect:/board/main";
    }
    
    // ✅ 상세 보기
    @GetMapping("/view")
    public String view(@RequestParam Long id, Model model) {
    	boardService.incrementViewCount(id);  // 조회수 증가
        Board post = boardService.findById(id);
        if (post == null) {
            return "redirect:/board/main";
        }
        model.addAttribute("post", post);
        model.addAttribute("page", MAIN_URL + "view"); // /WEB-INF/views/board/view.jsp
        return "index";
    }
    
 // ✅ 수정 폼 (소유자만 접근)
    @GetMapping("/edit")
    public String editForm(@RequestParam Long id, Model model, Principal principal) {
        Board post = boardService.findById(id);
        if (post == null) return "redirect:/board/main";
        if (!post.getUser_id().equals(principal.getName())) {
            return "redirect:/board/main";
        }
        model.addAttribute("post", post);
        model.addAttribute("page", MAIN_URL + "edit");
        return "index";
    }

    // ✅ 수정 처리 (소유자만)
    @PostMapping("/update")
    public String update(@RequestParam Long id,
                         @RequestParam String title,
                         @RequestParam String content,
                         Principal principal) {

        Board toUpdate = Board.builder()
                .id(id)
                .title(title)
                .content(content)
                .build();

        int updated = boardService.updateOwned(toUpdate, principal.getName());
        if (updated == 0) {
            // 권한 없음 또는 글 없음
            return "redirect:/board/main";
        }
        return "redirect:/board/view?id=" + id;
    }

    // ✅ 삭제 (소유자만)
    @PostMapping("/delete")
    public String delete(@RequestParam Long id, Principal principal) {
        boardService.deleteOwned(id, principal.getName());
        return "redirect:/board/main";
    }
}
