package review;

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
public interface ReviewMapper{

    @Insert("INSERT INTO review (book_id, user_id, rating, content) " +
            "VALUES (#{bookId}, #{userId}, #{rating}, #{content})")
    @SelectKey(statement = "SELECT LAST_INSERT_ID()", keyProperty = "reviewId", before = false, resultType = Integer.class)
    int insertReview(Review review);

    // 책별 리뷰 조회
    @Select("SELECT review_id, book_id, user_id, rating, content, created_at " +
            "FROM review WHERE book_id = #{bookId} ORDER BY created_at DESC")
    @Results({
        @Result(column="review_id", property="reviewId"),
        @Result(column="book_id", property="bookId"),
        @Result(column="user_id", property="userId"),
        @Result(column="created_at", property="createdAt")
    })
    List<Review> findByBookId(Integer bookId);

    // 리뷰 삭제
    @Delete("DELETE FROM review WHERE review_id = #{reviewId}")
    int deleteReview(int reviewId);

    // 리뷰 ID로 조회
    @Select("SELECT review_id, book_id, user_id, rating, content, created_at " +
            "FROM review WHERE review_id = #{reviewId}")
    @Results({
        @Result(column="review_id", property="reviewId"),
        @Result(column="book_id", property="bookId"),
        @Result(column="user_id", property="userId"),
        @Result(column="created_at", property="createdAt"),
    })
    Review findById(int reviewId);

    // 리뷰 수정
    @Update("UPDATE review SET rating = #{rating}, content = #{content} WHERE review_id = #{reviewId}")
	void updateReview(Review review);

}