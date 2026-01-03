package DAO;

import model.Movie;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MovieDAO {

	private final Connection conn;

	// Nhận Connection từ bên ngoài
	public MovieDAO(Connection conn) {
		this.conn = conn;
	}

	// 1. Thêm phim mới
	public boolean addMovie(Movie m) {
		String sql = "INSERT INTO movies "
				+ "(title, genre, duration, description, director, cast, poster_url, age_rating, release_date, status) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			ps.setString(1, m.getTitle());
			ps.setString(2, m.getGenre());

			if (m.getDuration() != null) {
				ps.setInt(3, m.getDuration());
			} else {
				ps.setNull(3, Types.INTEGER);
			}

			ps.setString(4, m.getDescription());
			ps.setString(5, m.getDirector());
			ps.setString(6, m.getCast());
			ps.setString(7, m.getPosterUrl());
			ps.setString(8, m.getAgeRating());

			if (m.getReleaseDate() != null) {
				ps.setDate(9, m.getReleaseDate());
			} else {
				ps.setNull(9, Types.DATE);
			}

			ps.setString(10, m.getStatus());

			int rows = ps.executeUpdate();
			if (rows > 0) {
				ResultSet rs = ps.getGeneratedKeys();
				if (rs.next()) {
					m.setMovieId(rs.getInt(1));
				}
				return true;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// 2. Cập nhật phim
	public boolean updateMovie(Movie m) {
		String sql = "UPDATE movies SET " + "title=?, genre=?, duration=?, description=?, director=?, cast=?, "
				+ "poster_url=?, age_rating=?, release_date=?, status=? " + "WHERE movie_id=?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, m.getTitle());
			ps.setString(2, m.getGenre());

			if (m.getDuration() != null) {
				ps.setInt(3, m.getDuration());
			} else {
				ps.setNull(3, Types.INTEGER);
			}

			ps.setString(4, m.getDescription());
			ps.setString(5, m.getDirector());
			ps.setString(6, m.getCast());
			ps.setString(7, m.getPosterUrl());
			ps.setString(8, m.getAgeRating());

			if (m.getReleaseDate() != null) {
				ps.setDate(9, m.getReleaseDate());
			} else {
				ps.setNull(9, Types.DATE);
			}

			ps.setString(10, m.getStatus());
			ps.setInt(11, m.getMovieId());

			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// 3. Xóa phim

	public boolean deleteMovie(int movieId) {
		String sql = "DELETE FROM movies WHERE movie_id=?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, movieId);
			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// 4. Tìm phim theo ID
	public Movie findById(int movieId) {
		String sql = "SELECT * FROM movies WHERE movie_id=?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, movieId);

			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return mapRow(rs);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	// 5. Lấy tất cả phim
	public List<Movie> findAll() {
		List<Movie> list = new ArrayList<>();
		String sql = "SELECT * FROM movies ORDER BY movie_id DESC";

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

	// 6. Lấy phim theo trạng thái (SHOWING, COMING_SOON, ENDED)
	public List<Movie> findByStatus(String status) {
		List<Movie> list = new ArrayList<>();
		String sql = "SELECT * FROM movies WHERE status=? ORDER BY release_date DESC";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				list.add(mapRow(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	// Helper: shortcut theo từng trạng thái
	public List<Movie> findShowingMovies() {
		return findByStatus("SHOWING");
	}

	public List<Movie> findComingSoonMovies() {
		return findByStatus("COMING_SOON");
	}

	public List<Movie> findEndedMovies() {
		return findByStatus("ENDED");
	}

	// 7. Tìm kiếm phim theo tên (cho khách hàng)
	public List<Movie> searchByTitle(String keyword) {
		List<Movie> list = new ArrayList<>();
		String sql = "SELECT * FROM movies WHERE title LIKE ? ORDER BY release_date DESC";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, "%" + keyword + "%");

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				list.add(mapRow(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	// 8. Đếm tổng số phim
	public int countAll() {
		String sql = "SELECT COUNT(*) FROM movies";

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

	// 9. Đếm phim theo status
	public int countByStatus(String status) {
		String sql = "SELECT COUNT(*) FROM movies WHERE status=?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);

			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	// ================== NEW: LIMIT (Home) ==================
	public List<Movie> findByStatusLimit(String status, int limit) {
		List<Movie> list = new ArrayList<>();
		String sql = "SELECT * FROM movies WHERE status=? ORDER BY release_date DESC, movie_id DESC LIMIT ?";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setInt(2, limit);

			ResultSet rs = ps.executeQuery();
			while (rs.next())
				list.add(mapRow(rs));
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	// ================== NEW: PAGED LIST ==================
	public List<Movie> findByStatusPaged(String status, int page, int pageSize) {
		List<Movie> list = new ArrayList<>();
		int offset = (Math.max(1, page) - 1) * pageSize;

		String sql = "SELECT * FROM movies WHERE status=? ORDER BY release_date DESC, movie_id DESC LIMIT ? OFFSET ?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setInt(2, pageSize);
			ps.setInt(3, offset);

			ResultSet rs = ps.executeQuery();
			while (rs.next())
				list.add(mapRow(rs));
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	// ================== SEARCH PAGED (optional status) ==================
	public List<Movie> searchPaged(String keyword, String statusOrNull, int page, int pageSize) {
		List<Movie> list = new ArrayList<>();
		int offset = (Math.max(1, page) - 1) * pageSize;

		StringBuilder sql = new StringBuilder("SELECT * FROM movies WHERE 1=1 ");
		List<Object> params = new ArrayList<>();

		if (keyword != null && !keyword.trim().isEmpty()) {
			sql.append(" AND title LIKE ? ");
			params.add("%" + keyword.trim() + "%");
		}
		if (statusOrNull != null && !statusOrNull.trim().isEmpty()) {
			sql.append(" AND status = ? ");
			params.add(statusOrNull.trim());
		}

		sql.append(" ORDER BY release_date DESC, movie_id DESC LIMIT ? OFFSET ? ");
		params.add(pageSize);
		params.add(offset);

		try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
			for (int i = 0; i < params.size(); i++)
				ps.setObject(i + 1, params.get(i));
			ResultSet rs = ps.executeQuery();
			while (rs.next())
				list.add(mapRow(rs));
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	// ================== COUNT SEARCH (optional status) ==================
	public int countSearch(String keyword, String statusOrNull) {
		StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM movies WHERE 1=1 ");
		List<Object> params = new ArrayList<>();

		if (keyword != null && !keyword.trim().isEmpty()) {
			sql.append(" AND title LIKE ? ");
			params.add("%" + keyword.trim() + "%");
		}
		if (statusOrNull != null && !statusOrNull.trim().isEmpty()) {
			sql.append(" AND status = ? ");
			params.add(statusOrNull.trim());
		}

		try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
			for (int i = 0; i < params.size(); i++)
				ps.setObject(i + 1, params.get(i));
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	// mapRow: ResultSet -> Movie
	private Movie mapRow(ResultSet rs) throws SQLException {
		Movie m = new Movie();

		m.setMovieId(rs.getInt("movie_id"));
		m.setTitle(rs.getString("title"));
		m.setGenre(rs.getString("genre"));

		int dur = rs.getInt("duration");
		if (rs.wasNull()) {
			m.setDuration(null);
		} else {
			m.setDuration(dur);
		}

		m.setDescription(rs.getString("description"));
		m.setDirector(rs.getString("director"));
		m.setCast(rs.getString("cast"));
		m.setPosterUrl(rs.getString("poster_url"));
		m.setAgeRating(rs.getString("age_rating"));

		Date d = rs.getDate("release_date");
		if (d != null) {
			m.setReleaseDate(d);
		}

		m.setStatus(rs.getString("status"));
		return m;
	}
}
