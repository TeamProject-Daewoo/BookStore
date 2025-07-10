package vo;

import java.util.Date;

import lombok.Data;

/**
 * # MemberDTO<br>
 * id<br>
 * name<br>
 * email<br>
 * password<br>
 * createdAt
 */
@Data
public class Member {
	private int id;
	private String user_id; // Changed from username to user_id
	private String name;
	private String email;
	private String password;
	private String phone_number; // Added phone_number
	private String role;
	private Date createdAt;
}
