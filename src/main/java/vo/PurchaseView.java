package vo;

import java.util.Date;

import lombok.Builder;
import lombok.Data;

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
    private int book_id;
    private String book_title;
    private int quantity;
    private Date order_date;
}
