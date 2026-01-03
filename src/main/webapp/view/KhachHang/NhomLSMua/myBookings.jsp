<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Lịch sử đặt vé - CinemaDB</title>
  <jsp:include page="/view/KhachHang/Base/header.jsp"/>

  <style>
    .glass{ background: rgba(255,255,255,.06); border:1px solid rgba(255,255,255,.10); border-radius: 18px; box-shadow: 0 16px 50px rgba(0,0,0,.35); backdrop-filter: blur(14px); }
    .glass-soft{ background: rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08); border-radius: 16px; }
    .muted{ color: rgba(255,255,255,.65) !important; }
    .chip{ border:1px solid rgba(255,255,255,.12); background: rgba(255,255,255,.04); color:#fff; border-radius: 999px; padding:.45rem .9rem; font-weight:700; }
    .chip.active{ background: rgba(236,19,128,.18); border-color: rgba(236,19,128,.50); box-shadow: 0 0 18px rgba(236,19,128,.14); }
    .poster{ width: 110px; aspect-ratio: 2/3; border-radius: 14px; overflow:hidden; border:1px solid rgba(255,255,255,.10); background:#111; }
    .poster img{ width:100%; height:100%; object-fit: cover; display:block; }
    .badge-pill{ border-radius: 999px; padding:.35rem .65rem; font-weight:800; letter-spacing:.02em; }
    .badge-upcoming{ background: rgba(34,197,94,.15); border:1px solid rgba(34,197,94,.35); color:#86efac; }
    .badge-used{ background: rgba(148,163,184,.14); border:1px solid rgba(148,163,184,.30); color:#e2e8f0; }
    .badge-cancel{ background: rgba(239,68,68,.15); border:1px solid rgba(239,68,68,.35); color:#fecaca; }

    .searchbox{ background: rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.10); border-radius: 14px; }
    .searchbox .form-control{ background: transparent; border: none; color:#fff; }
    .searchbox .form-control:focus{ box-shadow:none; }
    .searchbox .input-group-text{ background: transparent; border: none; color: rgba(255,255,255,.65); }

    .ticket-divider{ border-top: 1px dashed rgba(255,255,255,.18); }
  </style>
</head>

<body>
<jsp:include page="/view/KhachHang/Base/head.jsp"/>
<main class="container py-4 py-md-5">

  <!-- Header -->
  <div class="d-flex flex-column flex-md-row align-items-md-end justify-content-between gap-3 mb-4">
    <div>
      <h2 class="font-display mb-1" style="font-weight: 900">Lịch sử đặt vé</h2>
      <div class="muted">Quản lý vé đã đặt và lịch sử giao dịch của bạn.</div>
    </div>

    <form class="w-100 w-md-auto" method="get" action="${pageContext.request.contextPath}/my-bookings">
      <input type="hidden" name="status" value="${status}"/>
      <input type="hidden" name="sort" value="${sort}"/>
      <div class="input-group searchbox" style="max-width: 420px;">
        <span class="input-group-text">
          <i class="bi bi-search"></i>
        </span>
        <input class="form-control" name="q" value="${q}" placeholder="Tìm phim, phòng..." />
      </div>
    </form>
  </div>

  <!-- Filters -->
  <div class="glass p-3 p-md-4 mb-4">
    <div class="d-flex flex-column flex-lg-row align-items-lg-center justify-content-between gap-3">
      <div class="d-flex flex-wrap gap-2">
        <a class="chip ${status=='ALL' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/my-bookings?status=ALL&sort=${sort}&q=${q}">
          Tất cả
        </a>
        <a class="chip ${status=='PENDING' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/my-bookings?status=PENDING&sort=${sort}&q=${q}">
          Chưa thanh toán
        </a>
        <a class="chip ${status=='PAID' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/my-bookings?status=PAID&sort=${sort}&q=${q}">
          Đã thanh toán
        </a>
        <a class="chip ${status=='CANCELLED' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/my-bookings?status=CANCELLED&sort=${sort}&q=${q}">
          Đã hủy
        </a>
      </div>

      <form class="d-flex align-items-center gap-2" method="get" action="${pageContext.request.contextPath}/my-bookings">
        <input type="hidden" name="status" value="${status}"/>
        <input type="hidden" name="q" value="${q}"/>
        <span class="muted small">Sắp xếp:</span>
        <select class="form-select form-select-sm"
                name="sort"
                style="width: 190px; background: rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.10); color:#fff;"
                onchange="this.form.submit()">
          <option value="newest" ${sort=='newest' ? 'selected' : ''}>Mới nhất</option>
          <option value="oldest" ${sort=='oldest' ? 'selected' : ''}>Cũ nhất</option>
          <option value="az" ${sort=='az' ? 'selected' : ''}>Tên phim (A-Z)</option>
        </select>
      </form>
    </div>
  </div>

  <!-- List -->
  <c:choose>
    <c:when test="${empty items}">
      <div class="glass p-4 text-center">
        <div class="muted">Chưa có lịch sử đặt vé nào.</div>
        <a class="btn btn-primaryx mt-3" href="${pageContext.request.contextPath}/movies">Đặt vé ngay</a>
      </div>
    </c:when>

    <c:otherwise>
      <div class="d-flex flex-column gap-3">

        <c:forEach var="it" items="${items}">
          <div class="glass p-3 p-md-4">
            <div class="d-flex flex-column flex-md-row gap-3 gap-md-4">

              <!-- Poster -->
              <div class="poster">
                <c:choose>
                  <c:when test="${not empty it.posterUrl}">
                    <img src="${it.posterUrl}" alt="${it.movieTitle}"/>
                  </c:when>
                  <c:otherwise>
                    <img src="https://via.placeholder.com/220x330?text=Poster" alt="poster"/>
                  </c:otherwise>
                </c:choose>
              </div>

              <!-- Content -->
              <div class="flex-grow-1">
                <div class="d-flex flex-column flex-lg-row justify-content-between gap-2">
                  <div>
                    <div class="d-flex flex-wrap align-items-center gap-2">
                      <h5 class="mb-0" style="font-weight: 900">${it.movieTitle}</h5>

                      <c:choose>
                        <c:when test="${it.paymentStatus=='PAID'}">
                          <span class="badge badge-pill badge-upcoming">Đã thanh toán</span>
                        </c:when>
                        <c:when test="${it.paymentStatus=='PENDING'}">
                          <span class="badge badge-pill" style="background: rgba(251,191,36,.15); border:1px solid rgba(251,191,36,.35); color:#fde68a;">Chưa thanh toán</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge badge-pill badge-cancel">Đã hủy</span>
                        </c:otherwise>
                      </c:choose>
                    </div>

                    <div class="muted small mt-1">
                      Booking #${it.bookingId} • Đặt lúc:
                      <fmt:formatDate value="${it.bookingTime}" pattern="dd/MM/yyyy HH:mm"/>
                    </div>
                  </div>

                  <div class="text-lg-end">
                    <div class="muted small">Tổng tiền</div>
                    <div class="fw-bold" style="font-size: 18px;">
                      <fmt:formatNumber value="${it.totalAmount}" type="number"/> đ
                    </div>
                  </div>
                </div>

                <div class="row g-3 mt-2">
                  <div class="col-md-6">
                    <div class="glass-soft p-3 h-100">
                      <div class="muted small mb-1"><i class="bi bi-geo-alt"></i> Rạp / Phòng</div>
                      <div class="fw-bold">${it.roomName}</div>
                      <div class="muted small">Phòng: ${it.roomId} • Suất: ${it.showtimeId}</div>
                    </div>
                  </div>

                  <div class="col-md-6">
                    <div class="glass-soft p-3 h-100">
                      <div class="muted small mb-1"><i class="bi bi-calendar-event"></i> Suất chiếu</div>
                      <div class="fw-bold">
                        <fmt:formatDate value="${it.showDate}" pattern="HH:mm"/>
                      </div>
                      <div class="muted small">
                        <fmt:formatDate value="${it.showDate}" pattern="dd/MM/yyyy"/>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="ticket-divider my-3"></div>

                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                  <div>
                    <div class="muted small">Ghế đã đặt</div>
                    <div class="fw-bold">
                      <c:out value="${empty it.seatLabels ? '—' : it.seatLabels}"/>
                    </div>
                  </div>

                  <div class="d-flex gap-2">
                    <a class="btn btn-outline-light"
                       href="${pageContext.request.contextPath}/movie-detail?id=${it.movieId}">
                      Xem phim
                    </a>

                    <a class="btn btn-primaryx"
                       href="${pageContext.request.contextPath}/booking-success?bookingId=${it.bookingId}">
                      Xem vé / Hóa đơn
                    </a>
                  </div>
                </div>

              </div>
            </div>
          </div>
        </c:forEach>

      </div>
    </c:otherwise>
  </c:choose>

</main>
<jsp:include page="/view/KhachHang/Base/footer.jsp"/>
</body>
</html>
