package user;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface CartMapper extends BaseMapper<Cart> {
	
	@Override
	@Insert("insert into cart(id, member_id, book_id, quantity) values(#{id}, #{member_id}, #{book_id}, #{quantity})")
	public int save(Cart cart);
	
	@Override
	@Select("select * from cart")
	List<Cart> findAll();
		
	@Override
	@Select("select * from cart where id=#{id}")
	Cart findById(int id);
	
	@Override
	@Update("update cart set member_id=#{member_id}, book_id=#{book_id}, quantity=#{quantity} where id=#{id}")
	int update(Cart cart);
	
	@Override
	@Delete("delete from cart where id=#{id}")
	int delete(int id);
}