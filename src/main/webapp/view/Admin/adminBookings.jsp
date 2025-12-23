<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
    <meta charset="UTF-8">
    <title>Quản lý đơn đặt vé - Cinema Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

    <style>
        :root {
            --bg-main: #020617;
            --text-main: #e5e7eb;
            --text-muted: #94a3b8;
            --border-subtle: #1f2937;
            --primary: #6366f1;
        }
        body { margin:0; background:var(--bg-main); color:var(--text-main); font-family:system-ui,-apple-system,"Segoe UI",sans-serif; }
        .layout { display:flex; min-height:100vh; }

        /* Sidebar */
        .sidebar{ width:240px; padding:16px; background:var(--bg-main); border-right:1px solid var(--border-subtle); }
        .sidebar-title{ display:flex; align-items:center; gap:8px; font-weight:700; margin-bottom:16px; }
        .sidebar-title i{ color:var(--primary); }
        .side-link{ display:block; padding:8px 12px; border-radius:999px; margin-bottom:6px; color:var(--text-muted); text-decoration:none; }
        .side-link:hover,.side-link.active{ background:rgba(99,102,241,0.30); color:var(--text-main); }

        /* Mobile sidebar */
        .mobile-toggle{ display:none; font-size:1.7rem; cursor:pointer; }
        .sidebar-mobile{
            position:fixed; inset:0 auto 0 0; width:240px; background:#020617; border-right:1px solid var(--border-subtle);
            padding:16px; transform:translateX(-100%); transition:transform .25s; z-index:2000;
        }
        .sidebar-mobile.show{ transform:translateX(0); }
        .mobile-overlay{ position:fixed; inset:0; background:rgba(0,0,0,0.45); display:none; z-index:1500; }
        .mobile-overlay.show{ display:block; }

        /* Main */
        .main{ flex:1; display:flex; flex-direction:column; }
        .topbar{
            padding:12px 20px; border-bottom:1px solid var(--border-subtle);
            background:rgba(15,23,42,0.9); backdrop-filter:blur(8px);
            display:flex; justify-content:space-between; align-items:center; gap:12px;
        }
        .avatar-circle{
            width:32px; height:32px; border-radius:50%;
            background: radial-gradient(circle at top, #4f46e5, #1d2448);
            display:flex; align-items:center; justify-content:center; font-weight:700;
        }
        .content{ padding:22px 22px 28px; }

        /* Search */
        .search-bar{ display:flex; gap:8px; flex-wrap:wrap; margin-bottom:14px; }
        .form-control,.form-select{
            background:#020617; border:1px solid #1f2937; color:var(--text-main);
        }
        .form-control:focus,.form-select:focus{
            border-color:var(--primary); box-shadow:0 0 0 1px var(--primary);
            background:#020617; color:var(--text-main);
        }

        /* Grid */
        .booking-grid{
            display:grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
        }
        .bk-card{
            position:relative;
            background: radial-gradient(circle at top, #0b1120, #020617);
            border:1px solid var(--border-subtle);
            border-radius:18px;
            padding:12px 12px 14px;
            box-shadow:0 10px 25px rgba(0,0,0,0.8);
            transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease;
        }
        .bk-card:hover{
            transform: translateY(-4px);
            box-shadow:0 20px 40px rgba(0,0,0,0.95);
            border-color: rgba(129,140,248,0.8);
        }

        .bk-title{ font-size:0.95rem; font-weight:700; margin-bottom:4px; }
        .bk-sub{ font-size:0.82rem; color:var(--text-muted); margin-bottom:8px; }

        .bk-row{ display:flex; justify-content:space-between; gap:10px; font-size:0.85rem; margin-top:6px; }
        .bk-row span:first-child{ color:var(--text-muted); }

        .bk-badge{
            position:absolute; top:10px; right:10px;
            font-size:0.72rem; padding:2px 10px; border-radius:999px;
            border:1px solid rgba(148,163,184,0.4);
            background: rgba(148,163,184,0.12);
            color:#e5e7eb;
        }
        .bk-paid{ border-color: rgba(34,197,94,0.6); background: rgba(34,197,94,0.18); color:#22c55e; }
        .bk-pending{ border-color: rgba(59,130,246,0.6); background: rgba(59,130,246,0.18); color:#93c5fd; }
        .bk-cancel{ border-color: rgba(248,113,113,0.7); background: rgba(248,113,113,0.18); color:#fecaca; }

        .bk-actions{
            margin-top:10px;
            display:flex; flex-wrap:wrap; gap:6px;
            justify-content:flex-end;
        }
        .btn-admin{
            border-radius:999px;
            border:1px solid rgba(148,163,184,0.6);
            font-size:0.78rem;
            padding:3px 10px;
            background: rgba(15,23,42,0.95);
            color: var(--text-main);
            text-decoration:none;
        }
        .btn-admin:hover{ border-color:#a5b4fc; color:#e5e7eb; }
        .btn-danger-soft{ border-color: rgba(248,113,113,0.9); color:#fecaca; }
        .btn-danger-soft:hover{ background: rgba(239,68,68,0.30); }
        .btn-success-soft{ border-color: rgba(34,197,94,0.8); color:#bbf7d0; }
        .btn-success-soft:hover{ background: rgba(34,197,94,0.18); }
        .btn-info-soft{ border-color: rgba(59,130,246,0.8); color:#bfdbfe; }
        .btn-info-soft:hover{ background: rgba(59,130,246,0.18); }

        @media (max-width: 1200px){
            .booking-grid{ grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }
        @media (max-width: 768px){
            .sidebar{ display:none; }
            .mobile-toggle{ display:block; }
            .content{ padding:18px 14px 24px; }
            .booking-grid{ grid-template-columns: repeat(1, minmax(0, 1fr)); }
        }
    </style>
</head>

<body>

<!-- SIDEBAR MOBILE -->
<div class="sidebar-mobile" id="sidebarMobile">
    <div class="sidebar-title"><i class="bi bi-film"></i> Cinema Admin</div>

    <a href="${pageContext.request.contextPath}/admin/home" class="side-link">
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
    <a href="${pageContext.request.contextPath}/admin/bookings" class="side-link active">
        <i class="bi bi-receipt-cutoff"></i> Đơn đặt vé
    </a>
</div>
<div class="mobile-overlay" id="mobileOverlay"></div>

<div class="layout">

    <!-- SIDEBAR PC -->
    <aside class="sidebar">
        <div class="sidebar-title"><i class="bi bi-film"></i> <span>Cinema Admin</span></div>

        <a href="${pageContext.request.contextPath}/admin/home" class="side-link">
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
        <a href="${pageContext.request.contextPath}/admin/bookings" class="side-link active">
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
                    <div style="font-size:1.05rem;font-weight:700;">Quản lý đơn đặt vé</div>
                    <div style="font-size:0.85rem;color:var(--text-muted);">Xác nhận / huỷ đơn + lọc theo trạng thái</div>
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
                <div class="avatar-circle"><%= Character.toUpperCase(admin.getUsername().charAt(0)) %></div>
                <form action="${pageContext.request.contextPath}/admin/logout" method="get">
                    <button class="btn btn-sm btn-outline-light">
                        <i class="bi bi-box-arrow-right"></i>
                    </button>
                </form>
            </div>
        </header>

        <!-- CONTENT -->
        <main class="content">

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <!-- SEARCH + FILTER -->
            <form class="search-bar" method="get" action="${pageContext.request.contextPath}/admin/bookings">
                <input class="form-control" style="min-width:240px; flex:1;"
                       name="keyword" value="${keyword}"
                       placeholder="Tìm theo username / phim / phòng / mã đơn...">

                <select class="form-select" style="width:180px;" name="status">
                    <option value="ALL" ${status == 'ALL' ? 'selected' : ''}>Tất cả</option>
                    <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                    <option value="PAID" ${status == 'PAID' ? 'selected' : ''}>PAID</option>
                    <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                </select>

                <button class="btn btn-outline-light" type="submit">
                    <i class="bi bi-search"></i> Lọc
                </button>
            </form>

            <!-- GRID -->
            <c:if test="${empty bookings}">
                <p class="text-muted">Chưa có đơn đặt vé nào.</p>
            </c:if>

            <c:if test="${not empty bookings}">
                <div class="booking-grid">
                    <c:forEach var="b" items="${bookings}">
                        <div class="bk-card">

                            <!-- badge status -->
                            <c:choose>
                                <c:when test="${b.paymentStatus == 'PAID'}">
                                    <span class="bk-badge bk-paid">PAID</span>
                                </c:when>
                                <c:when test="${b.paymentStatus == 'PENDING'}">
                                    <span class="bk-badge bk-pending">PENDING</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="bk-badge bk-cancel">CANCELLED</span>
                                </c:otherwise>
                            </c:choose>

                            <div class="bk-title">
                                <i class="bi bi-receipt"></i>
                                Đơn #${b.bookingId}
                            </div>
                            <div class="bk-sub">
                                <i class="bi bi-person"></i>
                                User: <strong>${b.username}</strong>
                            </div>

                            <div class="bk-row">
                                <span>Phim</span>
                                <span style="text-align:right;">${b.movieTitle}</span>
                            </div>

                            <div class="bk-row">
                                <span>Phòng</span>
                                <span>${b.roomName}</span>
                            </div>

                            <div class="bk-row">
                                <span>Suất chiếu</span>
                                <span>
                                    <fmt:formatDate value="${b.showDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>

                            <div class="bk-row">
                                <span>Đặt lúc</span>
                                <span>
                                    <fmt:formatDate value="${b.bookingTime}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>

                            <div class="bk-row">
                                <span>Tổng tiền</span>
                                <span style="font-weight:700; color:#a5b4fc;">
                                    <fmt:formatNumber value="${b.totalAmount}" pattern="#,##0"/> đ
                                </span>
                            </div>

                            <div class="bk-actions">
                                <!-- Nếu đang PENDING thì cho xác nhận / huỷ -->
                                <c:if test="${b.paymentStatus == 'PENDING'}">
                                    <a class="btn-admin btn-success-soft"
                                       href="${pageContext.request.contextPath}/admin/bookings?action=pay&id=${b.bookingId}"
                                       onclick="return confirm('Xác nhận đơn này đã thanh toán?');">
                                        <i class="bi bi-check2-circle"></i> PAID
                                    </a>
                                    <a class="btn-admin btn-danger-soft"
                                       href="${pageContext.request.contextPath}/admin/bookings?action=cancel&id=${b.bookingId}"
                                       onclick="return confirm('Huỷ đơn này?');">
                                        <i class="bi bi-x-circle"></i> CANCEL
                                    </a>
                                </c:if>

                                <!-- Nếu đang PAID hoặc CANCELLED thì cho “đưa về PENDING” (tuỳ mày muốn) -->
                                <c:if test="${b.paymentStatus != 'PENDING'}">
                                    <a class="btn-admin btn-info-soft"
                                       href="${pageContext.request.contextPath}/admin/bookings?action=pending&id=${b.bookingId}"
                                       onclick="return confirm('Chuyển đơn về PENDING?');">
                                        <i class="bi bi-arrow-counterclockwise"></i> PENDING
                                    </a>
                                </c:if>
                            </div>

                        </div>
                    </c:forEach>
                </div>
            </c:if>

        </main>
    </div>
</div>

<script>
    // mobile sidebar
    const mobileToggle   = document.getElementById("mobileToggle");
    const sidebarMobile  = document.getElementById("sidebarMobile");
    const mobileOverlay  = document.getElementById("mobileOverlay");
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
