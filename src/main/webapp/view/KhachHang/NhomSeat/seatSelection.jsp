<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Chọn ghế - CinemaDB</title>

  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>

  <!-- Optional: Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
<jsp:include page="/view/KhachHang/Base/head.jsp"/>	
  <style>
    :root{
      --bg:#0f0a0d;
      --card:#1a1216;
      --card2:#151013;
      --stroke:rgba(255,255,255,.08);
      --stroke2:rgba(255,255,255,.12);
      --muted:rgba(255,255,255,.65);
      --muted2:rgba(255,255,255,.45);
      --primary:#ec1380;
      --primary2:#ff4d6d;
      --shadow: 0 18px 60px rgba(0,0,0,.55);
    }
    body{
      background: radial-gradient(circle at 30% 10%, rgba(236,19,128,.14), transparent 55%),
                  radial-gradient(circle at 70% 30%, rgba(255,77,109,.08), transparent 55%),
                  linear-gradient(180deg, rgba(0,0,0,.0), rgba(0,0,0,.25)),
                  var(--bg);
      color:#fff;
      min-height:100vh;
    }
    .glass{
      background: rgba(26,18,22,.72);
      backdrop-filter: blur(16px);
      -webkit-backdrop-filter: blur(16px);
      border: 1px solid var(--stroke);
      border-radius: 22px;
      box-shadow: var(--shadow);
    }
    .glass-soft{
      background: rgba(255,255,255,.04);
      border:1px solid rgba(255,255,255,.08);
      border-radius: 16px;
    }
    .text-mutedx{ color: var(--muted); }
    .font-display{ font-weight: 900; letter-spacing: -0.02em; }

    /* Screen */
    .screen-label{
      letter-spacing:.35em;
      font-weight:900;
      color: rgba(255,255,255,.65);
      font-size:.9rem;
    }
    .screen{
      height: 14px;
      border-radius: 999px;
      background: linear-gradient(90deg, transparent, rgba(236,19,128,.85), transparent);
      box-shadow: 0 0 30px rgba(236,19,128,.22);
    }

    /* Seat Map wrapper */
    .seat-map{
      overflow:auto;
      padding-bottom: 6px;
    }

    /* Each row layout: label | seats grid */
    .seat-row{
      display:flex;
      align-items:center;
      gap: 12px;
      margin-bottom: 10px;
      justify-content:center;
      min-width: max-content;
    }
    .row-label{
      width: 28px;
      height: 28px;
      border-radius: 10px;
      display:flex;
      align-items:center;
      justify-content:center;
      font-weight:900;
      font-size:.85rem;
      color: rgba(255,255,255,.75);
      background: rgba(255,255,255,.04);
      border:1px solid rgba(255,255,255,.10);
    }

    /* Seats container per row */
    .row-seats{
      display:flex;
      align-items:center;
      gap: 10px;
    }

    /* Seat button */
    .seat-btn{
      width: 44px;
      height: 38px;
      border-radius: 12px;
      border:1px solid rgba(255,255,255,.12);
      background: rgba(255,255,255,.04);
      color:#fff;
      font-weight:900;
      font-size:.85rem;
      transition: all .14s ease;
      display:flex;
      align-items:center;
      justify-content:center;
      user-select:none;
    }
    .seat-btn:hover{
      transform: translateY(-2px);
      border-color: rgba(236,19,128,.28);
      box-shadow: 0 0 18px rgba(236,19,128,.10);
    }
    .seat-btn.selected{
      background: rgba(236,19,128,.18);
      border-color: rgba(236,19,128,.55);
      box-shadow: 0 0 18px rgba(236,19,128,.18);
    }
    .seat-btn.booked{
      background: rgba(255,255,255,.06);
      border-color: rgba(255,255,255,.08);
      color: rgba(255,255,255,.35);
      cursor:not-allowed;
      box-shadow:none;
      transform:none !important;
    }

    /* Aisle space */
    .aisle{
      width: 42px;
      height: 1px;
      flex: 0 0 42px;
    }

    /* Sticky summary */
    .sticky-summary{ position: sticky; top: 92px; }

    /* Primary button */
    .btn-primaryx{
      background: linear-gradient(135deg, var(--primary) 0%, var(--primary2) 100%);
      border: none;
      color:#fff;
      font-weight: 900;
      border-radius: 14px;
      box-shadow: 0 10px 30px rgba(236,19,128,.22);
    }
    .btn-primaryx:hover{
      filter: brightness(1.03);
      box-shadow: 0 12px 34px rgba(236,19,128,.30);
    }
    .badge-pink{
      background: rgba(236,19,128,.16);
      color:#ffb3d2;
      border: 1px solid rgba(236,19,128,.35);
      border-radius: 999px;
      padding: .35rem .65rem;
      font-weight: 800;
    }
  </style>
