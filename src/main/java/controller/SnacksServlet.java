package controller;

import DAO.*;
import model.Snack;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/snacks")
public class SnacksServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ CHECK LOGIN
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            String returnUrl = "/snacks?bookingId=" + request.getParameter("bookingId");
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=" +
                    java.net.URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }

        int bookingId;
        try { bookingId = Integer.parseInt(request.getParameter("bookingId")); }
        catch (Exception e) { response.sendRedirect(request.getContextPath() + "/home"); return; }

        try (Connection conn = DBConnection.getConnection()) {
            SnackDAO snackDAO = new SnackDAO(conn);
            List<Snack> snacks = snackDAO.findAll(null, null);

            request.setAttribute("bookingId", bookingId);
            request.setAttribute("snacks", snacks);

            request.getRequestDispatcher("/view/KhachHang/NhomSnack/snacks.jsp").forward(request, response);
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
            String returnUrl = "/snacks?bookingId=" + request.getParameter("bookingId");
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=" +
                    java.net.URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }

        request.setCharacterEncoding("UTF-8");

        int bookingId;
        try { bookingId = Integer.parseInt(request.getParameter("bookingId")); }
        catch (Exception e) { response.sendRedirect(request.getContextPath() + "/home"); return; }

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            SnackDAO snackDAO = new SnackDAO(conn);
            BookingSnackDAO bookingSnackDAO = new BookingSnackDAO(conn);
            BookingSeatDAO bookingSeatDAO = new BookingSeatDAO(conn);
            BookingDAO bookingDAO = new BookingDAO(conn);

            // ✅ quan trọng: tránh submit lại bị cộng dồn
            bookingSnackDAO.clearByBooking(bookingId);

            // đọc tất cả snack, lấy qty_{snackId}
            List<Snack> snacks = snackDAO.findAll(null, null);
            for (Snack s : snacks) {
                String key = "qty_" + s.getSnackId();
                String raw = request.getParameter(key);
                if (raw == null) continue;

                int qty;
                try { qty = Integer.parseInt(raw.trim()); } catch (Exception ex) { qty = 0; }
                if (qty <= 0) continue;

                // giá thực (nếu có discount dạng trừ thẳng)
                double price = s.getPrice().doubleValue();
                double discount = (s.getDiscount() != null) ? s.getDiscount().doubleValue() : 0;
                double unitPrice = Math.max(0, price - discount);

                // insert mới (vì đã clear)
                bookingSnackDAO.upsertBookingSnack(bookingId, s.getSnackId(), qty, unitPrice);
            }

            double snackTotal = bookingSnackDAO.sumSnackAmount(bookingId);
            double seatTotal = bookingSeatDAO.sumSeatTotal(bookingId).doubleValue();

            bookingDAO.updateTotalAmount(bookingId, seatTotal + snackTotal);

            conn.commit();

            response.sendRedirect(request.getContextPath() + "/checkout?bookingId=" + bookingId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}

