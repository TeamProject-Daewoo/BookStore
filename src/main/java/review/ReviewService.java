package review;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ReviewService {

	@Autowired
	ReviewMapper reviewMapper;

	@Transactional
	public void saveReview(Review review) {
		reviewMapper.insertReview(review);
	}
	
	@Transactional(readOnly = true)
	public List<Review> getReviewsByBookId(int bookId) {
		return reviewMapper.findByBookId(bookId);
    }

	@Transactional(readOnly = true)
	public Review findById(int reviewId) {
		return reviewMapper.findById(reviewId);
	}

	@Transactional
	public void deleteReview(int reviewId) {
		reviewMapper.deleteReview(reviewId);	
	}

	@Transactional
	public void updateReview(Review review) {
		reviewMapper.updateReview(review);
		
	}
	
}
