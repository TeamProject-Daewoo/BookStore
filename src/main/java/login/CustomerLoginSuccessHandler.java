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
		System.out.println("성공시 : " + authentication.getAuthorities());
		//아래코드를 실행하는 이유는 authoritie.getAuthority()가 문자열이 아니므로 문자열로 변환
		List<String> roleNames = new ArrayList<>();
		authentication.getAuthorities().forEach(authoritie->{
			roleNames.add(authoritie.getAuthority());
		});
		
		if(roleNames.contains("ROLE_ADMIN")) {
			response.sendRedirect("/manager/booklist"); //pageController에서 모두 처리
		}else if(roleNames.contains("ROLE_USER")) {
			response.sendRedirect("/user/booklist");
		}else {
			response.sendRedirect("/user/login/accessError");
		}
		
	}

}
