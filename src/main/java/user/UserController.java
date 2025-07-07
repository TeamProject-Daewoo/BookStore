package user;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
@Controller
@RequestMapping("/user")
public class UserController {

	@RequestMapping("index")
	public String index(Model model) {
		model.addAttribute("page", "user/" + "index");
		return "index"; 
	}
	
	@RequestMapping("cart")
	public String cart(Model model) {
		model.addAttribute("page", "user/" + "cart");
		return "user/cart"; 
	}
}
