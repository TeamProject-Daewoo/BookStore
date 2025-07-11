package repository;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

import vo.Member;

@Mapper
public interface MemberMapper extends BaseMapper<Member> {
	
	@Override
<<<<<<< HEAD
	@Insert("insert into member(id, user_id, name, email, password, phone_number, created_at, role) values(#{id}, #{user_id}, #{name}, #{email}, #{password}, #{phone_number}, SYSDATE, 'ROLE_USER')")
=======
	@Insert("insert into member(id, user_id, name, email, password, phone_number, CREATED_AT, role) values(#{id}, #{user_id}, #{name}, #{email}, #{password}, #{phone_number}, SYSDATE, #{role})")
>>>>>>> origin/lsy
	@SelectKey(statement = "SELECT member_seq.NEXTVAL FROM DUAL", keyProperty = "id", before = true, resultType = int.class)
	public int save(Member member);
	
	@Override
	@Select("select * from member")
	List<Member> findAll();
		
	@Override
	@Select("select * from member where id=#{id}")
	Member findById(int id);
	
	@Select("select * from member where user_id=#{userId}")
	Member findByUserId(String userId);
	
	@Override
	@Update("update member set name=#{name}, email=#{email}, password=#{password} where id=#{id}")
	int update(Member member);
	
	@Override
	@Delete("delete from member where id=#{id}")
	int delete(int id);
	
	@Select("select * from member where user_id=#{user_id}")
	Member findByUserId(@Param("user_id") String user_id);
}