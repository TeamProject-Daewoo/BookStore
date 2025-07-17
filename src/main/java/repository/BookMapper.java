package repository;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

import vo.Book;

@Mapper
public interface BookMapper extends BaseMapper<Book> {
	
	@Override
	@Insert("insert into book(id, title, author, price, stock, img, description) values(#{id}, #{title}, #{author}, #{price}, #{stock}, #{img}, #{description})")
	@SelectKey(statement = "SELECT book_seq.NEXTVAL FROM DUAL", keyProperty = "id", before = true, resultType = int.class)
	public int save(Book book);
	
	@Override
	@Select("select * from book")
	List<Book> findAll();
		
	@Override
	@Select("select * from book where id=#{id}")
	Book findById(int id);
	
	@Override
	@Update("update book set title=#{title}, author=#{author}, price=#{price}, stock=#{stock}, img=#{img}, description=#{description} where id=#{id}")
	int update(Book book);
	
	@Override
	@Delete("delete from book where id=#{id}")
	int delete(int id);

	@Select("SELECT * FROM book WHERE stock > 0 and (title LIKE '%'||#{keyword}||'%' OR author LIKE '%'||#{keyword}||'%')")
	public List<Book> findByKeyword(String keyword);
	
	@Select("select * from book where stock > 0")
	public List<Book> findExistBook();
}