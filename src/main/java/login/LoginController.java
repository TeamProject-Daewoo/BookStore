package login;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {
//
//	@GetMapping("login")
//	public void login() {
//		//�븿�닔媛� void�삎 利� 由ы꽩�씠 �뾾�쓣 寃쎌슦 二쇱냼瑜� 李몄“�븯�뿬 �럹�씠吏� 寃곗젙
//		// /login -> login ->/WEB-INF/views/login.jsp
//		//留뚯빟 url二쇱냼媛� /login/login ->/WEB-INF/views/login/login.jsp
//	}
	
	@GetMapping("/accesserror")
	public void accesserror() {}
	

}
