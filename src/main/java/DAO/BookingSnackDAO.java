package DAO;

import java.sql.*;
import java.util.*;

public class BookingSnackDAO {
	private final Connection conn;

	public BookingSnackDAO(Connection conn) {
		this.conn = conn;
	}

	// Upsert: nếu đã có booking_id + snack_id thì cộng dồn quantity
	public void upsertBookingSnack(int bookingId, int snackId, int quantity, double unitPrice) throws SQLException {
		String sql = """
				    INSERT INTO booking_snacks(booking_id, snack_id, quantity, unit_price)
				    VALUES(?, ?, ?, ?)
				    ON DUPLICATE KEY UPDATE
				      quantity = quantity + VALUES(quantity),
				      unit_price = VALUES(unit_price)
				""";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, bookingId);
			ps.setInt(2, snackId);
			ps.setInt(3, quantity);
			ps.setDouble(4, unitPrice);
			ps.executeUpdate();
		}
	}

	public void clearByBooking(int bookingId) throws SQLException {
		String sql = "DELETE FROM booking_snacks WHERE booking_id=?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, bookingId);
			ps.executeUpdate();
		}
	}

	public double sumSnackAmount(int bookingId) {
		String sql = "SELECT COALESCE(SUM(quantity * unit_price),0) FROM booking_snacks WHERE booking_id=?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, bookingId);
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getDouble(1);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	public static class BookingSnackRow {
		public int snackId;
		public String snackName;
		public int quantity;
		public double unitPrice;
		public double amount;
	}

	public List<BookingSnackRow> findRowsByBooking(int bookingId) throws SQLException {
		List<BookingSnackRow> list = new ArrayList<>();
		String sql = """
				    SELECT bs.snack_id, s.snack_name, bs.quantity, bs.unit_price,
				           (bs.quantity * bs.unit_price) AS amount
				    FROM booking_snacks bs
				    JOIN snacks s ON bs.snack_id = s.snack_id
				    WHERE bs.booking_id = ?
				    ORDER BY s.snack_name
				""";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, bookingId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					BookingSnackRow r = new BookingSnackRow();
					r.snackId = rs.getInt("snack_id");
					r.snackName = rs.getString("snack_name");
					r.quantity = rs.getInt("quantity");
					r.unitPrice = rs.getDouble("unit_price");
					r.amount = rs.getDouble("amount");
					list.add(r);
				}
			}
		}
		return list;
	}

}
