package login;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

public class CustomerLoginSuccessHandler implements AuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		System.out.println("������ : " + authentication.getAuthorities());
		//�Ʒ��ڵ带 �����ϴ� ������ authoritie.getAuthority()�� ���ڿ��� �ƴϹǷ� ���ڿ��� ��ȯ
		List<String> roleNames = new ArrayList<>();
		authentication.getAuthorities().forEach(authoritie->{
			roleNames.add(authoritie.getAuthority());
		});
		
		if(roleNames.contains("ROLE_ADMIN")) {
			response.sendRedirect("/manager/booklist"); //pageController���� ��� ó��
		}else if(roleNames.contains("ROLE_USER")) {
			response.sendRedirect("/user/booklist");
		}else {
			response.sendRedirect("/user/login/accessError");
		}
		
	}

}
