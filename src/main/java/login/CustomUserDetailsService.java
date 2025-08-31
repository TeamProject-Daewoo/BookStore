package login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import user.Member;
import user.MemberMapper;

@Service("customdetail")
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private MemberMapper memberRepository; // 또는 MyBatis Mapper

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // DB에서 사용자 조회
        Member member = memberRepository.findByUserId(username);

        if (member == null) {
            throw new UsernameNotFoundException("User not found: " + username);
        }

        // Spring Security의 UserDetails 객체로 변환
        return User.builder()
                .username(member.getUser_id())
                .password(member.getPassword())
                .authorities(member.getRole()) // "ROLE_USER" 같은 권한
                .build();
    }
}
