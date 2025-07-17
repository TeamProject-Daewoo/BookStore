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
public class MyPurchaseView {
    private String book_title;
    private String img;
    private int quantity;
    private Date order_date;
}
