package DAO;

import model.Snack;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SnackDAO {
    private final Connection conn;

    public SnackDAO(Connection conn) {
        this.conn = conn;
    }

    private Snack mapRow(ResultSet rs) throws SQLException {
        Snack s = new Snack();
        s.setSnackId(rs.getInt("snack_id"));
        s.setSnackName(rs.getString("snack_name"));
        s.setCategory(rs.getString("category"));
        s.setPrice(rs.getBigDecimal("price"));
        s.setImageUrl(rs.getString("image_url"));
        s.setDiscount(rs.getBigDecimal("discount") == null ? BigDecimal.ZERO : rs.getBigDecimal("discount"));
        return s;
    }

    public List<Snack> findAll(String keyword, String category) {
        List<Snack> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM snacks WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND snack_name LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }
        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND category = ? ");
            params.add(category.trim());
        }

        sql.append(" ORDER BY snack_id DESC");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Snack findById(int id) {
        String sql = "SELECT * FROM snacks WHERE snack_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean add(Snack s) {
        String sql = """
            INSERT INTO snacks(snack_name, category, price, image_url, discount)
            VALUES(?,?,?,?,?)
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getSnackName());
            ps.setString(2, s.getCategory());
            ps.setBigDecimal(3, s.getPrice());
            ps.setString(4, s.getImageUrl());
            ps.setBigDecimal(5, s.getDiscount() == null ? BigDecimal.ZERO : s.getDiscount());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Snack s) {
        String sql = """
            UPDATE snacks
            SET snack_name=?, category=?, price=?, image_url=?, discount=?
            WHERE snack_id=?
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getSnackName());
            ps.setString(2, s.getCategory());
            ps.setBigDecimal(3, s.getPrice());
            ps.setString(4, s.getImageUrl());
            ps.setBigDecimal(5, s.getDiscount() == null ? BigDecimal.ZERO : s.getDiscount());
            ps.setInt(6, s.getSnackId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM snacks WHERE snack_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
