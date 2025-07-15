package login;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AccessErrorController {

	@GetMapping("accessError")
	public void accessError() {} //WEB-INF/views/login/accessError.jsp
	
}
