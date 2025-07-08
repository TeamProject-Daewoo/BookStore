package user;

import lombok.Data;

/**
 * # BookDTO<br>
 * id<br>
 * title<br>
 * price<br>
 * stock<br>
 * img<br>
 * description
 */
@Data
public class Book {
	private int id;
	private String title;
	private String author;
	private String price;
	private int stock;
	private String img;
	private String description;
}
