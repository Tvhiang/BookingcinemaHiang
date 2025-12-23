package DAO;

import model.Room;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    private Connection conn;

    public RoomDAO(Connection conn) {
        this.conn = conn;
    }

    // Lấy tất cả phòng (dùng cho select box)
    public List<Room> findAll() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY room_name ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setRoomName(rs.getString("room_name"));
                r.setTotalRows(rs.getInt("total_rows"));
                r.setTotalCols(rs.getInt("total_cols"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tìm phòng theo ID
    public Room findById(int id) {
        String sql = "SELECT * FROM rooms WHERE room_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Room(
                        rs.getInt("room_id"),
                        rs.getString("room_name"),
                        rs.getInt("total_rows"),
                        rs.getInt("total_cols")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
