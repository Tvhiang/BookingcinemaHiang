package controller;

import DAO.*;
import model.User;
import model.Showtime;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.*;

@WebServlet("/seat-selection")
public class SeatSelectionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ CHECK LOGIN
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            String returnUrl = "/seat-selection?showtimeId=" + request.getParameter("showtimeId");
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=" +
                    java.net.URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }

        int showtimeId;
        try {
            showtimeId = Integer.parseInt(request.getParameter("showtimeId"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            ShowtimeDAO showtimeDAO = new ShowtimeDAO(conn);
            SeatDAO seatDAO = new SeatDAO(conn);

            Showtime showtime = showtimeDAO.findById(showtimeId);
            if (showtime == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            int roomId = showtime.getRoomId();

            request.setAttribute("showtime", showtime);
            request.setAttribute("seats", seatDAO.findSeatsByRoom(roomId));
            request.setAttribute("bookedSeatIds", seatDAO.findBookedSeatIdsByShowtime(showtimeId)); // Set<Integer>

            request.getRequestDispatcher("/view/KhachHang/NhomSeat/seatSelection.jsp")
                    .forward(request, response);

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
            String returnUrl = "/seat-selection?showtimeId=" + request.getParameter("showtimeId");
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=" +
                    java.net.URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }

        request.setCharacterEncoding("UTF-8");

        int showtimeId = Integer.parseInt(request.getParameter("showtimeId"));
        String[] seatIdsRaw = request.getParameterValues("seatIds");

        if (seatIdsRaw == null || seatIdsRaw.length == 0) {
            response.sendRedirect(request.getContextPath() + "/seat-selection?showtimeId=" + showtimeId);
            return;
        }

        List<Integer> seatIds = new ArrayList<>();
        for (String s : seatIdsRaw) seatIds.add(Integer.parseInt(s));

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            BookingDAO bookingDAO = new BookingDAO(conn);
            ShowtimeDAO showtimeDAO = new ShowtimeDAO(conn);

            // lấy base price theo showtime
            double seatPrice = showtimeDAO.findById(showtimeId).getBasePrice().doubleValue();

            // ✅ chống chọn trùng ngay trước khi insert
            if (!bookingDAO.areSeatsAvailable(showtimeId, seatIds)) {
                conn.rollback();
                request.getSession().setAttribute("seatError", "Ghế vừa bị người khác đặt. Vui lòng chọn ghế khác!");
                response.sendRedirect(request.getContextPath() + "/seat-selection?showtimeId=" + showtimeId);
                return;
            }

            double total = seatPrice * seatIds.size();
            int bookingId = bookingDAO.createPendingBooking(user.getUserId(), showtimeId, total);
            bookingDAO.insertBookingSeats(bookingId, seatIds, seatPrice);

            conn.commit();
            response.sendRedirect(request.getContextPath() + "/snacks?bookingId=" + bookingId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
