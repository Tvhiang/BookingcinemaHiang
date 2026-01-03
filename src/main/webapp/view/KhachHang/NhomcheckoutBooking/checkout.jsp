<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Thanh toán - CinemaDB</title>
 <jsp:include page="/view/KhachHang/Base/head.jsp"/>
  <style>
    .sticky-summary{ position: sticky; top: 92px; }
    .radio-card{
      border-radius: 16px;
      border:1px solid rgba(255,255,255,.10);
      background: rgba(255,255,255,.04);
      padding: 14px 14px;
      cursor:pointer;
      transition: all .15s ease;
    }
    .radio-card:hover{ transform: translateY(-2px); border-color: rgba(236,19,128,.25); }
    .radio-card input{ transform: scale(1.15); }
  </style>
</head>
<body>
<jsp:include page="/view/KhachHang/Base/header.jsp"/>
<main class="container py-4 py-md-5">
  <div class="row g-4 g-lg-5">
    <div class="col-lg-8">
      <div class="glass p-4 p-md-5">
        <h2 class="font-display mb-1" style="font-weight:900">Thanh toán</h2>
        <div class="text-mutedx mb-4">Chọn phương thức thanh toán và xác nhận.</div>

        <form method="post" action="${pageContext.request.contextPath}/checkout">
          <input type="hidden" name="bookingId" value="${booking.bookingId}"/>

          <div class="row g-3">
            <div class="col-md-6">
              <label class="radio-card w-100 d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-2">
                  <input type="radio" name="paymentMethod" value="CASH" checked/>
                  <div>
                    <div class="fw-bold">Tiền mặt</div>
                    <div class="text-mutedx small">Thanh toán trực tiếp</div>
                  </div>
                </div>
                <span class="badge badge-soft">CASH</span>
              </label>
            </div>

            <div class="col-md-6">
              <label class="radio-card w-100 d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-2">
                  <input type="radio" name="paymentMethod" value="CARD"/>
                  <div>
                    <div class="fw-bold">Thẻ</div>
                    <div class="text-mutedx small">Visa/Mastercard</div>
                  </div>
                </div>
                <span class="badge badge-soft">CARD</span>
              </label>
            </div>

            <div class="col-md-6">
              <label class="radio-card w-100 d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-2">
                  <input type="radio" name="paymentMethod" value="MOMO"/>
                  <div>
                    <div class="fw-bold">MoMo</div>
                    <div class="text-mutedx small">Ví điện tử</div>
                  </div>
                </div>
                <span class="badge badge-soft">MOMO</span>
              </label>
            </div>

            <div class="col-md-6">
              <label class="radio-card w-100 d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-2">
                  <input type="radio" name="paymentMethod" value="VNPAY"/>
                  <div>
                    <div class="fw-bold">VNPay</div>
                    <div class="text-mutedx small">QR/Internet Banking</div>
                  </div>
                </div>
                <span class="badge badge-soft">VNPAY</span>
              </label>
            </div>
          </div>

          <div class="mt-4 d-flex justify-content-end">
            <button class="btn btn-primaryx px-4 py-3" type="submit">
              Xác nhận thanh toán
            </button>
          </div>
        </form>
      </div>
    </div>

    <div class="col-lg-4">
      <div class="sticky-summary">
        <div class="glass p-4">
          <h5 class="fw-bold mb-2">Tóm tắt đơn</h5>
          <div class="text-mutedx small mb-3">Booking #${booking.bookingId}</div>

          <div class="glass-soft p-3 mb-3">
            <div class="d-flex justify-content-between">
              <div class="text-mutedx small">Trạng thái</div>
              <div class="fw-bold">${booking.paymentStatus}</div>
            </div>
          </div>

          <div class="glass-soft p-3">
            <div class="d-flex justify-content-between">
              <div class="text-mutedx small">Tổng tiền</div>
              <div class="fw-bold">
                <fmt:formatNumber value="${booking.totalAmount}" type="number"/> đ
              </div>
            </div>
          </div>

          <div class="text-mutedx small mt-3">
            * Sau khi xác nhận, hệ thống sẽ chuyển qua trang hóa đơn.
          </div>
        </div>
      </div>
    </div>
  </div>
</main>
<jsp:include page="/view/KhachHang/Base/footer.jsp"/>
</body>
</html>
