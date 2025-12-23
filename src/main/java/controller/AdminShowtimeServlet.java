package controller;

import DAO.DBConnection;
import DAO.ShowtimeDAO;
import DAO.MovieDAO;
import DAO.RoomDAO;

import model.Showtime;
import model.Movie;
import model.Room;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Timestamp;
import java.math.BigDecimal;
import java.util.*;

@WebServlet("/admin/showtimes")
public class AdminShowtimeServlet extends HttpServlet {

	private ShowtimeDAO showtimeDAO;
	private MovieDAO movieDAO;
	private RoomDAO roomDAO;

	@Override
	public void init() throws ServletException {
		Connection conn = DBConnection.getConnection();
		if (conn == null) {
			throw new ServletException("Không thể kết nối database.");
		}
		showtimeDAO = new ShowtimeDAO(conn);
		movieDAO = new MovieDAO(conn);
		roomDAO = new RoomDAO(conn);
	}

	// ============================ GET ============================
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");

		// Check login admin
		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("adminUser") == null) {
			resp.sendRedirect(req.getContextPath() + "/admin");
			return;
		}

		String action = req.getParameter("action");
		String idStr = req.getParameter("id");
		if (action == null)
			action = "list";

		switch (action) {

		// ---------- mở form thêm ----------
		case "create":
			req.setAttribute("showtime", null);
			req.setAttribute("movies", movieDAO.findAll());
			req.setAttribute("rooms", roomDAO.findAll());
			req.getRequestDispatcher("/view/Admin/adminShowtimeForm.jsp").forward(req, resp);
			break;

		// ---------- mở form sửa ----------
		case "edit":
			if (idStr == null) {
				resp.sendRedirect(req.getContextPath() + "/admin/showtimes");
				return;
			}
			try {
				int id = Integer.parseInt(idStr);
				Showtime st = showtimeDAO.findById(id);
				if (st == null) {
					resp.sendRedirect(req.getContextPath() + "/admin/showtimes");
					return;
				}

				req.setAttribute("showtime", st);
				req.setAttribute("movies", movieDAO.findAll());
				req.setAttribute("rooms", roomDAO.findAll());
				req.getRequestDispatcher("/view/Admin/adminShowtimeForm.jsp").forward(req, resp);

			} catch (Exception e) {
				resp.sendRedirect(req.getContextPath() + "/admin/showtimes");
			}
			break;

		// ---------- xóa ----------
		case "delete":
			try {
				int id = Integer.parseInt(idStr);
				showtimeDAO.deleteShowtime(id);
			} catch (Exception ignored) {
			}
			resp.sendRedirect(req.getContextPath() + "/admin/showtimes");
			break;

		// ---------- danh sách ----------
		default: {
			String keyword = req.getParameter("keyword");
			if (keyword != null)
				keyword = keyword.trim();

			// 1) lấy showtimes
			List<Showtime> showtimes = showtimeDAO.findAll();

			// 2) build map movieId->title, roomId->roomName (KEY = Integer)
			Map<Integer, String> movieNames = new HashMap<>();
			for (model.Movie m : movieDAO.findAll()) {
				movieNames.put(m.getMovieId(), m.getTitle());
			}

			Map<Integer, String> roomNames = new HashMap<>();
			for (model.Room r : roomDAO.findAll()) {
				roomNames.put(r.getRoomId(), r.getRoomName());
			}

			// 3) search theo tên phim hoặc tên phòng (lọc in-memory)
			if (keyword != null && !keyword.isEmpty()) {
				String kw = keyword.toLowerCase();
				List<Showtime> filtered = new ArrayList<>();

				for (Showtime st : showtimes) {
					String mv = movieNames.get(st.getMovieId());
					String rm = roomNames.get(st.getRoomId());

					boolean matchMovie = mv != null && mv.toLowerCase().contains(kw);
					boolean matchRoom = rm != null && rm.toLowerCase().contains(kw);

					if (matchMovie || matchRoom)
						filtered.add(st);
				}
				showtimes = filtered;
			}

			// 4) đẩy qua JSP
			req.setAttribute("showtimes", showtimes);
			req.setAttribute("movieNames", movieNames);
			req.setAttribute("roomNames", roomNames);
			req.setAttribute("keyword", keyword);

			req.getRequestDispatcher("/view/Admin/adminShowtime.jsp").forward(req, resp);
			break;
		}

		}
	}

	// ============================ POST (ADD + EDIT) ============================
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

		req.setCharacterEncoding("UTF-8");

		// Check login admin
		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("adminUser") == null) {
			resp.sendRedirect(req.getContextPath() + "/admin");
			return;
		}

		// Lấy field từ form
		String idStr = req.getParameter("id"); // hidden
		String movieIdStr = req.getParameter("movieId");
		String roomIdStr = req.getParameter("roomId");
		String showDateStr = req.getParameter("showDate"); // yyyy-MM-dd
		String showTimeStr = req.getParameter("showTime"); // HH:mm
		String basePriceStr = req.getParameter("basePrice");
		String activeStr = req.getParameter("active"); // checkbox

		Showtime st = new Showtime();

		boolean updating = (idStr != null && !idStr.isEmpty());
		if (updating) {
			try {
				st.setShowtimeId(Integer.parseInt(idStr));
			} catch (Exception ignored) {
			}
		}

		try {
			st.setMovieId(Integer.parseInt(movieIdStr));
		} catch (Exception e) {
			st.setMovieId(0);
		}
		try {
			st.setRoomId(Integer.parseInt(roomIdStr));
		} catch (Exception e) {
			st.setRoomId(0);
		}

		// ===== Ghép ngày + giờ =====
		try {
		    if (showDateStr != null && showTimeStr != null
		            && !showDateStr.isEmpty() && !showTimeStr.isEmpty()) {

		        String tsStr = showDateStr + " " + showTimeStr + ":00";
		        // vd: 2025-12-15 19:30:00

		        st.setShowDate(Timestamp.valueOf(tsStr));
		    } else {
		        st.setShowDate(null);
		    }
		} catch (Exception e) {
		    st.setShowDate(null);
		}


		try {
			st.setBasePrice(new BigDecimal(basePriceStr));
		} catch (Exception e) {
			st.setBasePrice(BigDecimal.ZERO);
		}

		st.setActive(activeStr != null);

		if (updating)
			showtimeDAO.updateShowtime(st);
		else
			showtimeDAO.addShowtime(st);

		resp.sendRedirect(req.getContextPath() + "/admin/showtimes");
	}
}
