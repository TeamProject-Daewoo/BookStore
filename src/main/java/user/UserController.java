package user;

import java.io.IOException;
import org.springframework.http.HttpHeaders;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
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
@RequestMapping("user")		//index �럹�씠吏� �뾾�쓣 �떆 異붽�
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
		// id濡� 梨� �젙蹂대�� 議고쉶
	    Book book = service.getBook(id);
	    List<Review> reviews = reviewService.getReviewsByBookId(id);
	    
	    // �씠誘몄� 寃쎈줈 �깮�꽦 (static/images/ 寃쎈줈�� 梨� �씠誘몄� �뙆�씪紐� 寃고빀)
	    String imagePath = "/static/images/" + book.getImg();  // "�샎紐�.jpg"�� 寃고빀�븯�뿬 /static/images/�샎紐�.jpg濡� 留뚮벀
	    
	    if(authentication != null) {
	        model.addAttribute("user", authentication.getName());
	    }
	    
	    System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" + reviews);
	    
	    // 梨� �젙蹂댁� �씠誘몄� 寃쎈줈, �럹�씠吏� �젙蹂대�� 紐⑤뜽�뿉 異붽�
	    model.addAttribute("book", book);
	    model.addAttribute("reviews", reviews);
	    model.addAttribute("imagePath", imagePath);  // �씠誘몄� 寃쎈줈 異붽�
	    model.addAttribute("page", MAIN_URL + "bookdetail");
	    
	    // imagePath瑜� �솗�씤�븯湲� �쐞�빐 濡쒓렇 異쒕젰
	    System.out.println("Image Path: " + imagePath);  // 肄섏넄�뿉�꽌 寃쎈줈 �솗�씤
	    
	    return "index";  // index.jsp�뿉�꽌 bookdetail.jsp瑜� include�븯�룄濡� 泥섎━
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

    // 由щ럭 �닔�젙 泥섎━
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
	
	@GetMapping("login")
	public String loginPage(@RequestParam(value = "error", required = false) String error, Model model) {
	    if (error != null) {
	        model.addAttribute("loginError", "�븘�씠�뵒 �삉�뒗 鍮꾨�踰덊샇媛� �옒紐삳릺�뿀�뒿�땲�떎.");
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

		    // �씤利� 媛앹껜�뿉�꽌 �궗�슜�옄 �씠由� 異붿텧
		    if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
		        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
		        username = userDetails.getUsername();
		    } else {
		        // �삁�쇅 �삉�뒗 湲고� 泥섎━
		        username = authentication.getName(); // 蹂댄넻 �씠 寃쎌슦�뿉�룄 username�씠 �뱾�뼱 �엳�쓬
		    }
		    int id = service.findId(username);
		model.addAttribute("purchaseList", service.getMyPurchaseView(id));
		model.addAttribute("page", MAIN_URL + "mypurchaselist");
		return "index";
	}
	
	@GetMapping("checkId")
	@ResponseBody
	public Map<String, Boolean> checkId(@RequestParam String user_id) {
	    boolean exists = service.isUserIdExist(user_id);  // UserService�뿉�꽌 DB 議고쉶
	    Map<String, Boolean> result = new HashMap<>();
	    result.put("exists", exists);
	    return result;
	}
	
	@RequestMapping("mypage/{username}")
	public String mypage(@PathVariable("username") String username, Model model) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String name = "";

	    // �씤利� 媛앹껜�뿉�꽌 �궗�슜�옄 �씠由� 異붿텧
	    if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
	        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
	        name = userDetails.getUsername();
	    } else {
	        // �삁�쇅 �삉�뒗 湲고� 泥섎━
	    	name = authentication.getName(); // 蹂댄넻 �씠 寃쎌슦�뿉�룄 username�씠 �뱾�뼱 �엳�쓬
	    }
	    
	    Member member = service.findByUsername(name);
	    
	    int id = member.getId();
	    
	    // DB�뿉�꽌 Member 媛앹껜 媛��졇�삤湲�
	    Member user = service.findById(id); // UserService�뿉 援ы쁽 �븘�슂
	    model.addAttribute("user", user); // Member �쟾泥대�� JSP�뿉 �쟾�떖
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
        
        System.out.println("�쁽�옱 鍮꾨�踰덊샇 =============================" + currentPassword);
        System.out.println("湲곗〈 鍮꾨�踰덊샇 =============================" + encodedPassword);

        if (!passwordEncoder.matches(currentPassword, encodedPassword)) {
            redirectAttributes.addFlashAttribute("error", "鍮꾨�踰덊샇媛� �씪移섑븯吏� �븡�뒿�땲�떎.");
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
	        redirectAttributes.addFlashAttribute("error", "�옒紐삳맂 �슂泥��엯�땲�떎. ID媛� �뾾�뒿�땲�떎.");
	        return "redirect:/user/mypage/" + member.getUser_id();
	    }
		
		if (profileImageFile != null && !profileImageFile.isEmpty()) {
		    member.setProfileImage(profileImageFile.getBytes());
		} else if (member.getProfileImage() == null) {
		    // 湲곕낯 �씠誘몄� �꽔湲�
		    ClassPathResource defaultImg = new ClassPathResource("static/profileimage/default.jpg");
		    member.setProfileImage(FileCopyUtils.copyToByteArray(defaultImg.getInputStream()));
		}

	    service.updateMember(member);

	    UserDetails updatedUser = userDetailsService.loadUserByUsername(member.getUser_id());

	    Authentication newAuth = new UsernamePasswordAuthenticationToken(
	            updatedUser, null, updatedUser.getAuthorities());
	    SecurityContextHolder.getContext().setAuthentication(newAuth);

	    redirectAttributes.addFlashAttribute("message", "媛쒖씤�젙蹂� �닔�젙�씠 �셿猷뚮릺�뿀�뒿�땲�떎");
	    redirectAttributes.addAttribute("username", service.findById(member.getId()).getUser_id());

	    return "redirect:/"+MAIN_URL+ "mypage/{username}";
	}
	
	//�봽濡쒗븘 �궗吏� �쟻�슜 : 留덉씠�럹�씠吏� 諛� �닔�젙�럹�씠吏��뿉 �쟻�슜�븯湲� �쐞�빐 �궗�슜
	@GetMapping("profileImage/{id}")
	@ResponseBody
	public ResponseEntity<byte[]> getProfileImage(@PathVariable("id") int id) {
	    Member user = service.findById(id);
	    byte[] imageBytes = null;

	    try {
	        if(user != null && user.getProfileImage() != null) {
	            imageBytes = user.getProfileImage();
	        } else {
	            // DB�뿉 �씠誘몄� �뾾�쑝硫� 湲곕낯 �씠誘몄� �젣怨�
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
	
	//�봽濡쒗븘 �궗吏� �쟻�슜 : �뿤�뜑�뿉 �쟻�슜�븯湲� �쐞�븿
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