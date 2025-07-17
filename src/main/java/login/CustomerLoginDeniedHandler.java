package login;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

public class CustomerLoginDeniedHandler implements AccessDeniedHandler{

	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {
		// �꽦怨듭떆 LoginService�뿉�꽌 authorities�뿉 ���옣�맂 媛믪쓣 �솗�씤�븳 �썑�뿉 沅뚰븳�뿉 �빐�떦�븯�뒗 �럹�씠吏� �씠�룞
		response.sendRedirect("/accessError");
			
		}
	}
