package board;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;




/**
 * BOARD 테이블 매핑용 DTO
 *  - id          NUMBER (PK)
 *  - title       VARCHAR2(200) NOT NULL
 *  - author      VARCHAR2(100)
 *  - content     CLOB NOT NULL
 *  - created_at  DATE DEFAULT SYSDATE
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Board {
    private Long id;                 // PK
    private String title;            // 제목
    private String author;           // 작성자
    private String content;          // 내용 (CLOB)
    private String createdAt; // 작성일 (Oracle DATE -> Java LocalDateTime)
    private String user_id;
    private Integer viewCount;       // 조회수 추가
    private int commentCount; // getter/setter 포함
}
