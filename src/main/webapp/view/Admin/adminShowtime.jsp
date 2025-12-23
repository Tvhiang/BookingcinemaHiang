<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<title>Quản lý suất chiếu - Cinema Admin</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
	rel="stylesheet" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />

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
	font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI",
		sans-serif;
}

.layout {
	display: flex;
	min-height: 100vh;
}

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

.side-link:hover, .side-link.active {
	background: rgba(99, 102, 241, 0.3);
	color: var(--text-main);
}

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

.page-header {
	display: flex;
	justify-content: space-between;
	gap: 12px;
	align-items: center;
	margin-bottom: 16px;
}

.page-title {
	font-size: 1.1rem;
	font-weight: 600;
}

.page-sub {
	font-size: 0.85rem;
	color: var(--text-muted);
}

.search-bar {
	margin-bottom: 16px;
	display: flex;
	gap: 8px;
	flex-wrap: wrap;
}

.search-bar input {
	background: #020617;
	border: 1px solid #1f2937;
	color: var(--text-main);
}

.search-bar input:focus {
	border-color: var(--primary);
	box-shadow: 0 0 0 1px var(--primary);
	background: #020617;
}

.showtime-grid {
	display: grid;
	grid-template-columns: repeat(4, minmax(0, 1fr));
	gap: 18px;
}

.showtime-card {
	position: relative;
	background: radial-gradient(circle at top, #0b1120, #020617);
	border-radius: 18px;
	padding: 12px 12px 14px;
	border: 1px solid var(--border-subtle);
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.8);
	transition: transform .18s ease, box-shadow .18s ease, border-color .18s
		ease;
}

.showtime-card:hover {
	transform: translateY(-4px);
	box-shadow: 0 20px 40px rgba(0, 0, 0, 0.95);
	border-color: rgba(129, 140, 248, 0.8);
}

.st-movie {
	font-size: 0.95rem;
	font-weight: 600;
	margin-bottom: 2px;
}

.st-room {
	font-size: 0.75rem;
	display: inline-flex;
	align-items: center;
	gap: 4px;
	padding: 2px 8px;
	border-radius: 999px;
	border: 1px solid rgba(148, 163, 184, 0.6);
	color: #e5e7eb;
	margin-bottom: 6px;
}

.st-datetime {
	font-size: 0.85rem;
	color: var(--text-main);
	margin-bottom: 4px;
}

.st-price {
	font-size: 0.82rem;
	color: #a5b4fc;
}

.st-status-pill {
	position: absolute;
	top: 10px;
	right: 10px;
	font-size: 0.7rem;
	padding: 2px 8px;
	border-radius: 999px;
}

.st-active {
	background: rgba(34, 197, 94, 0.25);
	color: #22c55e;
	border: 1px solid rgba(34, 197, 94, 0.6);
}

.st-inactive {
	background: rgba(148, 163, 184, 0.15);
	color: #cbd5f5;
	border: 1px solid rgba(148, 163, 184, 0.5);
}

.st-meta-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 6px;
}

.st-meta-left {
	font-size: 0.75rem;
	color: var(--text-muted);
}

.st-actions {
	margin-top: 10px;
	display: flex;
	gap: 6px;
	flex-wrap: wrap;
	justify-content: flex-end;
}

.btn-admin {
	border-radius: 999px;
	border: 1px solid rgba(148, 163, 184, 0.6);
	font-size: 0.78rem;
	padding: 3px 10px;
	background: rgba(15, 23, 42, 0.95);
	color: var(--text-main);
	text-decoration: none;
}

.btn-admin:hover {
	border-color: #a5b4fc;
	color: #e5e7eb;
}

.btn-danger-soft {
	border-color: rgba(248, 113, 113, 0.9);
	color: #fecaca;
}

.btn-danger-soft:hover {
	background: rgba(239, 68, 68, 0.3);
}

@media ( max-width : 1200px) {
	.showtime-grid {
		grid-template-columns: repeat(3, minmax(0, 1fr));
	}
}

@media ( max-width : 992px) {
	.content {
		padding: 20px 16px 26px;
	}
	.showtime-grid {
		grid-template-columns: repeat(2, minmax(0, 1fr));
	}
}

@media ( max-width : 768px) {
	.sidebar {
		display: none;
	}
	.mobile-toggle {
		display: block;
	}
	.showtime-grid {
		grid-template-columns: repeat(1, minmax(0, 1fr));
	}
}
</style>
</head>

