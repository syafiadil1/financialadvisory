<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>

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

</head>

<body class="bg-light">

	<div class="container min-vh-100 d-flex align-items-center justify-content-center py-5">
		<div class="row w-100 justify-content-center">
			<div class="col-md-10 col-lg-7">

				<!-- Register Card -->
				<div class="card border-0 shadow-lg rounded-4">
					<div class="card-body p-5">

						<div class="text-center mb-4">
							<div
								class="bg-primary text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
								style="width: 70px; height: 70px;">
								<i class="bi bi-person-plus fs-2"></i>
							</div>

							<h3 class="fw-bold mb-1">Create Account</h3>
							<p class="text-secondary mb-0">
								Register to start managing company financial activities.
							</p>
						</div>

						<form action="#" method="post">

							<div class="row g-3">

								<div class="col-md-6">
									<label class="form-label">Full Name</label>
									<div class="input-group">
										<span class="input-group-text bg-white">
											<i class="bi bi-person"></i>
										</span>
										<input type="text" class="form-control"
											name="fullName" placeholder="Enter full name" required>
									</div>
								</div>

								<div class="col-md-6">
									<label class="form-label">Email Address</label>
									<div class="input-group">
										<span class="input-group-text bg-white">
											<i class="bi bi-envelope"></i>
										</span>
										<input type="email" class="form-control"
											name="email" placeholder="Enter email address" required>
									</div>
								</div>

								<div class="col-md-6">
									<label class="form-label">Company Name</label>
									<div class="input-group">
										<span class="input-group-text bg-white">
											<i class="bi bi-building"></i>
										</span>
										<input type="text" class="form-control"
											name="companyName" placeholder="Enter company name" required>
									</div>
								</div>

								<div class="col-md-6">
									<label class="form-label">User Role</label>
									<div class="input-group">
										<span class="input-group-text bg-white">
											<i class="bi bi-person-badge"></i>
										</span>
										<select class="form-select" name="role" required>
											<option selected disabled>Select role</option>
											<option value="financial-manager">Financial Manager</option>
											<option value="department-manager">Department Manager</option>
											<option value="staff">Staff</option>
										</select>
									</div>
								</div>

								<div class="col-md-6">
									<label class="form-label">Password</label>
									<div class="input-group">
										<span class="input-group-text bg-white">
											<i class="bi bi-lock"></i>
										</span>
										<input type="password" class="form-control"
											name="password" placeholder="Create password" required>
									</div>
								</div>

								<div class="col-md-6">
									<label class="form-label">Confirm Password</label>
									<div class="input-group">
										<span class="input-group-text bg-white">
											<i class="bi bi-shield-lock"></i>
										</span>
										<input type="password" class="form-control"
											name="confirmPassword" placeholder="Confirm password" required>
									</div>
								</div>

								<div class="col-12">
									<div class="form-check mt-2">
										<input class="form-check-input" type="checkbox"
											id="termsCheck" required>
										<label class="form-check-label" for="termsCheck">
											I agree to use this system for company financial record management.
										</label>
									</div>
								</div>

								<div class="col-12 mt-4">
									<a href="login.jsp" class="btn btn-primary w-100 rounded-pill py-2">
										<i class="bi bi-person-check me-2"></i> Register Account
									</a>
								</div>

							</div>
						</form>

						<div class="text-center mt-4">
							<p class="text-secondary mb-0">
								Already have an account?
								<a href="login.jsp" class="text-decoration-none fw-semibold">
									Login here
								</a>
							</p>
						</div>

					</div>
				</div>

				<div class="text-center mt-4">
					<a href="index.jsp" class="text-decoration-none">
						<i class="bi bi-arrow-left me-2"></i> Back to Home
					</a>
				</div>

			</div>
		</div>
	</div>

	<!-- Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
