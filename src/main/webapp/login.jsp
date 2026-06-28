<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>AI Financial Advisory System</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Bootstrap Icons -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

<style>
	body {
		min-height: 100vh;
		background-color: #eef3ff;
	}

	.login-left {
		min-height: 100vh;
		background: linear-gradient(135deg, #0d6efd 0%, #003b9f 100%);
		position: relative;
		overflow: hidden;
	}

	.login-left::before {
		content: "";
		position: absolute;
		width: 360px;
		height: 360px;
		border-radius: 50%;
		background: rgba(255, 255, 255, 0.08);
		top: -110px;
		right: -80px;
	}

	.login-left::after {
		content: "";
		position: absolute;
		width: 280px;
		height: 280px;
		border-radius: 50%;
		background: rgba(255, 255, 255, 0.08);
		bottom: -120px;
		left: -80px;
	}

	.login-left-content {
		position: relative;
		z-index: 2;
	}

	.feature-pill {
		background: rgba(255, 255, 255, 0.16);
		border: 1px solid rgba(255, 255, 255, 0.18);
		backdrop-filter: blur(8px);
	}

	.login-card {
		max-width: 430px;
		width: 100%;
		border-radius: 24px;
	}

	.input-group-text {
		border-right: 0;
	}

	.form-control {
		border-left: 0;
	}

	.form-control:focus {
		box-shadow: none;
		border-color: #dee2e6;
	}

	.input-group:focus-within .input-group-text,
	.input-group:focus-within .form-control {
		border-color: #0d6efd;
	}

	.password-eye {
		border-left: 0;
		background-color: #f8f9fa;
	}

	.login-btn {
		background: linear-gradient(90deg, #2563eb, #0047bd);
		border: 0;
	}

	.login-btn:hover {
		background: linear-gradient(90deg, #1d4ed8, #003b9f);
	}

	@media (max-width: 991px) {
		.login-left {
			min-height: auto;
			padding: 60px 24px;
		}
	}
</style>

</head>

<body>
<body>

<%
String error = request.getParameter("error");

if ("loginRequired".equals(error)) {
%>
<script>
    alert("Please login first.");
</script>
<%
}
%>
	<div class="container-fluid p-0">
		<div class="row g-0 min-vh-100">

			<!-- Left Branding Section -->
			<div class="col-lg-5 login-left d-flex align-items-center">
				<div class="login-left-content text-white px-5 py-5">

					<div class="d-flex align-items-center gap-2 mb-5">
						<i class="bi bi-folder2-open fs-3"></i>
						<div class="fw-bold lh-sm">
							Financial<br>Advisory
						</div>
					</div>

					<h1 class="display-5 fw-bold mb-4">
						Smart financial decisions start here.
					</h1>

					<p class="fs-5 opacity-75 mb-5">
						Company Financial Behavior Analysis & Advisory System gives your team
						complete visibility into revenue, expenses, and cashflow — all in one platform.
					</p>

					<div class="d-flex flex-column gap-4">
						<div class="feature-pill rounded-pill px-4 py-2 d-inline-flex align-items-center gap-2"
							style="width: fit-content;">
							<i class="bi bi-shield-check"></i>
							<span class="fw-semibold">Secured & Role-Based Access</span>
						</div>

						<div class="feature-pill rounded-pill px-4 py-2 d-inline-flex align-items-center gap-2"
							style="width: fit-content;">
							<i class="bi bi-graph-up-arrow"></i>
							<span class="fw-semibold">AI-Powered Advisory</span>
						</div>
					</div>

				</div>
			</div>

			<!-- Right Login Section -->
			<div class="col-lg-7 d-flex align-items-center justify-content-center px-4 py-5">
				<div class="login-card card border-0 shadow-sm">
					<div class="card-body p-5">

						<div class="mb-4">
							<h2 class="fw-bold mb-1">Welcome back</h2>
							<p class="text-secondary mb-0">
								Sign in to your account to continue
							</p>
						</div>

						<form action="LoginController" method="post">

							<div class="mb-3">
								<label class="form-label fw-semibold small">Email Address</label>
								<div class="input-group">
									<span class="input-group-text bg-white">
										<i class="bi bi-envelope text-secondary"></i>
									</span>
									<input type="email" class="form-control"
										name="email" placeholder="you@company.com" required>
								</div>
							</div>

							<div class="mb-3">
								<label class="form-label fw-semibold small">Password</label>
								<div class="input-group">
									<span class="input-group-text bg-white">
										<i class="bi bi-lock text-secondary"></i>
									</span>
									<input type="password" class="form-control"
										name="password" placeholder="Enter your password" required>
									<span class="input-group-text password-eye">
										<i class="bi bi-eye text-secondary"></i>
									</span>
								</div>
							</div>

							<div class="form-check mb-4">
								<input class="form-check-input" type="checkbox" id="rememberMe">
								<label class="form-check-label text-secondary" for="rememberMe">
									Remember me
								</label>
							</div>

							<button type="submit"
								class="btn btn-primary login-btn w-100 rounded-pill py-2 fw-semibold">
								<i class="bi bi-box-arrow-in-right me-2"></i> Log In
							</button>

						</form>

						<div class="text-center mt-4">
							<span class="text-secondary">Don't have an account?</span>
							<a href="register.jsp" class="text-decoration-none fw-bold">
								Register here
							</a>
						</div>

						<div class="d-flex align-items-center my-4">
							<hr class="flex-grow-1">
							<span class="px-3 text-secondary small">or</span>
							<hr class="flex-grow-1">
						</div>

						<div class="text-center">
							<a href="index.jsp" class="text-decoration-none fw-semibold">
								<i class="bi bi-house me-1"></i> Back to Home
							</a>
						</div>

						<hr class="my-4">

						<p class="text-center text-secondary small mb-0">
							© 2026 LKP RACER GROUP — Company Financial<br>
							Behavior Analysis & Advisory System
						</p>

					</div>
				</div>
			</div>

		</div>
	</div>

	<!-- Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>