</head>

<body>
<jsp:include page="/view/KhachHang/Base/header.jsp"/>
<main class="container py-4 py-md-5">
  <div class="row g-4 g-lg-5">

    <!-- LEFT -->
    <div class="col-lg-8">
      <div class="glass p-4 p-md-5">

        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3 mb-3">
          <div>
            <div class="d-flex align-items-center gap-2 mb-1">
              <span class="badge-pink"><i class="bi bi-ticket-perforated me-1"></i> Seat Selection</span>
            </div>
            <h2 class="font-display mb-1">Chọn ghế</h2>
            <div class="text-mutedx small">Chọn ghế trống. Ghế đã đặt sẽ bị khóa.</div>
          </div>

          <div class="text-end">
            <div class="text-mutedx small">Giá ghế</div>
            <div class="fw-bold">
              <fmt:formatNumber value="${showtime.basePrice}" type="number"/> đ / ghế
            </div>
          </div>
        </div>

        <div class="text-center mt-4 mb-2 screen-label">SCREEN</div>
        <div class="screen mb-4"></div>

        <!-- legend -->
        <div class="d-flex gap-3 flex-wrap justify-content-center mb-4">
          <div class="d-flex align-items-center gap-2">
            <span class="seat-btn" style="transform:none; pointer-events:none"></span>
            <span class="text-mutedx small">Trống</span>
          </div>
          <div class="d-flex align-items-center gap-2">
            <span class="seat-btn selected" style="transform:none; pointer-events:none"></span>
            <span class="text-mutedx small">Đang chọn</span>
          </div>
          <div class="d-flex align-items-center gap-2">
            <span class="seat-btn booked" style="transform:none; pointer-events:none"></span>
            <span class="text-mutedx small">Đã đặt</span>
          </div>
        </div>

        <form id="seatForm" method="post" action="${pageContext.request.contextPath}/seat-selection">
          <input type="hidden" name="showtimeId" value="${param.showtimeId}"/>

          <!-- Seat map render here -->
          <div class="seat-map glass-soft p-3 p-md-4">
            <div id="seatMap"></div>
          </div>

          <!-- container hidden seatIds -->
          <div id="selectedInputs"></div>

          <div class="mt-4 d-flex justify-content-end">
            <button id="btnContinue" class="btn btn-primaryx px-4 py-3" type="submit" disabled>
              Tiếp tục chọn đồ ăn <i class="bi bi-arrow-right ms-1"></i>
            </button>
          </div>
        </form>

      </div>
    </div>

    <!-- RIGHT -->
    <div class="col-lg-4">
      <div class="sticky-summary">
        <div class="glass p-4">
          <h5 class="fw-bold mb-2">Tóm tắt</h5>
          <div class="text-mutedx small mb-3">Suất chiếu: <b>#${showtime.showtimeId}</b></div>

          <div class="glass-soft p-3 mb-3">
            <div class="text-mutedx small">Ghế đã chọn</div>
            <div id="seatList" class="fw-bold">Chưa chọn</div>
          </div>

          <div class="glass-soft p-3">
            <div class="d-flex justify-content-between align-items-center">
              <div class="text-mutedx small">Tạm tính</div>
              <div class="fw-bold" id="subtotal">0 đ</div>
            </div>
          </div>

          <c:if test="${not empty sessionScope.seatError}">
            <div class="alert alert-warning mt-3 mb-0">
              ${sessionScope.seatError}
              <c:remove var="seatError" scope="session"/>
            </div>
          </c:if>
        </div>
      </div>
    </div>

  </div>
