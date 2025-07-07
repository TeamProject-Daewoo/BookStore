package manager;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/manager")
public class ManagerController {
	
	@RequestMapping("index")
	public String index(Model model) {
		model.addAttribute("page", "user/" + "index");
		return "index"; 
	}
}
