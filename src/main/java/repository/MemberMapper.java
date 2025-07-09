package repository;

import vo.Member;
import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface MemberMapper extends BaseMapper<Member> {
	
	@Override
	@Insert("insert into member(id, name, email, password, phone_number, createAt) values(#{id}, #{name}, #{email}, #{password}, #{phone_number}, SYSDATE)")
	@SelectKey(statement = "SELECT member_seq.NEXTVAL FROM DUAL", keyProperty = "id", before = true, resultType = int.class)
	public int save(Member member);
	
	@Override
	@Select("select * from member")
	List<Member> findAll();
		
	@Override
	@Select("select * from member where id=#{id}")
	Member findById(int id);
	
	@Override
	@Update("update member set name=#{name}, email=#{email}, password=#{password} where id=#{id}")
	int update(Member member);
	
	@Override
	@Delete("delete from member where id=#{id}")
	int delete(int id);
}