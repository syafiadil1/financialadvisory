<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String action = request.getParameter("action");
	boolean isCreate = "create".equals(action);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>AI Financial Advisory System</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="css/chatbot-widget.css?v=2">
</head>
<body class="bg-light">
	<div class="container-fluid">
		<div class="row min-vh-100">
			<aside class="col-12 col-lg-2 text-white p-4"
				style="background-color: #950606;">
				<h4 class="fw-bold mb-4">
					<i class="bi bi-shield-lock me-2"></i> System Admin
				</h4>
				<div class="nav flex-column nav-pills gap-2">
					<a class="nav-link text-white rounded-3" href="admin-user-list.jsp">
						<i class="bi bi-people me-2"></i> User List
					</a>
					<a class="nav-link text-white rounded-3" href="admin-department-list.jsp">
						<i class="bi bi-building me-2"></i> Department List
					</a>
					<a class="nav-link text-white rounded-3" href="account-settings.jsp?role=admin">
						<i class="bi bi-gear me-2"></i> Account Settings
					</a>
					<a class="nav-link text-white bg-danger rounded-3 mt-4 shadow-sm fw-bold" href="index.jsp">
						<i class="bi bi-box-arrow-right me-2"></i> <b>Logout</b>
					</a>
				</div>
			</aside>

			<main class="col-12 col-lg-10 p-4">
				<div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
					<div>
						<h1 class="fw-bold mb-1"><%= isCreate ? "Create User" : "User Details" %></h1>
						<p class="text-secondary mb-0">Create or update user profile, role, department, and account status.</p>
					</div>
					<a class="btn btn-outline-secondary rounded-pill px-4" href="admin-user-list.jsp">
						<i class="bi bi-arrow-left me-2"></i>Back to List
					</a>
				</div>

				<section class="card border-0 shadow-sm rounded-4">
					<div class="card-body p-4">
						<form action="#" method="post">
							<div class="row g-3">
								<div class="col-md-6">
									<label class="form-label">Full Name</label>
									<input type="text" class="form-control rounded-3" name="fullName"
										value="<%= isCreate ? "" : "Siti Aminah" %>" placeholder="Enter full name">
								</div>
								<div class="col-md-6">
									<label class="form-label">Email Address</label>
									<input type="email" class="form-control rounded-3" name="email"
										value="<%= isCreate ? "" : "siti@example.com" %>" placeholder="Enter email">
								</div>
								<div class="col-md-4">
									<label class="form-label">Role</label>
									<select class="form-select rounded-3" name="role">
										<option <%= isCreate ? "selected" : "" %>>Staff</option>
										<option>Department Manager</option>
										<option>Financial Manager</option>
										<option>System Admin</option>
									</select>
								</div>
								<div class="col-md-4">
									<label class="form-label">Department</label>
									<select class="form-select rounded-3" name="department">
										<option>Operations</option>
										<option>Finance</option>
										<option>Sales</option>
										<option>Information Technology</option>
										<option>Not Applicable</option>
									</select>
								</div>
								<div class="col-md-4">
									<label class="form-label">Account Status</label>
									<select class="form-select rounded-3" name="status">
										<option selected>Active</option>
										<option>Inactive</option>
									</select>
								</div>
								<div class="col-md-6">
									<label class="form-label">Temporary Password</label>
									<input type="password" class="form-control rounded-3" name="password"
										placeholder="<%= isCreate ? "Set temporary password" : "Leave blank to keep current password" %>">
								</div>
								<div class="col-md-6">
									<label class="form-label">Confirm Password</label>
									<input type="password" class="form-control rounded-3" name="confirmPassword"
										placeholder="Confirm password">
								</div>
								<div class="col-12 d-flex justify-content-end gap-2">
									<a class="btn btn-outline-secondary rounded-pill px-4" href="admin-user-list.jsp">Cancel</a>
									<button class="btn btn-danger rounded-pill px-4" type="submit">
										<i class="bi bi-save me-2"></i><%= isCreate ? "Create User" : "Save Changes" %>
									</button>
								</div>
							</div>
						</form>
					</div>
				</section>
			</main>
		</div>
	</div>

	<jsp:include page="/notification-widget.jsp" />
	<jsp:include page="/chatbot-widget.jsp" />
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
	<script src="js/chatbot-widget.js?v=2"></script>
</body>
</html>
