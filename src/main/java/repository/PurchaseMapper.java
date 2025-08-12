package repository;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

import vo.Purchase;

@Mapper
public interface PurchaseMapper extends BaseMapper<Purchase> {
	
	@Override
	@Insert("insert into purchase(id, member_id, book_id, quantity, order_date, order_id) values(#{id}, #{member_id}, #{book_id}, #{quantity}, SYSDATE, #{order_id})")
	@SelectKey(statement = "SELECT purchase_seq.NEXTVAL FROM DUAL", keyProperty = "id", before = true, resultType = int.class)
	public int save(Purchase purchase);
	
	@Override
	@Select("select * from purchase")
	List<Purchase> findAll();
		
	@Override
	@Select("select * from purchase where id=#{id}")
	Purchase findById(int id);
	
	@Select("select * from purchase where member_id=#{id}")
	List<Purchase> findByUserId(int id);
	
	@Override
	@Update("update purchase set member_id=#{member_id}, book_id=#{book_id}, quantity=#{quantity}, order_id=#{order_id} where id=#{id}")
	int update(Purchase purchase);
	
	@Override
	@Delete("delete from purchase where id=#{id}")
	int delete(int id);
	
	@Select("SELECT SUM(p.quantity * b.price) AS total_price FROM purchase p JOIN book b ON p.book_id = b.id WHERE p.order_id = #{orderId} GROUP BY p.order_id")
	public int getPurchasePrice(int order_id);;

	@Select("SELECT SUM(p.quantity * b.price) AS total_price FROM purchase p JOIN book b ON p.book_id = b.id WHERE p.id = #{Id} GROUP BY p.id")
	public int getTotalPrice(int id);

} 