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
    <title>${snack == null ? 'Thêm đồ ăn' : 'Sửa đồ ăn'} - Cinema Admin</title>

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
        .content{ padding:22px 22px 28px; max-width:1100px; width:100%; margin:0 auto; }

        .panel{
            background: radial-gradient(circle at top, #0b1120, #020617);
            border:1px solid var(--border-subtle);
            border-radius:18px;
            padding:16px;
            box-shadow:0 10px 25px rgba(0,0,0,0.8);
        }

        .form-control,.form-select{
            background:#020617; border:1px solid #1f2937; color:var(--text-main);
        }
        .form-control:focus,.form-select:focus{
            border-color:var(--primary); box-shadow:0 0 0 1px var(--primary);
            background:#020617; color:var(--text-main);
        }

        /* Preview box (không dùng <img> khi chưa có URL => không còn icon lỗi) */
        .preview-wrap{
            width:100%;
            border-radius:14px;
            border:1px solid rgba(148,163,184,0.25);
            background:#0b1120;
            overflow:hidden;
        }
        .preview-img{
            width:100%;
            aspect-ratio:16/9;
            object-fit:cover;
            display:block;
        }
        .preview-empty{
            aspect-ratio:16/9;
            display:flex;
            align-items:center;
            justify-content:center;
            gap:10px;
            color:rgba(148,163,184,0.95);
            font-size:0.95rem;
            padding:14px;
            text-align:center;
        }
        .preview-empty i{
            font-size:1.25rem;
            color:rgba(165,180,252,0.95);
        }
        .preview-hint{
            font-size:0.82rem;
            color:var(--text-muted);
            margin-top:6px;
        }
        .error-badge{
            display:none;
            margin-top:8px;
            font-size:0.82rem;
        }

        @media (max-width: 768px){
            .sidebar{ display:none; }
            .mobile-toggle{ display:block; }
            .content{ padding:18px 14px 24px; }
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
                    <div style="font-size:1.05rem;font-weight:700;">
                        ${snack == null ? 'Thêm đồ ăn / uống' : 'Sửa đồ ăn / uống'}
                    </div>
                    <div style="font-size:0.85rem;color:var(--text-muted);">
                        Nhập thông tin snack theo DB
                    </div>
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

            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
                <div class="text-secondary">
                    <i class="bi bi-info-circle"></i>
                    ${snack == null ? 'Tạo snack mới' : 'Cập nhật snack hiện tại'}
                </div>
                <a class="btn btn-sm btn-outline-light"
                   href="${pageContext.request.contextPath}/admin/snacks">
                    <i class="bi bi-arrow-left"></i> Quay lại
                </a>
            </div>

            <div class="panel">
                <form method="post" action="${pageContext.request.contextPath}/admin/snacks">
                    <c:if test="${snack != null}">
                        <input type="hidden" name="id" value="${snack.snackId}">
                    </c:if>

                    <div class="row g-3">
                        <div class="col-12 col-md-7">
                            <label class="form-label">Tên món <span class="text-danger">*</span></label>
                            <input class="form-control" name="snackName" required
                                   value="${snack != null ? snack.snackName : ''}">
                        </div>

                        <div class="col-12 col-md-5">
                            <label class="form-label">Loại <span class="text-danger">*</span></label>
                            <select class="form-select" name="category" required>
                                <option value="POP_CORN" ${snack != null && snack.category == 'POP_CORN' ? 'selected' : ''}>POP_CORN</option>
                                <option value="DRINK" ${snack != null && snack.category == 'DRINK' ? 'selected' : ''}>DRINK</option>
                                <option value="COMBO" ${snack != null && snack.category == 'COMBO' ? 'selected' : ''}>COMBO</option>
                                <option value="OTHER" ${snack == null || snack.category == 'OTHER' ? 'selected' : ''}>OTHER</option>
                            </select>
                        </div>

                        <div class="col-12 col-md-4">
                            <label class="form-label">Giá (đ) <span class="text-danger">*</span></label>
                            <input type="number" step="1" min="0"
                                   class="form-control" name="price" required
                                   value="${snack != null ? snack.price : ''}">
                            <div class="preview-hint">Gợi ý: nhập số nguyên (VD: 35000)</div>
                        </div>

                        <div class="col-12 col-md-4">
                            <label class="form-label">Giảm giá (đ)</label>
                            <input type="number" step="1" min="0"
                                   class="form-control" name="discount"
                                   value="${snack != null ? snack.discount : '0'}">
                            <div class="preview-hint">discount = số tiền giảm trực tiếp.</div>
                        </div>

                        <div class="col-12 col-md-4">
                            <label class="form-label">Giá sau giảm</label>
                            <input class="form-control" id="finalPrice" readonly value="0 đ">
                            <div class="preview-hint" id="finalPriceHint">—</div>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Image URL</label>
                            <input class="form-control" name="imageUrl" id="imageUrl"
                                   value="${snack != null ? snack.imageUrl : ''}"
                                   placeholder="https://...">
                            <div class="form-text text-secondary">
                                Nếu chưa làm upload file thì dùng URL trước.
                            </div>

                            <div class="alert alert-warning error-badge" id="imgError">
                                <i class="bi bi-exclamation-triangle"></i>
                                Ảnh không hợp lệ hoặc không load được. Đang hiển thị placeholder.
                            </div>
                        </div>

                        <div class="col-12">
                            <div class="preview-wrap">
                                <!-- Placeholder (mặc định) -->
                                <div class="preview-empty" id="previewEmpty">
                                    <i class="bi bi-image"></i>
                                    <div>
                                        <div><b>Chưa có ảnh preview</b></div>
                                        <div class="preview-hint">Dán Image URL để xem trước.</div>
                                    </div>
                                </div>

                                <!-- Img thật (chỉ bật khi URL hợp lệ) -->
                                <img class="preview-img" id="imgPreview" alt="Snack preview" style="display:none;" />
                            </div>
                        </div>

                        <div class="col-12 d-flex justify-content-end gap-2">
                            <a class="btn btn-outline-light"
                               href="${pageContext.request.contextPath}/admin/snacks">Hủy</a>
                            <button class="btn btn-primary" type="submit">
                                <i class="bi bi-save"></i> Lưu
                            </button>
                        </div>
                    </div>
                </form>
            </div>

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

    // ========= VNĐ format =========
    const fmtVND = (n) => {
        const v = Number.isFinite(n) ? n : 0;
        return Math.round(v).toLocaleString('vi-VN') + " đ";
    };

    // ========= preview + final price =========
    const urlInput = document.getElementById('imageUrl');
    const img = document.getElementById('imgPreview');
    const empty = document.getElementById('previewEmpty');
    const imgError = document.getElementById('imgError');

    const priceInput = document.querySelector('input[name="price"]');
    const discountInput = document.querySelector('input[name="discount"]');
    const finalPrice = document.getElementById('finalPrice');
    const finalPriceHint = document.getElementById('finalPriceHint');

    function showPlaceholder(showError){
        img.style.display = "none";
        empty.style.display = "flex";
        imgError.style.display = showError ? "block" : "none";
    }

    function showImage(src){
        empty.style.display = "none";
        imgError.style.display = "none";
        img.style.display = "block";
        img.src = src;
    }

    function updatePreview(){
        const v = (urlInput?.value || "").trim();

        if (!v) {
            showPlaceholder(false);
            return;
        }

        // thử load ảnh, nếu fail => placeholder
        const tester = new Image();
        tester.onload = () => showImage(v);
        tester.onerror = () => showPlaceholder(true);
        tester.src = v;
    }

    function calcFinal(){
        const p = parseFloat(priceInput?.value || "0") || 0;
        let d = parseFloat(discountInput?.value || "0") || 0;

        // clamp giảm giá không vượt giá (để đỡ "ảo")
        if (d > p) d = p;

        const f = Math.max(0, p - d);

        finalPrice.value = fmtVND(f);
        finalPriceHint.textContent = "Giá gốc: " + fmtVND(p) + " • Giảm: " + fmtVND(d);
    }

    if(urlInput) urlInput.addEventListener('input', updatePreview);
    if(priceInput) priceInput.addEventListener('input', calcFinal);
    if(discountInput) discountInput.addEventListener('input', calcFinal);

    // init: load từ DB nếu có
    updatePreview();
    calcFinal();
</script>

</body>
</html>
