package purchase;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PurchaseView {

	private PurchaseFragment purchaseList;	//구매 정보
    
    @Builder.Default
    private List<BookDetailFragment> bookList = new ArrayList<>();	//책정보
}
