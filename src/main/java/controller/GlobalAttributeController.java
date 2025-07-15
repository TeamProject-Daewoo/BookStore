package controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import repository.MemberMapper;
import service.CartService;
import vo.Member;

@Component
@ControllerAdvice
public class GlobalAttributeController {
	
	 @Autowired
    private MemberMapper memberMapper;

    @Autowired
    private CartService cartService;

    @ModelAttribute("cartCount")
    public int getCartCount(Principal user) {
        if(user == null) return 0;
        Member member = memberMapper.findByUserId(user.getName());
        return member != null ? cartService.getCartItems(member.getId()).size() : 0;
    }
}
