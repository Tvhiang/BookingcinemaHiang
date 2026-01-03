package controller;

import DAO.*;
import model.Payment;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/booking-success")
public class BookingSuccessServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // CHECK LOGIN (vì đây là hóa đơn của user)
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            String returnUrl = "/booking-success?bookingId=" + request.getParameter("bookingId");
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=" + java.net.URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        try (Connection conn = DBConnection.getConnection()) {
            BookingDAO bookingDAO = new BookingDAO(conn);
            PaymentDAO paymentDAO = new PaymentDAO(conn);

            var booking = bookingDAO.findById(bookingId);
            if (booking == null || booking.getUserId() != user.getUserId()) {
                response.sendError(403);
                return;
            }

            Payment payment = paymentDAO.findLatestByBooking(bookingId);

            request.setAttribute("booking", booking);
            request.setAttribute("payment", payment);

            request.getRequestDispatcher("/view/KhachHang/NhomcheckoutBooking/booking_hoadon.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
