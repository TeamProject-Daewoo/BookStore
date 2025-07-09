package vo;

import java.util.Date;

import lombok.Data;

/**
 * # Purchase<br>
 * id<br>
 * member_id<br>
 * book_id<br>
 * quantity<br>
 * order_date
 */
@Data
public class Purchase {
	private int id;
	private int member_id;
	private int book_id;
	private int quantity; // Changed from String to int
	private Date order_date;
}
