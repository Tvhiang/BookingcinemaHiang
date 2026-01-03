package controller;

import DAO.*;
import model.Movie;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int limitShowing = 8; 
        int limitComing = 12; 
        try (Connection conn = DBConnection.getConnection()) {
            MovieDAO movieDAO = new MovieDAO(conn);

            List<Movie> showing = movieDAO.findByStatusLimit("SHOWING", limitShowing);
            List<Movie> coming = movieDAO.findByStatusLimit("COMING_SOON", limitComing);

            request.setAttribute("showing", showing);
            request.setAttribute("coming", coming);

            request.getRequestDispatcher("/view/KhachHang/NhomMovie/home.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
