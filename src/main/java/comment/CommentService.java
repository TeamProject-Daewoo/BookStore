package comment;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CommentService {

    @Autowired
    private CommentMapper commentMapper;

    // 댓글 등록
    public void saveComment(Comment comment) {
        commentMapper.insertComment(comment);
    }

    // 특정 게시글의 댓글 조회
    public List<Comment> getCommentsByBoardId(Long id) {
        System.out.println("################################################" + commentMapper.findByBoardId(id));
        return commentMapper.findByBoardId(id);
    }

    // 댓글 ID로 조회
    public Comment findById(int commentId) {
        return commentMapper.findById(commentId);
    }

    // 댓글 삭제
    public void deleteComment(int commentId) {
        commentMapper.deleteComment(commentId);
    }

    // 댓글 수정
    public void updateComment(Comment comment) {
        commentMapper.updateComment(comment);
    }

}
