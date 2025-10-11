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
	
    // MySQL AUTO_INCREMENT 적용 및 SYSDATE -> NOW() 변경
	@Override
	@Insert("INSERT INTO member(user_id, name, email, password, phone_number, profile_image, created_at, role) "
			+ "VALUES(#{user_id}, #{name}, #{email}, #{password}, #{phone_number}, #{profileImage,jdbcType=BLOB}, NOW(), #{role})")
	@SelectKey(statement = "SELECT LAST_INSERT_ID()", keyProperty = "id", before = false, resultType = int.class)
	public int save(Member member);
	
	@Override
	@Select("SELECT id, user_id, name, email, password, phone_number, created_at, role, profile_image FROM member")
	List<Member> findAll();
		
    // profile_image 컬럼이 BLOB 타입이므로 @Results 유지
	@Select("SELECT id, user_id, name, email, password, phone_number, created_at, role, profile_image FROM member WHERE id = #{id}")
    @Results({@Result(column="profile_image", property="profileImage")})
    Member findById(int id);
	
	@Select("SELECT id, user_id, name, email, password, phone_number, created_at, role, profile_image FROM member WHERE user_id = #{userId}")
    @Results({@Result(column="profile_image", property="profileImage")})
	Member findByUserId(String user_id);
	
	@Override
	@Update("UPDATE member SET user_id = #{user_id}, name = #{name}, email = #{email}, "
			+ "phone_number = #{phone_number}, profile_image = #{profileImage,jdbcType=BLOB}, "
			+ "password = #{password} "
			+ "WHERE id = #{id}")
	int update(Member member);
	
	@Update("UPDATE member SET user_id = #{user_id}, name = #{name}, email = #{email}, "
			+ "phone_number = #{phone_number}, profile_image = #{profileImage,jdbcType=BLOB}, "
			+ "password = #{password}, role = #{role} "
			+ "WHERE id = #{id}")
	int updateManager(Member member);
	
	@Override
	@Delete("DELETE FROM member WHERE id = #{id}")
	int delete(int id);
	
	@Select("SELECT id, user_id, name, email, password, phone_number, created_at, role, profile_image FROM member WHERE user_id = #{username}")
    @Results({@Result(column="profile_image", property="profileImage")})
	public Member findByUsername(String username);
	
}