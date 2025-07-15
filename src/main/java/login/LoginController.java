package login;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {
//
//	@GetMapping("login")
//	public void login() {
//		//함수가 void형 즉 리턴이 없을 경우 주소를 참조하여 페이지 결정
//		// /login -> login ->/WEB-INF/views/login.jsp
//		//만약 url주소가 /login/login ->/WEB-INF/views/login/login.jsp
//	}
	
	@GetMapping("/accesserror")
	public void accesserror() {}
}
