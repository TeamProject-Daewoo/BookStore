package restapi;

import lombok.Data;

@Data
public class SearchRequest {
	private String keyword;
    private String orderItem;
    private String order;
}
