package purchase;

import java.util.Date;

import lombok.Data;

@Data
public class PurchaseQueryResult {
    private int id;
    private int member_id;
    private String member_name;
    private Date order_date;
    private int total_price;
    private int order_id;

    private int book_id;
    private String book_title;
    private int quantity;
    private String author;
    private String category;
    private String isbn;
    private double rating;
}