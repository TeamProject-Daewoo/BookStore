package restapi;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import service.ManagerService;
import vo.SalesView;

@RestController
@RequestMapping("api")
public class PurchaseRestController {
	
	@Autowired
	ManagerService managerService;
	
	@GetMapping("renderSalesList")
	public SalesView renderSalesList() {
		return managerService.getSalesView();
	}
	
}
