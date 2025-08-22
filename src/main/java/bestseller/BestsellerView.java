package bestseller;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BestsellerView {
	private int id; 
	private int book_id;
    private int rank;
    private int totalSales;
    private Integer rankChange; // 순위 변동
    private String title;
    private String author;
    private String img;
}
