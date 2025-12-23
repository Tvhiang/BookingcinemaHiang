package DAO;

import model.BookingRow;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminBookingDAO {
    private final Connection conn;

    public AdminBookingDAO(Connection conn) {
        this.conn = conn;
    }

    // List booking kèm username + movie + room + showDate
    public List<BookingRow> findAllWithDetails(String keyword, String status) {
        List<BookingRow> list = new ArrayList<>();

        String sql = """
            SELECT 
                b.booking_id, b.user_id, u.username,
                b.showtime_id, s.show_date,
                m.title AS movie_title,
                r.room_name,
                b.booking_time, b.total_amount, b.payment_status
            FROM bookings b
            JOIN users u      ON u.user_id = b.user_id
            JOIN showtimes s  ON s.showtime_id = b.showtime_id
            JOIN movies m     ON m.movie_id = s.movie_id
            JOIN rooms r      ON r.room_id = s.room_id
            WHERE 1=1
        """;

        // filter keyword: username / movie / room / bookingId
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += """
                AND (
                    u.username LIKE ? OR
                    m.title LIKE ? OR
                    r.room_name LIKE ? OR
                    CAST(b.booking_id AS CHAR) LIKE ?
                )
            """;
        }

        // filter status
        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql += " AND b.payment_status = ? ";
        }

        sql += " ORDER BY b.booking_time DESC ";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String k = "%" + keyword.trim() + "%";
                ps.setString(idx++, k);
                ps.setString(idx++, k);
                ps.setString(idx++, k);
                ps.setString(idx++, k);
            }

            if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
                ps.setString(idx++, status.trim());
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookingRow row = new BookingRow();
                row.setBookingId(rs.getInt("booking_id"));
                row.setUserId(rs.getInt("user_id"));
                row.setUsername(rs.getString("username"));

                row.setShowtimeId(rs.getInt("showtime_id"));
                row.setShowDate(rs.getTimestamp("show_date"));
                row.setMovieTitle(rs.getString("movie_title"));
                row.setRoomName(rs.getString("room_name"));

                row.setBookingTime(rs.getTimestamp("booking_time"));
                row.setTotalAmount(rs.getBigDecimal("total_amount"));
                row.setPaymentStatus(rs.getString("payment_status"));

                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Đổi trạng thái: PAID / CANCELLED / PENDING
    public boolean updatePaymentStatus(int bookingId, String paymentStatus) {
        String sql = "UPDATE bookings SET payment_status=?, updated_at=NOW() WHERE booking_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