<body>

	<!-- SIDEBAR MOBILE -->
	<div class="sidebar-mobile" id="sidebarMobile">
		<div class="sidebar-title">
			<i class="bi bi-film"></i> Cinema Admin
		</div>
		<a href="${pageContext.request.contextPath}/admin/home"
			class="side-link"><i class="bi bi-speedometer2"></i> Tổng quan</a> <a
			href="${pageContext.request.contextPath}/admin/movies"
			class="side-link"><i class="bi bi-camera-reels"></i> Phim</a> <a
			href="${pageContext.request.contextPath}/admin/showtimes"
			class="side-link active"><i class="bi bi-clock-history"></i> Suất
			chiếu</a> <a href="${pageContext.request.contextPath}/admin/snacks"
			class="side-link"><i class="bi bi-cup-straw"></i> Đồ ăn</a> <a
			href="${pageContext.request.contextPath}/admin/bookings"
			class="side-link"><i class="bi bi-receipt-cutoff"></i> Đơn đặt vé</a>
	</div>
	<div class="mobile-overlay" id="mobileOverlay"></div>

	<div class="layout">

		<!-- SIDEBAR PC -->
		<aside class="sidebar">
			<div class="sidebar-title">
				<i class="bi bi-film"></i><span>Cinema Admin</span>
			</div>
			<a href="${pageContext.request.contextPath}/admin/home"
				class="side-link"><i class="bi bi-speedometer2"></i> Tổng quan</a> <a
				href="${pageContext.request.contextPath}/admin/movies"
				class="side-link"><i class="bi bi-camera-reels"></i> Phim</a> <a
				href="${pageContext.request.contextPath}/admin/showtimes"
				class="side-link active"><i class="bi bi-clock-history"></i>
				Suất chiếu</a> <a href="${pageContext.request.contextPath}/admin/snacks"
				class="side-link"><i class="bi bi-cup-straw"></i> Đồ ăn</a> <a
				href="${pageContext.request.contextPath}/admin/bookings"
				class="side-link"><i class="bi bi-receipt-cutoff"></i> Đơn đặt
				vé</a>
		</aside>

		<!-- MAIN -->
		<div class="main">

			<!-- TOPBAR -->
			<header class="topbar">
				<div class="d-flex align-items-center gap-2">
					<i class="bi bi-list mobile-toggle" id="mobileToggle"></i>
					<div>
						<div class="page-title">Quản lý suất chiếu</div>
					</div>
				</div>

				<div class="d-flex align-items-center gap-2">
					<span style="font-size: 0.85rem; color: var(--text-muted);">
						Xin chào, <span style="color: #a5b4fc;"> <%=admin.getFullName() != null && !admin.getFullName().isEmpty() ? admin.getFullName() : admin.getUsername()%>
					</span>
					</span>
					<div class="avatar-circle"><%=Character.toUpperCase(admin.getUsername().charAt(0))%></div>
					<form action="${pageContext.request.contextPath}/admin/logout"
						method="get">
						<button class="btn btn-sm btn-outline-light">
							<i class="bi bi-box-arrow-right"></i>
						</button>
					</form>
				</div>
			</header>

			<!-- CONTENT -->
			<main class="content">

				<div class="page-header">
					<div>
						<div class="page-title">Danh sách suất chiếu</div>
						<div class="page-sub">Kiểm soát lịch chiếu theo phim, phòng
							và trạng thái.</div>
					</div>
					<a
						href="${pageContext.request.contextPath}/admin/showtimes?action=create"
						class="btn btn-sm btn-primary"> <i class="bi bi-plus-lg"></i>
						Thêm suất chiếu
					</a>
				</div>

				<!-- SEARCH -->
				<form class="search-bar" method="get"
					action="${pageContext.request.contextPath}/admin/showtimes">
					<div class="flex-grow-1">
						<input type="text" class="form-control" name="keyword"
							value="${keyword}"
							placeholder="Tìm theo tên phim hoặc phòng chiếu...">
					</div>
					<button class="btn btn-outline-light" type="submit">
						<i class="bi bi-search"></i> Tìm kiếm
					</button>
				</form>

				<!-- GRID SHOWTIMES -->
				<c:if test="${empty showtimes}">
					<p class="text-muted">Chưa có suất chiếu nào.</p>
				</c:if>

				<c:if test="${not empty showtimes}">
					<div class="showtime-grid">
						<c:forEach var="st" items="${showtimes}">
							<div class="showtime-card">

								<c:choose>
									<c:when test="${st.active}">
										<span class="st-status-pill st-active">Đang chiếu</span>
									</c:when>
									<c:otherwise>
										<span class="st-status-pill st-inactive">Ngừng chiếu</span>
									</c:otherwise>
								</c:choose>

								<div class="st-movie">
									<i class="bi bi-film"></i> <span> <c:out
											value="${movieNames[st.movieId]}" default="(Không rõ phim)" />
									</span>
								</div>

								<div class="st-room">
									<i class="bi bi-layout-sidebar"></i> <span>Phòng: <c:out
											value="${roomNames[st.roomId]}" default="(N/A)" /></span>
								</div>

								<div class="st-datetime">
									<i class="bi bi-calendar3"></i> <span> <fmt:formatDate
											value="${st.showDate}" pattern="dd/MM/yyyy HH:mm" />
									</span>
								</div>

								<div class="st-price">
									<i class="bi bi-ticket-perforated"></i> Giá vé từ: <strong><fmt:formatNumber
											value="${st.basePrice}" type="number" /></strong> đ
								</div>

								<div class="st-meta-row">
									<div class="st-meta-left">Mã suất: #${st.showtimeId}</div>
								</div>

								<div class="st-actions">
									<a
										href="${pageContext.request.contextPath}/admin/showtimes?action=edit&id=${st.showtimeId}"
										class="btn-admin"> <i class="bi bi-pencil-square"></i> Sửa
									</a> <a
										href="${pageContext.request.contextPath}/admin/showtimes?action=delete&id=${st.showtimeId}"
										class="btn-admin btn-danger-soft"
										onclick="return confirm('Xóa suất chiếu này?');"> <i
										class="bi bi-trash3"></i> Xóa
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
    const mobileToggle  = document.getElementById("mobileToggle");
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

