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

    // 由щ럭 �벑濡�
    @Insert("INSERT INTO review (review_id, book_id, user_id, rating, content) " +
            "VALUES (#{reviewId}, #{bookId}, #{userId}, #{rating}, #{content})")
    @SelectKey(statement = "SELECT review_seq.NEXTVAL FROM dual", keyProperty = "reviewId", before = true, resultType = Integer.class)
    int insertReview(Review review);

    // 梨낅퀎 由щ럭 議고쉶
    @Select("SELECT * FROM review WHERE book_id = #{bookId} ORDER BY created_at DESC")
    @Results({
        @Result(column="review_id", property="reviewId"),
        @Result(column="book_id", property="bookId"),
        @Result(column="user_id", property="userId"),
        @Result(column="created_at", property="createdAt")
    })
    List<Review> findByBookId(Integer bookId);

    // 由щ럭 �궘�젣
    @Delete("DELETE FROM review WHERE review_id = #{reviewId}")
    int deleteReview(int reviewId);

    @Select("SELECT * FROM review WHERE review_id = #{reviewId}")
    @Results({
        @Result(column="review_id", property="reviewId"),
        @Result(column="book_id", property="bookId"),
        @Result(column="user_id", property="userId"),
        @Result(column="created_at", property="createdAt"),
    })
    Review findById(int reviewId);

    @Update("UPDATE review SET rating=#{rating}, content=#{content} WHERE review_id=#{reviewId}")
	void updateReview(Review review);

}
