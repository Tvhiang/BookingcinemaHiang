<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header class="topbar">
  <div class="container py-3">
    <div class="d-flex align-items-center justify-content-between gap-3">
      <a class="d-flex align-items-center gap-2 text-decoration-none" href="${pageContext.request.contextPath}/home">
        <span class="brand-dot"></span>
        <span class="font-display fw-black" style="font-weight:900; letter-spacing:-.02em; color:#fff; font-size:1.35rem">
          Cinema<span style="color:var(--primary)">DB</span>
        </span>
      </a>
       <a class="btn btn-primaryx px-4" href="${pageContext.request.contextPath}/my-bookings">Lịch sử Mua vé</a>	
      <div class="d-flex align-items-center gap-2">
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <div class="d-none d-md-flex align-items-center px-3 py-2 glass-soft">
              <span class="text-mutedx me-2">Xin chào</span>
              <span class="fw-bold">${sessionScope.user.fullName}</span>
            </div>
            <a class="btn btn-outline-lightx px-3 fw-bold" href="${pageContext.request.contextPath}/logout">Logout</a>
          </c:when>
          <c:otherwise>
            <a class="btn btn-primaryx px-4" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</header>
