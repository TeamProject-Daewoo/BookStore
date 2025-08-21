package category;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import data.Book;
import data.BookMapper;

@Service
public class CategoryService {
	
	 @Autowired
	    private BookMapper bookMapper;

	    public List<Book> getExistBookList() {
	        return bookMapper.findExistBook();
	    }

	    public List<Book> getBooksByCategory(String category) {
	        if(category == null || category.isEmpty()) return getExistBookList();
	        return bookMapper.findByCategory(category);
	    }

	    public List<Book> findByCategoryAndKeyword(String dbCategory, String keyword) {
	        if(dbCategory == null || dbCategory.isEmpty() || keyword == null || keyword.isEmpty()) {
	            return getExistBookList();
	        }
	        return bookMapper.findByCategoryAndKeyword(dbCategory, keyword);
	    }
}