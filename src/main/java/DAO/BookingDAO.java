package DAO;

import model.Booking;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

	private final Connection conn;

	// ✅ Nhận Connection từ bên ngoài
	public BookingDAO(Connection conn) {
		this.conn = conn;
	}

	// 1. Tạo booking mới (khi khách đặt vé)
	public boolean createBooking(Booking b) {
		String sql = "INSERT INTO bookings " + "(user_id, showtime_id, booking_time, total_amount, payment_status) "
				+ "VALUES (?, ?, NOW(), ?, ?)";

		try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			ps.setInt(1, b.getUserId());
			ps.setInt(2, b.getShowtimeId());
			ps.setBigDecimal(3, b.getTotalAmount() != null ? b.getTotalAmount() : BigDecimal.ZERO);
			ps.setString(4, b.getPaymentStatus()); // PENDING / PAID / CANCELLED

			int rows = ps.executeUpdate();
			if (rows > 0) {
				ResultSet rs = ps.getGeneratedKeys();
				if (rs.next()) {
					b.setBookingId(rs.getInt(1));
				}
				return true;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// 2. Cập nhật trạng thái thanh toán
	public boolean updatePaymentStatus(int bookingId, String paymentStatus) {
		String sql = "UPDATE bookings " + "SET payment_status=?, updated_at=NOW() " + "WHERE booking_id=?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, paymentStatus);
			ps.setInt(2, bookingId);

			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// ================== Helper: Huỷ đơn ==================
	public boolean cancelBooking(int bookingId) {
		return updatePaymentStatus(bookingId, "CANCELLED");
	}

	// 3. Lấy booking theo ID
	public Booking findById(int bookingId) {
		String sql = "SELECT * FROM bookings WHERE booking_id=?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, bookingId);

			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return mapRow(rs);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	// 4. Lấy booking theo user (lịch sử đặt vé của khách)
	public List<Booking> findByUser(int userId) {
		List<Booking> list = new ArrayList<>();
		String sql = "SELECT * FROM bookings WHERE user_id=? " + "ORDER BY booking_time DESC";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				list.add(mapRow(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	// 5. Lấy booking theo showtime (admin xem theo suất chiếu)

	public List<Booking> findByShowtime(int showtimeId) {
		List<Booking> list = new ArrayList<>();
		String sql = "SELECT * FROM bookings WHERE showtime_id=? " + "ORDER BY booking_time DESC";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, showtimeId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				list.add(mapRow(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	// 6. Lấy tất cả booking ( cho admin)
	public List<Booking> findAll() {
		List<Booking> list = new ArrayList<>();
		String sql = "SELECT * FROM bookings ORDER BY booking_time DESC";

		try (Statement st = conn.createStatement()) {
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				list.add(mapRow(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	// 7. Lấy các đơn đặt vé mới nhất (dashboard)
	public List<Booking> getLatestBookings(int limit) {
		List<Booking> list = new ArrayList<>();
		String sql = "SELECT * FROM bookings " + "ORDER BY booking_time DESC LIMIT ?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, limit);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				list.add(mapRow(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	// 8. Đếm số đơn đặt vé hôm nay
	public int countBookingsToday() {
		String sql = "SELECT COUNT(*) FROM bookings " + "WHERE DATE(booking_time) = CURDATE()";

		try (Statement st = conn.createStatement()) {
			ResultSet rs = st.executeQuery(sql);
			if (rs.next()) {
				return rs.getInt(1);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	// 9. Doanh thu hôm nay (chỉ đơn PAID)
	public BigDecimal sumRevenueToday() {
		String sql = "SELECT COALESCE(SUM(total_amount), 0) " + "FROM bookings "
				+ "WHERE DATE(booking_time) = CURDATE() " + "AND payment_status = 'PAID'";

		try (Statement st = conn.createStatement()) {
			ResultSet rs = st.executeQuery(sql);
			if (rs.next()) {
				BigDecimal result = rs.getBigDecimal(1);
				return result != null ? result : BigDecimal.ZERO;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return BigDecimal.ZERO;
	}

	// 10. Đếm số booking theo movie (dùng cho phim HOT)
	public int countBookingsByMovie(int movieId) {
		String sql = "SELECT COUNT(*) " + "FROM bookings b " + "JOIN showtimes s ON b.showtime_id = s.showtime_id "
				+ "WHERE s.movie_id = ? " + "AND b.payment_status = 'PAID'";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, movieId);

			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	} // Tạo booking PENDING (chưa thanh toán)

	public int createPendingBooking(int userId, int showtimeId, double totalAmount) throws SQLException {
		String sql = """
				    INSERT INTO bookings(user_id, showtime_id, booking_time, total_amount, payment_status, updated_at)
				    VALUES(?, ?, NOW(), ?, 'PENDING', NOW())
				""";

		try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			ps.setInt(1, userId);
			ps.setInt(2, showtimeId);
			ps.setDouble(3, totalAmount);

			int affected = ps.executeUpdate();
			if (affected == 0)
				throw new SQLException("Create booking failed (no rows).");

			ResultSet keys = ps.getGeneratedKeys();
			if (keys.next())
				return keys.getInt(1);
		}
		throw new SQLException("Create booking failed (no generated key).");
	}

	// Insert booking_seats (mỗi seat có thể dùng basePrice hoặc seatPrice riêng)
	public void insertBookingSeats(int bookingId, List<Integer> seatIds, double seatPrice) throws SQLException {
		String sql = "INSERT INTO booking_seats(booking_id, seat_id, seat_price) VALUES(?,?,?)";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			for (Integer seatId : seatIds) {
				ps.setInt(1, bookingId);
				ps.setInt(2, seatId);
				ps.setDouble(3, seatPrice);
				ps.addBatch();
			}
			ps.executeBatch();
		}
	}

	// Check seat still available right before insert (chống chọn trùng)
	public boolean areSeatsAvailable(int showtimeId, List<Integer> seatIds) throws SQLException {
		if (seatIds == null || seatIds.isEmpty())
			return false;

		StringBuilder in = new StringBuilder();
		for (int i = 0; i < seatIds.size(); i++) {
			if (i > 0)
				in.append(",");
			in.append("?");
		}

		String sql = """
				SELECT COUNT(*)
				FROM booking_seats bs
				JOIN bookings b ON bs.booking_id = b.booking_id
				WHERE b.showtime_id=? AND b.payment_status <> 'CANCELLED'
				  AND bs.seat_id IN (""" + in + ")";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			int idx = 1;
			ps.setInt(idx++, showtimeId);
			for (Integer id : seatIds)
				ps.setInt(idx++, id);

			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				int conflict = rs.getInt(1);
				return conflict == 0;
			}
		}
		return false;
	}

	// =========================================
	// mapRow: ResultSet -> Booking
	// =========================================
	private Booking mapRow(ResultSet rs) throws SQLException {
		Booking b = new Booking();

		b.setBookingId(rs.getInt("booking_id"));
		b.setUserId(rs.getInt("user_id"));
		b.setShowtimeId(rs.getInt("showtime_id"));
		b.setBookingTime(rs.getTimestamp("booking_time"));
		b.setTotalAmount(rs.getBigDecimal("total_amount"));
		b.setPaymentStatus(rs.getString("payment_status"));
		b.setUpdatedAt(rs.getTimestamp("updated_at"));

		return b;
	}

	public boolean updateTotalAmount(int bookingId, double totalAmount) {
		String sql = "UPDATE bookings SET total_amount=?, updated_at=NOW() WHERE booking_id=?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setDouble(1, totalAmount);
			ps.setInt(2, bookingId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

}