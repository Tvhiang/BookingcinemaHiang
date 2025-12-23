package controller;

import DAO.DBConnection;
import DAO.SnackDAO;
import model.Snack;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.util.List;

@WebServlet("/admin/snacks")
public class AdminSnackServlet extends HttpServlet {

    private SnackDAO snackDAO;

    @Override
    public void init() throws ServletException {
        Connection conn = DBConnection.getConnection();
        if (conn == null) throw new ServletException("Không thể kết nối database.");
        snackDAO = new SnackDAO(conn);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Check login admin
        HttpSession session = req.getSession(false);
        User admin = (session != null) ? (User) session.getAttribute("adminUser") : null;
        if (admin == null) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create":
                req.setAttribute("snack", null);
                req.getRequestDispatcher("/view/Admin/adminSnackForm.jsp").forward(req, resp);
                break;

            case "edit": {
                String idStr = req.getParameter("id");
                try {
                    int id = Integer.parseInt(idStr);
                    Snack s = snackDAO.findById(id);
                    if (s == null) {
                        resp.sendRedirect(req.getContextPath() + "/admin/snacks");
                        return;
                    }
                    req.setAttribute("snack", s);
                    req.getRequestDispatcher("/view/Admin/adminSnackForm.jsp").forward(req, resp);
                } catch (Exception e) {
                    resp.sendRedirect(req.getContextPath() + "/admin/snacks");
                }
                break;
            }

            case "delete": {
                String idStr = req.getParameter("id");
                try {
                    int id = Integer.parseInt(idStr);
                    snackDAO.delete(id);
                } catch (Exception ignored) {}
                resp.sendRedirect(req.getContextPath() + "/admin/snacks");
                break;
            }

            default: {
                String keyword = req.getParameter("keyword");
                String category = req.getParameter("category");

                List<Snack> snacks = snackDAO.findAll(keyword, category);

                req.setAttribute("snacks", snacks);
                req.setAttribute("keyword", keyword);
                req.setAttribute("category", category);

                req.getRequestDispatcher("/view/Admin/adminSnack.jsp").forward(req, resp);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");

        // Check login admin
        HttpSession session = req.getSession(false);
        User admin = (session != null) ? (User) session.getAttribute("adminUser") : null;
        if (admin == null) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }

        String idStr = req.getParameter("id");
        String snackName = req.getParameter("snackName");
        String category = req.getParameter("category");
        String priceStr = req.getParameter("price");
        String imageUrl = req.getParameter("imageUrl");
        String discountStr = req.getParameter("discount");

        Snack s = new Snack();

        boolean updating = (idStr != null && !idStr.isEmpty());
        if (updating) {
            try { s.setSnackId(Integer.parseInt(idStr)); } catch (Exception ignored) {}
        }

        s.setSnackName(snackName != null ? snackName.trim() : "");
        s.setCategory(category != null ? category.trim() : "OTHER");

        try { s.setPrice(new BigDecimal(priceStr)); }
        catch (Exception e) { s.setPrice(BigDecimal.ZERO); }

        s.setImageUrl((imageUrl != null && !imageUrl.trim().isEmpty()) ? imageUrl.trim() : null);

        try { s.setDiscount(new BigDecimal(discountStr)); }
        catch (Exception e) { s.setDiscount(BigDecimal.ZERO); }

        if (updating) snackDAO.update(s);
        else snackDAO.add(s);

        resp.sendRedirect(req.getContextPath() + "/admin/snacks");
    }
}
