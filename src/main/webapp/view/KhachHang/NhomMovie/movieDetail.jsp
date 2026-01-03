<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>${movie.title}- CinemaDB</title>
<jsp:include page="/view/KhachHang/Base/head.jsp" />
<style>
.poster-wrap {
	border-radius: 20px;
	overflow: hidden;
	border: 1px solid rgba(255, 255, 255, .10);
}

.poster-img {
	width: 100%;
	aspect-ratio: 2/3;
	object-fit: cover;
}

.sticky-col {
	position: sticky;
	top: 92px;
}

.time-btn {
	border-radius: 14px;
	background: rgba(255, 255, 255, .04);
	border: 1px solid rgba(255, 255, 255, .10);
	padding: .65rem .5rem;
	width: 100%;
	text-align: center;
	transition: all .15s ease;
}

.time-btn:hover {
	transform: translateY(-2px);
	border-color: rgba(236, 19, 128, .25);
}

.time {
	font-weight: 900;
}

.price {
	color: rgba(255, 255, 255, .75);
	font-size: .78rem;
}
</style>
</head>
<body>
	<jsp:include page="/view/KhachHang/Base/header.jsp" />

	<main class="container py-4 py-md-5">
		<div class="row g-4 g-lg-5">
			<!-- LEFT -->
			<div class="col-lg-8">
				<section class="glass p-4 p-md-5 mb-4 position-relative">
					<div class="row g-4 align-items-start">
						<div class="col-md-4">
							<div class="poster-wrap">
								<img class="poster-img" src="${movie.posterUrl}"
									alt="${movie.title}" />
							</div>
						</div>

						<div class="col-md-8">
							<h1 class="font-display mb-1"
								style="font-weight: 900; letter-spacing: -.02em; font-size: clamp(26px, 3.6vw, 44px);">
								${movie.title}</h1>
							<div class="text-mutedx mb-3">${movie.genre}</div>

							<div class="d-flex gap-2 flex-wrap mb-3">
								<span class="badge badge-soft">2D Phụ đề</span> <span
									class="badge badge-soft">Standard</span>
								<c:if test="${not empty movie.ageRating}">
									<span class="badge badge-age">${movie.ageRating}</span>
								</c:if>
								<span class="badge badge-soft">${movie.status}</span>
							</div>

							<div class="glass-soft p-3 p-md-4">
								<div class="row g-3">
									<div class="col-6">
										<div class="text-mutedx small">Thời lượng</div>
										<div class="fw-bold">
											<c:choose>
												<c:when test="${not empty movie.duration}">${movie.duration} phút</c:when>
												<c:otherwise>Đang cập nhật</c:otherwise>
											</c:choose>
										</div>
									</div>
									<div class="col-6">
										<div class="text-mutedx small">Khởi chiếu</div>
										<div class="fw-bold">
											<c:choose>
												<c:when test="${not empty movie.releaseDate}">
													<fmt:formatDate value="${movie.releaseDate}"
														pattern="yyyy-MM-dd" />
												</c:when>
												<c:otherwise>Đang cập nhật</c:otherwise>
											</c:choose>
										</div>
									</div>
									<div class="col-6">
										<div class="text-mutedx small">Đạo diễn</div>
										<div class="fw-bold">
											<c:choose>
												<c:when test="${not empty movie.director}">${movie.director}</c:when>
												<c:otherwise>Đang cập nhật</c:otherwise>
											</c:choose>
										</div>
									</div>
									<div class="col-6">
										<div class="text-mutedx small">Trạng thái</div>
										<div class="fw-bold">${movie.status}</div>
									</div>
								</div>
							</div>

							<div class="d-flex gap-2 mt-3 flex-wrap">
								<button class="btn btn-outline-lightx px-4 fw-bold">Trailer</button>
								<button class="btn btn-outline-lightx px-4 fw-bold">Chia
									sẻ</button>
							</div>
						</div>
					</div>
				</section>

				<section class="glass p-4 p-md-5 mb-4 position-relative">
					<div class="d-flex align-items-center gap-2 mb-3">
						<div
							style="width: 6px; height: 28px; border-radius: 99px; background: linear-gradient(to bottom, var(--primary), #8b5cf6)"></div>
						<h3 class="font-display mb-0" style="font-weight: 900">Nội
							dung phim</h3>
					</div>
					<p class="text-mutedx mb-0" style="line-height: 1.9">
						<c:out value="${movie.description}" />
					</p>
				</section>
				<section class="glass p-4 p-md-5 mb-4 position-relative">
					<div class="d-flex align-items-center gap-2 mb-3">
						<div
							style="width: 6px; height: 28px; border-radius: 99px; background: linear-gradient(to bottom, var(--primary), #8b5cf6)"></div>
						<h3 class="font-display mb-0" style="font-weight: 900">Diễn
							viên</h3>
					</div>
					<p class="text-mutedx mb-0" style="line-height: 1.9">
						<c:out value="${movie.cast}" />
					</p>
				</section>
			</div>

			<!-- RIGHT sticky showtimes -->
			<div class="col-lg-4">
				<div class="sticky-col">
					<section class="glass p-0 overflow-hidden">
						<div
							class="d-flex align-items-center justify-content-between px-4 py-3"
							style="border-bottom: 1px solid rgba(255, 255, 255, .06); background: linear-gradient(90deg, rgba(38, 24, 29, .9), rgba(30, 18, 22, .75));">
							<div class="d-flex align-items-center gap-2">
								<span style="color: var(--primary); font-weight: 900;">📅</span>
								<div class="fw-bold">Lịch chiếu</div>
							</div>
							<span class="badge"
								style="background: rgba(34, 197, 94, .14); border: 1px solid rgba(34, 197, 94, .25); color: #22c55e; font-weight: 900">
								Còn vé </span>
						</div>

						<div class="p-4">
							<c:if test="${empty showtimes}">
								<div class="text-mutedx">Chưa có lịch chiếu.</div>
							</c:if>

							<c:if test="${not empty showtimes}">
								<div class="text-mutedx small mb-2">Chọn suất chiếu</div>

								<div class="d-grid gap-2">
									<c:forEach var="st" items="${showtimes}">
										<a class="time-btn text-decoration-none"
											href="${pageContext.request.contextPath}/seat-selection?showtimeId=${st.showtimeId}">
											<div
												class="d-flex justify-content-between align-items-center">
												<div class="text-start">
													<div class="fw-bold">${st.roomName}</div>
													<div class="text-mutedx small">
														<fmt:formatDate value="${st.showDate}"
															pattern="yyyy-MM-dd HH:mm" />
													</div>
												</div>
												<div class="text-end">
													<div class="time">
														<fmt:formatDate value="${st.showDate}" pattern="HH:mm" />
													</div>
													<div class="price">
														<fmt:formatNumber value="${st.basePrice}" type="number" />
														đ
													</div>
												</div>
											</div>
										</a>
									</c:forEach>
								</div>
							</c:if>

							<div class="mt-3 text-mutedx small">* Bấm suất chiếu →
								chuyển qua trang chọn ghế (nếu chưa login sẽ tự chuyển login).</div>
						</div>
					</section>
				</div>
			</div>
		</div>
	</main>
	<jsp:include page="/view/KhachHang/Base/footer.jsp" />
</body>
</html>
