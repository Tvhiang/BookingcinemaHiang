<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    // Check login admin
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
    <title>Chi tiết phim - Cinema Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet"/>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/view/Admin/assets/CSS/style_adminMovieDetail.css"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
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
                    <div style="font-size:1rem;font-weight:600;">
                        Chi tiết phim
                    </div>
                    <div style="font-size:0.8rem;color:var(--text-muted);">
                        Xem đầy đủ thông tin phim và thao tác nhanh.
                    </div>
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
            <c:if test="${empty movie}">
                <p>Không tìm thấy phim.</p>
            </c:if>

            <c:if test="${not empty movie}">
                <div class="detail-card">
                    <div class="row g-4">
                        <div class="col-md-4">
                            <div class="poster-box">
                                <img src="${empty movie.posterUrl
                                            ? 'https://via.placeholder.com/600x900?text=No+Poster'
                                            : movie.posterUrl}"
                                     alt="${movie.title}">
                            </div>
                        </div>
                        <div class="col-md-8">
                            <h4 class="mb-1">${movie.title}</h4>

                            <div class="mb-2">
                                <span class="tag">${movie.genre}</span>
                                <span class="tag">${movie.ageRating}</span>
                                <span class="tag">${movie.status}</span>
                            </div>

                            <div class="mb-2">
                                <div class="field-label">Thời lượng</div>
                                <div class="field-value">
                                    <c:out value="${movie.duration}"/> phút
                                </div>
                            </div>

                            <div class="mb-2">
                                <div class="field-label">Đạo diễn</div>
                                <div class="field-value">
                                    <c:out value="${movie.director}"/>
                                </div>
                            </div>

                            <div class="mb-2">
                                <div class="field-label">Dàn diễn viên</div>
                                <div class="field-value">
                                    <c:out value="${movie.cast}"/>
                                </div>
                            </div>

                            <div class="mb-2">
                                <div class="field-label">Ngày khởi chiếu</div>
                                <div class="field-value">
                                    <c:out value="${movie.releaseDate}"/>
                                </div>
                            </div>

                            <div class="mb-3">
                                <div class="field-label">Mô tả</div>
                                <div class="field-value">
                                    <c:out value="${movie.description}"/>
                                </div>
                            </div>

                            <div class="d-flex gap-2 mt-2 flex-wrap">
                                <a href="${pageContext.request.contextPath}/admin/movies"
                                   class="btn btn-outline-secondary btn-sm">
                                    <i class="bi bi-arrow-left"></i> Quay lại danh sách
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/movies?action=edit&id=${movie.movieId}"
                                   class="btn btn-primary btn-sm">
                                    <i class="bi bi-pencil-square"></i> Sửa
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/movies?action=delete&id=${movie.movieId}"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Xóa phim này khỏi hệ thống?');">
                                    <i class="bi bi-trash3"></i> Xóa
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
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
