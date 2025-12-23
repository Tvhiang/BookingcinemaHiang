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
	// Thêm User

	public boolean themUser(User u) {
		String sql = "INSERT INTO users(username, PASSWORD, full_name, email, phone, ROLE, STATUS, created_at) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, u.getUsername());
			ps.setString(2, u.getPassword());
			ps.setString(3, u.getFullName());
			ps.setString(4, u.getEmail());
			ps.setString(5, u.getPhone());
			ps.setString(6, u.getRole()); 
			ps.setString(7, u.getStatus()); 

			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// Sửa User
	// - Không sửa username, PASSWORD trong hàm này
	public boolean suaUser(User u) {
		String sql = "UPDATE users " + "SET full_name = ?, email = ?, phone = ?, ROLE = ?, STATUS = ? "
				+ "WHERE user_id = ?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, u.getFullName());
			ps.setString(2, u.getEmail());
			ps.setString(3, u.getPhone());
			ps.setString(4, u.getRole());
			ps.setString(5, u.getStatus());
			ps.setInt(6, u.getUserId());

			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// Sửa mật khẩu
	public boolean doiMatKhau(int userId, String matKhauMoi) {
		String sql = "UPDATE users SET PASSWORD = ? WHERE user_id = ?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, matKhauMoi);
			ps.setInt(2, userId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// Xóa User

	public boolean xoaUser(int id) {
		String sql = "DELETE FROM users WHERE user_id = ?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// Tìm theo ID

	public User timTheoId(int id) {
		String sql = "SELECT * FROM users WHERE user_id = ?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return mapRow(rs);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	// Tìm theo username
	public User timTheoUsername(String username) {
		String sql = "SELECT * FROM users WHERE username = ?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, username);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return mapRow(rs);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}


	//  Lấy toàn bộ User
	
	public List<User> layTatCa() {
		List<User> ds = new ArrayList<>();
		String sql = "SELECT * FROM users";

		try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {

			while (rs.next()) {
				ds.add(mapRow(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return ds;
	}

	//  Lọc theo role
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

	//  Đăng nhập (username + password)

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

	//  mapRow – chuyển ResultSet thành User
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
