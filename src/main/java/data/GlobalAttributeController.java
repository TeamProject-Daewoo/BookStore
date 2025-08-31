package data;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import cart.CookieService;

/**
 * 전역 Controller<br>
 * 전역 정보)<br>
 * - 카트 개수
 */
@Component
@ControllerAdvice
public class GlobalAttributeController {

    @Autowired
    private CookieService cookieService;

    //세션의 setAttribute를 spring-security 방식으로 대체
    @ModelAttribute("cartCount")
    public int getCartCount(HttpServletRequest request) {
    	Map<String, Integer> cartMap = cookieService.readCartCookie(request);
        return cartMap.values().stream().mapToInt(Integer::intValue).sum();
    }
}
