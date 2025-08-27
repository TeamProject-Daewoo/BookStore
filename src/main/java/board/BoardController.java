package board;

import lombok.RequiredArgsConstructor;
import review.Review;
import review.ReviewService;
import user.UserService;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import comment.Comment;
import comment.CommentService;
import data.Book;

@Controller
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

	
	@Autowired
    private final BoardService boardService;  // ★ BoardService 주입

	@Autowired
	private final UserService userService;
	
	@Autowired
	private CommentService commentService;
	    
	  
    private static final String MAIN_URL = "board/";

    @GetMapping("/main")
    public String boardMain(Model model,
                            @RequestParam(defaultValue = "1") int page,
                            @RequestParam(defaultValue = "10") int size) {
        List<Board> posts = boardService.findPage(page, size);
        
        // 각 게시글에 댓글 수 추가
        for (Board post : posts) {
            int commentCount = commentService.countByBoardId(post.getId());
            post.setCommentCount(commentCount); // Board 클래스에 필드 추가 필요
        }

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
    public String view(@RequestParam Long id, Model model, Principal principal) {
        boardService.incrementViewCount(id);  
        List<Comment> comments = commentService.getCommentsByBoardId(id); 
        model.addAttribute("comments", comments); 
        
        Board post = boardService.findById(id);
        if (post == null) {
            return "redirect:/board/main";
        }
        model.addAttribute("post", post);
        
        // ✅ 로그인 사용자 정보 추가
        if (principal != null) {
            String userId = principal.getName();
            model.addAttribute("user", userId);
            
            String role = userService.getRoleByUsername(userId); // ex: ROLE_USER or ROLE_ADMIN
            model.addAttribute("userRoles", role);
        }
        
        model.addAttribute("page", MAIN_URL + "view"); 
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

    // ✅ 삭제 (소유자 / 관리자 가능)
    @PostMapping("/delete")
    public String delete(@RequestParam Long id, Principal principal) {
        String currentUserId = principal.getName();
        boolean isAdmin = isAdmin(principal); // 관리자 여부 체크

        try {
            boardService.deleteOwned(id, currentUserId, isAdmin);
        } catch (IllegalArgumentException e) {
            String errorMessage = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
            return "redirect:/board/main?error=" + errorMessage + "&cartCount=0";
        }

        return "redirect:/board/main";
    }

    // 관리자 여부 체크 메서드
    private boolean isAdmin(Principal principal) {
        String role = userService.getRoleByUsername(principal.getName());
        return "ROLE_ADMIN".equals(role);  // ROLE_ADMIN이면 관리자
    }
    
    @RequestMapping("addComment")
    public String addComment(@RequestParam int boardId, @ModelAttribute Comment comment, Authentication authentication) {
        comment.setUserId(authentication.getName());
        comment.setBoardId(boardId); // 게시판 ID 설정
        commentService.saveComment(comment); // 댓글 저장 서비스 호출
        return "redirect:/board/view?id=" + boardId; // 게시글 상세보기로 리다이렉트
    }

    @RequestMapping("/commentDelete")
    public String deleteComment(@RequestParam int commentId) {
        int boardId = commentService.findById(commentId).getBoardId(); // 해당 댓글의 게시판 ID 추출
        commentService.deleteComment(commentId); // 댓글 삭제 서비스 호출
        return "redirect:/board/view?id=" + boardId; // 게시글 상세보기로 리다이렉트
    }

    @PostMapping("/commentEdit")
    public String editComment(@ModelAttribute Comment comment, RedirectAttributes redirectAttributes) {

        if(comment.getCommentId() == null) {
            redirectAttributes.addFlashAttribute("msg", "댓글 ID가 존재하지 않습니다.");
            return "redirect:/board/view?id=" + comment.getBoardId();
        }

        commentService.updateComment(comment);

        return "redirect:/board/view?id=" + comment.getBoardId();
    }
}
