package purchase;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.jdbc.SQL; // MyBatis의 SQL 빌더 클래스는 그대로 유지합니다.

public class PurchaseSqlProvider {

    /**
     * MySQL의 단일 INSERT 문으로 여러 행을 삽입(Batch Insert)하는 SQL을 동적으로 생성합니다.
     * MySQL에서는 AUTO_INCREMENT를 사용하고, Oracle 시퀀스/PL/SQL 블록을 사용하지 않습니다.
     * @param parameters Mapper 메서드로부터 전달받은 파라미터 맵
     * @return 생성된 SQL 문자열
     */
	public String savePurchaseListSql(Map<String, Object> parameters) {
        List<Purchase> list = (List<Purchase>) parameters.get("list");

        if (list == null || list.isEmpty()) {
            // MySQL에서는 실행할 내용이 없을 때 빈 문자열을 반환하여 쿼리 실행을 막습니다.
            // 또는 최소한의 유효한 쿼리 (예: SELECT 1)를 반환할 수도 있습니다.
            return "SELECT 1"; 
        }

        StringBuilder sql = new StringBuilder();

        sql.append("INSERT INTO purchase (MEMBER_ID, BOOK_ID, QUANTITY, ORDER_DATE, ORDER_ID, STATUS) VALUES ");

        for (int i = 0; i < list.size(); i++) {
            if (i > 0) {
                sql.append(", ");
            }
            sql.append("(");
            sql.append("#{list[").append(i).append("].member_id}, ");
            sql.append("#{list[").append(i).append("].book_id}, ");
            sql.append("#{list[").append(i).append("].quantity}, ");
            sql.append("NOW(), ");
            sql.append("#{list[").append(i).append("].order_id}, ");
            sql.append("#{list[").append(i).append("].status})");
        }

        return sql.toString();
    }
}