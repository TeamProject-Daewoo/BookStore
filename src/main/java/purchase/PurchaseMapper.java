package purchase;

import java.time.LocalDateTime;
import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

import data.BaseMapper;
import restapi.SearchRequest;

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
	public int getPurchasePrice(int order_id);

	@Select("SELECT SUM(p.quantity * b.price) AS total_price FROM purchase p JOIN book b ON p.book_id = b.id WHERE p.id = #{Id} GROUP BY p.id")
	public int getTotalPrice(int id);

	
	@Select("SELECT * FROM delivery_info WHERE order_id = #{orderId}")
    Delivery findByOrderId(int orderId);

    @Insert("INSERT INTO delivery_info(id, order_id, receiver_name, address, phone_number, delivery_message) " +
            "VALUES (delivery_info_seq.nextval, #{orderId}, #{receiverName}, #{address}, #{phoneNumber}, #{deliveryMessage})")
    void deliveryinsert(Delivery deliveryInfo);

    @Update("UPDATE delivery_info SET receiver_name = #{receiverName}, address = #{address}, phone_number = #{phoneNumber}, " +
            "delivery_message = #{deliveryMessage} WHERE order_id = #{orderId}")
    void deliveryupdate(Delivery deliveryInfo);
    
    @Select("SELECT order_id FROM (SELECT order_id FROM purchase WHERE member_id = #{memberId} ORDER BY order_date DESC) WHERE ROWNUM = 1")
    Integer findMostRecentOrderIdByMemberId(int memberId);

    @Select("SELECT * FROM purchase p JOIN book b on p.book_id=b.id JOIN member m on p.member_id=m.id "
    		+ "where b.title LIKE '%'||#{keyword}||'%' OR b.author LIKE '%'||#{keyword}||'%' order by ${orderItem} ${order}")
	public List<Purchase> getOrderedList(SearchRequest searchReq);

    
    @Select("SELECT * FROM purchase WHERE order_date BETWEEN #{startDate} AND #{endDate}")
    List<Purchase> findByDateRange(@Param("startDate") LocalDateTime startDate,
                                   @Param("endDate") LocalDateTime endDate);
} 