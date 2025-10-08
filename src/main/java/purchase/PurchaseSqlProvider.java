package purchase;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.jdbc.SQL; // MyBatis의 SQL 빌더 클래스를 사용할 수도 있습니다.

public class PurchaseSqlProvider {

    /**
     * Oracle의 INSERT ALL 구문을 동적으로 생성하는 메서드입니다.
     * @param parameters Mapper 메서드로부터 전달받은 파라미터 맵
     * @return 생성된 SQL 문자열
     */
	public String savePurchaseListSql(Map<String, Object> parameters) {
        List<Purchase> list = (List<Purchase>) parameters.get("list");

        if (list == null || list.isEmpty()) {
            // 실행할 내용이 없으므로 PL/SQL의 NULL; 문을 반환
            return "BEGIN NULL; END;";
        }

        StringBuilder sql = new StringBuilder();
        // 1. 여러 SQL 문을 하나의 블록으로 묶는 BEGIN 추가
        sql.append("BEGIN ");

        // 2. 리스트의 각 항목에 대해 별도의 INSERT 문을 생성하고 세미콜론(;)으로 구분
        for (int i = 0; i < list.size(); i++) {
            sql.append("INSERT INTO PURCHASE (ID, MEMBER_ID, BOOK_ID, QUANTITY, ORDER_DATE, ORDER_ID, STATUS) ");
            sql.append("VALUES (PURCHASE_SEQ.NEXTVAL, ");
            sql.append("#{list[").append(i).append("].member_id}, ");
            sql.append("#{list[").append(i).append("].book_id}, ");
            sql.append("#{list[").append(i).append("].quantity}, ");
            sql.append("SYSDATE, ");
            sql.append("#{list[").append(i).append("].order_id}, ");
            sql.append("#{list[").append(i).append("].status}); "); // 각 INSERT 문 끝에 세미콜론 추가
        }

        // 3. 블록을 닫는 END; 추가
        sql.append("END;");

        return sql.toString();
    }
}