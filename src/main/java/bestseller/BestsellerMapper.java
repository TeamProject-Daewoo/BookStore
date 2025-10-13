package bestseller;

import java.util.List;
import org.apache.ibatis.annotations.*;

@Mapper
public interface BestsellerMapper {

    @Delete("DELETE FROM bestseller WHERE period = #{period}")
    void deleteByPeriod(@Param("period") String period);

    /**
     * 주의: 'rank'는 MySQL 예약어이므로 백틱(`) 처리
     */
    @Insert("INSERT INTO bestseller (book_id, total_sales, `rank`, created_at, period) " +
            "VALUES (#{bookId}, #{totalSales}, #{rank}, #{createdAt}, #{period})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    void insertWithPeriod(Bestseller bestseller);

    @Select("SELECT id, book_id, total_sales, `rank`, created_at, period " +
            "FROM bestseller " +
            "WHERE period = #{period} ORDER BY `rank` ASC")

    @Results(id="BestsellerResult", value = {
            @Result(property="id", column="id"),
            @Result(property="bookId", column="book_id"),
            @Result(property="totalSales", column="total_sales"),
            @Result(property="rank", column="`rank`"),
            @Result(property="createdAt", column="created_at"),
            @Result(property="period", column="period")
    })
    List<Bestseller> findByPeriod(@Param("period") String period);
}