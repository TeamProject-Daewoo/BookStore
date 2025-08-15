package board;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import user.UserService;

@Controller
@RequestMapping("board")
public class BoardController {
	
	@Autowired
	UserService service;
	
	final static String MAIN_URL = "board/";
	

	@RequestMapping("/main")
	public String bookList(Model model, String keyword) {
	    model.addAttribute("page", MAIN_URL + "main");
	    return "index";
	}
}