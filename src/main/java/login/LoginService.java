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

import repository.MemberMapper;
import vo.Member;

@Service("loginService")
public class LoginService implements UserDetailsService{
	
	@Autowired
	SqlSessionFactory sqlSessionFactory;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		//1)username ����
		System.out.println("���޵� username: " + username);
		//2) sqlSessionFactory�� �̿��Ͽ� mapper���� username�� �̿��Ͽ� �����ҷ�����
		SqlSession sqlSession = sqlSessionFactory.openSession();
		MemberMapper memberDao = sqlSession.getMapper(MemberMapper.class);
		Member member = memberDao.findByUsername(username);
		System.out.println(member);
		//3) �α��� ����, ���и� security�� ó��
		// �α��� ó������ ROLE������ ����Ʈ�� ������ �Է��� �ص־��Ѵ�.
		List<GrantedAuthority> authorities = new ArrayList<>();
		

		if(member.getRole().equals("ROLE_ADMIN")) {
			authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
			authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
		}else if(member.getRole().equals("ROLE_USER")) {
			authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
		}
		
		//User ��ü�� �̿��Ͽ� �α��� �������� Ȯ��
		//User ��ü�� �̹� ������ ���۹��� username, password�� ������ �ִ� �����̰�
		//�����ͺ��̽��κ��� ���� member�� username, password�� �����ϰ�
		//�̸� Ȯ���ϴ� �����̸� �������ο� ���� User��ü�� null���� �ƴ��� ����
		//Ȯ�λ���) db�� �ִ� password�� ��ȣȭ�� �Ǿ� �ִ��� ���� �ݵ�� Ȯ��
		//�Ʒ��ڵ�� ��ȣȭ�� �������� ���¿��� ���� ����
		//��ȣȭ�� db�� ��� encode() �Լ��� �ʿ����
		//��ȣȭ�� �Ǿ��ִ� ��� �Ʒ��ڵ� ���
		User user = new User(member.getUser_id(), member.getPassword(), authorities);
		//User user = new User(member.getUsername(), new BCryptPasswordEncoder().encode(member.getPassword()), authorities);
		System.out.println(user);

		return user;
	}

}
