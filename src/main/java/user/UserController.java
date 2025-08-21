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
import org.springframework.security.core.userdetails.UsernameNotFoundException;
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
@RequestMapping("user")		//index 페이지 없을 시 추가
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
	public String bookDetail(@RequestParam int id, Model model, Authentication authentication) {
		// id로 책 정보를 조회
	    Book book = service.getBook(id);
	    List<Review> reviews = reviewService.getReviewsByBookId(id);
	    
	    // 이미지 경로 생성 (static/images/ 경로와 책 이미지 파일명 결합)
	    String imagePath = "/static/images/" + book.getImg();  // "혼모.jpg"와 결합하여 /static/images/혼모.jpg로 만듦
	    
	    if(authentication != null) {
	        model.addAttribute("user", authentication.getName());
	    }
	    
	    System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" + reviews);
	    
	    // 책 정보와 이미지 경로, 페이지 정보를 모델에 추가
	    model.addAttribute("book", book);
	    model.addAttribute("reviews", reviews);
	    model.addAttribute("imagePath", imagePath);  // 이미지 경로 추가
	    model.addAttribute("page", MAIN_URL + "bookdetail");
	    
	    // imagePath를 확인하기 위해 로그 출력
	    System.out.println("Image Path: " + imagePath);  // 콘솔에서 경로 확인
	    
	    return "index";  // index.jsp에서 bookdetail.jsp를 include하도록 처리
	}
	
	@RequestMapping("addReview")
    public String addReview(@ModelAttribute Review review, Authentication authentication) {
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

    // 리뷰 수정 처리
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
		model.addAttribute("checkIdUrl", "/user/checkId");
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
	
	@GetMapping("login")
	public String loginPage(@RequestParam(value = "error", required = false) String error, Model model) {
	    if (error != null) {
	        model.addAttribute("loginError", "아이디 또는 비밀번호가 잘못되었습니다.");
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
	
	@GetMapping("checkId")
	@ResponseBody
	public Map<String, Boolean> checkId(@RequestParam String user_id) {
	    boolean exists = service.isUserIdExist(user_id);  // UserService에서 DB 조회
	    Map<String, Boolean> result = new HashMap<>();
	    result.put("exists", exists);
	    return result;
	}
	
	@RequestMapping("mypage/{username}")
	public String mypage(@PathVariable("username") String username, Model model) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String name = "";

	    // 인증 객체에서 사용자 이름 추출
	    if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
	        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
	        name = userDetails.getUsername();
	    } else {
	        // 예외 또는 기타 처리
	    	name = authentication.getName(); // 보통 이 경우에도 username이 들어 있음
	    }
	    
	    Member member = service.findByUsername(name);
	    
	    int id = member.getId();
	    
	    // DB에서 Member 객체 가져오기
	    Member user = service.findById(id); // UserService에 구현 필요
	    model.addAttribute("user", user); // Member 전체를 JSP에 전달
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
        
        System.out.println("현재 비밀번호 =============================" + currentPassword);
        System.out.println("기존 비밀번호 =============================" + encodedPassword);

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
	                         RedirectAttributes redirectAttributes) throws UsernameNotFoundException, IOException {
		
		if (member.getId() == null) {
	        redirectAttributes.addFlashAttribute("error", "잘못된 요청입니다. ID가 없습니다.");
	        return "redirect:/user/mypage/" + member.getUser_id();
	    }
		
		if (profileImageFile != null && !profileImageFile.isEmpty()) {
		    member.setProfileImage(profileImageFile.getBytes());
		} else if (member.getProfileImage() == null) {
		    // 기본 이미지 넣기
		    ClassPathResource defaultImg = new ClassPathResource("static/profileimage/default.jpg");
		    member.setProfileImage(FileCopyUtils.copyToByteArray(defaultImg.getInputStream()));
		}

	    service.updateMember(member);

	    UserDetails updatedUser = userDetailsService.loadUserByUsername(member.getUser_id());

	    Authentication newAuth = new UsernamePasswordAuthenticationToken(
	            updatedUser, null, updatedUser.getAuthorities());
	    SecurityContextHolder.getContext().setAuthentication(newAuth);

	    redirectAttributes.addFlashAttribute("message", "개인정보 수정이 완료되었습니다");
	    redirectAttributes.addAttribute("username", service.findById(member.getId()).getUser_id());

	    return "redirect:/"+MAIN_URL+ "mypage/{username}";
	}
	
	//프로필 사진 적용 : 마이페이지 및 수정페이지에 적용하기 위해 사용
	@GetMapping("profileImage/{id}")
	@ResponseBody
	public ResponseEntity<byte[]> getProfileImage(@PathVariable("id") int id) {
	    Member user = service.findById(id);
	    byte[] imageBytes = null;

	    try {
	        if(user != null && user.getProfileImage() != null) {
	            imageBytes = user.getProfileImage();
	        } else {
	            // DB에 이미지 없으면 기본 이미지 제공
	            ClassPathResource defaultImg = new ClassPathResource("static/profileimage/default.jpg");
	            imageBytes = FileCopyUtils.copyToByteArray(defaultImg.getInputStream());
	        }
	    } catch(IOException e) {
	        e.printStackTrace();
	    }

	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.IMAGE_JPEG);
	    return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
	}
	
	//프로필 사진 적용 : 헤더에 적용하기 위함
	@GetMapping("profileImageByUsername/{username}")
	@ResponseBody
	public ResponseEntity<byte[]> getProfileImageByUsername(@PathVariable String username) throws IOException {
	    Member user = service.findByUsername(username);
	    byte[] imageBytes;
	    System.out.println("username: " + username);
	    System.out.println("user object: " + user);
	    if(user != null) {
	        System.out.println("profileImage: " + user.getProfileImage());
	    }
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