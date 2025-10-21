package home;

import java.sql.Driver;
import java.sql.DriverManager;
import java.util.Enumeration;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.springframework.stereotype.Component;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

import org.springframework.stereotype.Component;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

@Component // Spring Bean으로 등록
public class MySQLCleanupListener implements ServletContextListener { 
	
	@Override
    public void contextDestroyed(ServletContextEvent sce) {

        // 1. 드라이버 해제
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
                System.out.println("[INFO] Deregistered driver: " + driver);
            } catch (Exception e) {
                System.err.println("[WARN] Error deregistering driver: " + driver);
            }
        }

        // 2. cleanup thread 종료
        AbandonedConnectionCleanupThread.checkedShutdown();
    }
}