package controller;

import DAO.BookingHistoryDAO;
import DAO.DBConnection;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/my-bookings")
public class MyBookingsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // CHECK LOGIN
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            String returnUrl = "/my-bookings";
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=" +
                    java.net.URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }

        String status = request.getParameter("status"); // ALL/PENDING/PAID/CANCELLED
        String q = request.getParameter("q");           // search
        String sort = request.getParameter("sort");     // newest/oldest/az

        if (status == null || status.isBlank()) status = "ALL";
        if (sort == null || sort.isBlank()) sort = "newest";

        try (Connection conn = DBConnection.getConnection()) {
            BookingHistoryDAO dao = new BookingHistoryDAO(conn);
            var items = dao.findByUser(user.getUserId(), status, q, sort);

            request.setAttribute("items", items);
            request.setAttribute("status", status);
            request.setAttribute("q", q);
            request.setAttribute("sort", sort);

            request.getRequestDispatcher("/view/KhachHang/NhomLSMua/myBookings.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
