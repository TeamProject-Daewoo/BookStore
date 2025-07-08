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
	private String name;
	private String email;
	private String password;
	private Date createdAt;
}
