package controller;

import DAO.BookingDAO;
import DAO.MovieDAO;
import DAO.DBConnection;
import model.User;
import model.Movie;
import model.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/admin/home")
public class AdminHomeServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");

		// 1. Kiểm tra đã đăng nhập admin chưa
		HttpSession session = req.getSession(false);
		User adminUser = null;
		if (session != null) {
			adminUser = (User) session.getAttribute("adminUser");
		}

		if (adminUser == null) {
			// Chưa login admin -> quay lại trang login admin (/admin)
			resp.sendRedirect(req.getContextPath() + "/admin");
			return;
		}

		Connection conn = null;
		try {
			// 2. Mở connection
			conn = DBConnection.getConnection();
			if (conn == null) {
				// Có thể set message lỗi để JSP hiển thị
				req.setAttribute("error", "Không thể kết nối CSDL!");
			} else {
				MovieDAO movieDAO = new MovieDAO(conn);
				BookingDAO bookingDAO = new BookingDAO(conn);

				// 3. Lấy dữ liệu cho dashboard

				// 3.1. Thống kê phim
				int totalMovies = movieDAO.countAll();
				int showingMoviesCount = movieDAO.countByStatus("SHOWING");
				int comingMoviesCount = movieDAO.countByStatus("COMING_SOON");
				int endedMoviesCount = movieDAO.countByStatus("ENDED");

				// 3.2. Danh sách phim đang chiếu & sắp chiếu
				List<Movie> showingMovies = movieDAO.findShowingMovies();
				List<Movie> comingSoonMovies = movieDAO.findComingSoonMovies();

				// 3.3. Đơn đặt vé mới nhất
				List<Booking> latestBookings = bookingDAO.getLatestBookings(6);

				// 3.4. Thống kê đơn & doanh thu hôm nay
				int todayBookings = bookingDAO.countBookingsToday();
				BigDecimal todayRevenue = bookingDAO.sumRevenueToday();

				// 3.5. Phim "hot" – dựa trên số lượng booking PAID
				// (ở đây lấy dựa trên phim đang chiếu)
				Map<Integer, Integer> bookingCountsByMovie = new HashMap<>();
				for (Movie m : showingMovies) {
					int count = bookingDAO.countBookingsByMovie(m.getMovieId());
					bookingCountsByMovie.put(m.getMovieId(), count);
				}

				// Sort lại showingMovies theo độ "hot"
				List<Movie> hotMovies = new ArrayList<>(showingMovies);
				hotMovies.sort((a, b) -> {
					int ca = bookingCountsByMovie.getOrDefault(a.getMovieId(), 0);
					int cb = bookingCountsByMovie.getOrDefault(b.getMovieId(), 0);
					// giảm dần
					return Integer.compare(cb, ca);
				});
				
				if (hotMovies.size() > 10) {
					hotMovies = hotMovies.subList(0, 10);
				}

				// Thông tin admin để hiển thị trên header
				req.setAttribute("adminUser", adminUser);

				// Thống kê số lượng phim
				req.setAttribute("totalMovies", totalMovies);
				req.setAttribute("showingMoviesCount", showingMoviesCount);
				req.setAttribute("comingSoonMoviesCount", comingMoviesCount);
				req.setAttribute("endedMoviesCount", endedMoviesCount);

				// Danh sách phim
				req.setAttribute("showingMovies", showingMovies);
				req.setAttribute("comingSoonMovies", comingSoonMovies);
				req.setAttribute("hotMovies", hotMovies);
				req.setAttribute("bookingCountsByMovie", bookingCountsByMovie);

				// Đơn đặt vé mới nhất
				req.setAttribute("latestBookings", latestBookings);

				// Thống kê booking & doanh thu
				req.setAttribute("todayBookings", todayBookings);
				req.setAttribute("todayRevenue", todayRevenue);
			}

		} catch (Exception e) {
			e.printStackTrace();
			req.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu dashboard: " + e.getMessage());
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException ignored) {
				}
			}
		}

		// 5. Forward sang JSP adminHome.jsp
		RequestDispatcher rd = req.getRequestDispatcher("/view/Admin/adminHome.jsp");
		rd.forward(req, resp);
	}
}
