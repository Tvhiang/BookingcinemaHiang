package DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

	private static final String JDBC_URL = "jdbc:mysql://localhost:3306/cenime_web_booking?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh";
	private static final String JDBC_USER = "root";
	private static final String JDBC_PASSWORD = "ankank123";

	public static Connection getConnection() {
		Connection conn = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
			System.out.println("✅ Kết nối MySQL thành công với database");
		} catch (ClassNotFoundException e) {
			System.err.println("❌ Không tìm thấy Driver MySQL. Vui lòng thêm mysql-connector-j.jar");
			e.printStackTrace();
		} catch (SQLException e) {
			System.err.println("❌ Lỗi kết nối database ");
			e.printStackTrace();
		}
		return conn;
	}

	public static void main(String[] args) {
		getConnection();
	}
}
