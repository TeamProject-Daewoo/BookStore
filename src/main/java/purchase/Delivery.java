package purchase;

import lombok.Data;

@Data
public class Delivery {
    private int id;
    private String orderId;
    private String receiverName;
    private String address;
    private String phoneNumber;
    private String deliveryMessage;
    
    
    // 생성자
    public Delivery(int memberId, String orderId, String receiverName, String address, String phoneNumber, String deliveryMessage) {
        this.id = memberId;
        this.orderId = orderId;
        this.receiverName = receiverName;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.deliveryMessage = deliveryMessage;
    }
}
