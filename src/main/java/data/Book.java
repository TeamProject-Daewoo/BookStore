package data;

import lombok.Data;

/**
 * # BookDTO<br>
 * id<br>
 * title<br>
 * author<br>
 * price<br>
 * stock<br>
 * img<br>
 * description
 */
@Data
public class Book {
	private Integer id;
	private String isbn;
	private String title;
	private String author; // Added this line
	private int price; // Changed from String to int
	private int stock;
	private String img;
	private String category;
	private String description;
}