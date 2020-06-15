package User;

import java.sql.*;
import java.util.ArrayList;

public class UserDAO
{
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	
	private void connect()
	{
		// 1. Driver 링크
		try {
			Class.forName("org.mariadb.jdbc.Driver");
		}
		catch (Exception e) {
			System.out.println("DB 링크 실패");
			return;
		}
		
		// 2. DB 연결
		try {
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/developers", "root", "qwe123!@#");

		}
		catch (Exception e) {
			System.out.println("DB 연결 실패 : " + e);
		}
	}
	
	private void disconnect()
	{
		if (pstmt != null) {
			try {
				pstmt.close();
			}
			catch(SQLException e) {
				System.out.println("DB 연결 해제 실패1 : " + e);
			}
		
		}
		
		if (conn != null) {
			try {
				conn.close();
			}
			catch (SQLException e) {
				System.out.println("DB 연결 해제 실패2 : " + e);
			}
		}
	}

	public boolean insertDB(User user)
	{
		connect();
		
		String sql = "insert into user(id,pwd,nickname,email,number) values(?,?,?,?,?)";
		String sql2 = "insert into user_favorite(user_id, %s, %s) values(?,1,1)";
		sql2 = String.format(sql2, user.getPlatform(), user.getGenre());

		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getId());
			pstmt.setString(2, user.getPwd());	// TODO: 비번 암호화!!
			pstmt.setString(3, user.getNickname());
			pstmt.setString(4, user.getEmail());
			pstmt.setString(5, user.getNumber());
			pstmt.executeUpdate();			
			
