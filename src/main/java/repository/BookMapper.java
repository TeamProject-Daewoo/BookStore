package repository;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import vo.Book;

@Mapper
public interface BookMapper extends BaseMapper<Book> {
	
	@Override
	@Insert("insert into book(id, title, author, price, stock, img, description) values(#{id}, #{title}, #{author}, #{price}, #{stock}, #{img}, #{description})")
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
}