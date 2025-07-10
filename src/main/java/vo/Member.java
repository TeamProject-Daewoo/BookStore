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
	private Integer id;		//sequence 사용 및 @SelectKey로 주입 시 반드시 Integer로 받기
	private String user_id;
	private String name;
	private String email;
	private String password;
	private String phone_number; // Added phone_number
	private Date created_at;
	private String role;
}
