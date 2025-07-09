package repository;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

import vo.Cart;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import vo.Cart;

@Mapper
public interface CartMapper extends BaseMapper<Cart> {
	
	@Override
	@Insert("insert into cart(id, member_id, book_id, quantity) values(#{id}, #{member_id}, #{book_id}, #{quantity})")
	@SelectKey(statement = "SELECT cart_seq.NEXTVAL FROM DUAL", keyProperty = "id", before = true, resultType = int.class)
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

    // New methods for cart management
    @Select("SELECT * FROM cart WHERE member_id = #{memberId} AND book_id = #{bookId}")
    Cart findByMemberIdAndBookId(@Param("memberId") int memberId, @Param("bookId") int bookId);

    @Select("SELECT * FROM cart WHERE member_id = #{memberId}")
    List<Cart> findByMemberId(@Param("memberId") int memberId);

    @Update("UPDATE cart SET quantity = #{quantity} WHERE member_id = #{memberId} AND book_id = #{bookId}")
    int updateQuantity(@Param("memberId") int memberId, @Param("bookId") int bookId, @Param("quantity") int quantity);

    @Delete("DELETE FROM cart WHERE member_id = #{memberId} AND book_id = #{bookId}")
    int deleteByMemberIdAndBookId(@Param("memberId") int memberId, @Param("bookId") int bookId);

    @Delete("DELETE FROM cart WHERE member_id = #{memberId}")
    int deleteAllByMemberId(@Param("memberId") int memberId);
}