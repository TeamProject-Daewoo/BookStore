package purchase;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class SalesView {
	private List<PurchaseView> purchase;
	private int totalSum;
}
