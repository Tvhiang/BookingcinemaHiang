<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
    <title>Quản lý đồ ăn - Cinema Admin</title>

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

        body {
            margin: 0;
            background: var(--bg-main);
            color: var(--text-main);
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        }

        .layout { display:flex; min-height:100vh; }

        /* ===== SIDEBAR PC ===== */
        .sidebar {
            width: 240px;
            padding: 16px;
            background: var(--bg-main);
            border-right: 1px solid var(--border-subtle);
        }

        .sidebar-title {
            display:flex; align-items:center; gap:8px;
            font-weight: 700;
            margin-bottom: 16px;
        }
        .sidebar-title i { color: var(--primary); }

        .side-link {
            display:block;
            padding: 8px 12px;
            border-radius: 999px;
            margin-bottom: 6px;
            color: var(--text-muted);
            text-decoration:none;
            font-size: 0.92rem;
        }
        .side-link:hover, .side-link.active {
            background: rgba(99,102,241,0.30);
            color: var(--text-main);
        }

        /* ===== SIDEBAR MOBILE ===== */
        .mobile-toggle { display:none; font-size:1.7rem; cursor:pointer; }

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
        .sidebar-mobile.show { transform: translateX(0); }

        .mobile-overlay {
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.45);
            display:none;
            z-index: 1500;
        }
        .mobile-overlay.show { display:block; }

        /* ===== MAIN ===== */
        .main { flex:1; display:flex; flex-direction:column; }

        .topbar {
            padding: 12px 20px;
            border-bottom: 1px solid var(--border-subtle);
            background: rgba(15,23,42,0.9);
            backdrop-filter: blur(8px);
            display:flex;
            justify-content: space-between;
            align-items:center;
            gap: 12px;
        }

        .avatar-circle {
            width: 32px; height: 32px;
            border-radius: 50%;
            background: radial-gradient(circle at top, #4f46e5, #1d2448);
            display:flex; align-items:center; justify-content:center;
            font-size: .9rem; font-weight: 700;
        }

        .content { padding: 22px 22px 28px; }

        .page-title { font-size: 1.15rem; font-weight: 700; }
        .page-sub { font-size: 0.9rem; color: var(--text-muted); }

        /* ===== FILTER BAR ===== */
        .form-control, .form-select {
            background: #020617;
            border: 1px solid #1f2937;
            color: var(--text-main);
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 1px var(--primary);
            background: #020617;
            color: var(--text-main);
        }

        /* ===== GRID SNACKS ===== */
        .snack-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px;
            margin-top: 14px;
        }

        .snack-card {
            background: radial-gradient(circle at top, #0b1120, #020617);
            border-radius: 18px;
            padding: 12px;
            border: 1px solid var(--border-subtle);
            box-shadow: 0 10px 25px rgba(0,0,0,0.8);
            transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease;
        }
        .snack-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 38px rgba(0,0,0,0.95);
            border-color: rgba(129,140,248,0.8);
        }

        .snack-thumb {
            width: 100%;
            aspect-ratio: 16/10;
            object-fit: cover;
            border-radius: 14px;
            border: 1px solid rgba(148,163,184,0.25);
            background: #0b1120;
        }

        .snack-name { font-size: 0.98rem; font-weight: 700; margin-top: 10px; }
        .snack-meta { font-size: 0.85rem; color: var(--text-muted); display:flex; gap:10px; flex-wrap:wrap; }
        .snack-price { margin-top: 6px; font-weight: 800; color: #a5b4fc; }
        .snack-id { margin-top: 4px; font-size: .82rem; color: var(--text-muted); }

        .pill {
            display:inline-flex; align-items:center; gap:6px;
            font-size: .75rem;
            padding: 3px 10px;
            border-radius: 999px;
            border: 1px solid rgba(148,163,184,0.55);
            color: var(--text-main);
            background: rgba(15,23,42,0.85);
        }

        .actions {
            margin-top: 10px;
            display:flex;
            justify-content:flex-end;
            gap: 8px;
            flex-wrap:wrap;
        }
        .btn-admin {
            border-radius: 999px;
            border: 1px solid rgba(148,163,184,0.6);
            font-size: 0.78rem;
            padding: 4px 10px;
            background: rgba(15,23,42,0.95);
            color: var(--text-main);
            text-decoration:none;
        }
        .btn-admin:hover { border-color:#a5b4fc; color: var(--text-main); }

        .btn-danger-soft {
            border-color: rgba(248,113,113,0.9);
            color: #fecaca;
        }
        .btn-danger-soft:hover { background: rgba(239,68,68,0.3); }

        /* RESPONSIVE */
        @media (max-width: 1200px) { .snack-grid { grid-template-columns: repeat(3, 1fr); } }
        @media (max-width: 992px)  { .snack-grid { grid-template-columns: repeat(2, 1fr); } .content{padding:18px 14px 24px;} }
        @media (max-width: 768px)  {
            .sidebar { display:none; }
            .mobile-toggle { display:block; }
            .snack-grid { grid-template-columns: repeat(1, 1fr); }
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
    <a href="${pageContext.request.contextPath}/admin/showtimes" class="side-link">
        <i class="bi bi-clock-history"></i> Suất chiếu
    </a>
    <a href="${pageContext.request.contextPath}/admin/snacks" class="side-link active">
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
            <i class="bi bi-film"></i> <span>Cinema Admin</span>
        </div>

        <a href="${pageContext.request.contextPath}/admin/home" class="side-link">
            <i class="bi bi-speedometer2"></i> Tổng quan
        </a>
        <a href="${pageContext.request.contextPath}/admin/movies" class="side-link">
            <i class="bi bi-camera-reels"></i> Phim
        </a>
        <a href="${pageContext.request.contextPath}/admin/showtimes" class="side-link">
            <i class="bi bi-clock-history"></i> Suất chiếu
        </a>
        <a href="${pageContext.request.contextPath}/admin/snacks" class="side-link active">
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
                    <div class="page-title">Quản lý đồ ăn</div>
                    <div class="page-sub">Snack / nước / combo</div>
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

            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div>
                    <div class="page-title">Danh sách đồ ăn & uống</div>
                    <div class="page-sub">Tìm kiếm theo tên / lọc theo loại</div>
                </div>
                <a href="${pageContext.request.contextPath}/admin/snacks?action=create"
                   class="btn btn-sm btn-primary">
                    <i class="bi bi-plus-lg"></i> Thêm đồ ăn
                </a>
            </div>

            <!-- FILTER -->
            <form class="row g-2 mt-3"
                  method="get"
                  action="${pageContext.request.contextPath}/admin/snacks">
                <div class="col-12 col-md-6">
                    <input type="text"
                           class="form-control"
                           name="keyword"
                           value="${keyword}"
                           placeholder="Tìm theo tên đồ ăn...">
                </div>
                <div class="col-8 col-md-3">
                    <select class="form-select" name="category">
                        <option value="">Tất cả loại</option>
                        <option value="POP_CORN" ${category == 'POP_CORN' ? 'selected' : ''}>POP_CORN</option>
                        <option value="DRINK" ${category == 'DRINK' ? 'selected' : ''}>DRINK</option>
                        <option value="COMBO" ${category == 'COMBO' ? 'selected' : ''}>COMBO</option>
                        <option value="OTHER" ${category == 'OTHER' ? 'selected' : ''}>OTHER</option>
                    </select>
                </div>
                <div class="col-4 col-md-3 d-grid">
                    <button class="btn btn-outline-light" type="submit">
                        <i class="bi bi-search"></i> Tìm
                    </button>
                </div>
            </form>

            <!-- GRID -->
            <c:if test="${empty snacks}">
                <p class="text-secondary mt-4">Chưa có đồ ăn nào.</p>
            </c:if>

            <c:if test="${not empty snacks}">
                <div class="snack-grid">
                    <c:forEach var="s" items="${snacks}">
                        <div class="snack-card">

                            <img class="snack-thumb"
                                 src="${empty s.imageUrl ? 'https://via.placeholder.com/800x500?text=No+Image' : s.imageUrl}"
                                 alt="${s.snackName}"/>

                            <div class="snack-name">${s.snackName}</div>

                            <div class="snack-meta mt-1">
                                <span class="pill"><i class="bi bi-tag"></i> ${s.category}</span>
                                <span class="pill"><i class="bi bi-percent"></i> giảm: ${s.discount}</span>
                            </div>

                            <div class="snack-price">
                                <i class="bi bi-cash-coin"></i> ${s.price} đ
                            </div>

                            <div class="snack-id">Mã: #${s.snackId}</div>

                            <div class="actions">
                                <a class="btn-admin"
                                   href="${pageContext.request.contextPath}/admin/snacks?action=edit&id=${s.snackId}">
                                    <i class="bi bi-pencil-square"></i> Sửa
                                </a>
                                <a class="btn-admin btn-danger-soft"
                                   href="${pageContext.request.contextPath}/admin/snacks?action=delete&id=${s.snackId}"
                                   onclick="return confirm('Xóa đồ ăn này?');">
                                    <i class="bi bi-trash3"></i> Xóa
                                </a>
                            </div>

                        </div>
                    </c:forEach>
                </div>
            </c:if>

        </main>
    </div>
</div>

<script>
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
