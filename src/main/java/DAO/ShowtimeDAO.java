package DAO;

import model.Showtime;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShowtimeDAO {

	private final Connection conn;

	public ShowtimeDAO(Connection conn) {
		this.conn = conn;
	}

	// =========================================================
	// 1. Thêm suất chiếu
	// =========================================================
	public boolean addShowtime(Showtime s) {
		String sql = """
				INSERT INTO showtimes (movie_id, room_id, show_date, base_price, is_active)
				VALUES (?, ?, ?, ?, ?)
				""";

		try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			ps.setInt(1, s.getMovieId());
			ps.setInt(2, s.getRoomId());

			if (s.getShowDate() != null) {
				ps.setTimestamp(3, s.getShowDate());
			} else {
				ps.setNull(3, Types.TIMESTAMP);
			}

			ps.setBigDecimal(4, s.getBasePrice());
			ps.setBoolean(5, s.isActive());

			int rows = ps.executeUpdate();
			if (rows > 0) {
				ResultSet rs = ps.getGeneratedKeys();
				if (rs.next()) {
					s.setShowtimeId(rs.getInt(1));
				}
				return true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	// =========================================================
	// 2. Cập nhật suất chiếu
	// =========================================================
	public boolean updateShowtime(Showtime s) {
		String sql = """
				UPDATE showtimes SET
				    movie_id=?, room_id=?, show_date=?, base_price=?, is_active=?
				WHERE showtime_id=?
				""";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, s.getMovieId());
			ps.setInt(2, s.getRoomId());

			if (s.getShowDate() != null) {
				ps.setTimestamp(3, s.getShowDate());
			} else {
				ps.setNull(3, Types.TIMESTAMP);
			}

			ps.setBigDecimal(4, s.getBasePrice());
			ps.setBoolean(5, s.isActive());
			ps.setInt(6, s.getShowtimeId());

			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// =========================================================
	// 3. Xóa suất chiếu
	// =========================================================
	public boolean deleteShowtime(int id) {
		String sql = "DELETE FROM showtimes WHERE showtime_id=?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// =========================================================
	// 4. Lấy suất chiếu theo ID
	// =========================================================
	public Showtime findById(int id) {
		String sql = "SELECT * FROM showtimes WHERE showtime_id=?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);

			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return mapRow(rs);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// =========================================================
	// 5. Lấy tất cả suất chiếu
	// =========================================================
	public List<Showtime> findAll() {
		List<Showtime> list = new ArrayList<>();
		String sql = "SELECT * FROM showtimes ORDER BY show_date DESC";

		try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {

			while (rs.next()) {
				list.add(mapRow(rs));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// =========================================================
	// 6. Tìm suất chiếu theo movie_id
	// =========================================================
	public List<Showtime> findByMovieId(int movieId) {
		List<Showtime> list = new ArrayList<>();
		String sql = "SELECT * FROM showtimes WHERE movie_id=? ORDER BY show_date DESC";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, movieId);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				list.add(mapRow(rs));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// =========================================================
	// 7. Map dữ liệu từ ResultSet -> Showtime
	// =========================================================
	private Showtime mapRow(ResultSet rs) throws SQLException {

		Showtime s = new Showtime();

		s.setShowtimeId(rs.getInt("showtime_id"));
		s.setMovieId(rs.getInt("movie_id"));
		s.setRoomId(rs.getInt("room_id"));

		Timestamp ts = rs.getTimestamp("show_date");
		s.setShowDate(ts);

		BigDecimal price = rs.getBigDecimal("base_price");
		s.setBasePrice(price);

		s.setActive(rs.getBoolean("is_active"));

		return s;
	}
}
