package board;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface BoardMapper {

	@Select("SELECT id, title, author, content, created_at AS createdAt, user_id, view_count AS viewCount " +
	        "FROM board " +
	        "ORDER BY id DESC")
	List<Board> selectAll();

	@Select("SELECT id, title, author, content, created_at AS createdAt, user_id, view_count AS viewCount " +
	        "FROM board " +
	        "WHERE id = #{id}")
	Board selectById(@Param("id") Long id);

    @Insert("INSERT INTO board (id, title, author, content, created_at, user_id) " +
            "VALUES (board_seq.NEXTVAL, #{title}, #{author}, #{content}, SYSDATE, #{user_id})")
    int insert(Board post);

    // 페이징
    /* Oracle 12g 이상 문법
    @Select("SELECT id, title, author, content, created_at AS createdAt, user_id " +
            "FROM board " +
            "ORDER BY id DESC " +
            "OFFSET #{offset} ROWS FETCH NEXT #{limit} ROWS ONLY")*/
    @Select("SELECT id, title, author, content, created_at AS createdAt, user_id, view_count AS viewCount FROM "
            + "(SELECT a.*, ROWNUM rnum FROM "
            + "(SELECT id, title, author, content, created_at, user_id, view_count FROM board ORDER BY id DESC) a "
            + "WHERE ROWNUM <= #{offset} + #{limit}) "
            + "WHERE rnum > #{offset}")
    List<Board> selectPage(@Param("offset") int offset, @Param("limit") int limit);

    @Select("SELECT COUNT(*) FROM board")
    int countAll();

    // 수정: 글 주인만 수정 가능
    @Update("UPDATE board " +
            "SET title = #{title}, content = #{content} " +
            "WHERE id = #{id} AND user_id = #{user_id}")
    int updateOwned(Board post);

    // 삭제: 글 주인만 삭제 가능
    @Delete("DELETE FROM board " +
            "WHERE id = #{id} AND user_id = #{user_id}")
    int deleteOwned(@Param("id") Long id, @Param("user_id") String userId);

	int delete(Long id);

	// 조회수 증가
	@Update("UPDATE board " +
	        "SET view_count = view_count + 1 " +
	        "WHERE id = #{id}")
	void updateViewCount(@Param("id") Long id);
}
