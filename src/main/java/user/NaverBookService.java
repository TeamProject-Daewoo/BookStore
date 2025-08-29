package user;

import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.javassist.compiler.ast.Keyword;
import org.json.JSONArray;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.springframework.beans.factory.annotation.Value;
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

    @Value("${naver.api.clientId}")
    private String CLIENT_ID;

    @Value("${naver.api.clientSecret}")
    private String CLIENT_SECRET;

    // --- searchBooks, searchBookByIsbn 메서드는 기존과 동일 ---
    public List<Book> searchBooks(String keyword) {
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.set("X-Naver-Client-Id", CLIENT_ID);
        headers.set("X-Naver-Client-Secret", CLIENT_SECRET);
        HttpEntity<String> entity = new HttpEntity<>(headers);
        
        URI uri = UriComponentsBuilder.fromUriString("https://openapi.naver.com").path("/v1/search/book.json")
                .queryParam("query", (keyword == null || keyword.length() == 0 ? "책" : keyword)).queryParam("display", 20).encode(StandardCharsets.UTF_8).build().toUri();

        ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);
        return parseJsonToBookList(response.getBody());
    }

    public Book searchBookByIsbn(String isbn) {
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.set("X-Naver-Client-Id", CLIENT_ID);
        headers.set("X-Naver-Client-Secret", CLIENT_SECRET);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        URI uri = UriComponentsBuilder.fromUriString("https://openapi.naver.com").path("/v1/search/book_adv.json")
                .queryParam("d_isbn", isbn).encode(StandardCharsets.UTF_8).build().toUri();

        ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);
        List<Book> books = parseJsonToBookList(response.getBody());
        return books.isEmpty() ? null : books.get(0);
    }
    // -----------------------------------------------------------------

    private List<Book> parseJsonToBookList(String jsonString) {
        List<Book> bookList = new ArrayList<>();
        JSONObject jsonObject = new JSONObject(jsonString);
        JSONArray items = jsonObject.getJSONArray("items");

        for (int i = 0; i < items.length(); i++) {
            JSONObject item = items.getJSONObject(i);
            Book book = new Book();

            String title = Jsoup.parse(item.optString("title")).text();
            //String title = item.optString("title").replaceAll("<(/)?b>", "");
            String link = item.optString("link");
            
            book.setTitle(title);
            book.setIsbn(item.optString("isbn"));
            book.setAuthor(item.optString("author"));
            book.setImg(item.optString("image"));
            book.setDescription(item.optString("description"));
            book.setLink(link);
            
            int price = item.optInt("discount");
            if (price == 0) {
                price = item.optInt("price");
            }
            book.setPrice(price);
            book.setStock(10);
            
            // === (핵심 수정) 스크래핑 우선 로직 ===
            String category = "기타"; // 기본값을 '기타'로 설정
            
            // 1. 스크래핑 시도
            String scrapedCategory = scrapeCategoryFromUrl(link);
            
            // 2. 스크래핑에 성공했다면 해당 카테고리로 분류
            if (scrapedCategory != null && !scrapedCategory.isEmpty()) {
                category = classifyCategory(scrapedCategory);
            }
            // 3. (선택적) 스크래핑 실패 시 제목/설명으로 2차 시도
            else {
                 category = classifyCategory(book.getTitle() + " " + book.getDescription());
            }

            book.setCategory(category);
            // ===========================================

            bookList.add(book);
        }
        return bookList;
    }
    
    public String scrapeCategoryFromUrl(String bookLink) {
        try {
            if (bookLink == null || bookLink.isEmpty()) return null;
            Document doc = Jsoup.connect(bookLink).get();
            Element categoryElement = doc.selectFirst(".bookBasicInfo_info_detail__73sfk");
            if (categoryElement != null) {
                return categoryElement.text();
            }
        } catch (Exception e) {
            System.err.println("Jsoup 스크래핑 실패: " + bookLink);
        }
        return null;
    }

    public String classifyCategory(String text) {
        if (text == null || text.isEmpty()) {
            return "기타";
        }
        String lowerCaseText = text.toLowerCase();

        if (lowerCaseText.contains("소설") || lowerCaseText.contains("문학")) {
            return "소설";
        } else if (lowerCaseText.contains("java") || lowerCaseText.contains("python") || lowerCaseText.contains("코딩") || 
                   lowerCaseText.contains("프로그래밍") || lowerCaseText.contains("컴퓨터") || lowerCaseText.contains("it")) {
            return "IT/컴퓨터";
        } else if (lowerCaseText.contains("경제") || lowerCaseText.contains("경영") || lowerCaseText.contains("투자") || lowerCaseText.contains("주식")) {
            return "경제/경영";
        } else {
            return "기타";
        }
    }
}