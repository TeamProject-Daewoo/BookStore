package user;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

import data.BaseMapper;

@Mapper
public interface MemberMapper extends BaseMapper<Member> {
	
	@Override
	@Insert("insert into member(id, user_id, name, email, password, phone_number, profile_image, created_at, role) "
	        + "values(#{id}, #{user_id}, #{name}, #{email}, #{password}, #{phone_number}, #{profileImage,jdbcType=BLOB}, SYSDATE, #{role})")
	@SelectKey(statement = "SELECT member_seq.NEXTVAL FROM DUAL", keyProperty = "id", before = true, resultType = int.class)
	public int save(Member member);
	
	@Override
	@Select("select * from member")
	List<Member> findAll();
		
	@Select("SELECT * FROM member WHERE id=#{id}")
    @Results({@Result(column="profile_image", property="profileImage")})
    Member findById(int id);
	
	@Select("select * from member where user_id=#{userId}")
    @Results({@Result(column="profile_image", property="profileImage")})
	Member findByUserId(String user_id);
	
	@Override
	@Update("UPDATE member SET user_id=#{user_id}, name=#{name}, email=#{email}, phone_number=#{phone_number}, profile_image=#{profileImage,jdbcType=BLOB} WHERE id=#{id}")
	int update(Member member);
	
	@Override
	@Delete("delete from member where id=#{id}")
	int delete(int id);
	
	@Select("select * from member where user_id=#{username}")
    @Results({@Result(column="profile_image", property="profileImage")})
	public Member findByUsername(String username);
	
}