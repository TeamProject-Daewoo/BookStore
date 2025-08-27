package comment;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Comment {

    private Integer commentId;   // 댓글 ID
    private int boardId;         // 게시글 ID
    private String userId;       // 작성자 ID
    private String content;      // 댓글 내용
    private Date createdAt;      // 작성일시

}