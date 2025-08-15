package data;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import cart.CartService;
import user.Member;
import user.MemberMapper;

/**
 * 전역 Controller<br>
 * 전역 정보)<br>
 * - 카트 개수
 */
@Component
@ControllerAdvice
public class GlobalAttributeController {
	
	 @Autowired
    private MemberMapper memberMapper;

    @Autowired
    private CartService cartService;

    //세션의 setAttribute를 spring-security 방식으로 대체
    @ModelAttribute("cartCount")
    public int getCartCount(Principal user) {
        if(user == null) return 0;
        Member member = memberMapper.findByUserId(user.getName());
        return member != null ? cartService.getCartItems(member.getId()).size() : 0;
    }
}
