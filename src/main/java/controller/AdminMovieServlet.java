package controller;

import DAO.DBConnection;
import DAO.MovieDAO;
import model.Movie;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/movies")
public class AdminMovieServlet extends HttpServlet {

    private MovieDAO movieDAO;

    @Override
    public void init() throws ServletException {
        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            throw new ServletException("Không thể kết nối database.");
        }
        movieDAO = new MovieDAO(conn);
    }

    // ========================= doGET ==========================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }

        String action = req.getParameter("action");
        String idStr  = req.getParameter("id");

        if (action == null) action = "list";

        switch (action) {

            // ---------------- CREATE ----------------
            case "create":
                req.setAttribute("movie", null);
                req.getRequestDispatcher("/view/Admin/adminMovieForm.jsp")
                        .forward(req, resp);
                break;

            // ---------------- EDIT ----------------
            case "edit":
                if (idStr == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/movies");
                    return;
                }

                try {
                    int id = Integer.parseInt(idStr);
                    Movie m = movieDAO.findById(id);

                    if (m == null) {
                        resp.sendRedirect(req.getContextPath() + "/admin/movies");
                        return;
                    }

                    req.setAttribute("movie", m);
                    req.getRequestDispatcher("/view/Admin/adminMovieForm.jsp")
                            .forward(req, resp);

                } catch (Exception e) {
                    resp.sendRedirect(req.getContextPath() + "/admin/movies");
                }
                break;
             //Detail
            case "detail": // Xem chi tiết phim
                if (idStr == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/movies");
                    return;
                }

                try {
                    int id = Integer.parseInt(idStr);
                    Movie detail = movieDAO.findById(id);

                    if (detail == null) {
                        resp.sendRedirect(req.getContextPath() + "/admin/movies");
                        return;
                    }

                    req.setAttribute("movie", detail);
                    req.getRequestDispatcher("/view/Admin/adminMovieDetail.jsp")
                            .forward(req, resp);

                } catch (Exception e) {
                    resp.sendRedirect(req.getContextPath() + "/admin/movies");
                }
                break;

            // ---------------- DELETE ----------------
            case "delete":
                try {
                    int id = Integer.parseInt(idStr);
                    movieDAO.deleteMovie(id);
                } catch (Exception ignored) { }

                resp.sendRedirect(req.getContextPath() + "/admin/movies");
                break;
                
            // ---------------- LIST ------------------
            default:

                String keyword = req.getParameter("keyword");
                List<Movie> movies;

                if (keyword != null && !keyword.trim().isEmpty()) {
                    movies = movieDAO.searchByTitle(keyword.trim());
                } else {
                    movies = movieDAO.findAll();
                }

                req.setAttribute("movies", movies);
                req.setAttribute("keyword", keyword);

                req.getRequestDispatcher("/view/Admin/adminMovie.jsp")
                        .forward(req, resp);

        }
    }

    // ========================= doPOST (Add + Edit) ==========================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }

        // ===== Lấy dữ liệu từ form
        String idStr       = req.getParameter("movieId");
        String title       = req.getParameter("title");
        String genre       = req.getParameter("genre");
        String durationRaw = req.getParameter("duration");
        String description = req.getParameter("description");
        String director    = req.getParameter("director");
        String cast        = req.getParameter("cast");
        String posterUrl   = req.getParameter("posterUrl");
        String ageRating   = req.getParameter("ageRating");
        String releaseRaw  = req.getParameter("releaseDate");
        String status      = req.getParameter("status");

        Movie m = new Movie();

        boolean updating = idStr != null && !idStr.isEmpty();
        if (updating) {
            m.setMovieId(Integer.parseInt(idStr));
        }

        m.setTitle(title);
        m.setGenre(genre);

        try {
            m.setDuration(durationRaw == null ? null : Integer.parseInt(durationRaw));
        } catch (Exception e) {
            m.setDuration(null);
        }

        m.setDescription(description);
        m.setDirector(director);
        m.setCast(cast);
        m.setPosterUrl(posterUrl);
        m.setAgeRating(ageRating);

        try {
            m.setReleaseDate(
                    releaseRaw == null || releaseRaw.isEmpty()
                            ? null
                            : Date.valueOf(releaseRaw)
            );
        } catch (Exception e) {
            m.setReleaseDate(null);
        }

        m.setStatus(status);

        // ===== ADD / UPDATE
        if (updating) {
            movieDAO.updateMovie(m);
        } else {
            movieDAO.addMovie(m);
        }

      
        resp.sendRedirect(req.getContextPath() + "/admin/movies");
    }
}

