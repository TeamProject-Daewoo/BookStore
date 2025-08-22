package bestseller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/bestseller")
public class BestsellerController {

	@Autowired
    BestsellerService bestsellerService;

	@GetMapping("/main")
	public String Bestseller(Model model){
	    model.addAttribute("todayBestSellers", bestsellerService.getBestSellers("today"));
        model.addAttribute("weeklyBestSellers", bestsellerService.getBestSellers("week"));
        model.addAttribute("monthlyBestSellers", bestsellerService.getBestSellers("month"));
	    model.addAttribute("page", "user/bestseller");
	    return "index";
	}


}
