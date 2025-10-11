package purchase;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PurchaseFragment {
	private int id;
    private int member_id;
    private String member_name;
    private Date order_date;
    private int total_price;
    private String order_id;
}
