package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public UserDAO() {
        try {
            String dbURL = "jdbc:mysql://localhost:3306/bbs";
            String dbID = "root";
            String dbPassword = "root";
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String login(String userID, String userPassword) {
        String SQL = "SELECT userPassword FROM user WHERE userID = ?";
        try {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                if (rs.getString(1).equals(userPassword)) {
                    return userID; // 로그인 성공
                } else {
                    return "fail"; // 비밀번호 불일치
                }
            }
            return "fail"; // 아이디가 없음
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "error"; // 데이터베이스 오류
    }

    public int join(User user) {
        String checkUserSQL = "SELECT * FROM user WHERE userID = ?";
        String insertUserSQL = "INSERT INTO user (userID, userPassword, userName, userAddress, userEmail) VALUES (?, ?, ?, ?, ?)";
        try {
            // 기존 사용자 확인
            pstmt = conn.prepareStatement(checkUserSQL);
            pstmt.setString(1, user.getUserID());
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return -1; // 이미 존재하는 아이디
            }

            // 새 사용자 추가
            pstmt = conn.prepareStatement(insertUserSQL);
            pstmt.setString(1, user.getUserID());
            pstmt.setString(2, user.getUserPassword());
            pstmt.setString(3, user.getUserName());
            pstmt.setString(4, user.getUserAddress());
            pstmt.setString(5, user.getUserEmail());

            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return -2; // 데이터베이스 오류
    }
}
