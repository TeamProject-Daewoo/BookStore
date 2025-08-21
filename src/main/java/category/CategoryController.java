package category;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("category")		//index 페이지 없을 시 추가
public class CategoryController {
	
	 	@Autowired
	    CategoryService service;

	 	@RequestMapping(value="{category}", method=RequestMethod.GET)
	    public String category(@PathVariable("category") String category, Model model, String keyword) {
	        model.addAttribute("page", "category/categoryList"); // include될 JSP
	        model.addAttribute("categoryKey", category); // novel, economy 등
	        Map<String, Object> pageList = new HashMap<>();

	        // URL 카테고리 → DB 카테고리 매핑
	        String dbCategory = null;
	        switch (category.toLowerCase()) {
	            case "novel": dbCategory = "소설"; break;
	            case "it": dbCategory = "IT/컴퓨터"; break;
	            case "economy": dbCategory = "경제/경영"; break;
	            case "etc": dbCategory = "기타"; break;
	            default: dbCategory = null;
	        }

	        List<?> list;

	        if (keyword != null && !keyword.isEmpty()) {
	            // 검색 키워드가 있으면 제목/저자 검색
	        	list = service.findByCategoryAndKeyword(dbCategory, keyword);
	        } else if (dbCategory != null) {
	            // 카테고리별 조회
	            list = service.getBooksByCategory(dbCategory);
	        } else {
	            // 전체 재고 있는 책
	            list = service.getExistBookList();
	        }
	        
	        pageList.put("list", list);
	        pageList.put("category", dbCategory);
	        pageList.put("totalCount", list.size());
	        pageList.put("currentPage", 1);
	        pageList.put("totalPage", 1);

	        model.addAttribute("pageList", pageList);
	        return "index";
	    }
}