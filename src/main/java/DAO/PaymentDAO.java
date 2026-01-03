package DAO;

import model.Payment;

import java.sql.*;

public class PaymentDAO {
	private final Connection conn;

	public PaymentDAO(Connection conn) {
		this.conn = conn;
	}

	public int createPaidPayment(int bookingId, String method) throws SQLException {
		String sql = "INSERT INTO payments (booking_id, payment_method, payment_status) VALUES (?, ?, 'PAID')";
		try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			ps.setInt(1, bookingId);
			ps.setString(2, method);
			ps.executeUpdate();
			try (ResultSet rs = ps.getGeneratedKeys()) {
				if (rs.next())
					return rs.getInt(1);
			}
		}
		return -1;
	}

	public Payment findLatestByBooking(int bookingId) throws SQLException {
		String sql = "SELECT * FROM payments WHERE booking_id=? ORDER BY payment_date DESC, payment_id DESC LIMIT 1";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, bookingId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					Payment p = new Payment();
					p.setPaymentId(rs.getInt("payment_id"));
					p.setBookingId(rs.getInt("booking_id"));
					p.setPaymentMethod(rs.getString("payment_method"));
					p.setPaymentStatus(rs.getString("payment_status"));
					p.setPaymentDate(rs.getTimestamp("payment_date"));
					return p;
				}
			}
		}
		return null;
	}

	public int createPaymentPending(int bookingId, String method) throws SQLException {
		String sql = """
				    INSERT INTO payments(booking_id, payment_method, payment_status, payment_date)
				    VALUES(?, ?, 'PENDING', NOW())
				""";
		try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			ps.setInt(1, bookingId);
			ps.setString(2, method);
			ps.executeUpdate();

			ResultSet keys = ps.getGeneratedKeys();
			if (keys.next())
				return keys.getInt(1);
		}
		throw new SQLException("Create payment failed.");
	}

	public boolean updateStatus(int paymentId, String status) {
		String sql = "UPDATE payments SET payment_status=?, payment_date=NOW() WHERE payment_id=?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setInt(2, paymentId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
}
