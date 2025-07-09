package vo;

import lombok.Data;

@Data
public class CartItem {
    private Book book;
    private int quantity;

    public CartItem(Book book, int quantity) {
        this.book = book;
        this.quantity = quantity;
    }

    // Method to calculate item total
    public int getItemTotal() {
        return book.getPrice() * quantity;
    }
}
