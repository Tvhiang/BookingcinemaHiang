<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    model.User admin = (model.User) session.getAttribute("adminUser");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Admin Dashboard - Cinema</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/view/Admin/assets/CSS/style_adminHome.css"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>

<body>

<!-- MOBILE SIDEBAR -->
<div class="sidebar-mobile" id="sidebarMobile">
    <h5 class="sidebar-title"><i class="bi bi-film"></i> Cinema Admin</h5>

    <a href="${pageContext.request.contextPath}/admin/home" class="side-link active">
        <i class="bi bi-speedometer2"></i> Tổng quan
    </a>
    <a href="${pageContext.request.contextPath}/admin/movies" class="side-link">
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
            <i class="bi bi-film"></i> Cinema Admin
        </div>

        <a href="${pageContext.request.contextPath}/admin/home" class="side-link active">
            <i class="bi bi-speedometer2"></i> Tổng quan
        </a>
        <a href="${pageContext.request.contextPath}/admin/movies" class="side-link">
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
        <header class="topbar">
            <i id="mobileToggle" class="bi bi-list mobile-toggle"></i>

            <div>
                <strong>Admin Dashboard</strong>
                <div style="font-size:0.8rem;color:var(--text-muted);">
                    Theo dõi phim, suất chiếu, đơn đặt vé & doanh thu
                </div>
            </div>

            <div class="d-flex align-items-center gap-2">
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

            <!-- METRICS -->
            <div class="row g-3">

                <div class="col-sm-6 col-lg-3">
                    <div class="metric-card">
                        <div class="metric-label">Phim đang chiếu</div>
                        <div class="metric-value">${showingMoviesCount}</div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="metric-card">
                        <div class="metric-label">Phim sắp chiếu</div>
                        <div class="metric-value">${comingSoonMoviesCount}</div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="metric-card">
                        <div class="metric-label">Đơn đặt vé hôm nay</div>
                        <div class="metric-value">${todayBookings}</div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="metric-card">
                        <div class="metric-label">Doanh thu hôm nay</div>
                        <div class="metric-value">${todayRevenue} đ</div>
                    </div>
                </div>

            </div>

            <!-- ========== SPOTLIGHT MOVIES ========== -->

            <section class="spot-panel">

                <div class="spot-header">
                    <div>
                        <h5>🔥 Phim nổi bật</h5>
                        <div class="spot-subtitle">Top phim có nhiều lượt đặt vé nhất</div>
                    </div>

                    <a href="${pageContext.request.contextPath}/admin/movies"
                       class="spot-subtitle">Quản lý danh sách phim</a>
                </div>

                <button class="spot-btn spot-btn-left" id="spotPrev">
                    <i class="bi bi-chevron-left"></i>
                </button>

                <button class="spot-btn spot-btn-right" id="spotNext">
                    <i class="bi bi-chevron-right"></i>
                </button>

                <div class="spot-stage" id="spotStage">

                    <c:if test="${not empty hotMovies}">
                        <c:forEach var="m" items="${hotMovies}" varStatus="st">
                            <div class="spot-item"
                                 data-title="${m.title}"
                                 data-sub="${bookingCountsByMovie[m.movieId]} lượt đặt"
                                 data-rank="#${st.index + 1}">
                                <img src="${empty m.posterUrl ? 'https://via.placeholder.com/350x500?text=No+Poster' : m.posterUrl}">
                            </div>
                        </c:forEach>
                    </c:if>

                    <c:if test="${empty hotMovies}">
                        <div class="spot-item spot-center"
                             data-title="Chưa có dữ liệu"
                             data-sub="0 lượt đặt"
                             data-rank="#1">
                            <img src="https://via.placeholder.com/350x500?text=No+Data">
                        </div>
                    </c:if>

                </div>

                <div class="text-center mt-3">
                    <span id="spotRank" class="badge bg-danger">#1</span>
                    <h5 id="spotTitle">—</h5>
                    <div id="spotSub" class="text-muted">—</div>
                </div>

            </section>

            <!-- LATEST BOOKINGS -->
            <h5 class="mt-4">🧾 Đơn đặt vé mới nhất</h5>

            <div class="booking-grid">

                <c:if test="${empty latestBookings}">
                    <p class="text-muted">Chưa có đơn đặt vé nào.</p>
                </c:if>

                <c:forEach var="b" items="${latestBookings}">
                    <div class="booking-card">
                        <div class="bk-label">Mã đơn</div>
                        <div class="bk-value">#${b.bookingId}</div>

                        <div class="bk-label mt-2">Khách hàng</div>
                        <div class="bk-value">${b.userId}</div>

                        <div class="bk-label mt-2">Suất chiếu</div>
                        <div class="bk-value">${b.showtimeId}</div>

                        <div class="bk-label mt-2">Thời gian</div>
                        <div class="bk-value">${b.bookingTime}</div>

                        <div class="bk-label mt-2">Tổng tiền</div>
                        <div class="bk-value">${b.totalAmount} đ</div>

                        <c:choose>
                            <c:when test="${b.paymentStatus == 'PAID'}">
                                <span class="bk-status bk-paid">PAID</span>
                            </c:when>
                            <c:when test="${b.paymentStatus == 'PENDING'}">
                                <span class="bk-status bk-pending">PENDING</span>
                            </c:when>
                            <c:otherwise>
                                <span class="bk-status bk-cancelled">CANCELLED</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>

            </div>

        </main>
    </div>
</div>

<!-- MOBILE SIDEBAR JS -->
<script>
const mToggle = document.getElementById("mobileToggle");
const mSidebar = document.getElementById("sidebarMobile");
const mOverlay = document.getElementById("mobileOverlay");

mToggle.onclick = () => {
    mSidebar.classList.add("show");
    mOverlay.classList.add("show");
};
mOverlay.onclick = () => {
    mSidebar.classList.remove("show");
    mOverlay.classList.remove("show");
};
</script>

<!-- SPOTLIGHT JS -->
<script>
(function () {
    const items = Array.from(document.querySelectorAll(".spot-item"));
    if (!items.length) return;

    const rankEl = document.getElementById("spotRank");
    const titleEl = document.getElementById("spotTitle");
    const subEl = document.getElementById("spotSub");

    let index = 0;

    const apply = () => {
        const n = items.length;
        const left = (index - 1 + n) % n;
        const right = (index + 1) % n;

        items.forEach((item, i) => {
            item.className = "spot-item";
            if (i === index) item.classList.add("spot-center");
            else if (i === left) item.classList.add("spot-left-pos");
            else if (i === right) item.classList.add("spot-right-pos");
            else item.classList.add("spot-hidden");
        });

        rankEl.textContent = items[index].dataset.rank;
        titleEl.textContent = items[index].dataset.title;
        subEl.textContent = items[index].dataset.sub;
    };

    document.getElementById("spotNext").onclick = () => {
        index = (index + 1) % items.length;
        apply();
    };

    document.getElementById("spotPrev").onclick = () => {
        index = (index - 1 + items.length) % items.length;
        apply();
    };

    apply();
})();
</script>

</body>
</html>

