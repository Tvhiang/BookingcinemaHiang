<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Phim - CinemaDB</title>
<jsp:include page="/view/KhachHang/Base/head.jsp" />
<!-- Bootstrap -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
	rel="stylesheet" />

<style>
:root {
	--bg: #0f0a0d;
	--stroke: rgba(255, 255, 255, .08);
	--muted: rgba(255, 255, 255, .65);
	--muted2: rgba(255, 255, 255, .45);
	--primary: #ec1380;
	--primary2: #ff4d6d;
	--shadow: 0 18px 60px rgba(0, 0, 0, .55);
}

body {
	background: radial-gradient(circle at 30% 10%, rgba(236, 19, 128, .14),
		transparent 55%),
		radial-gradient(circle at 70% 30%, rgba(255, 77, 109, .08),
		transparent 55%), linear-gradient(180deg, rgba(0, 0, 0, .0),
		rgba(0, 0, 0, .25)), var(--bg);
	color: #fff;
	min-height: 100vh;
}

.glass {
	background: rgba(26, 18, 22, .72);
	backdrop-filter: blur(16px);
	-webkit-backdrop-filter: blur(16px);
	border: 1px solid var(--stroke);
	border-radius: 22px;
	box-shadow: var(--shadow);
}

.glass-soft {
	background: rgba(255, 255, 255, .04);
	border: 1px solid rgba(255, 255, 255, .08);
	border-radius: 16px;
}

.text-mutedx {
	color: var(--muted);
}

.text-mutedx2 {
	color: var(--muted2);
}

.font-display {
	font-weight: 900;
	letter-spacing: -0.02em;
}

.btn-primaryx {
	background: linear-gradient(135deg, var(--primary) 0%, var(--primary2)
		100%);
	border: none;
	color: #fff;
	font-weight: 900;
	border-radius: 14px;
	box-shadow: 0 10px 30px rgba(236, 19, 128, .22);
}

.btn-primaryx:hover {
	filter: brightness(1.03);
	box-shadow: 0 12px 34px rgba(236, 19, 128, .30);
}

.badge-pink {
	background: rgba(236, 19, 128, .16);
	color: #ffb3d2;
	border: 1px solid rgba(236, 19, 128, .35);
	border-radius: 999px;
	padding: .35rem .65rem;
	font-weight: 800;
}

/* movie card */
.movie-card {
	height: 100%;
	border-radius: 18px;
	overflow: hidden;
	border: 1px solid rgba(255, 255, 255, .08);
	background: rgba(255, 255, 255, .03);
	transition: transform .14s ease, border-color .14s ease, box-shadow .14s
		ease;
}

.movie-card:hover {
	transform: translateY(-3px);
	border-color: rgba(236, 19, 128, .22);
	box-shadow: 0 18px 60px rgba(0, 0, 0, .45);
}

.poster {
	width: 100%;
	aspect-ratio: 2/3;
	object-fit: cover;
	display: block;
	background: rgba(255, 255, 255, .05);
}

.movie-title {
	font-weight: 900;
	line-height: 1.15;
	margin: 0;
	font-size: 1.02rem;
}

.pill {
	border-radius: 999px;
	padding: .25rem .6rem;
	font-size: .75rem;
	font-weight: 800;
	border: 1px solid rgba(255, 255, 255, .12);
	color: rgba(255, 255, 255, .80);
	background: rgba(255, 255, 255, .04);
}

.pill-pink {
	border-color: rgba(236, 19, 128, .35);
	background: rgba(236, 19, 128, .12);
	color: #ffb3d2;
}
/* pagination theme */
.pagination .page-link {
	background: rgba(255, 255, 255, .04);
	border: 1px solid rgba(255, 255, 255, .10);
	color: rgba(255, 255, 255, .85);
	border-radius: 12px;
	margin: 0 4px;
}

.pagination .page-link:hover {
	border-color: rgba(236, 19, 128, .25);
	color: #fff;
}

.pagination .page-item.active .page-link {
	background: rgba(236, 19, 128, .18);
	border-color: rgba(236, 19, 128, .55);
	color: #fff;
	font-weight: 900;
}

.pagination .page-item.disabled .page-link {
	color: rgba(255, 255, 255, .35);
	background: rgba(255, 255, 255, .03);
}

.form-control, .form-select {
	background: rgba(255, 255, 255, .04);
	border: 1px solid rgba(255, 255, 255, .10);
	color: #fff;
	border-radius: 14px;
}

.form-control::placeholder {
	color: rgba(255, 255, 255, .45);
}

.form-control:focus, .form-select:focus {
	background: rgba(255, 255, 255, .05);
	border-color: rgba(236, 19, 128, .35);
	box-shadow: 0 0 0 .2rem rgba(236, 19, 128, .12);
	color: #fff;
}

.form-select option {
	color: #000;
}
</style>
</head>

