package vo;

import java.util.Date;

import org.apache.ibatis.annotations.SelectKey;

import lombok.Data;

/**
 * # MemberDTO<br>
 * id<br>
 * user_id<br>
 * name<br>
 * email<br>
 * password<br>
 * phone_number<br>
 * created_at<br>
 * role
 */
@Data
public class Member {
<<<<<<< HEAD
	private Integer id;		//sequence 사용 및 @SelectKey로 주입 시 반드시 Integer로 받기
	private String user_id;
=======
	private int id;
	private String user_id; // Changed from username to user_id
>>>>>>> origin/lsy
	private String name;
	private String email;
	private String password;
	private String phone_number; // Added phone_number
<<<<<<< HEAD
	private Date created_at;
	private String role;
=======
	private String role;
	private Date createdAt;
>>>>>>> origin/lsy
}
