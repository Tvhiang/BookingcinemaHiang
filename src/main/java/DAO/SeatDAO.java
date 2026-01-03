package DAO;

import model.Seat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.*;
import java.util.*;

public class SeatDAO {
	private final Connection conn;

	public SeatDAO(Connection conn) {
		this.conn = conn;
	}

	public int countTotalSeatsByRoom(int roomId) {
		String sql = "SELECT COUNT(*) FROM seats WHERE room_id=?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, roomId);
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getInt(1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	// bookedSeats = count seat in booking_seats của các booking thuộc showtime và
	// chưa CANCELLED
	public int countBookedSeatsByShowtime(int showtimeId) {
		String sql = """
				    SELECT COUNT(*)
				    FROM booking_seats bs
				    JOIN bookings b ON bs.booking_id = b.booking_id
				    WHERE b.showtime_id = ? AND b.payment_status <> 'CANCELLED'
				""";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, showtimeId);
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getInt(1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	public List<Seat> findSeatsByRoom(int roomId) {
		List<Seat> list = new ArrayList<>();
		String sql = """
				    SELECT seat_id, room_id, seat_row, seat_col, seat_label
				    FROM seats
				    WHERE room_id=?
				    ORDER BY seat_row ASC, seat_col ASC
				""";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, roomId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Seat s = new Seat();
				s.setSeatId(rs.getInt("seat_id"));
				s.setRoomId(rs.getInt("room_id"));
				s.setSeatRow(rs.getString("seat_row")); // vd: A,B,C
				s.setSeatCol(rs.getInt("seat_col")); // vd: 1..12
				s.setSeatLabel(rs.getString("seat_label")); // vd: A1
				list.add(s);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// ghế đã đặt theo showtime (booking đã tạo, không CANCELLED)
	public Set<Integer> findBookedSeatIdsByShowtime(int showtimeId) {
		Set<Integer> set = new HashSet<>();
		String sql = """
				    SELECT bs.seat_id
				    FROM booking_seats bs
				    JOIN bookings b ON bs.booking_id = b.booking_id
				    WHERE b.showtime_id=? AND b.payment_status <> 'CANCELLED'
				""";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, showtimeId);
			ResultSet rs = ps.executeQuery();
			while (rs.next())
				set.add(rs.getInt(1));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return set;
	}
}
