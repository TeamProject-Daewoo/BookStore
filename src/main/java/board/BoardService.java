package board;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BoardService {

    private final BoardMapper boardMapper;

    // 전체 글 목록
    public List<Board> findAll() {
        return boardMapper.selectAll();
    }

    // 글 상세 조회
    public Board findById(Long id) {
        return boardMapper.selectById(id);
    }

    // 글 등록
    public int save(Board post) {
        return boardMapper.insert(post);
    }
    
    public List<Board> findPage(int page, int size) {
        int offset = (page - 1) * size;
        return boardMapper.selectPage(offset, size);
    }

    public int countAll() {
        return boardMapper.countAll();
    }

 // ✅ 소유자 검증된 수정
    @Transactional
    public int updateOwned(Board post, String currentUserId) {
        post.setUser_id(currentUserId);          // WHERE user_id = ?
        return boardMapper.updateOwned(post);    // 성공:1, 실패:0
    }

    // ✅ 소유자 검증된 삭제
    @Transactional
    public void deleteOwned(Long id, String currentUserId, boolean isAdmin) {
        Board post = boardMapper.selectById(id);
        if (post == null) {
            throw new IllegalArgumentException("게시글이 존재하지 않습니다.");
        }

        // 작성자 또는 관리자만 삭제 가능
        if (post.getUser_id().equals(currentUserId) || isAdmin) {
            boardMapper.delete(id); // 관리자라면 모든 게시글 삭제
        } else {
            throw new IllegalArgumentException("삭제 권한이 없습니다.");
        }
    }
    
    @Transactional
    public void incrementViewCount(Long id) {
        boardMapper.updateViewCount(id);
    }
}
