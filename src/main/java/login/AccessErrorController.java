package login;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AccessErrorController {

	@GetMapping("accessError")
	public String accessError(Model model) {
		model.addAttribute("page", "accesserror");
		return "index";
	}
	
}
