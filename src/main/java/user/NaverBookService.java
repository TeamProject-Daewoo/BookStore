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
            book.setStock(30);
            
            String category = "기타";
            
            String scrapedCategory = scrapeCategoryFromUrl(link);
            
            if (scrapedCategory != null && !scrapedCategory.isEmpty()) {
                category = classifyCategory(scrapedCategory);
            }
            else {
                 category = classifyCategory(book.getTitle() + " " + book.getDescription());
            }

            book.setCategory(category);

            bookList.add(book);
        }
        return bookList;
    }
    
    public String scrapeCategoryFromUrl(String bookLink) {
        try {
            if (bookLink == null || bookLink.isEmpty()) return null;
            Document doc = Jsoup.connect(bookLink).get();
            // 참고: 네이버 도서의 카테고리 클래스명이 변경될 수 있습니다.
            Element categoryElement = doc.selectFirst(".bookBasicInfo_info_detail__73sfk");
            if (categoryElement != null) {
                return categoryElement.text();
            }
        } catch (Exception e) {
            System.err.println("Jsoup 스크래핑 실패: " + bookLink);
        }
        return null;
    }
    
    // ===== classifyCategory 메서드 수정된 부분 시작 =====
    public String classifyCategory(String text) {
        if (text == null || text.isEmpty()) {
            return "기타";
        }
        String lowerCaseText = text.toLowerCase();

        // 구체적인 카테고리부터 검사하여 우선순위를 정합니다.
        if (containsAny(lowerCaseText, "수험서", "자격증", "기사", "공무원", "수능", "모의고사")) return "수험서/자격증";
        if (containsAny(lowerCaseText, "고등", "고등학교")) return "고등학교 참고서";
        if (containsAny(lowerCaseText, "중등", "중학교")) return "중학교 참고서";
        if (containsAny(lowerCaseText, "초등", "초등학교", "문제집")) return "초등학교 참고서";
        if (containsAny(lowerCaseText, "java", "python", "코딩", "프로그래밍", "개발", "c++", "컴퓨터", "it", "서버", "네트워크", "데이터베이스", "db")) return "컴퓨터/IT";
        if (containsAny(lowerCaseText, "토익", "toeic", "영어", "일본어", "jlpt", "중국어", "hsk", "언어", "사전")) return "국어/외국어";
        if (containsAny(lowerCaseText, "경제", "경영", "투자", "주식", "재테크", "마케팅", "비즈니스", "금융", "회계")) return "경제/경영";
        if (containsAny(lowerCaseText, "요리", "레시피", "육아", "인테리어", "살림")) return "가정/요리";
        if (containsAny(lowerCaseText, "건강", "다이어트", "운동", "의학", "취미", "스포츠", "등산")) return "건강/취미";
        if (containsAny(lowerCaseText, "만화", "웹툰", "코믹스", "그래픽노블")) return "만화";
        if (containsAny(lowerCaseText, "여행", "가이드북")) return "여행";
        if (containsAny(lowerCaseText, "유아", "아기", "그림책", "0세", "1세", "2세", "3세")) return "유아";
        if (containsAny(lowerCaseText, "어린이", "동화")) return "어린이";
        if (containsAny(lowerCaseText, "청소년", "10대")) return "청소년";
        if (containsAny(lowerCaseText, "시", "에세이", "산문", "수필")) return "시/에세이";
        if (containsAny(lowerCaseText, "소설", "문학", "희곡")) return "소설";
        if (containsAny(lowerCaseText, "자기계발", "성공", "습관", "리더십", "처세", "동기부여")) return "자기계발";
        if (containsAny(lowerCaseText, "역사", "세계사", "한국사")) return "역사";
        if (containsAny(lowerCaseText, "과학", "물리", "화학", "생물", "우주", "뇌과학", "수학")) return "자연/과학";
        if (containsAny(lowerCaseText, "예술", "미술", "음악", "영화", "디자인", "건축", "사진")) return "예술/대중문화";
        if (containsAny(lowerCaseText, "사회", "정치", "법", "미디어", "페미니즘", "인권")) return "사회/정치";
        if (containsAny(lowerCaseText, "인문", "철학", "심리", "교양", "사상")) return "인문";
        if (containsAny(lowerCaseText, "종교", "기독교", "불교", "성경", "신학")) return "종교";
        if (containsAny(lowerCaseText, "잡지", "매거진", "월간")) return "잡지";

        // 위 조건에 모두 해당하지 않으면 '기타'로 분류
        return "기타";
    }

    /**
     * 텍스트에 여러 키워드 중 하나라도 포함되어 있는지 확인하는 헬퍼 메서드
     * @param text 검사할 전체 텍스트
     * @param keywords 포함 여부를 확인할 키워드 배열
     * @return 하나라도 포함되면 true, 아니면 false
     */
    private boolean containsAny(String text, String... keywords) {
        for (String keyword : keywords) {
            if (text.contains(keyword)) {
                return true;
            }
        }
        return false;
    }
    // ===== classifyCategory 메서드 수정된 부분 끝 =====
}