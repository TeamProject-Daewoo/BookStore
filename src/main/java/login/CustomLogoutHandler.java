package login;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutHandler;
import org.springframework.stereotype.Component;

import cart.CookieService;

// 스프링이 관리하는 부품(Bean)으로 등록합니다.
@Component
public class CustomLogoutHandler implements LogoutHandler {

    // 필요한 CookieService를 주입받습니다.
    @Autowired
    private CookieService cookieService;

    @Override
    public void logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
        System.out.println("====== 커스텀 로그아웃 핸들러 실행: 쿠키를 삭제합니다. ======");
        
        cookieService.deleteCartCookie(response);
    }
}