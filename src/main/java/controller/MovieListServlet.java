package controller;

import DAO.*;
import model.Movie;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/movies")
public class MovieListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status"); // SHOWING / COMING_SOON / ENDED (optional)
        String keyword = request.getParameter("q");

        int page = 1;
        int pageSize = 12;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception ignored) {}

        try (Connection conn = DBConnection.getConnection()) {
            MovieDAO movieDAO = new MovieDAO(conn);

            int total = movieDAO.countSearch(keyword, status);
            int totalPages = (int) Math.ceil(total * 1.0 / pageSize);

            List<Movie> items = movieDAO.searchPaged(keyword, status, page, pageSize);

            request.setAttribute("items", items);
            request.setAttribute("total", total);
            request.setAttribute("page", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);

            request.setAttribute("status", status);
            request.setAttribute("q", keyword);

            request.getRequestDispatcher("/view/KhachHang/NhomMovie/movies.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
