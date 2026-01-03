package controller;

import DAO.*;
import model.Payment;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ CHECK LOGIN
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            String returnUrl = "/checkout?bookingId=" + request.getParameter("bookingId");
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=" + java.net.URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        try (Connection conn = DBConnection.getConnection()) {
            BookingDAO bookingDAO = new BookingDAO(conn);

            request.setAttribute("booking", bookingDAO.findById(bookingId));
            request.getRequestDispatcher("/view/KhachHang/NhomcheckoutBooking/checkout.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ CHECK LOGIN
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            String returnUrl = "/checkout?bookingId=" + request.getParameter("bookingId");
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=" + java.net.URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }

        request.setCharacterEncoding("UTF-8");

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String method = request.getParameter("paymentMethod"); // CASH/CARD/MOMO/VNPAY...

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            BookingDAO bookingDAO = new BookingDAO(conn);
            PaymentDAO paymentDAO = new PaymentDAO(conn);

            // Demo: thanh toán thành công luôn
            paymentDAO.createPaidPayment(bookingId, method);
            bookingDAO.updatePaymentStatus(bookingId, "PAID");

            conn.commit();

            // TODO: gửi mail vé (optional)
            response.sendRedirect(request.getContextPath() + "/booking-success?bookingId=" + bookingId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}

