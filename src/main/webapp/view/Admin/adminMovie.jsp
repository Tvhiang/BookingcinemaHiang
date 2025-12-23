<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Check đã login admin chưa
    model.User admin = (model.User) session.getAttribute("adminUser");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý phim - Cinema Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/view/Admin/assets/CSS/style_adminMovie.css" />

    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>

<body>

<!-- SIDEBAR MOBILE -->
<div class="sidebar-mobile" id="sidebarMobile">
    <div class="sidebar-title">
        <i class="bi bi-film"></i> Cinema Admin
    </div>
    <a href="${pageContext.request.contextPath}/admin/home" class="side-link">
        <i class="bi bi-speedometer2"></i> Tổng quan
    </a>
    <a href="${pageContext.request.contextPath}/admin/movies" class="side-link active">
        <i class="bi bi-camera-reels"></i> Phim
    </a>
    <a href="${pageContext.request.contextPath}/admin/showtimes" class="side-link">
        <i class="bi bi-clock-history"></i> Suất chiếu
    </a>
    <a href="${pageContext.request.contextPath}/admin/snacks" class="side-link">
        <i class="bi bi-cup-straw"></i> Đồ ăn
    </a>
    <a href="${pageContext.request.contextPath}/admin/bookings" class="side-link">
        <i class="bi bi-receipt-cutoff"></i> Đơn đặt vé
    </a>
</div>
<div class="mobile-overlay" id="mobileOverlay"></div>

<div class="layout">

    <!-- SIDEBAR PC -->
    <aside class="sidebar">
        <div class="sidebar-title">
            <i class="bi bi-film"></i>
            <span>Cinema Admin</span>
        </div>
        <a href="${pageContext.request.contextPath}/admin/home" class="side-link">
            <i class="bi bi-speedometer2"></i> Tổng quan
        </a>
        <a href="${pageContext.request.contextPath}/admin/movies" class="side-link active">
            <i class="bi bi-camera-reels"></i> Phim
        </a>
        <a href="${pageContext.request.contextPath}/admin/showtimes" class="side-link">
            <i class="bi bi-clock-history"></i> Suất chiếu
        </a>
        <a href="${pageContext.request.contextPath}/admin/snacks" class="side-link">
            <i class="bi bi-cup-straw"></i> Đồ ăn
        </a>
        <a href="${pageContext.request.contextPath}/admin/bookings" class="side-link">
            <i class="bi bi-receipt-cutoff"></i> Đơn đặt vé
        </a>
    </aside>

    <!-- MAIN -->
    <div class="main">

        <!-- TOPBAR -->
        <header class="topbar">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-list mobile-toggle" id="mobileToggle"></i>
                <div>
                    <div class="movie-header-title">Quản lý phim</div>
                </div>
            </div>

            <div class="d-flex align-items-center gap-2">
                <span style="font-size:0.85rem;color:var(--text-muted);">
                    Xin chào,
                    <span style="color:#a5b4fc;">
                        <%= admin.getFullName() != null && !admin.getFullName().isEmpty()
                                ? admin.getFullName()
                                : admin.getUsername() %>
                    </span>
                </span>
                <div class="avatar-circle">
                    <%= Character.toUpperCase(admin.getUsername().charAt(0)) %>
                </div>
                <form action="${pageContext.request.contextPath}/admin/logout" method="get">
                    <button class="btn btn-sm btn-outline-light">
                        <i class="bi bi-box-arrow-right"></i>
                    </button>
                </form>
            </div>
        </header>

        <!-- CONTENT -->
        <main class="content">

            <!-- HEADER + ADD -->
            <div class="movie-header">
                <div>
                    <div class="movie-header-title">Danh sách phim</div>
                    <div class="movie-header-sub">
                        Quản lý phim đang chiếu, sắp chiếu và đã chiếu.
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/admin/movies?action=create"
                   class="btn btn-sm btn-primary btn-plus">
                    <i class="bi bi-plus-lg"></i> Thêm phim mới
                </a>
            </div>

            <!-- SEARCH -->
            <form class="movie-search-bar" method="get"
                  action="${pageContext.request.contextPath}/admin/movies">
                <div class="flex-grow-1">
                    <input type="text"
                           class="form-control"
                           name="keyword"
                           value="${keyword}"
                           placeholder="Nhập tên phim để tìm...">
                </div>
                <button class="btn btn-outline-light" type="submit">
                    <i class="bi bi-search"></i> Tìm kiếm
                </button>
            </form>

            <!-- GRID MOVIES -->
            <div class="movie-grid">

                <!-- Nếu không có phim -->
                <c:if test="${empty movies}">
                    <p style="color:var(--text-muted); font-size:0.9rem;">
                        Chưa có phim nào trong hệ thống. Hãy nhấn <b>Thêm phim mới</b> để bắt đầu.
                    </p>
                </c:if>

                <!-- Lặp phim từ DB -->
                <c:forEach var="m" items="${movies}">
                    <div class="movie-card">
                        <div class="movie-poster">
                            <img src="${empty m.posterUrl ? 'https://via.placeholder.com/400x260?text=No+Poster' : m.posterUrl}"
                                 alt="${m.title}">
                        </div>

                        <div class="movie-hover-panel">
                            <div class="movie-hover-thumb">
                                <img src="${empty m.posterUrl ? 'https://via.placeholder.com/400x260?text=No+Poster' : m.posterUrl}"
                                     alt="${m.title}">
                            </div>
                            <div class="movie-hover-title">${m.title}</div>
                            <div class="movie-hover-meta">
                                <c:out value="${m.releaseDate}" /> ·
                                <c:out value="${m.duration}" /> phút ·
                                <c:out value="${m.ageRating}" />
                            </div>
                            <div class="movie-hover-tags">
                                <span>${m.genre}</span>
                                <span>${m.status}</span>
                            </div>
                            <div class="movie-actions">
                                <a href="${pageContext.request.contextPath}/admin/movies?action=edit&id=${m.movieId}"
                                   class="btn-admin btn-primary-soft">
                                    <i class="bi bi-pencil-square"></i> Sửa
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/movies?action=delete&id=${m.movieId}"
                                   class="btn-admin btn-danger-soft"
                                   onclick="return confirm('Xóa phim này?');">
                                    <i class="bi bi-trash3"></i> Xóa
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/movies?action=detail&id=${m.movieId}"
                                   class="btn-admin">
                                    <i class="bi bi-info-circle"></i> Chi tiết
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div> 

        </main>
    </div>
</div>

<!-- JS SIDEBAR MOBILE -->
<script>
    const mobileToggle = document.getElementById("mobileToggle");
    const sidebarMobile = document.getElementById("sidebarMobile");
    const mobileOverlay = document.getElementById("mobileOverlay");

    if (mobileToggle) {
        mobileToggle.addEventListener("click", () => {
            sidebarMobile.classList.add("show");
            mobileOverlay.classList.add("show");
        });
    }
    if (mobileOverlay) {
        mobileOverlay.addEventListener("click", () => {
            sidebarMobile.classList.remove("show");
            mobileOverlay.classList.remove("show");
        });
    }
</script>

</body>
</html>

