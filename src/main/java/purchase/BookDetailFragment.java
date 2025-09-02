package purchase;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookDetailFragment {
	private int book_id;
    private String book_title;
    private int quantity;
    private String author;
    private String category;
    private String isbn;
    private double rating;
}
