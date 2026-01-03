package DAO;

import model.BookingHistoryRow;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingHistoryDAO {
    private final Connection conn;
    public BookingHistoryDAO(Connection conn) { this.conn = conn; }


    public List<BookingHistoryRow> findByUser(int userId, String status, String q, String sort) throws SQLException {
        List<BookingHistoryRow> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT
                b.booking_id, b.booking_time, b.payment_status, b.total_amount,
                s.showtime_id, s.show_date, s.base_price,
                r.room_id, r.room_name,
                m.movie_id, m.title AS movie_title, m.poster_url,
                GROUP_CONCAT(se.seat_label ORDER BY se.seat_row, se.seat_col SEPARATOR ', ') AS seat_labels
            FROM bookings b
            JOIN showtimes s ON b.showtime_id = s.showtime_id
            JOIN movies m ON s.movie_id = m.movie_id
            JOIN rooms r ON s.room_id = r.room_id
            LEFT JOIN booking_seats bs ON b.booking_id = bs.booking_id
            LEFT JOIN seats se ON bs.seat_id = se.seat_id
            WHERE b.user_id = ?
        """);

        List<Object> params = new ArrayList<>();
        params.add(userId);

        if (status != null && !status.isBlank() && !"ALL".equalsIgnoreCase(status)) {
            sql.append(" AND b.payment_status = ? ");
            params.add(status.trim().toUpperCase());
        }

        if (q != null && !q.isBlank()) {
            sql.append(" AND (m.title LIKE ? OR r.room_name LIKE ?) ");
            String kw = "%" + q.trim() + "%";
            params.add(kw);
            params.add(kw);
        }

        sql.append("""
            GROUP BY b.booking_id, b.booking_time, b.payment_status, b.total_amount,
                     s.showtime_id, s.show_date, s.base_price,
                     r.room_id, r.room_name,
                     m.movie_id, m.title, m.poster_url
        """);

        if ("oldest".equalsIgnoreCase(sort)) {
            sql.append(" ORDER BY b.booking_time ASC ");
        } else if ("az".equalsIgnoreCase(sort)) {
            sql.append(" ORDER BY m.title ASC, b.booking_time DESC ");
        } else {
            sql.append(" ORDER BY b.booking_time DESC ");
        }

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookingHistoryRow row = new BookingHistoryRow();
                row.setBookingId(rs.getInt("booking_id"));
                row.setBookingTime(rs.getTimestamp("booking_time"));
                row.setPaymentStatus(rs.getString("payment_status"));
                row.setTotalAmount(rs.getBigDecimal("total_amount"));

                row.setShowtimeId(rs.getInt("showtime_id"));
                row.setShowDate(rs.getTimestamp("show_date"));
                row.setBasePrice(rs.getBigDecimal("base_price"));

                row.setRoomId(rs.getInt("room_id"));
                row.setRoomName(rs.getString("room_name"));

                row.setMovieId(rs.getInt("movie_id"));
                row.setMovieTitle(rs.getString("movie_title"));
                row.setPosterUrl(rs.getString("poster_url"));

                row.setSeatLabels(rs.getString("seat_labels"));
                list.add(row);
            }
        }

        return list;
    }
}
