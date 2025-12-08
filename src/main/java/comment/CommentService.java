package comment;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CommentService {

    @Autowired
    private CommentMapper commentMapper;

    // 댓글 등록
    @Transactional
    public void saveComment(Comment comment) {
        commentMapper.insertComment(comment);
    }

    // 특정 게시글의 댓글 조회
    @Transactional(readOnly = true)
    public List<Comment> getCommentsByBoardId(Long id) {
        return commentMapper.findByBoardId(id);
    }

    // 댓글 ID로 조회
    @Transactional(readOnly = true)
    public Comment findById(int commentId) {
        return commentMapper.findById(commentId);
    }

    // 댓글 삭제
    @Transactional
    public void deleteComment(int commentId) {
        commentMapper.deleteComment(commentId);
    }

    // 댓글 수정
    @Transactional
    public void updateComment(Comment comment) {
        commentMapper.updateComment(comment);
    }

    @Transactional(readOnly = true)
    public int countByBoardId(Long boardId) {
        return commentMapper.countByBoardId(boardId); // Mapper에 쿼리 필요
    }

}
