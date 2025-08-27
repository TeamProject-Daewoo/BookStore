package comment;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface CommentMapper {

    // 댓글 등록
    @Insert("INSERT INTO board_comment (comment_id, board_id, user_id, content, created_at) " +
            "VALUES (#{commentId}, #{boardId}, #{userId}, #{content}, SYSDATE)")
    @SelectKey(statement = "SELECT comment_seq.NEXTVAL FROM dual", keyProperty = "commentId", before = true, resultType = Integer.class)
    int insertComment(Comment comment);

    // 게시글의 댓글 조회
    @Select("SELECT * FROM board_comment WHERE board_id = #{boardId} ORDER BY created_at DESC")
    @Results({
        @Result(column="comment_id", property="commentId"),
        @Result(column="board_id", property="boardId"),
        @Result(column="user_id", property="userId"),
        @Result(column="created_at", property="createdAt")
    })
    List<Comment> findByBoardId(Long boardId);

    // 댓글 삭제
    @Delete("DELETE FROM board_comment WHERE comment_id = #{commentId}")
    int deleteComment(int commentId);

    // 댓글 ID로 조회
    @Select("SELECT * FROM board_comment WHERE comment_id = #{commentId}")
    @Results({
        @Result(column="comment_id", property="commentId"),
        @Result(column="board_id", property="boardId"),
        @Result(column="user_id", property="userId"),
        @Result(column="created_at", property="createdAt")
    })
    Comment findById(int commentId);

    // 댓글 수정
    @Update("UPDATE board_comment SET content=#{content} WHERE comment_id=#{commentId}")
    void updateComment(Comment comment);

}
