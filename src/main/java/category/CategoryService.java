package category;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import data.Book;
import data.BookMapper;

@Service
public class CategoryService {
	
	 @Autowired
    private BookMapper bookMapper;

 	@Transactional(readOnly = true)
    public List<Book> getExistBookList() {
        return bookMapper.findExistBook();
    }

 	@Transactional(readOnly = true)
    public List<Book> getBooksByCategory(String category) {
        if(category == null || category.isEmpty()) return getExistBookList();
        return bookMapper.findByCategory(category);
    }

 	@Transactional(readOnly = true)
    public List<Book> findByCategoryAndKeyword(String dbCategory, String keyword) {
        if(dbCategory == null || dbCategory.isEmpty() || keyword == null || keyword.isEmpty()) {
            return getExistBookList();
        }
        return bookMapper.findByCategoryAndKeyword(dbCategory, "%"+keyword+"%");
    }
}