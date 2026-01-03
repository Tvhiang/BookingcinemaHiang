package controller;

import DAO.*;
import model.Movie;
import model.ShowtimeView;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/movie-detail")
public class MovieDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int movieId;
        try {
            movieId = Integer.parseInt(request.getParameter("id"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            MovieDAO movieDAO = new MovieDAO(conn);
            ShowtimeDAO showtimeDAO = new ShowtimeDAO(conn);

            Movie movie = movieDAO.findById(movieId);
            if (movie == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            List<ShowtimeView> showtimes = showtimeDAO.findByMovie(movieId);

            request.setAttribute("movie", movie);
            request.setAttribute("showtimes", showtimes);

            request.getRequestDispatcher("/view/KhachHang/NhomMovie/movieDetail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
