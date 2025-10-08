package purchase;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import purchase.PurchaseService;

@Component // 👈 Spring이 이 클래스를 관리하도록 @Component를 붙여줍니다.
public class OrderCleanupScheduler {

    private static final Logger log = LoggerFactory.getLogger(OrderCleanupScheduler.class);

    @Autowired
    private PurchaseService purchaseService;

    /**
     * 10분마다 실행되어 오래된 PENDING 주문을 정리합니다.
     * fixedRate = 600000 (10분 = 600,000 밀리초)
     */
    @Scheduled(fixedRate = 600000)
    public void cleanupTask() {
        log.info("오래된 PENDING 주문 데이터 정리 작업을 시작합니다...");
        try {
            purchaseService.cleanupOldPendingPurchases();
            log.info("정리 작업이 성공적으로 완료되었습니다.");
        } catch (Exception e) {
            log.error("주문 데이터 정리 작업 중 오류가 발생했습니다.", e);
        }
    }
}