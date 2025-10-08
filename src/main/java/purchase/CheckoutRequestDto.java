package purchase;

import lombok.Data;

@Data
public class CheckoutRequestDto {

	private String type;
    private String bookIsbn;
    private Integer quantity;
}
