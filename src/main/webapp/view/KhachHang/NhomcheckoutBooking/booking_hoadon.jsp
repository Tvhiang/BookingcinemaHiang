<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Thanh toán thành công - CinemaDB</title>
  <jsp:include page="/view/KhachHang/Base/head.jsp"/>
  <style>
    .ok{ color:#22c55e; font-weight:900; }
  </style>
</head>
<body>
<jsp:include page="/view/KhachHang/Base/header.jsp"/>
<main class="container py-5">
  <div class="glass p-4 p-md-5 text-center">
    <h2 class="font-display mb-2" style="font-weight:900">
      <span class="ok">✔</span> Thanh toán thành công
    </h2>
    <div class="text-mutedx mb-4">Booking #${booking.bookingId}</div>

    <div class="row g-3 justify-content-center text-start">
      <div class="col-md-6">
        <div class="glass-soft p-3">
          <div class="text-mutedx small">Trạng thái</div>
          <div class="fw-bold">${booking.paymentStatus}</div>
        </div>
      </div>

      <div class="col-md-6">
        <div class="glass-soft p-3">
          <div class="text-mutedx small">Tổng tiền</div>
          <div class="fw-bold">
            <fmt:formatNumber value="${booking.totalAmount}" type="number"/> đ
          </div>
        </div>
      </div>

      <div class="col-md-6">
        <div class="glass-soft p-3">
          <div class="text-mutedx small">Phương thức</div>
          <div class="fw-bold"><c:out value="${payment.paymentMethod}"/></div>
        </div>
      </div>

      <div class="col-md-6">
        <div class="glass-soft p-3">
          <div class="text-mutedx small">Thời gian</div>
          <div class="fw-bold"><c:out value="${payment.paymentDate}"/></div>
        </div>
      </div>
    </div>

    <div class="mt-4 d-flex gap-2 justify-content-center flex-wrap">
      <a class="btn btn-primaryx px-4" href="${pageContext.request.contextPath}/home">Về trang chủ</a>
      <a class="btn btn-outline-lightx px-4" href="${pageContext.request.contextPath}/movies">Xem phim khác</a>
    </div>
  </div>
</main>
<jsp:include page="/view/KhachHang/Base/footer.jsp"/>
</body>
</html>
