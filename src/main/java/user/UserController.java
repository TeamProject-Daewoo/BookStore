package user;

import java.io.IOException;
import org.springframework.http.HttpHeaders;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import data.Book;
import login.CustomUserDetailsService;
import review.Review;
import review.ReviewService;

@Controller
@RequestMapping("user")
public class UserController {

    @Autowired
    UserService service;
    final static String MAIN_URL = "user/";

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private ReviewService reviewService;

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
    public String bookDetail(@RequestParam int id, Model model, Authentication authentication) {
        Book book = service.getBook(id);
        List<Review> reviews = reviewService.getReviewsByBookId(id);

        String imagePath = "/static/images/" + book.getImg();

        if(authentication != null) {
            model.addAttribute("user", authentication.getName());
        }

        model.addAttribute("book", book);
        model.addAttribute("reviews", reviews);
        model.addAttribute("imagePath", imagePath);
        model.addAttribute("page", MAIN_URL + "bookdetail");

        System.out.println("Image Path: " + imagePath);

        return "index";
    }

    @RequestMapping("addReview")
    public String addReview(@ModelAttribute Review review, Authentication authentication) throws IOException {
        review.setUserId(authentication.getName());
        reviewService.saveReview(review);
        return "redirect:/user/bookdetail?id=" + review.getBookId();
    }

    @RequestMapping("/reviewDelete")
    public String deleteReview(@RequestParam int reviewId) {
        int bookId = reviewService.findById(reviewId).getBookId();
        reviewService.deleteReview(reviewId);
        return "redirect:/user/bookdetail?id=" + bookId;
    }

    @GetMapping("/reviewEdit")
    public String editForm(@RequestParam Integer reviewId, Model model) {
        Review review = reviewService.findById(reviewId);
        model.addAttribute("review", review);
        model.addAttribute("page", MAIN_URL + "reviewedit");
        return "index";
    }

    @PostMapping("/reviewEdit")
    public String editReview(@ModelAttribute Review review) {
        reviewService.updateReview(review);
        Integer bookId = reviewService.findById(review.getReviewId()).getBookId();
        return "redirect:/user/bookdetail?id=" + bookId;
    }

    @RequestMapping("loginform")
    public String loginForm(Model model) {
        model.addAttribute("page", MAIN_URL + "loginform");
        return "index";
    }

    @RequestMapping("purchase")
    public String purchase(Model model) {
        model.addAttribute("page", MAIN_URL + "purchase");
        return "index";
    }

    @RequestMapping("registerform")
    public String registerForm(Model model) {
        model.addAttribute("page", MAIN_URL + "registerform");
        model.addAttribute("checkIdUrl", "/user/checkId");
        return "index";
    }

    @GetMapping("login")
    public String loginPage(@RequestParam(value = "error", required = false) String error, Model model) {
        if (error != null) {
            model.addAttribute("loginError", "아이디 또는 비밀번호가 올바르지 않습니다.");
        }
        model.addAttribute("page", MAIN_URL + "loginform");
        return "index";
    }

    @RequestMapping("logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/"+MAIN_URL+"booklist";
    }

    @RequestMapping("register")
    public String register(@ModelAttribute Member member, RedirectAttributes redirectAttributes) {
        boolean registered = service.registerMember(member);
        String result = (registered) ? "회원가입이 완료되었습니다. 로그인 후 이용해주세요." : "이미 사용 중인 아이디입니다. 다른 아이디를 입력해주세요.";
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

        if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            username = userDetails.getUsername();
        } else {
            username = authentication.getName();
        }

