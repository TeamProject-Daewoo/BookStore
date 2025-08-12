package socket;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/salesSocket")
public class Websocket {
	
	static Set<Session> sessions = new HashSet<Session>();
	@OnOpen
	public void open(Session session) {
		sessions.add(session);
		try {
	        session.getBasicRemote().sendText("init");
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
	}
	@OnMessage
	public void message(String message, Session session) {
		for (Session s : sessions) {
		    if (s.isOpen()) {
		        try {
		            s.getBasicRemote().sendText("update");
		            System.out.println("fiewfe");
		        } catch (IOException e) {
		            e.printStackTrace();
		        }
		    }
		}
	}
	@OnError
	public void error(Throwable throwable) {
		System.out.println("소켓 에러!");
	} 
	@OnClose
	public void close(Session session) {
		sessions.remove(session);
	}
}
