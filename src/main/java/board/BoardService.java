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
    public int deleteOwned(Long id, String currentUserId) {
        return boardMapper.deleteOwned(id, currentUserId); // 성공:1, 실패:0
    }
}
