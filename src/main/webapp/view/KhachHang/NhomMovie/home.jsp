<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Home - CinemaDB</title>
   <jsp:include page="/view/KhachHang/Base/head.jsp"/>
  <style>
    .hero{
      border-radius: 24px;
      overflow:hidden;
      position:relative;
      background: radial-gradient(circle at 30% 20%, rgba(236,19,128,.18), transparent 55%),
                  radial-gradient(circle at 70% 60%, rgba(255,77,109,.12), transparent 55%),
                  rgba(30,18,22,.65);
      border:1px solid rgba(255,255,255,.08);
      box-shadow: 0 18px 60px rgba(0,0,0,.50);
    }
    .movie-card{
      border-radius: 18px; overflow:hidden;
      border:1px solid rgba(255,255,255,.08);
      background: rgba(38,24,29,.55);
      transition: all .18s ease;
      height: 100%;
    }
    .movie-card:hover{ transform: translateY(-3px); border-color: rgba(236,19,128,.25); }
    .poster{
      width:100%; aspect-ratio:2/3; object-fit:cover;
      filter: saturate(1.05) contrast(1.05);
    }
    .movie-title{ font-weight:900; letter-spacing:-.01em; }
  </style>
</head>
<body>
<jsp:include page="/view/KhachHang/Base/header.jsp"/>
  <main class="container py-4 py-md-5">

    <section class="hero p-4 p-md-5 mb-4">
      <div class="row align-items-center g-4">
        <div class="col-lg-7">
          <h1 class="font-display" style="font-weight:900; font-size: clamp(28px, 4vw, 46px);">
            Đặt vé xem phim <span style="color:var(--primary)">nhanh</span> & <span style="color:var(--primary)">gọn, lẹ</span>
          </h1>
          <p class="text-mutedx mt-3 mb-4" style="max-width: 52ch;">
           Đặt vé nhanh chóng gọn lẹ tiết kiệm thời gian
          </p>
          <div class="d-flex gap-2 flex-wrap">
            <a class="btn btn-primaryx px-4" href="${pageContext.request.contextPath}/movies?status=SHOWING">Xem phim đang chiếu</a>
            <a class="btn btn-outline-lightx px-4" href="${pageContext.request.contextPath}/movies">Tất cả phim</a>
          </div>
        </div>
        <div class="col-lg-5">
          <div class="glass-soft p-3">	
            <div class="text-mutedx small">Gợi ý</div>
            <div class="fw-bold">Tìm phim → chọn suất chiếu ở trang Chi tiết phim</div>
            <div class="text-mutedx small mt-2">Tip: Nếu chưa đăng nhập, vui lòng đăng nhập để đặt vé.</div>
          </div>
        </div>
      </div>
    </section>

    <!-- SHOWING -->
    <div class="d-flex justify-content-between align-items-end mb-3">
      <div>
        <h3 class="font-display mb-1" style="font-weight:900">Phim đang chiếu</h3>
        <div class="text-mutedx">Top phim nổi bật</div>
      </div>
      <a class="btn btn-outline-lightx" href="${pageContext.request.contextPath}/movies?status=SHOWING">Xem tất cả</a>
    </div>

    <div class="row g-3 g-md-4 mb-5">
      <c:forEach var="m" items="${showing}">
        <div class="col-6 col-md-4 col-lg-3">
          <div class="movie-card">
            <a class="text-decoration-none" href="${pageContext.request.contextPath}/movie-detail?id=${m.movieId}">
              <img class="poster" src="${m.posterUrl}" alt="${m.title}"/>
            </a>
            <div class="p-3">
              <div class="movie-title mb-1">${m.title}</div>
              <div class="text-mutedx small">${m.genre}</div>
              <div class="d-flex gap-2 mt-2 flex-wrap">
                <span class="badge badge-soft">${m.status}</span>
                <c:if test="${not empty m.ageRating}">
                  <span class="badge badge-age">${m.ageRating}</span>
                </c:if>
              </div>
              <div class="mt-3 d-grid">
                <a class="btn btn-primaryx" href="${pageContext.request.contextPath}/movie-detail?id=${m.movieId}">Xem chi tiết</a>
              </div>
            </div>
          </div>
        </div>
      </c:forEach>

      <c:if test="${empty showing}">
        <div class="col-12">
          <div class="glass p-4 text-center text-mutedx">Chưa có phim đang chiếu.</div>
        </div>
      </c:if>
    </div>

    <!-- COMING SOON -->
    <div class="d-flex justify-content-between align-items-end mb-3">
      <div>
        <h3 class="font-display mb-1" style="font-weight:900">Phim sắp chiếu</h3>
        <div class="text-mutedx">Danh sách dự kiến</div>
      </div>
      <a class="btn btn-outline-lightx" href="${pageContext.request.contextPath}/movies?status=COMING_SOON">Xem tất cả</a>
    </div>

    <div class="row g-3 g-md-4">
      <c:forEach var="m" items="${coming}">
        <div class="col-6 col-md-4 col-lg-3">
          <div class="movie-card">
            <a class="text-decoration-none" href="${pageContext.request.contextPath}/movie-detail?id=${m.movieId}">
              <img class="poster" src="${m.posterUrl}" alt="${m.title}"/>
            </a>
            <div class="p-3">
              <div class="movie-title mb-1">${m.title}</div>
              <div class="text-mutedx small">${m.genre}</div>
              <div class="d-flex gap-2 mt-2 flex-wrap">
                <span class="badge badge-soft">${m.status}</span>
                <c:if test="${not empty m.ageRating}">
                  <span class="badge badge-age">${m.ageRating}</span>
                </c:if>
              </div>
              <div class="mt-3 d-grid">
                <a class="btn btn-outline-lightx" href="${pageContext.request.contextPath}/movie-detail?id=${m.movieId}">Xem chi tiết</a>
              </div>
            </div>
          </div>
        </div>
      </c:forEach>

      <c:if test="${empty coming}">
        <div class="col-12">
          <div class="glass p-4 text-center text-mutedx">Chưa có phim sắp chiếu.</div>
        </div>
      </c:if>
    </div>

  </main>
  
</body>
</html>

