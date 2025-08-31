package cart;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

import data.Book;

@Service
public class CookieService {

    private static final String CART_COOKIE_NAME = "cart";

    // 쿠키에서 장바구니 읽기 (isbn 기준)
    public Map<String, Integer> readCartCookie(HttpServletRequest request) {
        Map<String, Integer> cartMap = new HashMap<>();
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (CART_COOKIE_NAME.equals(c.getName())) {
                    String decodedValue = URLDecoder.decode(c.getValue(), StandardCharsets.UTF_8);
                    String[] items = decodedValue.split(",");
                    for (String item : items) {
                        if (item.isEmpty()) continue;
                        String[] parts = item.split(":");
                        String isbn = parts[0];
                        int quantity = Integer.parseInt(parts[1]);
                        cartMap.put(isbn, quantity);
                    }
                }
            }
        }
        return cartMap;
    }

    // 쿠키에 장바구니 저장 (isbn 기준)
    public void writeCartCookie(HttpServletResponse response, Map<String, Integer> cartMap) {
        StringBuilder sb = new StringBuilder();
        for (Map.Entry<String, Integer> entry : cartMap.entrySet()) {
            if (sb.length() > 0) sb.append(",");
            sb.append(entry.getKey()).append(":").append(entry.getValue());
        }
        try {
            String encodedValue = URLEncoder.encode(sb.toString(), StandardCharsets.UTF_8);
            Cookie cookie = new Cookie(CART_COOKIE_NAME, encodedValue);
            cookie.setPath("/");
            cookie.setMaxAge(7 * 24 * 60 * 60); // 7일
            response.addCookie(cookie);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 쿠키 장바구니 전체 삭제
    public void deleteCartCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie(CART_COOKIE_NAME, "");
        cookie.setPath("/");
        cookie.setMaxAge(0); // 만료
        response.addCookie(cookie);
    }

    // 특정 아이템 삭제
    public void deleteCartItem(HttpServletRequest request, HttpServletResponse response, String isbn) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (CART_COOKIE_NAME.equals(cookie.getName())) {
                    String decodedValue = URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8);
                    String[] items = decodedValue.split(",");
                    StringBuilder newValue = new StringBuilder();

                    for (String item : items) {
                        String[] parts = item.split(":");
                        String itemIsbn = parts[0];

                        if (!itemIsbn.equals(isbn)) {
                            if (newValue.length() > 0) newValue.append(",");
                            newValue.append(item);
                        }
                    }

                    try {
                        String encodedNewValue = URLEncoder.encode(newValue.toString(), StandardCharsets.UTF_8);
                        Cookie newCart = new Cookie(CART_COOKIE_NAME, encodedNewValue);
                        newCart.setPath("/");
                        newCart.setMaxAge(7 * 24 * 60 * 60); // 7일
                        response.addCookie(newCart);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    break;
                }
            }
        }
    }
    
    public void updateQuantity(HttpServletRequest request, HttpServletResponse response, String bookIsbn, int quantity) {
        // 1. bookId로 Book 조회
    	if (bookIsbn == null) return;


        // 2. 쿠키에서 장바구니 읽기
        Map<String, Integer> cartMap = readCartCookie(request);

        // 3. 수량 업데이트
        if (quantity <= 0) {
            cartMap.remove(bookIsbn); // 수량이 0이면 제거
        } else {
            cartMap.put(bookIsbn, quantity);
        }

        // 4. 쿠키에 다시 저장
        writeCartCookie(response, cartMap);
    }
    
}
