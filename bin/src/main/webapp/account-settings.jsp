<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String role = request.getParameter("role");
	if (role == null || role.trim().isEmpty()) {
		role = "staff";
	}

	String roleName = "Staff";
	String sidebarColor = "#0D6EFD";
	String profileName = "Siti Aminah";
	String profileSubtitle = "Department Staff";
	String profileBadge = "Staff Profile";
	String email = "siti@example.com";
	String department = "Operations";
	String avatarIcon = "bi-person";
	String buttonClass = "btn-primary";

	if ("admin".equals(role)) {
		roleName = "System Admin";
		sidebarColor = "#950606";
		profileName = "System Admin";
		profileSubtitle = "Administration Account";
		profileBadge = "Admin Profile";
		email = "admin@example.com";
		department = "Not Applicable";
		avatarIcon = "bi-person-gear";
		buttonClass = "btn-danger";
	} else if ("departmentmanager".equals(role)) {
		roleName = "Department Manager";
		sidebarColor = "#4338CA";
		profileName = "Sarah Ahmad";
		profileSubtitle = "Sales Department Manager";
		profileBadge = "Department Profile";
		email = "sarah@example.com";
		department = "Sales";
		avatarIcon = "bi-person-badge";
	} else if ("financialmanager".equals(role)) {
		roleName = "Financial Manager";
		sidebarColor = "#0F766E";
		profileName = "Abu Bakar";
		profileSubtitle = "Financial Manager";
		profileBadge = "Finance Profile";
		email = "abu@example.com";
		department = "Finance";
		avatarIcon = "bi-person-check";
		buttonClass = "btn-success";
	} else {
		role = "staff";
	}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<jsp:include page="/includes/common-head.jsp" />
</head>

<body class="bg-light">
	<div class="container-fluid">
		<div class="row min-vh-100">
			<jsp:include page="/includes/sidebar.jsp">
				<jsp:param name="sidebarRole" value="<%= role %>" />
				<jsp:param name="activeMenu" value="settings" />
			</jsp:include>

			<main class="col-12 col-lg-10 p-4">
				<jsp:include page="/includes/page-header.jsp">
					<jsp:param name="pageTitle" value="Account Settings" />
					<jsp:param name="pageSubtitle" value="Manage your profile, contact details, password, and notification preferences." />
					<jsp:param name="pageRoleName" value="<%= roleName %>" />
				</jsp:include>

				<section class="row g-4">
					<div class="col-lg-4">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4 text-center">
								<div class="text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
									style="width: 92px; height: 92px; background-color: <%= sidebarColor %>;">
									<i class="bi <%= avatarIcon %> fs-1"></i>
								</div>
								<h5 class="fw-bold mb-1"><%= profileName %></h5>
								<p class="text-secondary mb-3"><%= profileSubtitle %></p>
							</div>
						</div>
					</div>

					<div class="col-lg-8">
						<form action="#" method="post">
							<div class="card border-0 shadow-sm rounded-4 mb-4">
								<div class="card-body p-4">
									<div class="d-flex justify-content-between align-items-center mb-3">
										<h5 class="fw-bold mb-0">
											<i class="bi bi-person-lines-fill me-2"></i> Profile Details
										</h5>
									</div>

									<div class="row g-3">
										<div class="col-md-6">
											<label class="form-label">Full Name</label>
											<input type="text" class="form-control rounded-3"
												name="fullName" value="<%= profileName %>">
										</div>
										<div class="col-md-6">
											<label class="form-label">Email Address</label>
											<input type="email" class="form-control rounded-3"
												name="email" value="<%= email %>">
										</div>
										<div class="col-md-6">
											<label class="form-label">Role</label>
											<input type="text" class="form-control rounded-3"
												value="<%= roleName %>" readonly>
										</div>
										<div class="col-md-6">
											<label class="form-label">Department</label>
											<input type="text" class="form-control rounded-3"
												value="<%= department %>" readonly>
										</div>
										<div class="col-md-6">
											<label class="form-label">Phone Number</label>
											<input type="text" class="form-control rounded-3"
												name="phone" placeholder="Example: 012-3456789">
										</div>
										<div class="col-md-6">
											<label class="form-label">Account Status</label>
											<input type="text" class="form-control rounded-3"
												value="Active" readonly>
										</div>
									</div>
								</div>
							</div>

							<div class="card border-0 shadow-sm rounded-4">
								<div class="card-body p-4">
									<h5 class="fw-bold mb-3">
										<i class="bi bi-shield-lock me-2"></i> Security and Preferences
									</h5>
									<div class="row g-3">
										<div class="col-md-6">
											<label class="form-label">New Password</label>
											<input type="password" class="form-control rounded-3"
												name="newPassword" placeholder="Enter new password">
										</div>
										<div class="col-md-6">
											<label class="form-label">Confirm Password</label>
											<input type="password" class="form-control rounded-3"
												name="confirmPassword" placeholder="Confirm new password">
										</div>
										<div class="col-12">
											<div class="form-check form-switch">
												<input class="form-check-input" type="checkbox"
													name="notifications" id="notifications" checked>
												<label class="form-check-label" for="notifications">
													Receive system, transaction, and AI advisory notifications
												</label>
											</div>
										</div>
										<div class="col-12 d-flex justify-content-end gap-2">
											<button type="reset" class="btn btn-outline-secondary rounded-pill px-4">
												Reset
											</button>
											<button type="submit" class="btn <%= buttonClass %> rounded-pill px-4">
												<i class="bi bi-save me-2"></i> Save Settings
											</button>
										</div>
									</div>
								</div>
							</div>
						</form>
					</div>
				</section>
			</main>
		</div>
	</div>
<jsp:include page="/includes/common-scripts.jsp" />
</body>
</html>
