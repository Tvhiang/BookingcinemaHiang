<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
    <title>
        <c:choose>
            <c:when test="${empty showtime}">Thêm suất chiếu</c:when>
            <c:otherwise>Chỉnh sửa suất chiếu</c:otherwise>
        </c:choose>
        - Cinema Admin
    </title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet"/>

    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

    <style>
        :root {
            --bg-main: #020617;
            --bg-card: #020617;
            --text-main: #e5e7eb;
            --text-muted: #94a3b8;
            --border-subtle: #1f2937;
            --primary: #6366f1;
        }

        body {
            margin: 0;
            background: var(--bg-main);
            color: var(--text-main);
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        /* ===== SIDEBAR PC ===== */
        .sidebar {
            width: 240px;
            padding: 16px;
            background: var(--bg-main);
            border-right: 1px solid var(--border-subtle);
        }

        .sidebar-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            margin-bottom: 16px;
        }

        .sidebar-title i {
            color: var(--primary);
        }

        .side-link {
            display: block;
            padding: 8px 12px;
            border-radius: 999px;
            margin-bottom: 4px;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.9rem;
        }

        .side-link:hover,
        .side-link.active {
            background: rgba(99, 102, 241, 0.3);
            color: var(--text-main);
        }

        /* ===== SIDEBAR MOBILE ===== */
        .mobile-toggle {
            display: none;
            font-size: 1.7rem;
            cursor: pointer;
        }

        .sidebar-mobile {
            position: fixed;
            inset: 0 auto 0 0;
            width: 240px;
            background: #020617;
            border-right: 1px solid var(--border-subtle);
            padding: 16px;
            transform: translateX(-100%);
            transition: transform .25s;
            z-index: 2000;
        }

        .sidebar-mobile.show {
            transform: translateX(0);
        }

        .mobile-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.45);
            display: none;
            z-index: 1500;
        }

        .mobile-overlay.show {
            display: block;
        }

        /* ===== MAIN ===== */
        .main {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .topbar {
            padding: 12px 20px;
            border-bottom: 1px solid var(--border-subtle);
            background: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(8px);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .avatar-circle {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: radial-gradient(circle at top, #4f46e5, #1d2448);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .content {
            padding: 24px 40px 30px;
        }

        /* ===== FORM CARD ===== */
        .form-card {
            max-width: 900px;
            margin: 0 auto;
            background: radial-gradient(circle at top, #0b1120, #020617);
            border-radius: 20px;
            border: 1px solid var(--border-subtle);
            padding: 22px 24px 26px;
            box-shadow: 0 20px 45px rgba(0, 0, 0, 0.85);
        }

        .form-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
        }

        .form-title h4 {
            margin: 0;
            font-size: 1.15rem;
        }

        .badge-mode {
            font-size: 0.75rem;
            border-radius: 999px;
            padding: 4px 12px;
            background: rgba(99, 102, 241, 0.2);
            border: 1px solid rgba(129, 140, 248, 0.7);
            color: #c7d2fe;
        }

        .form-section-title {
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--text-muted);
            margin-bottom: 6px;
        }

        .form-label {
            font-size: 0.85rem;
            color: var(--text-muted);
        }

        .form-control, .form-select {
            background: #020617;
            border: 1px solid #1f2937;
            color: var(--text-main);
            font-size: 0.9rem;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 1px var(--primary);
            background: #020617;
            color: var(--text-main);
        }

        .btn-pill {
            border-radius: 999px;
            padding-inline: 16px;
        }

        @media (max-width: 992px) {
            .content {
                padding: 18px 16px 26px;
            }

            .form-card {
                padding: 18px 16px 24px;
            }
        }

        @media (max-width: 768px) {
            .sidebar { display: none; }
            .mobile-toggle { display: block; }
        }
    </style>
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
    <a href="${pageContext.request.contextPath}/admin/movies" class="side-link">
        <i class="bi bi-camera-reels"></i> Phim
    </a>
    <a href="${pageContext.request.contextPath}/admin/showtimes" class="side-link active">
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
        <a href="${pageContext.request.contextPath}/admin/movies" class="side-link">
            <i class="bi bi-camera-reels"></i> Phim
        </a>
        <a href="${pageContext.request.contextPath}/admin/showtimes" class="side-link active">
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
                        <c:choose>
                            <c:when test="${empty showtime}">Thêm suất chiếu</c:when>
                            <c:otherwise>Chỉnh sửa suất chiếu</c:otherwise>
                        </c:choose>
                    </div>
                    <div style="font-size:0.8rem;color:var(--text-muted);">
                        Chọn phim, phòng chiếu và thời gian chiếu chính xác.
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

            <div class="form-card">
                <div class="form-title">
                    <div>
                        <h4>
                            <c:choose>
                                <c:when test="${empty showtime}">Thêm suất chiếu</c:when>
                                <c:otherwise>Chỉnh sửa suất chiếu</c:otherwise>
                            </c:choose>
                        </h4>
                        <div style="font-size:0.82rem;color:var(--text-muted);">
                            Các trường có dấu <span class="text-danger">*</span> là bắt buộc.
                        </div>
                    </div>
                    <span class="badge-mode">
                        <c:choose>
                            <c:when test="${empty showtime}">
                                <i class="bi bi-plus-circle"></i> Tạo mới
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-pencil-square"></i> Chỉnh sửa
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <!-- Nếu có lỗi từ servlet (nếu sau này m validate) -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2">
                        ${error}
                    </div>
                </c:if>

                <!-- Chuẩn bị biến cho ngày giờ / active -->
                <c:choose>
                    <c:when test="${not empty showtime and not empty showtime.showDate}">
                        <c:set var="showDateVal" value="${showtime.showDate}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="showDateVal" value="" />
                    </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${empty showtime}">
                        <c:set var="activeVal" value="true"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="activeVal" value="${showtime.active}"/>
                    </c:otherwise>
                </c:choose>

                <!-- FORM -->
                <form method="post"
                      action="${pageContext.request.contextPath}/admin/showtimes">

                    <!-- hidden id nếu edit -->
                    <c:if test="${not empty showtime}">
                        <input type="hidden" name="id" value="${showtime.showtimeId}"/>
                    </c:if>

                    <div class="row g-3">
                        <!-- LEFT -->
                        <div class="col-lg-8">

                            <div class="form-section-title">Thông tin suất chiếu</div>

                            <!-- Chọn phim -->
                            <div class="mb-3">
                                <label class="form-label">Phim <span class="text-danger">*</span></label>
                                <select name="movieId" class="form-select" required>
                                    <option value="">-- Chọn phim --</option>
                                    <c:forEach var="m" items="${movies}">
                                        <option value="${m.movieId}"
                                                ${not empty showtime && showtime.movieId == m.movieId ? 'selected' : ''}>
                                            ${m.title}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Chọn phòng -->
                            <div class="mb-3">
                                <label class="form-label">Phòng chiếu <span class="text-danger">*</span></label>
                                <select name="roomId" class="form-select" required>
                                    <option value="">-- Chọn phòng --</option>
                                    <c:forEach var="r" items="${rooms}">
                                        <option value="${r.roomId}"
                                                ${not empty showtime && showtime.roomId == r.roomId ? 'selected' : ''}>
                                            ${r.roomName} ( ${r.totalRows} x ${r.totalCols} )
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Ngày + giờ tách riêng -->
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Ngày chiếu <span class="text-danger">*</span></label>
                                    <input type="date"
                                           name="showDate"
                                           class="form-control"
                                           required
                                           value="${showDateVal != '' ? fn:substring(showDateVal,0,10) : ''}">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Giờ chiếu <span class="text-danger">*</span></label>
                                    <input type="time"
                                           name="showTime"
                                           class="form-control"
                                           required
                                           value="${showDateVal != '' ? fn:substring(showDateVal,11,16) : ''}">
                                </div>
                            </div>

                            <!-- Giá vé -->
                            <div class="mt-3">
                                <label class="form-label">Giá vé cơ bản (VNĐ) <span class="text-danger">*</span></label>
                                <input type="number"
                                       name="basePrice"
                                       min="0"
                                       step="1000"
                                       class="form-control"
                                       required
                                       value="${empty showtime ? '75000' : showtime.basePrice}">
                            </div>

                            <!-- Active -->
                            <div class="mt-3 form-check">
                                <input class="form-check-input"
                                       type="checkbox"
                                       name="active"
                                       id="activeCheck"
                                       ${activeVal ? 'checked' : ''}>
                                <label class="form-check-label" for="activeCheck"
                                       style="font-size:0.9rem;">
                                    Suất chiếu đang hoạt động (cho phép đặt vé)
                                </label>
                            </div>

                        </div>

                        <!-- RIGHT: note nhỏ -->
                        <div class="col-lg-4">
                            <div class="form-section-title">Gợi ý</div>

                            <div style="font-size:0.85rem;color:var(--text-muted);line-height:1.5;">
                                • Hãy đảm bảo <strong>phim</strong> đã được tạo trong mục Quản lý phim trước.<br/>
                                • Nên tạo suất chiếu cách thời điểm hiện tại ít nhất
                                <strong>30 phút</strong> để khách đặt vé.<br/>
                                • Giá vé cơ bản có thể dùng làm giá mặc định, sau này cộng
                                thêm phụ phí ghế VIP, ghế đôi, suất cuối tuần,...
                            </div>

                            <hr style="border-color:#1f2937;margin:12px 0;"/>

                            <div style="font-size:0.8rem;color:var(--text-muted);">
                                Sau khi lưu, bạn có thể quay lại trang danh sách suất chiếu
                                để kiểm tra sơ đồ ghế và trạng thái đặt vé của từng suất.
                            </div>
                        </div>
                    </div>

                    <hr class="mt-4 mb-3" style="border-color:#1f2937;"/>

                    <div class="d-flex justify-content-between align-items-center">
                        <a href="${pageContext.request.contextPath}/admin/showtimes"
                           class="btn btn-outline-secondary btn-sm btn-pill">
                            <i class="bi bi-arrow-left"></i> Quay lại danh sách
                        </a>

                        <div class="d-flex gap-2">
                            <c:if test="${not empty showtime}">
                                <a href="${pageContext.request.contextPath}/admin/showtimes?action=delete&id=${showtime.showtimeId}"
                                   class="btn btn-outline-danger btn-sm btn-pill"
                                   onclick="return confirm('Xóa suất chiếu này khỏi hệ thống?');">
                                    <i class="bi bi-trash3"></i> Xóa
                                </a>
                            </c:if>

                            <button class="btn btn-primary btn-sm btn-pill" type="submit">
                                <c:choose>
                                    <c:when test="${empty showtime}">
                                        <i class="bi bi-plus-lg"></i> Thêm suất chiếu
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-save"></i> Cập nhật
                                    </c:otherwise>
                                </c:choose>
                            </button>
                        </div>
                    </div>

                </form>
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