<body>
<jsp:include page="/view/KhachHang/Base/header.jsp"/>
	<div class="container py-4 py-md-5">
		<div class="glass p-4 p-md-5 mb-4">
			<div
				class="d-flex justify-content-between align-items-start flex-wrap gap-3">
				<div>
					<span class="badge-pink"><i class="bi bi-film me-1"></i>
						Movies</span>
					<h2 class="font-display mt-2 mb-1">Tất cả phim</h2>
					<div class="text-mutedx small">
						<c:choose>
							<c:when test="${total != null}">Tổng: <b>${total}</b> phim</c:when>
							<c:otherwise>Danh sách phim</c:otherwise>
						</c:choose>
					</div>
				</div>

				<!-- Search + Filter -->
				<form class="d-flex gap-2 flex-wrap" method="get"
					action="${pageContext.request.contextPath}/movies"
					style="max-width: 540px;">
					<input class="form-control" type="text" name="q" value="${q}"
						placeholder="Tìm theo tên phim..." /> <select class="form-select"
						name="status" style="min-width: 180px;">
						<option value="" ${empty status ? "selected" : ""}>Tất cả
							trạng thái</option>
						<option value="SHOWING" ${status == 'SHOWING' ? "selected" : ""}>Đang
							chiếu</option>
						<option value="COMING_SOON"
							${status == 'COMING_SOON' ? "selected" : ""}>Sắp chiếu</option>
						<option value="ENDED" ${status == 'ENDED' ? "selected" : ""}>Kết
							thúc</option>
					</select>

					<button class="btn btn-primaryx px-3" type="submit">
						<i class="bi bi-search me-1"></i> Lọc
					</button>
				</form>
			</div>
		</div>

		<!-- Grid -->
		<div class="row g-3 g-md-4">
			<c:choose>
				<c:when test="${empty items}">
					<div class="col-12">
						<div class="glass p-4 text-center">
							<div class="text-mutedx">Không có phim phù hợp.</div>
							<a class="btn btn-primaryx mt-3 px-4"
								href="${pageContext.request.contextPath}/movies"> Xem tất cả
							</a>
						</div>
					</div>
				</c:when>

				<c:otherwise>
					<c:forEach var="m" items="${items}">
						<div class="col-6 col-md-4 col-xl-3">
							<div class="movie-card">
								<a
									href="${pageContext.request.contextPath}/movie-detail?id=${m.movieId}"
									style="text-decoration: none; color: inherit;"> <img
									class="poster" src="<c:out value='${m.posterUrl}'/>"
									onerror="this.src='https://via.placeholder.com/600x900?text=No+Poster';"
									alt="<c:out value='${m.title}'/>" />
									<div class="p-3">
										<div class="d-flex align-items-center gap-2 flex-wrap mb-2">
											<span class="pill pill-pink"> <c:out
													value="${m.status}" />
											</span>
											<c:if test="${not empty m.genre}">
												<span class="pill"><c:out value="${m.genre}" /></span>
											</c:if>
											<c:if test="${not empty m.ageRating}">
												<span class="pill"><c:out value="${m.ageRating}" /></span>
											</c:if>
										</div>

										<p class="movie-title mb-1">
											<c:out value="${m.title}" />
										</p>

										<div class="text-mutedx2 small d-flex justify-content-between">
											<span> <c:choose>
													<c:when test="${m.duration != null}">
														<i class="bi bi-clock me-1"></i>${m.duration} phút
                        </c:when>
													<c:otherwise>&nbsp;</c:otherwise>
												</c:choose>
											</span> <span> <c:if test="${m.releaseDate != null}">
													<fmt:formatDate value="${m.releaseDate}"
														pattern="yyyy-MM-dd" />
												</c:if>
											</span>
										</div>

										<div class="mt-3 d-flex gap-2">
											<span class="btn btn-primaryx w-100"> <i
												class="bi bi-ticket-perforated me-1"></i> Xem chi tiết
											</span>
										</div>
									</div>
								</a>
							</div>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</div>

		<!-- Pagination -->
		<c:if test="${totalPages != null && totalPages > 1}">
			<div class="d-flex justify-content-center mt-4 mt-md-5">
				<nav aria-label="pagination">
					<ul class="pagination mb-0">

						<c:set var="prev" value="${page - 1}" />
						<c:set var="next" value="${page + 1}" />

						<!-- Prev -->
						<li class="page-item ${page <= 1 ? 'disabled' : ''}"><a
							class="page-link"
							href="${pageContext.request.contextPath}/movies?page=${prev}&status=${status}&q=${q}">
								<i class="bi bi-chevron-left"></i>
						</a></li>

						<%-- window pages (hiển thị gọn) --%>
						<c:set var="start" value="${page - 2}" />
						<c:set var="end" value="${page + 2}" />
						<c:if test="${start < 1}">
							<c:set var="start" value="1" />
						</c:if>
						<c:if test="${end > totalPages}">
							<c:set var="end" value="${totalPages}" />
						</c:if>

						<!-- First + dots -->
						<c:if test="${start > 1}">
							<li class="page-item"><a class="page-link"
								href="${pageContext.request.contextPath}/movies?page=1&status=${status}&q=${q}">1</a>
							</li>
							<c:if test="${start > 2}">
								<li class="page-item disabled"><span class="page-link">…</span></li>
							</c:if>
						</c:if>

						<!-- Middle pages -->
						<c:forEach var="p" begin="${start}" end="${end}">
							<li class="page-item ${p == page ? 'active' : ''}"><a
								class="page-link"
								href="${pageContext.request.contextPath}/movies?page=${p}&status=${status}&q=${q}">
									${p} </a></li>
						</c:forEach>

						<!-- Dots + last -->
						<c:if test="${end < totalPages}">
							<c:if test="${end < totalPages - 1}">
								<li class="page-item disabled"><span class="page-link">…</span></li>
							</c:if>
							<li class="page-item"><a class="page-link"
								href="${pageContext.request.contextPath}/movies?page=${totalPages}&status=${status}&q=${q}">
									${totalPages} </a></li>
						</c:if>

						<!-- Next -->
						<li class="page-item ${page >= totalPages ? 'disabled' : ''}">
							<a class="page-link"
							href="${pageContext.request.contextPath}/movies?page=${next}&status=${status}&q=${q}">
								<i class="bi bi-chevron-right"></i>
						</a>
						</li>

					</ul>
				</nav>
			</div>
		</c:if>

	</div>
<jsp:include page="/view/KhachHang/Base/footer.jsp"/>
</body>
</html>
