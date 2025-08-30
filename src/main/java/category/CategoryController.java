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
@RequestMapping("category")
public class CategoryController {
	
	 	@Autowired
	    CategoryService service;

	 	@RequestMapping(value="{category}", method=RequestMethod.GET)
	    public String category(@PathVariable("category") String category, Model model, String keyword) {
	        model.addAttribute("page", "category/categoryList"); // include될 JSP
	        model.addAttribute("categoryKey", category);
	        Map<String, Object> pageList = new HashMap<>();

	        // ===== switch문 수정된 부분 시작 =====
	        String dbCategory = null;
	        switch (category.toLowerCase()) {
	            case "novel": 
	            	dbCategory = "소설"; 
	            	break;
	            case "poem-essay": 
	            	dbCategory = "시/에세이"; 
	            	break;
	            case "economy-management": 
	            	dbCategory = "경제/경영"; 
	            	break;
	            case "self-development": 
	            	dbCategory = "자기계발"; 
	            	break;
	            case "humanities": 
	            	dbCategory = "인문"; 
	            	break;
	            case "history": 
	            	dbCategory = "역사"; 
	            	break;
	            case "social-politics": 
	            	dbCategory = "사회/정치"; 
	            	break;
	            case "science": 
	            	dbCategory = "자연/과학"; 
	            	break;
	            case "art-culture": 
	            	dbCategory = "예술/대중문화"; 
	            	break;
	            case "religion": 
	            	dbCategory = "종교"; 
	            	break;
	            case "preschool": 
	            	dbCategory = "유아"; 
	            	break;
	            case "children": 
	            	dbCategory = "어린이"; 
	            	break;
	            case "home-cooking": 
	            	dbCategory = "가정/요리"; 
	            	break;
	            case "travel": 
	            	dbCategory = "여행"; 
	            	break;
	            case "language": 
	            	dbCategory = "국어/외국어"; 
	            	break;
	            case "computer-it": 
	            	dbCategory = "컴퓨터/IT"; 
	            	break;
	            case "teen": 
	            	dbCategory = "청소년"; 
	            	break;
	            case "test-prep": 
	            	dbCategory = "수험서/자격증"; 
	            	break;
	            case "comics": 
	            	dbCategory = "만화"; 
	            	break;
	            case "magazine": 
	            	dbCategory = "잡지"; 
	            	break;
	            case "foreign-books": 
	            	dbCategory = "외국도서"; 
	            	break;
	            case "health-hobby": 
	            	dbCategory = "건강/취미"; 
	            	break;
	            case "highschool-reference": 
	            	dbCategory = "고등학교 참고서"; 
	            	break;
	            case "middleschool-reference": 
	            	dbCategory = "중학교 참고서"; 
	            	break;
	            case "elementary-reference": 
	            	dbCategory = "초등학교 참고서"; 
	            	break;
	            case "used-books": 
	            	dbCategory = "중고도서"; 
	            	break;
	            case "etc": 
	            	dbCategory = "기타"; 
	            	break;
	            default: 
	            	dbCategory = null; // 매핑되지 않은 경우 전체 목록
	        }
	        // ===== switch문 수정된 부분 끝 =====

	        List<?> list;

	        if (keyword != null && !keyword.isEmpty()) {
	            // 검색 키워드가 있으면 제목/저자 검색
	        	list = service.findByCategoryAndKeyword(dbCategory, keyword);
	        } else if (dbCategory != null) {
	            // 카테고리별 조회
	            list = service.getBooksByCategory(dbCategory);
	        } else {
	            // 'all' 또는 매핑되지 않은 category의 경우, 전체 재고 있는 책
	            list = service.getExistBookList();
	        }
	        
	        pageList.put("list", list);
	        pageList.put("category", dbCategory); // 현재 카테고리명 전달 (null일 경우 '전체')
	        pageList.put("totalCount", list.size());
	        pageList.put("currentPage", 1);
	        pageList.put("totalPage", 1);

	        model.addAttribute("pageList", pageList);
	        return "index";
	    }
}