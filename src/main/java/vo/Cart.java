package vo;

import lombok.Data;

/**
 * # CartDTO<br>
 * id<br>
 * member_id<br>
 * book_id<br>
 * quantity
 */
@Data
public class Cart {
	private int id;
	private int member_id;
	private int book_id;
	private int quantity;
}
