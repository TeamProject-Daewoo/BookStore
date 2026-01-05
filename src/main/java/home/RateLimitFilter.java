package home;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.Refill;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
        
        String requestURI = httpRequest.getRequestURI();
        String method = httpRequest.getMethod();
        
        if (requestURI.equals("/user/register") && "POST".equalsIgnoreCase(method)) {
            String clientIp = httpRequest.getRemoteAddr();
            Bucket bucket = buckets.computeIfAbsent(clientIp, this::newBucket);

            if (bucket.tryConsume(1)) {
                chain.doFilter(request, response);
            } else {
            	httpResponse.setContentType("text/html; charset=UTF-8");
                String contextPath = httpRequest.getContextPath();
                httpResponse.sendRedirect(contextPath + "/error/limitExceeded.jsp");
            }
        } else {
            chain.doFilter(request, response);
        }
    }

    private Bucket newBucket(String ip) {
        return Bucket.builder()
            .addLimit(Bandwidth.classic(5, Refill.intervally(3, Duration.ofMinutes(30))))
            .build();
    }
}