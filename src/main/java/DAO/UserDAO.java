package DAO;

import model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

	private Connection conn;

	// Constructor – tự động kết nối DB

	public UserDAO() {
		this.conn = DBConnection.getConnection();
		if (this.conn == null) {
			System.err.println("❌ Không thể kết nối CSDL trong UserDAO!");
		} else {
			System.out.println("✅ UserDAO đã kết nối CSDL thành công!");
		}
	}

	public UserDAO(Connection conn) {

		this.conn = (conn != null) ? conn : DBConnection.getConnection();
	}

	// Lọc theo role
	public List<User> layTheoRole(String role) {
		List<User> ds = new ArrayList<>();	
		String sql = "SELECT * FROM users WHERE ROLE = ?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, role);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				ds.add(mapRow(rs));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return ds;
	}

	// Đăng nhập (username + password)

	public User dangNhap(String username, String password) {
		String sql = "SELECT * FROM users " + "WHERE username = ? AND PASSWORD = ? AND STATUS = 'ACTIVE'";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, username);
			ps.setString(2, password);

			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return mapRow(rs);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return null;
	}

	// LOGIN KHÁCH: cho phép nhập username OR email OR phone
	public User dangNhapKhach(String key, String password) {
		String sql = """
				    SELECT * FROM users
				    WHERE (username = ? OR email = ? OR phone = ?)
				      AND PASSWORD = ?
				      AND STATUS = 'ACTIVE'
				""";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, key);
			ps.setString(2, key);
			ps.setString(3, key);
			ps.setString(4, password);
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return mapRow(rs);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public boolean existsUsername(String username) {
		String sql = "SELECT 1 FROM users WHERE username = ? LIMIT 1";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, username);
			ResultSet rs = ps.executeQuery();
			return rs.next();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean existsEmail(String email) {
		String sql = "SELECT 1 FROM users WHERE email = ? LIMIT 1";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, email);
			ResultSet rs = ps.executeQuery();
			return rs.next();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// tạo user role CUSTOMER
	public boolean createCustomer(User u) {
		String sql = """
				    INSERT INTO users(username, PASSWORD, full_name, email, phone, ROLE, STATUS, created_at)
				    VALUES(?, ?, ?, ?, ?, 'CUSTOMER', 'ACTIVE', NOW())
				""";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, u.getUsername());
			ps.setString(2, u.getPassword()); // demo: plaintext (thi xong hãy hash)
			ps.setString(3, u.getFullName());
			ps.setString(4, u.getEmail());
			ps.setString(5, u.getPhone());
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// mapRow – chuyển ResultSet thành User
	private User mapRow(ResultSet rs) throws SQLException {
		User u = new User();

		u.setUserId(rs.getInt("user_id"));
		u.setUsername(rs.getString("username"));
		u.setPassword(rs.getString("PASSWORD"));
		u.setFullName(rs.getString("full_name"));
		u.setEmail(rs.getString("email"));
		u.setPhone(rs.getString("phone"));
		u.setRole(rs.getString("ROLE"));
		u.setStatus(rs.getString("STATUS"));
		u.setCreatedAt(rs.getTimestamp("created_at"));

		return u;
	}
}
