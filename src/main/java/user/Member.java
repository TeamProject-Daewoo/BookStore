package user;

import java.util.Date;

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
	private Integer id;		//sequence �궗�슜 諛� @SelectKey濡� 二쇱엯 �떆 諛섎뱶�떆 Integer濡� 諛쏄린
	private String user_id;
	private String name;
	private String email;
	private String password;
	private String phone_number; // Added phone_number
	private Date created_at;
	private String role;

	 // 새로 추가
    private byte[] profileImage;

    // Getter & Setter
    public byte[] getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(byte[] profileImage) {
        this.profileImage = profileImage;
    }
}
