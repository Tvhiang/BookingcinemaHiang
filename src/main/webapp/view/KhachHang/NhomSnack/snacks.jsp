<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Chọn đồ ăn - CinemaDB</title>
<jsp:include page="/view/KhachHang/Base/head.jsp" />
<style>
.snack-card {
	border-radius: 18px;
	overflow: hidden;
	border: 1px solid rgba(255, 255, 255, .08);
	background: rgba(38, 24, 29, .55);
	height: 100%;
}

.snack-img {
	width: 100%;
	height: 160px;
	object-fit: cover;
	background: #000;
}

.qty {
	width: 100px;
	text-align: center;
	font-weight: 900;
}

.sticky-summary {
	position: sticky;
	top: 92px;
}
</style>
</head>
<body>
	<jsp:include page="/view/KhachHang/Base/header.jsp" />
	<main class="container py-4 py-md-5">
		<div class="row g-4 g-lg-5">
			<div class="col-lg-8">
				<div class="glass p-4 p-md-5 mb-4">
					<div
						class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-3">
						<div>
							<h2 class="font-display mb-1" style="font-weight: 900">Chọn
								đồ ăn</h2>
							<div class="text-mutedx small">Bạn có thể bỏ qua và tiếp
								tục thanh toán.</div>
						</div>
						<div class="text-mutedx small">Booking #${bookingId}</div>
					</div>

					<form method="post"
						action="${pageContext.request.contextPath}/snacks" id="snackForm">
						<input type="hidden" name="bookingId" value="${bookingId}" />

						<div class="row g-3 g-md-4">
							<c:forEach var="s" items="${snacks}">
								<div class="col-12 col-md-6">
									<div class="snack-card">
										<img class="snack-img" src="${s.imageUrl}"
											alt="${s.snackName}" onerror="this.style.display='none'" />
										<div class="p-3">
											<div class="fw-bold">${s.snackName}</div>
											<div class="text-mutedx small mb-2">${s.category}</div>

											<div
												class="d-flex justify-content-between align-items-center">
												<div class="fw-bold">
													<fmt:formatNumber value="${s.price}" type="number" />
													đ
													<c:if
														test="${s.discount != null && s.discount.doubleValue() > 0}">
														<span class="text-mutedx small">(- <fmt:formatNumber
																value="${s.discount}" type="number" /> đ)
														</span>
													</c:if>
												</div>

												<input class="form-control qty" type="number" min="0"
													name="qty_${s.snackId}" value="0" data-price="${s.price}"
													data-discount="${s.discount}" />
											</div>
										</div>
									</div>
								</div>
							</c:forEach>

							<c:if test="${empty snacks}">
								<div class="col-12">
									<div class="glass-soft p-4 text-center text-mutedx">Chưa
										có snack trong hệ thống.</div>
								</div>
							</c:if>
						</div>

						<div class="mt-4 d-flex justify-content-end gap-2 flex-wrap">
							<a class="btn btn-outline-lightx px-4"
								href="${pageContext.request.contextPath}/checkout?bookingId=${bookingId}">
								Bỏ qua </a>
							<button class="btn btn-primaryx px-4 py-3" type="submit">Tiếp
								tục thanh toán</button>
						</div>
					</form>
				</div>
			</div>

			<div class="col-lg-4">
				<div class="sticky-summary">
					<div class="glass p-4">
						<h5 class="fw-bold mb-2">Tóm tắt</h5>
						<div class="text-mutedx small mb-3">Booking #${bookingId}</div>

						<div class="glass-soft p-3 mb-3">
							<div class="text-mutedx small">Tạm tính snack</div>
							<div class="fw-bold" id="snackTotal">0 đ</div>
						</div>

						<div class="text-mutedx small">* Tổng tiền cuối cùng = tiền
							ghế + snack (đã được servlet cập nhật).</div>
					</div>
				</div>
			</div>
		</div>
	</main>
	<jsp:include page="/view/KhachHang/Base/footer.jsp" />
	<script>
  const fmt = (n) => new Intl.NumberFormat('vi-VN').format(n) + " đ";

  function calc(){
    let total = 0;
    document.querySelectorAll('input.qty').forEach(inp => {
      const qty = Number(inp.value || 0);
      const price = Number(inp.dataset.price || 0);
      const disc = Number(inp.dataset.discount || 0);
      const unit = Math.max(0, price - disc);
      total += qty * unit;
    });
    document.getElementById('snackTotal').textContent = fmt(total);
  }

  document.querySelectorAll('input.qty').forEach(i => i.addEventListener('input', calc));
  calc();
</script>
</body>
</html>
