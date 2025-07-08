package user;

import java.util.List;

/**
 * 기본 DAO 인터페이스(삽입, 검색, 수정, 삭제)
 * @param <T> DTO 정보
 */
public interface BaseMapper<T> {
	int save(T t);
	List<T> findAll();
	T findById(int id);
	int update(T t);
	int delete(int id);
}