</main>
<jsp:include page="/view/KhachHang/Base/footer.jsp"/>
<script>
  // ---- Build data from JSP ----
  const seats = [
    <c:forEach var="s" items="${seats}" varStatus="st">
      { seatId: ${s.seatId}, row: "${s.seatRow}", col: ${s.seatCol}, label: "${s.seatLabel}" }<c:if test="${!st.last}">,</c:if>
    </c:forEach>
  ];

  const booked = new Set([
    <c:forEach var="bid" items="${bookedSeatIds}" varStatus="st">
      ${bid}<c:if test="${!st.last}">,</c:if>
    </c:forEach>
  ]);

  // price
  const pricePerSeat = Number("${showtime.basePrice}");
  const fmtVND = (n) => new Intl.NumberFormat('vi-VN').format(n) + " đ";

  // group by row
  const rowsMap = new Map(); // row => seats[]
  let maxCol = 0;

  seats.forEach(s => {
    maxCol = Math.max(maxCol, s.col);
    if (!rowsMap.has(s.row)) rowsMap.set(s.row, []);
    rowsMap.get(s.row).push(s);
  });

  // sort rows A..Z
  const rows = Array.from(rowsMap.keys()).sort((a,b) => a.localeCompare(b));

  // aisle position (center)
  const aisleAfter = Math.floor(maxCol / 2); // ex: 12 -> 6, 10 -> 5

  // selected state
  const selected = new Map(); // seatId -> label
  const seatListEl = document.getElementById('seatList');
  const selectedInputsEl = document.getElementById('selectedInputs');
  const subtotalEl = document.getElementById('subtotal');
  const btnContinue = document.getElementById('btnContinue');
  const seatMapEl = document.getElementById('seatMap');

  function renderSeatMap(){
    seatMapEl.innerHTML = "";

    rows.forEach(r => {
      // sort seats by col
      const rowSeats = rowsMap.get(r).sort((a,b)=>a.col-b.col);

      const rowWrap = document.createElement('div');
      rowWrap.className = "seat-row";

      const label = document.createElement('div');
      label.className = "row-label";
      label.textContent = r;
      rowWrap.appendChild(label);

      const seatsWrap = document.createElement('div');
      seatsWrap.className = "row-seats";

      rowSeats.forEach(s => {
        // insert aisle gap after center col
        if (s.col === aisleAfter + 1) {
          const aisle = document.createElement('div');
          aisle.className = "aisle";
          seatsWrap.appendChild(aisle);
        }

        const btn = document.createElement('button');
        btn.type = "button";
        btn.className = "seat-btn";
        btn.textContent = s.label;
        btn.dataset.id = s.seatId;
        btn.dataset.label = s.label;

        if (booked.has(s.seatId)) {
          btn.classList.add('booked');
          btn.disabled = true;
        }

        // restore selected UI if rerender
        if (selected.has(s.seatId)) btn.classList.add('selected');

        btn.addEventListener('click', () => {
          const id = Number(btn.dataset.id);
          const label = btn.dataset.label;

          if (selected.has(id)) {
            selected.delete(id);
            btn.classList.remove('selected');
          } else {
            selected.set(id, label);
            btn.classList.add('selected');
          }
          sync();
        });

        seatsWrap.appendChild(btn);
      });

      rowWrap.appendChild(seatsWrap);
      seatMapEl.appendChild(rowWrap);
    });
  }

  function sync(){
    // seat list
    if (selected.size === 0) {
      seatListEl.textContent = "Chưa chọn";
      btnContinue.disabled = true;
    } else {
      seatListEl.textContent = Array.from(selected.values()).sort().join(", ");
      btnContinue.disabled = false;
    }

    // subtotal
    const total = selected.size * pricePerSeat;
    subtotalEl.textContent = fmtVND(total);

    // hidden inputs
    selectedInputsEl.innerHTML = "";
    Array.from(selected.keys()).forEach(id => {
      const input = document.createElement('input');
      input.type = 'hidden';
      input.name = 'seatIds';
      input.value = id;
      selectedInputsEl.appendChild(input);
    });
  }

  renderSeatMap();
  sync();
</script>

</body>
</html>
