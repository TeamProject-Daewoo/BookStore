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
	@Insert("insert into purchase(id, member_id, book_id, quantity, order_date) values(#{id}, #{member_id}, #{book_id}, #{quantity}, SYSDATE)")
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
	@Update("update purchase set member_id=#{member_id}, book_id=#{book_id}, quantity=#{quantity} where id=#{id}")
	int update(Purchase purchase);
	
	@Override
	@Delete("delete from purchase where id=#{id}")
	int delete(int id);
} 