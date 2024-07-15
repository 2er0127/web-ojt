package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {

	private Connection conn;
	private ResultSet rs;


	public BbsDAO(){
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
	public String getDate() {//현재 서버 시간 가져오기
		String SQL="select now()";//현재 시간을 가져오는 mysql문장
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);//sql문장을 실행 준비 단계로
			rs=pstmt.executeQuery();//실행결과 가져오기
			if(rs.next()) {
				return rs.getString(1);//현재 날짜 반환
			}

		} catch(Exception e) {
			e.printStackTrace();//오류 발생
		}
		return "";//데이터베이스 오류
	}

	//게시판 글번호 가져오기
	public int getNext() {
		String SQL = "SELECT bbsID FROM bbs ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);

			rs= pstmt.executeQuery();

			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // 첫 번째 게시물인 경우

		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}


	public ArrayList<Bbs> getList(int pageNumber){//특정한 리스트를 받아서 반환
		String SQL="SELECT * from bbs where bbsID < ? AND bbsAvailable = 1 order by bbsID desc limit 10";//마지막 게시물 반환, 삭제가 되지 않은 글만 가져온다.
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-(pageNumber-1)*10);//물음표에 들어갈 내용
			rs=pstmt.executeQuery();
			while(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);//list에 해당 인스턴스를 담는다.
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list;//ㄱㅔ시글 리스트 반환
	}


	//게시물의 마지막 페이지일 경우 다음 페이지가 없어야함 (페이징 처리)
	public boolean nextPage(int pageNumber) {//페이지 처리를 위한 함수
		String SQL="SELECT * from bbs where bbsID < ? AND bbsAvailable =1";
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-(pageNumber-1)*10);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				return true;//다음 페이지로 넘어갈 수 있음
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}


	//게시글 상세 조회기능
	public Bbs getBbs(int bbsID) {
		String SQL = "SELECT * FROM bbs WHERE bbsID = ?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  bbsID);
			rs= pstmt.executeQuery();
			if(rs.next())
			{
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				return bbs;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null; // 데이터베이스 오류
	}


	//게시글 수정 기능
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		String SQL = "UPDATE bbs set bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);

			pstmt.setString(1,  bbsTitle);
			pstmt.setString(2,  bbsContent);
			pstmt.setInt(3,  bbsID);
			return pstmt.executeUpdate();

		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}



	//게시글 삭제 기능
	public int delete(int bbsID) {
		String SQL = "UPDATE bbs SET bbsAvailable = 0 WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  bbsID);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}


	//게시글 파일 업로드 기능
	public int write(String bbsTitle, String userID, String bbsContent, String fileName) {
	    String SQL = "INSERT INTO bbs VALUES (?, ?, ?, ?, ?, ?, ?)";
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setInt(1, getNext());       // 게시글 번호
	        pstmt.setString(2, bbsTitle);     // 제목
	        pstmt.setString(3, userID);       // 아이디
	        pstmt.setString(4, getDate());    // 날짜
	        pstmt.setString(5, bbsContent);   // 내용
	        pstmt.setInt(6, 1);               // 삭제된 경우가 아니기 때문에 1을 넣어줌
	        pstmt.setString(7, fileName);     // fileName
	        return pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return -1; // 데이터베이스 오류
	}

	


}