package cart;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey; // MySQL에서는 @SelectKey의 설정이 변경됨
import org.apache.ibatis.annotations.Update;

import data.BaseMapper;

@Mapper
public interface CartMapper extends BaseMapper<Cart> {

    @Override
    @Insert("INSERT INTO cart(member_id, book_id, quantity) VALUES(#{member_id}, #{book_id}, #{quantity})")
    @SelectKey(statement = "SELECT LAST_INSERT_ID()", keyProperty = "id", before = false, resultType = int.class)
    public int save(Cart cart);
    // ------------------------------------

    @Override
    @Select("SELECT id, member_id, book_id, quantity FROM cart") // 컬럼명 명시를 위해 * 대신 컬럼 이름을 적어주는 것이 좋습니다.
    List<Cart> findAll();

    @Override
    @Select("SELECT id, member_id, book_id, quantity FROM cart WHERE id = #{id}")
    Cart findById(int id);

    @Override
    @Update("UPDATE cart SET member_id = #{member_id}, book_id = #{book_id}, quantity = #{quantity} WHERE id = #{id}")
    int update(Cart cart);

    @Override
    @Delete("DELETE FROM cart WHERE id = #{id}")
    int delete(int id);

    // New methods for cart management (SQL 구문은 MySQL과 Oracle에서 동일하게 작동합니다.)
    @Select("SELECT id, member_id, book_id, quantity FROM cart WHERE member_id = #{memberId} AND book_id = #{bookId}")
    Cart findByMemberIdAndBookId(@Param("memberId") int memberId, @Param("bookId") int bookId);

    @Select("SELECT id, member_id, book_id, quantity FROM cart WHERE member_id = #{memberId}")
    List<Cart> findByMemberId(@Param("memberId") int memberId);

    @Update("UPDATE cart SET quantity = #{quantity} WHERE member_id = #{memberId} AND book_id = #{bookId}")
    int updateQuantity(@Param("memberId") int memberId, @Param("bookId") int bookId, @Param("quantity") int quantity);

    @Delete("DELETE FROM cart WHERE member_id = #{memberId} AND book_id = #{bookId}")
    int deleteByMemberIdAndBookId(@Param("memberId") int memberId, @Param("bookId") int bookId);

    @Delete("DELETE FROM cart WHERE member_id = #{memberId}")
    int deleteAllByMemberId(@Param("memberId") int memberId);
}