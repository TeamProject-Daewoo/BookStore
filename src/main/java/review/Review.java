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
    private int rating;         // �룊�젏 1~5
    private String content;     // 由щ럭 �궡�슜
    private Date createdAt;  // �깮�꽦�씪�떆

}
