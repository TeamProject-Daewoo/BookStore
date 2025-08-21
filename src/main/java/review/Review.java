package review;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Review {

	private Integer reviewId;      // review_id
    private int bookId;        // book_id
    private String userId;      // user_id
    private int rating;         // 평점 1~5
    private String content;     // 리뷰 내용
    private Date createdAt;  // 생성일시
}
