package home;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.Refill;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class RateLimitFilter implements Filter {
	
    private final Map<String, Bucket> buckets = new ConcurrentHashMap<>();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String clientIp = httpRequest.getRemoteAddr();
        String requestURI = httpRequest.getRequestURI();
        String method = httpRequest.getMethod();
        boolean isErrorPage = requestURI.endsWith("limitExceeded.jsp") || requestURI.contains("/error/");

        // 1. 회원가입 전용 제한(register 30분에 5번)
        if (requestURI.equals("/user/register") && "POST".equalsIgnoreCase(method)) {
            Bucket registerBucket = buckets.computeIfAbsent(clientIp + ":register", k -> createBucket(60 * 30, 5));
            if (!registerBucket.tryConsume(1)) {
                sendErrorRedirect(httpRequest, httpResponse);
                return;
            }
        }
        
        // 2. 봇 공격 제한(1초에 5번)
        Bucket globalBucket = buckets.computeIfAbsent(clientIp + ":global", k -> createBucket(1, 5));
        if (!isErrorPage && !globalBucket.tryConsume(1)) {
            sendErrorRedirect(httpRequest, httpResponse);
            return;
        }
        
        // 3. 반복적인 에러요청 제한(404, 403, 302 응답 1시간에 20번)
        Bucket penaltyBucket = buckets.computeIfAbsent(clientIp + ":penalty", k -> createBucket(60 * 60, 20));
        if (!isErrorPage && penaltyBucket.getAvailableTokens() <= 0) {
        	sendErrorRedirect(httpRequest, httpResponse);
            return;
        }
        chain.doFilter(request, response);
        
        int status = httpResponse.getStatus();
        if (status == 404 || status == 403 || status == 302) {
            penaltyBucket.tryConsume(1); 
        }
    }

    private Bucket createBucket(long seconds, int capacity) {
        return Bucket.builder()
            .addLimit(Bandwidth.classic(capacity, Refill.greedy(capacity, Duration.ofSeconds(seconds))))
            .build();
    }

    private void sendErrorRedirect(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/html; charset=UTF-8");
        res.sendRedirect(req.getContextPath() + "/error/limitExceeded.jsp");
    }
}
