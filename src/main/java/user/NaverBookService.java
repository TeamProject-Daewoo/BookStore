package user;

import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import data.Book;

@Service
public class NaverBookService {

    // 1. 네이버 개발자 센터에서 발급받은 ID와 Secret을 입력하세요.
    private final String CLIENT_ID = "3g1hOGZA5qAl2lqOIKEv";
    private final String CLIENT_SECRET = "JbAZ3W50hS";

    /**
     * 키워드로 책을 검색하는 메서드 (일반 검색)
     */
    public List<Book> searchBooks(String keyword) {
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.set("X-Naver-Client-Id", CLIENT_ID);
        headers.set("X-Naver-Client-Secret", CLIENT_SECRET);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        URI uri = UriComponentsBuilder
                .fromUriString("https://openapi.naver.com")
                .path("/v1/search/book.json")
                .queryParam("query", keyword)
                .queryParam("display", 20)
                .encode(StandardCharsets.UTF_8)
                .build()
                .toUri();

        ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);
        return parseJsonToBookList(response.getBody());
    }

    /**
     * ISBN으로 책을 검색하는 메서드 (상세 검색) - 하이브리드 모델용
     */
    public Book searchBookByIsbn(String isbn) {
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.set("X-Naver-Client-Id", CLIENT_ID);
        headers.set("X-Naver-Client-Secret", CLIENT_SECRET);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        URI uri = UriComponentsBuilder
                .fromUriString("https://openapi.naver.com")
                .path("/v1/search/book_adv.json")
                .queryParam("d_isbn", isbn)
                .encode(StandardCharsets.UTF_8)
                .build()
                .toUri();

        ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);
        List<Book> books = parseJsonToBookList(response.getBody());
        return books.isEmpty() ? null : books.get(0);
    }


    /**
     * JSON 문자열을 파싱하여 Book 객체 리스트로 변환하는 private 메서드
     */
    private List<Book> parseJsonToBookList(String jsonString) {
        List<Book> bookList = new ArrayList<>();
        JSONObject jsonObject = new JSONObject(jsonString);
        JSONArray items = jsonObject.getJSONArray("items");

        for (int i = 0; i < items.length(); i++) {
            JSONObject item = items.getJSONObject(i);
            Book book = new Book();

            String title = item.optString("title").replaceAll("<(/)?b>", "");
            
            book.setTitle(title);
            book.setIsbn(item.optString("isbn"));
            book.setAuthor(item.optString("author"));
            book.setImg(item.optString("image"));
            book.setDescription(item.optString("description"));
            
            int price = item.optInt("discount");
            if (price == 0) {
                price = item.optInt("price");
            }
            book.setPrice(price);
            
            book.setStock(10); // 임의의 재고
            
            
            
            // <<-- (핵심 수정) 카테고리 자동 분류 로직 호출 -->>
            String naverCategory = item.optString("category");
            System.out.println("네이버에서 받은 카테고리: [" + naverCategory + "]"); // 콘솔에 출력

            book.setCategory(determineCategory(naverCategory));

            bookList.add(book);
        }
        return bookList;
    }

    /**
     * 네이버 카테고리 문자열을 우리 시스템의 카테고리로 변환하는 메서드 (새로 추가)
     * @param naverCategory 네이버 API에서 받은 카테고리 문자열
     * @return 우리 시스템에서 사용하는 카테고리 문자열
     */
    private String determineCategory(String naverCategory) {
        if (naverCategory.contains("소설")) {
            return "소설";
        } else if (naverCategory.contains("컴퓨터") || naverCategory.contains("IT")) {
            return "IT/컴퓨터";
        } else if (naverCategory.contains("경제") || naverCategory.contains("경영")) {
            return "경제/경영";
        } else {
            return "기타"; // 위의 어떤 키워드에도 해당하지 않으면 '기타'로 분류
        }
    }
}