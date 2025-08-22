package bestseller;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Bestseller {
    private int id;             
    private int bookId;      
    private int totalSales;     
    private int rank;           
    private LocalDateTime createdAt;
    private String period;      // today, week, month
    private Integer rankChange; // 순위 변화
}
