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
        // RestTemplate 객체 생성 (사전 설정으로 Bean으로 등록하는 것을 추천)
        RestTemplate restTemplate = new RestTemplate();

        // HTTP 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.set("X-Naver-Client-Id", CLIENT_ID);
        headers.set("X-Naver-Client-Secret", CLIENT_SECRET);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        // URI 설정
        URI uri = UriComponentsBuilder
                .fromUriString("https://openapi.naver.com")
                .path("/v1/search/book.json")
                .queryParam("query", keyword)
                .queryParam("display", 20) // 20개까지 결과 가져오기
                .encode(StandardCharsets.UTF_8)
                .build()
                .toUri();

        // API 호출 및 응답 받기
        ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);
        
        // JSON 파싱 및 Book 리스트로 변환
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
                .path("/v1/search/book_adv.json") // 상세 검색 API
                .queryParam("d_isbn", isbn)
                .encode(StandardCharsets.UTF_8)
                .build()
                .toUri();

        ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);
        
        List<Book> books = parseJsonToBookList(response.getBody());
        // ISBN 검색은 보통 1개의 결과만 나오므로 첫 번째 항목을 반환
        return books.isEmpty() ? null : books.get(0);
    }


    /**
     * JSON 문자열을 파싱하여 Book 객체 리스트로 변환하는 private 메서드
     */
    /**
     * JSON 문자열을 파싱하여 Book 객체 리스트로 변환하는 private 메서드 (수정 버전)
     */
    private List<Book> parseJsonToBookList(String jsonString) {
        List<Book> bookList = new ArrayList<>();
        JSONObject jsonObject = new JSONObject(jsonString);
        JSONArray items = jsonObject.getJSONArray("items");

        for (int i = 0; i < items.length(); i++) {
            JSONObject item = items.getJSONObject(i);
            Book book = new Book();

            // title에서 <b>, </b> 태그 제거
            String title = item.optString("title").replaceAll("<(/)?b>", "");
            
            book.setTitle(title);
            book.setIsbn(item.optString("isbn")); // optString으로 안전하게 조회
            book.setAuthor(item.optString("author"));
            book.setImg(item.optString("image"));
            book.setDescription(item.optString("description"));
            
            // <<-- 가격 정보 안전하게 가져오기 (핵심 수정) -->>
            // 1. 할인가(discount)를 우선적으로 가져옵니다.
            int price = item.optInt("discount"); 
            // 2. 만약 할인가가 없거나 0원이면, 정가(price)를 가져옵니다.
            if (price == 0) {
                price = item.optInt("price");
            }
            book.setPrice(price);
            
            // 네이버 API는 재고(stock)나 카테고리 정보를 제공하지 않으므로 기본값 설정
            book.setStock(10); 
            book.setCategory("미분류");

            bookList.add(book);
        }
        return bookList;
    }
}