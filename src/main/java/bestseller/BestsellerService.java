package bestseller;

import java.time.*;
import java.util.*;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import data.Book;
import data.BookMapper;
import purchase.Purchase;
import purchase.PurchaseMapper;

@Service
public class BestsellerService {

    @Autowired
    private PurchaseMapper purchaseMapper;

    @Autowired
    private BestsellerMapper bestsellerMapper;

    @Autowired
    private BookMapper bookMapper; // Book 정보 조회

    // 화면용 DTO 반환
    public List<BestsellerView> getBestSellers(String period) {
        List<Bestseller> bestsellerList = bestsellerMapper.findByPeriod(period);

        List<BestsellerView> viewList = bestsellerList.stream()
                .map(b -> {
                    Book book = bookMapper.findById(b.getBookId());
                    return BestsellerView.builder()
                    		.book_id(b.getBookId())
                            .rank(b.getRank())
                            .totalSales(b.getTotalSales())
                            .rankChange(b.getRankChange())
                            .title(book != null ? book.getTitle() : "제목 없음")
                            .author(book != null ? book.getAuthor() : "저자 없음")
                            .img(book != null ? book.getImg() : "")
                            .build();
                })
                .collect(Collectors.toList());

        return viewList;
    }

    // 기존 updateBestSellers() 그대로 유지
    public void updateBestSellers() {
        LocalDate today = LocalDate.now();
        updateBestseller("today", today.atStartOfDay(), today.atTime(LocalTime.MAX));

        LocalDate weekStart = today.with(DayOfWeek.MONDAY);
        LocalDate weekEnd = today.with(DayOfWeek.SUNDAY);
        updateBestseller("week", weekStart.atStartOfDay(), weekEnd.atTime(LocalTime.MAX));

        LocalDate monthStart = today.withDayOfMonth(1);
        LocalDate monthEnd = today.withDayOfMonth(today.lengthOfMonth());
        updateBestseller("month", monthStart.atStartOfDay(), monthEnd.atTime(LocalTime.MAX));
    }

    private void updateBestseller(String period, LocalDateTime startDate, LocalDateTime endDate) {
        List<Purchase> purchases = purchaseMapper.findByDateRange(startDate, endDate);

        Map<Integer, Integer> salesMap = new HashMap<>();
        for (Purchase p : purchases) {
            salesMap.put(p.getBook_id(),
                    salesMap.getOrDefault(p.getBook_id(), 0) + p.getQuantity());
        }

        List<Map.Entry<Integer, Integer>> sorted = new ArrayList<>(salesMap.entrySet());
        sorted.sort((a, b) -> b.getValue() - a.getValue());

        List<Bestseller> previousList = bestsellerMapper.findByPeriod(period);
        Map<Integer, Integer> previousRankMap = previousList.stream()
                .collect(Collectors.toMap(
                        Bestseller::getBookId,
                        Bestseller::getRank,
                        (oldValue, newValue) -> oldValue
                ));

        bestsellerMapper.deleteByPeriod(period);

        int rank = 1;
        for (Map.Entry<Integer, Integer> entry : sorted) {
            if (rank > 100) break;

            Bestseller b = Bestseller.builder()
                    .id(bestsellerMapper.getNextId())
                    .bookId(entry.getKey())
                    .totalSales(entry.getValue())
                    .rank(rank)
                    .createdAt(LocalDateTime.now())
                    .period(period)
                    .build();

            Integer prevRank = previousRankMap.get(entry.getKey());
            if (prevRank != null) {
                b.setRankChange(prevRank - rank);
            } else {
                b.setRankChange(null);
            }

            bestsellerMapper.insertWithPeriod(b);
            rank++;
        }
    }
}
