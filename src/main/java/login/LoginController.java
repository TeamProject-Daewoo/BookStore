package login;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {
//
//	@GetMapping("login")
//	public void login() {
//		//�Լ��� void�� �� ������ ���� ��� �ּҸ� �����Ͽ� ������ ����
//		// /login -> login ->/WEB-INF/views/login.jsp
//		//���� url�ּҰ� /login/login ->/WEB-INF/views/login/login.jsp
//	}
	
	@GetMapping("/accesserror")
	public void accesserror() {}
}
