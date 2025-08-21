package user;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

import data.BaseMapper;

@Mapper
public interface MemberMapper extends BaseMapper<Member> {
	
	@Override
	@Insert("insert into member(id, user_id, name, email, password, phone_number, created_at, role) values(#{id}, #{user_id}, #{name}, #{email}, #{password}, #{phone_number}, SYSDATE, #{role})")
	@SelectKey(statement = "SELECT member_seq.NEXTVAL FROM DUAL", keyProperty = "id", before = true, resultType = int.class)
	public int save(Member member);
	
	@Override
	@Select("select * from member")
	List<Member> findAll();
		
	@Override
	@Select("select * from member where id=#{id}")
	Member findById(int id);
	
	@Select("select * from member where user_id=#{userId}")
	Member findByUserId(String user_id);
	
	@Override
	@Update("update member set user_id=#{user_id}, name=#{name}, email=#{email}, phone_number=#{phone_number}, password=#{password} where id=#{id}")
	int update(Member member);
	
	@Override
	@Delete("delete from member where id=#{id}")
	int delete(int id);
	
	@Select("select * from member where user_id=#{username}")
	public Member findByUsername(String username);
	
}