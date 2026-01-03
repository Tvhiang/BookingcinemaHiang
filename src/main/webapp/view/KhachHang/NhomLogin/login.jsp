<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Đăng nhập - CinemaDB</title>
   <jsp:include page="/view/KhachHang/Base/head.jsp"/>

  <style>
    .auth-bg{
      min-height: calc(100vh - 120px);
      display:flex; align-items:center; justify-content:center;
      position:relative;
    }
    .auth-bg::before{
      content:"";
      position:absolute; inset:0;
      background:
        radial-gradient(circle at 25% 15%, rgba(236,19,128,.18), transparent 55%),
        radial-gradient(circle at 75% 60%, rgba(255,77,109,.12), transparent 55%);
      pointer-events:none;
    }
    .auth-card{ width:100%; max-width:520px; }
    .form-control, .form-select{
      background: rgba(21,16,19,.65)!important;
      border:1px solid rgba(255,255,255,.10)!important;
      color:#fff!important;
      border-radius: 14px!important;
      padding: .75rem 1rem!important;
    }
    .form-control::placeholder{ color: rgba(255,255,255,.35); }
    .nav-pills .nav-link{
      border-radius: 14px;
      font-weight:900;
      color: rgba(255,255,255,.60);
      background: transparent;
    }
    .nav-pills .nav-link.active{
      background: rgba(255,255,255,.08);
      color:#fff;
      border:1px solid rgba(255,255,255,.10);
      box-shadow: 0 10px 30px rgba(0,0,0,.35);
    }
  </style>
</head>
<body>
<jsp:include page="/view/KhachHang/Base/header.jsp"/>
  <main class="container auth-bg py-5">
    <div class="auth-card glass overflow-hidden position-relative z-1">
      <div style="height:4px;background:linear-gradient(90deg, transparent, var(--primary), transparent); opacity:.8"></div>

      <div class="p-3" style="background:rgba(0,0,0,.18); border-bottom:1px solid rgba(255,255,255,.06);">
        <ul class="nav nav-pills nav-fill gap-2" id="authTab" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link active" id="login-tab" data-bs-toggle="pill" data-bs-target="#loginPane" type="button" role="tab">
              Đăng nhập
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="register-tab" data-bs-toggle="pill" data-bs-target="#registerPane" type="button" role="tab">
              Đăng ký
            </button>
          </li>
        </ul>
      </div>

      <div class="p-4 p-md-5">
        <div class="text-center mb-3">
          <h1 class="font-display" style="font-weight:900">Chào mừng!</h1>
          <div class="text-mutedx">Đăng nhập để đặt vé nhanh hơn.</div>
        </div>

        <c:if test="${not empty error}">
          <div class="alert alert-danger" role="alert">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
          <div class="alert alert-success" role="alert">${success}</div>
        </c:if>

        <div class="tab-content">
          <!-- LOGIN -->
          <div class="tab-pane fade show active" id="loginPane" role="tabpanel">
            <form method="post" action="${pageContext.request.contextPath}/login" class="mt-3">
              <input type="hidden" name="action" value="login"/>
              <input type="hidden" name="returnUrl" value="${param.returnUrl}"/>

              <div class="mb-3">
                <label class="form-label text-mutedx small fw-bold">Username / Email / SĐT</label>
                <input class="form-control" name="key" placeholder="vd: son123 hoặc example@gmail.com" required/>
              </div>
              <div class="mb-3">
                <label class="form-label text-mutedx small fw-bold">Mật khẩu</label>
                <input type="password" class="form-control" name="password" placeholder="••••••••" required/>
              </div>

              <button class="btn btn-primaryx w-100 py-3 mt-2">Đăng nhập</button>

              <div class="text-center text-mutedx small mt-3">
                Chưa có tài khoản? bấm tab <b>Đăng ký</b>.
              </div>
            </form>
          </div>

          <!-- REGISTER -->
          <div class="tab-pane fade" id="registerPane" role="tabpanel">
            <form method="post" action="${pageContext.request.contextPath}/login" class="mt-3">
              <input type="hidden" name="action" value="register"/>

              <div class="row g-3">
                <div class="col-12">
                  <label class="form-label text-mutedx small fw-bold">Username</label>
                  <input class="form-control" name="username" required/>
                </div>
                <div class="col-12">
                  <label class="form-label text-mutedx small fw-bold">Họ tên</label>
                  <input class="form-control" name="fullName"/>
                </div>
                <div class="col-md-6">
                  <label class="form-label text-mutedx small fw-bold">Email</label>
                  <input type="email" class="form-control" name="email"/>
                </div>
                <div class="col-md-6">
                  <label class="form-label text-mutedx small fw-bold">SĐT</label>
                  <input class="form-control" name="phone"/>
                </div>
                <div class="col-12">
                  <label class="form-label text-mutedx small fw-bold">Mật khẩu</label>
                  <input type="password" class="form-control" name="password" required/>
                </div>
              </div>

              <button class="btn btn-primaryx w-100 py-3 mt-3">Tạo tài khoản</button>
              <div class="text-center text-mutedx small mt-3">
                Tạo xong → quay lại tab <b>Đăng nhập</b>.
              </div>
            </form>
          </div>
        </div>
      </div>

      <div class="p-3 text-center text-mutedx small" style="background:rgba(0,0,0,.18); border-top:1px solid rgba(255,255,255,.06);">
        Bằng việc tiếp tục, bạn đồng ý Điều khoản & Chính sách bảo mật.
      </div>
    </div>
  </main>
  <jsp:include page="/view/KhachHang/Base/footer.jsp"/>
</body>
</html>
