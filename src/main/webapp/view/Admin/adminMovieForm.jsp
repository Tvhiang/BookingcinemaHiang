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
    <title>
        <c:choose>
            <c:when test="${empty movie}">Thêm phim mới</c:when>
            <c:otherwise>Chỉnh sửa phim</c:otherwise>
        </c:choose>
        - Cinema Admin
    </title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet"/>
          <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/view/Admin/assets/CSS/style_adminMovieForm.css" />

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
                        <c:choose>
                            <c:when test="${empty movie}">Thêm phim mới</c:when>
                            <c:otherwise>Chỉnh sửa phim</c:otherwise>
                        </c:choose>
                    </div>
                    <div style="font-size:0.8rem;color:var(--text-muted);">
                        Nhập đầy đủ thông tin phim để hiển thị trên trang khách hàng.
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
                                <c:when test="${empty movie}">Thêm phim mới</c:when>
                                <c:otherwise>Chỉnh sửa phim</c:otherwise>
                            </c:choose>
                        </h4>
                        <div style="font-size:0.82rem;color:var(--text-muted);">
                            Các trường có dấu <span class="text-danger">*</span> là bắt buộc.
                        </div>
                    </div>
                    <span class="badge-mode">
                        <c:choose>
                            <c:when test="${empty movie}">
                                <i class="bi bi-plus-circle"></i> Tạo mới
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-pencil-square"></i> Chỉnh sửa
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <!-- Hiển thị lỗi nếu servlet gửi về -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2">
                        ${error}
                    </div>
                </c:if>

                <!-- Chuẩn bị biến cho select -->
                <c:set var="ageRatingVal" value="${empty movie ? '' : movie.ageRating}" />
                <c:choose>
                    <c:when test="${empty movie || empty movie.status}">
                        <c:set var="statusVal" value="SHOWING" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="statusVal" value="${movie.status}" />
                    </c:otherwise>
                </c:choose>

                <!-- FORM -->
                <form method="post"
                      action="${pageContext.request.contextPath}/admin/movies">

                    <!-- hidden id nếu edit -->
                    <c:if test="${not empty movie}">
                        <input type="hidden" name="movieId" value="${movie.movieId}"/>
                    </c:if>

                    <div class="row g-3">
                        <!-- LEFT: fields -->
                        <div class="col-lg-8">

                            <div class="form-section-title">Thông tin cơ bản</div>

                            <div class="mb-3">
                                <label class="form-label">Tên phim <span class="text-danger">*</span></label>
                                <input type="text" name="title" class="form-control" required
                                       value="${empty movie ? '' : movie.title}">
                            </div>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Thể loại</label>
                                    <input type="text" name="genre" class="form-control"
                                           placeholder="Hành động, Tâm lý..."
                                           value="${empty movie ? '' : movie.genre}">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Thời lượng (phút)</label>
                                    <input type="number" name="duration" min="1" class="form-control"
                                           value="${empty movie ? '' : movie.duration}">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Độ tuổi</label>
                                    <select name="ageRating" class="form-select">
                                        <option value="">-- Chọn --</option>
                                        <option value="K"   ${ageRatingVal == 'K'   ? 'selected' : ''}>K</option>
                                        <option value="T13" ${ageRatingVal == 'T13' ? 'selected' : ''}>T13</option>
                                        <option value="T16" ${ageRatingVal == 'T16' ? 'selected' : ''}>T16</option>
                                        <option value="T18" ${ageRatingVal == 'T18' ? 'selected' : ''}>T18</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row g-3 mt-1">
                                <div class="col-md-6">
                                    <label class="form-label">Đạo diễn</label>
                                    <input type="text" name="director" class="form-control"
                                           value="${empty movie ? '' : movie.director}">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Ngày khởi chiếu</label>
                                    <input type="date" name="releaseDate" class="form-control"
                                           value="${empty movie ? '' : movie.releaseDate}">
                                </div>
                            </div>

                            <div class="mt-3">
                                <label class="form-label">Dàn diễn viên</label>
                                <textarea name="cast" class="form-control" rows="2"
                                          placeholder="Nhập danh sách diễn viên, ngăn cách bởi dấu phẩy">${empty movie ? '' : movie.cast}</textarea>
                            </div>

                            <div class="mt-3">
                                <label class="form-label">Mô tả</label>
                                <textarea name="description" class="form-control" rows="4"
                                          placeholder="Tóm tắt nội dung phim, điểm nhấn, bối cảnh...">${empty movie ? '' : movie.description}</textarea>
                            </div>

                            <div class="mt-3">
                                <label class="form-label">Trạng thái</label>
                                <select name="status" class="form-select">
                                    <option value="COMING_SOON" ${statusVal == 'COMING_SOON' ? 'selected' : ''}>COMING_SOON</option>
                                    <option value="SHOWING"     ${statusVal == 'SHOWING'     ? 'selected' : ''}>SHOWING</option>
                                    <option value="ENDED"       ${statusVal == 'ENDED'       ? 'selected' : ''}>ENDED</option>
                                </select>
                            </div>

                        </div>

                        <!-- RIGHT: poster preview -->
                        <div class="col-lg-4">
                            <div class="form-section-title">Poster</div>

                            <div class="mb-2">
                                <label class="form-label">Đường dẫn poster (URL) <span class="text-danger">*</span></label>
                                <input type="text" name="posterUrl" id="posterUrlInput"
                                       class="form-control" required
                                       placeholder="https://..."
                                       value="${empty movie ? '' : movie.posterUrl}">
                            </div>

                            <div class="poster-preview mt-2" id="posterPreview">
                                <c:choose>
                                    <c:when test="${not empty movie && not empty movie.posterUrl}">
                                        <img src="${movie.posterUrl}" alt="Poster">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="poster-placeholder">
                                            Dán URL poster vào để xem preview
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div style="font-size:0.75rem;color:var(--text-muted);margin-top:6px;">
                                Gợi ý: dùng ảnh tỉ lệ 2:3 (ví dụ: 600x900) để hiển thị đẹp.
                            </div>
                        </div>
                    </div>

                    <hr class="mt-4 mb-3" style="border-color:#1f2937;"/>

                    <div class="d-flex justify-content-between align-items-center">
                        <a href="${pageContext.request.contextPath}/admin/movies"
                           class="btn btn-outline-secondary btn-sm btn-pill">
                            <i class="bi bi-arrow-left"></i> Quay lại danh sách
                        </a>

                        <div class="d-flex gap-2">
                            <c:if test="${not empty movie}">
                                <a href="${pageContext.request.contextPath}/admin/movies?action=delete&id=${movie.movieId}"
                                   class="btn btn-outline-danger btn-sm btn-pill"
                                   onclick="return confirm('Xóa phim này khỏi hệ thống?');">
                                    <i class="bi bi-trash3"></i> Xóa
                                </a>
                            </c:if>

                            <button class="btn btn-primary btn-sm btn-pill" type="submit">
                                <c:choose>
                                    <c:when test="${empty movie}">
                                        <i class="bi bi-plus-lg"></i> Thêm phim
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

<!-- JS SIDEBAR MOBILE + poster preview -->
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

    // Live preview poster
    const posterInput = document.getElementById("posterUrlInput");
    const posterPreview = document.getElementById("posterPreview");

    if (posterInput && posterPreview) {
        posterInput.addEventListener("input", () => {
            const url = posterInput.value.trim();
            if (!url) {
                posterPreview.innerHTML =
                    '<div class="poster-placeholder">Dán URL poster vào để xem preview</div>';
                return;
            }
            posterPreview.innerHTML = '<img src="' + url + '" alt="Poster">';
        });
    }
</script>

</body>
</html>