			pstmt = conn.prepareStatement(sql2);
			pstmt.setString(1,  user.getId());
			pstmt.executeUpdate();			
		}
		catch(SQLException e) {
			System.out.println("insertDB 에러");
			return false;
		}
		finally {
			disconnect();
		}
		
		return true;
	}

	
	public boolean updateDB(User user)
	{
		connect();
		
		String sql;
		
		try {
			if (user.getPwd() != null) {
				sql = "update user set pwd=?, nickname=?, email=?, number=? where id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, user.getPwd());
				pstmt.setString(2, user.getNickname());
				pstmt.setString(3, user.getEmail());
				pstmt.setString(4, user.getNumber());
				pstmt.setString(5, user.getId());
			}
			else {
				sql = "update user set nickname=?, email=?, number=? where id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, user.getNickname());
				pstmt.setString(2, user.getEmail());
				pstmt.setString(3, user.getNumber());
				pstmt.setString(4, user.getId());
			}
			pstmt.executeUpdate();
			
			String sql2 = "update user_favorite set web=0, android=0, embeded=0, ios=0, health=0, psychology=0, game=0 where user_id=?";
			pstmt = conn.prepareStatement(sql2);
			pstmt.setString(1, user.getId());			
			pstmt.executeUpdate();
			
			
			String sql3 = "update user_favorite set %s=1, %s=1 where user_id=?";
			sql3 = String.format(sql3,  user.getPlatform(), user.getGenre());
			pstmt = conn.prepareStatement(sql3);
			pstmt.setString(1, user.getId());			
			pstmt.executeUpdate();
		}
		catch(SQLException e) {
			System.out.println("updateDB 에러");
			return false;
		}
		finally {
			disconnect();
		}

		return true;

	}
	
	
	public boolean deleteDB(String id)
	{
		connect();
		
		String sql = "delete from user where id=?";

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.executeUpdate();
		}
		catch(SQLException e) {
			System.out.println("deleteDB 에러");
			return false;
		}
		finally {
			disconnect();
		}

		return true;

	}
	
	
	
	public User getDB(String id)
	{
		connect();
		
		String sql = "select * from user where id=?";
		User user = new User();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			ResultSet rs = pstmt.executeQuery();
			
			rs.next();
			user.setId(rs.getString("id"));
			user.setPwd(rs.getString("pwd"));
			user.setNickname(rs.getString("nickname"));
			user.setEmail(rs.getString("email"));
			user.setNumber(rs.getString("number"));
			user.setDate(rs.getString("date"));
			
			String platforms[] = {"web", "android", "embeded", "ios"};
			String gernes[] = {"health", "psychology", "game"};
			
			for (int i=0; i<platforms.length; i++) {
				String value = platforms[i];
				if (rs.getBoolean(value) == true)
					user.setPlatform(value);	
			}
			
			for (int i=0; i<gernes.length; i++) {
				String value = gernes[i];
				if (rs.getBoolean(value) == true)
					user.setGenre(value);	
			}
			
			rs.close();
		}
		catch(SQLException e) {
			System.out.println("getDB 에러");
		}
		finally {
			disconnect();
		}
	
		return user;
	}
	
	
	
	public ArrayList getDBList (String type, String search, String order, int pageN)
	{
		connect();
		
		String sql = "select * from user";
		
		if (search != null) {
			switch(type) {
				case "id":
					sql += " where id like ?";
					break;
				case "nickname":
					sql += " where nickname like ?";
					break;
				case "email":
					sql += " where email like ?";
					break;
			}
			
			search = '%' + search.trim() + '%';
		}
		
		sql += " order by " + order;
		sql += " limit ?,?";
		
		ArrayList<User> users = new ArrayList<User>();

		try {
			pstmt = conn.prepareStatement(sql);
			
			if (search != null) {
				pstmt.setString(1, search);
				pstmt.setInt(2, (pageN-1)*10);
				pstmt.setInt(3, 10);
			}
			else {
				pstmt.setInt(1, (pageN-1)*10);
				pstmt.setInt(2, 10);
			}

			ResultSet rs = pstmt.executeQuery();

			while(rs.next()) {
				User user = new User();

				user.setId(rs.getString("id"));
				user.setNickname(rs.getString("nickname"));
				user.setEmail(rs.getString("email"));
				user.setNumber(rs.getString("number"));
				user.setDate(rs.getString("date"));
				
				users.add(user);
			}
			rs.close();
		}
		catch(SQLException e) {
			System.out.println("getDBList 에러");
		}
		finally {
			disconnect();
		}
	
		return users;
	}
	
	public int getDBCount (String type, String search)
	{
		connect();
		
		String sql = "select count(*) as cnt from user";
		
		if (search != null) {
			switch(type) {
				case "id":
					sql += " where id like ?";
					break;
				case "nickname":
					sql += " where nickname like ?";
					break;
				case "email":
					sql += " where email like ?";
					break;
			}
			
			search = '%' + search.trim() + '%';
		}
		
		int count = 0;
		try {
			pstmt = conn.prepareStatement(sql);
			
			if (search != null)
				pstmt.setString(1, search);

			ResultSet rs = pstmt.executeQuery();
			
			rs.next();
			count = rs.getInt("cnt");
		}
		catch(SQLException e) {
			System.out.println("getDBCount 에러");
			return -1;
		}
		
		return count;
	}

	
	public int getDBCount (int type) {
		connect();
		
		String sql = "select count(*) as cnt from user";
		
		switch(type) {
		// 누적 가입자 수
		case 0:
			break;
		// 이번 주 가입자 수
		case 1:
			sql += " where date > last_day(now() - interval 1 month)";
			sql += " and date <= last_day(now())";
			break;
		// 이번 달 가입자 수
		case 2:
			sql += " WHERE YEARWEEK(date) = YEARWEEK(now())";
			break;
		}

		
		int count = 0;
		try {
			pstmt = conn.prepareStatement(sql);
			
			ResultSet rs = pstmt.executeQuery();
			
			rs.next();
			count = rs.getInt("cnt");
		}
		catch(SQLException e) {
			System.out.println("getDBCount 에러");
			return -1;
		}
		
		return count;
	}
	
}