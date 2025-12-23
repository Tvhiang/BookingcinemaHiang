package controller;

import DAO.AdminBookingDAO;
import DAO.DBConnection;
import model.BookingRow;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/bookings")
public class AdminBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // ===== check login admin =====
        HttpSession session = req.getSession(false);
        User admin = (session != null) ? (User) session.getAttribute("adminUser") : null;
        if (admin == null) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }

        String action = req.getParameter("action"); // pay | cancel | pending | list
        String idStr = req.getParameter("id");
        if (action == null) action = "list";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) throw new ServletException("Không thể kết nối database.");

            AdminBookingDAO adminBookingDAO = new AdminBookingDAO(conn);

            // ===== actions đổi trạng thái =====
            if (!"list".equalsIgnoreCase(action)) {
                try {	
                    int bookingId = Integer.parseInt(idStr);

                    switch (action) {
                        case "pay":
                            adminBookingDAO.updatePaymentStatus(bookingId, "PAID");
                            break;
                        case "cancel":
                            adminBookingDAO.updatePaymentStatus(bookingId, "CANCELLED");
                            break;
                        case "pending":
                            adminBookingDAO.updatePaymentStatus(bookingId, "PENDING");
                            break;
                        default:
                            break;
                    }
                } catch (Exception ignored) {}

                resp.sendRedirect(req.getContextPath() + "/admin/bookings");
                return;
            }

            // ===== list + filter =====
            String keyword = req.getParameter("keyword");
            String status = req.getParameter("status"); // ALL / PENDING / PAID / CANCELLED

            List<BookingRow> rows = adminBookingDAO.findAllWithDetails(keyword, status);

            req.setAttribute("keyword", keyword);
            req.setAttribute("status", (status == null || status.isBlank()) ? "ALL" : status);
            req.setAttribute("bookings", rows);

            req.getRequestDispatcher("/view/Admin/adminBookings.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi load bookings: " + e.getMessage());
            req.getRequestDispatcher("/view/Admin/adminBookings.jsp").forward(req, resp);
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException ignored) {}
            }
        }
    }
}
