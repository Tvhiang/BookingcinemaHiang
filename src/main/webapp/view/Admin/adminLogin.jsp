<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Đăng nhập hệ thống</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/view/Admin/assets/CSS/style_adminLogin.css" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />

</head>

<body>

	<!-- OVERLAY LOADING -->
	<div class="login-overlay" id="loginOverlay">
		<div class="loading-box">
			<div class="spinner-border text-light" role="status">
				<span class="visually-hidden">Loading...</span>
			</div>
			<p>Đang xác thực, vui lòng chờ...</p>
		</div>
	</div>

	<div class="login-card" id="loginCard">

		<h3 class="text-center mb-3">
			<i class="bi bi-person-circle"></i> Đăng nhập
		</h3>

		<!-- Hiển thị lỗi từ Servlet -->
		<c:if test="${not empty error}">
			<div class="alert alert-danger py-2 text-center">${error}</div>
		</c:if>

		<!-- Form login gửi về servlet /admin -->
		<form id="AdminloginForm"
			action="${pageContext.request.contextPath}/admin" method="post">

			<!-- USERNAME -->
			<div class="mb-3">
				<label class="form-label">Tên đăng nhập</label> <input type="text"
					class="form-control login-input" name="username"
					placeholder="Nhập username" value="${rememberedUser}" required>
			</div>

			<!-- PASSWORD -->
			<div class="mb-3">
				<label class="form-label">Mật khẩu</label> <input type="password"
					class="form-control login-input" name="password"
					placeholder="Nhập mật khẩu" required>
			</div>

			<!-- REMEMBER -->
			<div class="form-check mb-3">
				<input class="form-check-input" type="checkbox" id="remember"
					name="remember"> <label class="form-check-label"
					for="remember">Ghi nhớ đăng nhập</label>
			</div>

			<button type="submit" class="btn-login">Đăng nhập</button>

		</form>

	</div>

	<script>
    const loginForm = document.getElementById("loginForm");
    const loginCard = document.getElementById("loginCard");
    const loginOverlay = document.getElementById("loginOverlay");
    const inputs = document.querySelectorAll(".login-input");

    // card hơi zoom khi focus vào ô user/pass
    inputs.forEach(inp => {
        inp.addEventListener("focus", () => {
            loginCard.classList.add("focused");
        });
        inp.addEventListener("blur", () => {
            const anyFocused = Array.from(inputs).some(i => i === document.activeElement);
            if (!anyFocused) {
                loginCard.classList.remove("focused");
            }
        });
    });

    // hiệu ứng phóng to + overlay khi nhấn đăng nhập
    loginForm.addEventListener("submit", function (e) {
        if (!loginForm.checkValidity()) {
            return; 
        }

        e.preventDefault(); 
       
        loginCard.classList.add("login-anim");
        loginOverlay.classList.add("show");

    
        setTimeout(function () {
            loginForm.submit();
        }, 700);
    });
</script>

</body>
</html>