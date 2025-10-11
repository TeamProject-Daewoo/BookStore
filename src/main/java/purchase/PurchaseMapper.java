package purchase;

import java.time.LocalDateTime;
import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.InsertProvider;
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
	@Insert("INSERT INTO purchase(member_id, book_id, quantity, order_date, order_id, status) " +
            "VALUES(#{member_id}, #{book_id}, #{quantity}, NOW(), #{order_id}, #{status})")
	@SelectKey(statement = "SELECT LAST_INSERT_ID()", keyProperty = "id", before = false, resultType = int.class)
	public int save(Purchase purchase);
	
	@Override
	@Select("SELECT * FROM purchase")
	List<Purchase> findAll();
		
	@Override
	@Select("SELECT * FROM purchase WHERE id = #{id}")
	Purchase findById(int id);
	
   	@Select("SELECT * FROM purchase WHERE member_id = #{id} AND status = 'COMPLETED'")
	List<Purchase> findByUserId(int id);
	
	@Override
	@Update("UPDATE purchase SET member_id = #{member_id}, book_id = #{book_id}, quantity = #{quantity}, order_id = #{order_id} WHERE id = #{id}")
	int update(Purchase purchase);
	
	@Override
	@Delete("DELETE FROM purchase WHERE id = #{id}")
	int delete(int id);
	
 	@Select("SELECT "
			+ "IFNULL(SUM(p.quantity * b.price), 0) AS total, "
			+ "IFNULL(SUM(CASE WHEN DATE(p.order_date) = CURDATE() THEN p.quantity * b.price ELSE 0 END), 0) AS daily, "
			+ "IFNULL(SUM(CASE WHEN DATE_FORMAT(p.order_date, '%Y%m') = DATE_FORMAT(NOW(), '%Y%m') THEN p.quantity * b.price ELSE 0 END), 0) AS monthly, "
			+ "IFNULL(SUM(CASE WHEN DATE_FORMAT(p.order_date, '%Y') = DATE_FORMAT(NOW(), '%Y') THEN p.quantity * b.price ELSE 0 END), 0) AS yearly "
			+ "FROM purchase p "
			+ "JOIN book b ON p.book_id = b.id")
	public SumList getTotalList();
	
	@Select("SELECT SUM(p.quantity * b.price) AS total_price FROM purchase p JOIN book b ON p.book_id = b.id WHERE p.id = #{Id} GROUP BY p.id")
	public int getTotalPrice(int id);

    @Select("SELECT * FROM delivery_info WHERE order_id = #{orderId}")
    Delivery findByOrderId(String orderId);

    @Insert("INSERT INTO delivery_info(order_id, receiver_name, address, phone_number, delivery_message) " +
            "VALUES (#{orderId}, #{receiverName}, #{address}, #{phoneNumber}, #{deliveryMessage})")
    @SelectKey(statement = "SELECT LAST_INSERT_ID()", keyProperty = "id", before = false, resultType = Integer.class)
    void deliveryinsert(Delivery deliveryInfo);

    @Update("UPDATE delivery_info SET receiver_name = #{receiverName}, address = #{address}, phone_number = #{phoneNumber}, " +
            "delivery_message = #{deliveryMessage} WHERE order_id = #{orderId}")
    void deliveryupdate(Delivery deliveryInfo);
    
    @Select("SELECT order_id FROM purchase WHERE member_id = #{memberId} ORDER BY order_date DESC LIMIT 1")
    String findMostRecentOrderIdByMemberId(int memberId);

    @Select("SELECT p.id, p.member_id, m.name AS member_name, p.order_date, p.order_id, SUM(b.price * p.quantity) OVER (PARTITION BY p.order_id) AS total_price, "
    		+"b.id AS book_id, b.title AS book_title, p.quantity, b.author, b.category, b.isbn, "
    		+"(SELECT AVG(rating) FROM review WHERE book_id = b.id) AS rating "
    	    +"FROM purchase p "
    	    +"JOIN member m ON p.member_id = m.id "
    	    +"JOIN book b ON p.book_id = b.id "
    	    +"WHERE b.title LIKE CONCAT('%', #{searchReq.keyword}, '%') OR b.author LIKE CONCAT('%', #{searchReq.keyword}, '%') "
    	    +"ORDER BY ${searchReq.orderItem} ${searchReq.order}")
    public List<PurchaseQueryResult> getPurchaseView(@Param("searchReq") SearchRequest searchReq);
    
    @Select("SELECT * FROM purchase WHERE order_date BETWEEN #{startDate} AND #{endDate}")
    List<Purchase> findByDateRange(@Param("startDate") LocalDateTime startDate,
    							   @Param("endDate") LocalDateTime endDate);
    
    @Select("SELECT * FROM purchase WHERE book_id = #{bookId}")
    List<Purchase> findByBookId(int bookId);

    @InsertProvider(type = PurchaseSqlProvider.class, method = "savePurchaseListSql")
	public void savePurchaseList(List<Purchase> purchaseList);

    @Select("SELECT * FROM purchase WHERE order_id = #{orderId} AND status = 'PENDING'")
	public List<Purchase> findPendingByOrderId(String orderId);
	
    @Update("UPDATE purchase SET status = 'COMPLETED', payment_key = #{paymentKey} WHERE order_id = #{orderId} AND status = 'PENDING'")
	void updateStatusToCompleted(@Param("orderId") String orderId, @Param("paymentKey") String paymentKey);


    @Delete("DELETE FROM purchase WHERE status = 'PENDING' AND order_date <= DATE_SUB(NOW(), INTERVAL 10 MINUTE)")
	public int deleteOldPendingPurchases(int i);
}