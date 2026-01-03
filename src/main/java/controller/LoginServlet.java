package controller;

import DAO.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // nếu đã login thì về home
        HttpSession s = request.getSession(false);
        if (s != null && s.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.getRequestDispatcher("/view/KhachHang/NhomLogin/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action"); // login/register
        String returnUrl = request.getParameter("returnUrl"); // để quay lại seat-selection

        if ("register".equalsIgnoreCase(action)) {
            String username = request.getParameter("username");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");

            if (username == null || username.isBlank() || password == null || password.isBlank()) {
                request.setAttribute("error", "Vui lòng nhập Username và Password.");
                request.getRequestDispatcher("/view/KhachHang/NhomLogin/login.jsp").forward(request, response);
                return;
            }
            if (userDAO.existsUsername(username)) {
                request.setAttribute("error", "Username đã tồn tại.");
                request.getRequestDispatcher("/view/KhachHang/NhomLogin/login.jsp").forward(request, response);
                return;
            }
            if (email != null && !email.isBlank() && userDAO.existsEmail(email)) {
                request.setAttribute("error", "Email đã tồn tại.");
                request.getRequestDispatcher("/view/KhachHang/NhomLogin/login.jsp").forward(request, response);
                return;
            }

            User u = new User();
            u.setUsername(username);
            u.setPassword(password);
            u.setFullName(fullName);
            u.setEmail(email);
            u.setPhone(phone);

            boolean ok = userDAO.createCustomer(u);
            request.setAttribute(ok ? "success" : "error", ok ? "Đăng ký thành công! Hãy đăng nhập." : "Đăng ký thất bại!");
            request.getRequestDispatcher("/view/KhachHang/NhomLogin/login.jsp").forward(request, response);
            return;
        }

        // LOGIN
        String key = request.getParameter("key"); // username/email/phone
        String password = request.getParameter("password");

        User user = userDAO.dangNhapKhach(key, password);
        if (user == null) {
            request.setAttribute("error", "Sai tài khoản/mật khẩu hoặc tài khoản bị khóa.");
            request.getRequestDispatcher("/view/KhachHang/NhomLogin/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);	
        session.setAttribute("user", user);
        session.setAttribute("role", user.getRole());

        if (returnUrl != null && !returnUrl.isBlank()) {
            // returnUrl do mình tự build: ví dụ /seat-selection?showtimeId=3
            response.sendRedirect(request.getContextPath() + returnUrl);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
