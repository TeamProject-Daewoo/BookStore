package vo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import lombok.Builder;
import lombok.Data;
import vo.PurchaseView.BookDetail;

/**
 * # PurchaseViewDTO<br>
 * id<br>
 * member_id<br>
 * member_name<br>
 * book_id<br>
 * book_title<br>
 * quantity<br>
 * order_date
 */

@Builder
@Data
public class PurchaseView {
	private int id;
    private int member_id;
    private String member_name;
    private Date order_date;
    private int total_price;
    
    @Builder.Default
    private List<BookDetail> bookList = new ArrayList<>();
    
    @Data
    @Builder
    public static class BookDetail {
        private int book_id;
        private String book_title;
        private int quantity;
    }
}