        int id = service.findId(username);
        model.addAttribute("purchaseList", service.getMyPurchaseView(id));
        model.addAttribute("page", MAIN_URL + "mypurchaselist");
        return "index";
    }

    @GetMapping("checkId")
    @ResponseBody
    public Map<String, Boolean> checkId(@RequestParam String user_id) {
        boolean exists = service.isUserIdExist(user_id);
        Map<String, Boolean> result = new HashMap<>();
        result.put("exists", exists);
        return result;
    }

    @RequestMapping("mypage/{username}")
    public String mypage(@PathVariable("username") String username, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String name = "";

        if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            name = userDetails.getUsername();
        } else {
            name = authentication.getName();
        }

        Member member = service.findByUsername(name);
        int id = member.getId();

        Member user = service.findById(id);
        model.addAttribute("user", user);
        model.addAttribute("purchaseList", service.getMyPurchaseView(id));

        model.addAttribute("id", id);
        model.addAttribute("username", service.findById(id).getUser_id());
        model.addAttribute("page", MAIN_URL + "mypage");
        return "index";
    }

    @RequestMapping("checkPasswordform")
    public String confirmPassword(Model model) {
        model.addAttribute("page", MAIN_URL + "checkPasswordform");
        return "index";
    }

    @RequestMapping("/checkPassword")
    public String checkPassword(@RequestParam("currentPassword") String currentPassword,
                                Authentication authentication,
                                RedirectAttributes redirectAttributes) {

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        int id = service.findId(userDetails.getUsername());
        String encodedPassword = service.findByUsername(userDetails.getUsername()).getPassword();

        if (!passwordEncoder.matches(currentPassword, encodedPassword)) {
            redirectAttributes.addFlashAttribute("error", "비밀번호가 일치하지 않습니다.");
            return "redirect:/user/checkPasswordform";
        }

        return "redirect:/user/editform/" + id;
    }

    @RequestMapping("editform/{id}")
    public String edit(@PathVariable("id") int id, Model model) {
        model.addAttribute("user", service.findById(id));
        model.addAttribute("checkIdUrl", "/user/checkId");
        model.addAttribute("page", MAIN_URL + "editform");
        return "index";
    }

    @RequestMapping("infoupdate")
    public String infoupdate(@ModelAttribute Member member,
                             @RequestParam(value = "profileImageFile", required = false) MultipartFile profileImageFile,
                             RedirectAttributes redirectAttributes) throws IOException {

        if (member.getId() == null) {
            redirectAttributes.addFlashAttribute("error", "잘못된 요청입니다. ID가 없습니다.");
            return "redirect:/user/mypage/" + member.getUser_id();
        }

        if (profileImageFile != null && !profileImageFile.isEmpty()) {
            member.setProfileImage(profileImageFile.getBytes());
        } else if (member.getProfileImage() == null) {
            ClassPathResource defaultImg = new ClassPathResource("static/profileimage/default.jpg");
            member.setProfileImage(FileCopyUtils.copyToByteArray(defaultImg.getInputStream()));
        }

        service.updateMember(member);

        UserDetails updatedUser = userDetailsService.loadUserByUsername(member.getUser_id());
        Authentication newAuth = new UsernamePasswordAuthenticationToken(
                updatedUser, null, updatedUser.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(newAuth);

        redirectAttributes.addFlashAttribute("message", "회원 정보가 수정되었습니다.");
        redirectAttributes.addAttribute("username", service.findById(member.getId()).getUser_id());

        return "redirect:/"+MAIN_URL+ "mypage/{username}";
    }

    @GetMapping("profileImage/{id}")
    @ResponseBody
    public ResponseEntity<byte[]> getProfileImage(@PathVariable("id") int id) throws IOException {
        Member user = service.findById(id);
        byte[] imageBytes;

        if(user != null && user.getProfileImage() != null) {
            imageBytes = user.getProfileImage();
        } else {
            ClassPathResource defaultImg = new ClassPathResource("static/profileimage/default.jpg");
            imageBytes = FileCopyUtils.copyToByteArray(defaultImg.getInputStream());
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_JPEG);
        return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
    }

    @GetMapping("profileImageByUsername/{username}")
    @ResponseBody
    public ResponseEntity<byte[]> getProfileImageByUsername(@PathVariable String username) throws IOException {
        Member user = service.findByUsername(username);
        byte[] imageBytes;

        if (user != null && user.getProfileImage() != null) {
            imageBytes = user.getProfileImage();
        } else {
            ClassPathResource defaultImg = new ClassPathResource("static/profileimage/default.jpg");
            imageBytes = FileCopyUtils.copyToByteArray(defaultImg.getInputStream());
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_JPEG);
        return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
    }
    

}
