package DAO;

import java.math.BigDecimal;
import java.util.*;
import java.sql.*;

public class BookingSeatDAO {
    private final Connection conn;

    public BookingSeatDAO(Connection conn) { this.conn = conn; }

    public BigDecimal sumSeatTotal(int bookingId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(seat_price),0) AS total FROM booking_seats WHERE booking_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal("total");
            }
        }
        return BigDecimal.ZERO;
    }
    public List<Integer> findBookedSeatIdsByShowtime(int showtimeId) throws SQLException {
        List<Integer> ids = new ArrayList<>();
        String sql = """
            SELECT bs.seat_id
            FROM booking_seats bs
            JOIN bookings b ON bs.booking_id = b.booking_id
            WHERE b.showtime_id = ?
              AND b.payment_status <> 'CANCELLED'
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ids.add(rs.getInt(1));
            }
        }
        return ids;
    }

    public List<Integer> findSeatIdsByBooking(int bookingId) throws SQLException {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT seat_id FROM booking_seats WHERE booking_id=? ORDER BY seat_id";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ids.add(rs.getInt(1));
            }
        }
        return ids;
    }
}
