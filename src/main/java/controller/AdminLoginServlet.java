package controller;

import DAO.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;
import java.io.IOException;

@WebServlet("/admin")
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Tên cookie lưu username admin khi "Ghi nhớ đăng nhập"
    private static final String COOKIE_ADMIN_REMEMBER = "rememberedAdminUser";

    // ===========================
    //  GET: Hiển thị form login
    // ===========================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // 1. Nếu đã đăng nhập admin thì chuyển luôn sang /admin/home
        HttpSession session = req.getSession(false);
        if (session != null) {
            User adminUser = (User) session.getAttribute("adminUser");
            if (adminUser != null) {
                resp.sendRedirect(req.getContextPath() + "/admin/home");
                return;
            }
        }

        // 2. Đọc cookie "rememberedAdminUser" để tự điền username
        String rememberedUser = null;
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (COOKIE_ADMIN_REMEMBER.equals(c.getName())) {
                    rememberedUser = c.getValue();
                    break;
                }
            }
        }
        req.setAttribute("rememberedUser", rememberedUser);

        // 3. Forward tới trang login admin
        RequestDispatcher rd =
                req.getRequestDispatcher("/view/Admin/adminLogin.jsp");
        rd.forward(req, resp);
    }

    // ===========================
    //  POST: Xử lý submit login
    // ===========================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember"); // "on" nếu có tick

        UserDAO userDAO = new UserDAO();
        User user = userDAO.dangNhap(username, password);

        // 1. Sai tài khoản / mật khẩu / user INACTIVE
        if (user == null) {
            req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
            req.setAttribute("rememberedUser", username); // giữ lại user vừa nhập
            req.getRequestDispatcher("/view/Admin/adminLogin.jsp").forward(req, resp);
            return;
        }

        // 2. Không phải ADMIN thì chặn
        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            req.setAttribute("error", "Tài khoản này không có quyền truy cập trang quản trị!");
            req.setAttribute("rememberedUser", username);
            req.getRequestDispatcher("/view/Admin/adminLogin.jsp").forward(req, resp);
            return;
        }

        // 3. Đúng admin → lưu session
        HttpSession session = req.getSession(true);
        session.setAttribute("adminUser", user);

        // 4. Xử lý "Ghi nhớ đăng nhập"
        if ("on".equals(remember)) {
            Cookie cUser = new Cookie(COOKIE_ADMIN_REMEMBER, username);
            cUser.setMaxAge(7 * 24 * 60 * 60); // 7 ngày
            cUser.setPath(req.getContextPath());
            resp.addCookie(cUser);
        } else {
            // Không tick remember → xoá cookie nếu có
            Cookie cUser = new Cookie(COOKIE_ADMIN_REMEMBER, "");
            cUser.setMaxAge(0);
            cUser.setPath(req.getContextPath());
            resp.addCookie(cUser);
        }

        // 5. Đăng nhập thành công → chuyển tới dashboard admin
        resp.sendRedirect(req.getContextPath() + "/admin/home");
    }
}
