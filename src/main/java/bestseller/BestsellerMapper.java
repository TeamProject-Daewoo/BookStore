package bestseller;

import java.util.List;
import org.apache.ibatis.annotations.*;

@Mapper
public interface BestsellerMapper {

    @Delete("DELETE FROM BESTSELLER WHERE PERIOD = #{period}")
    void deleteByPeriod(@Param("period") String period);

    @Select("SELECT BESTSELLER_SEQ.NEXTVAL FROM dual")
    int getNextId();

    @Insert("INSERT INTO BESTSELLER (ID, BOOK_ID, TOTAL_SALES, RANK, CREATED_AT, PERIOD) " +
            "VALUES (#{id}, #{bookId}, #{totalSales}, #{rank}, #{createdAt}, #{period})")
    void insertWithPeriod(Bestseller bestseller);

    @Select("SELECT ID as id, BOOK_ID as bookId, TOTAL_SALES as totalSales, RANK as rank, CREATED_AT as createdAt, PERIOD as period " +
            "FROM BESTSELLER " +
            "WHERE PERIOD = #{period} ORDER BY RANK ASC")
    @Results(id="BestsellerResult", value = {
            @Result(property="id", column="id"),
            @Result(property="bookId", column="bookId"),
            @Result(property="totalSales", column="totalSales"),
            @Result(property="rank", column="rank"),
            @Result(property="createdAt", column="createdAt"),
            @Result(property="period", column="period")
    })
    List<Bestseller> findByPeriod(@Param("period") String period);
}
