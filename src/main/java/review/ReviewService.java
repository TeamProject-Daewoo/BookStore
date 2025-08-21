package review;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReviewService {

	@Autowired
	ReviewMapper reviewMapper;

	public void saveReview(Review review) {
		reviewMapper.insertReview(review);
	}
	
	public List<Review> getReviewsByBookId(int bookId) {
		System.out.println("################################################" + reviewMapper.findByBookId(bookId));
		
		return reviewMapper.findByBookId(bookId);
    }

	public Review findById(int reviewId) {
		return reviewMapper.findById(reviewId);
	}

	public void deleteReview(int reviewId) {
		reviewMapper.deleteReview(reviewId);
		
	}

	public void updateReview(Review review) {
		reviewMapper.updateReview(review);
		
	}
	
}
