package restapi;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import manager.ManagerService;
import purchase.SalesView;

@RestController
@RequestMapping("api")
public class PurchaseRestController {
	
	@Autowired
	ManagerService managerService;
	
//	@GetMapping("renderSalesList")
//	public SalesView renderSalesList(@RequestParam String keyword, @RequestParam String orderItem, @RequestParam String order) {
//		return managerService.getSalesView();
//	}
	
	@PostMapping("renderSalesList")
	public SalesView renderSalesList(@RequestBody SearchRequest searchReq) {
		return managerService.getSalesView(searchReq);
	}
	
}
