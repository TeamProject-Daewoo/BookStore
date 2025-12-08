package login;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import user.Member;
import user.MemberMapper;

@Service("loginService")
public class LoginService implements UserDetailsService{
	
	@Autowired
	SqlSessionFactory sqlSessionFactory;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		//1)username 전달
//		System.out.println("전달된 username: " + username);
		//2) sqlSessionFactory를 이용하여 mapper에서 username을 이용하여 정보불러오기
		try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
			MemberMapper memberDao = sqlSession.getMapper(MemberMapper.class);
			Member member = memberDao.findByUsername(username);
			//3) 로그인 성공, 실패를 security가 처리
			// 로그인 처리전에 ROLE권한을 리스트에 사전에 입력을 해둬야한다.
			List<GrantedAuthority> authorities = new ArrayList<>();
			
	
			if(member.getRole().equals("ROLE_ADMIN")) {
				authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
				authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
			}else if(member.getRole().equals("ROLE_USER")) {
				authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
			}
			
			//User 객체를 이용하여 로그인 성공여부 확인
			//User 객체는 이미 폼에서 전송받은 username, password를 가지고 있는 상태이고
			//데이터베이스로부터 받은 member의 username, password를 전달하고
			//이를 확인하는 과정이며 성공여부에 따라 User객체가 null인지 아닌지 결정
			//확인사항) db에 있는 password가 암호화가 되어 있는지 여부 반드시 확인
			//아래코드는 암호화가 되지않은 상태에서 값이 전달
			//암호화된 db일 경우 encode() 함수가 필요없음
			//암호화가 되어있는 경우 아래코드 사용
			User user = new User(member.getUser_id(), member.getPassword(), authorities);
			//User user = new User(member.getUsername(), new BCryptPasswordEncoder().encode(member.getPassword()), authorities);
	
			return user;
		}
	}

}
