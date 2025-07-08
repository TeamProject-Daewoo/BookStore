package user;

import java.util.List;

/**
 * �⺻ DAO �������̽�(����, �˻�, ����, ����)
 * @param <T> DTO ����
 */
public interface BaseMapper<T> {
	int save(T t);
	List<T> findAll();
	T findById(int id);
	int update(T t);
	int delete(int id);
}
