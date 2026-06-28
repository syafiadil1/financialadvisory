<%@ page contentType="text/html;charset=UTF-8" language="java"%>

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
					<a class="nav-link active text-white rounded-3"
						style="background-color: #ff2c2c;" href="<%= request.getContextPath() %>/admin/admin-user-list.jsp">
						<i class="bi bi-people me-2"></i> User List
					</a>
					<a class="nav-link text-white rounded-3" href="<%= request.getContextPath() %>/admin/admin-department-list.jsp">
						<i class="bi bi-building me-2"></i> Department List
					</a>
					<a class="nav-link text-white rounded-3" href="<%= request.getContextPath() %>/account-settings.jsp?role=admin">
						<i class="bi bi-gear me-2"></i> Account Settings
					</a>

					<a class="nav-link text-white bg-danger rounded-3 mt-4 shadow-sm fw-bold" href="<%= request.getContextPath() %>/logout">
						<i class="bi bi-box-arrow-right me-2"></i> <b>Logout</b>
					</a>
				</div>
			</aside>

			<main class="col-12 col-lg-10 p-4">
				<div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
					<div>
						<h1 class="fw-bold mb-1">User List</h1>
						<p class="text-secondary mb-0">
							View and manage users created by the System Admin.
						</p>
					</div>

					<div class="card border-0 shadow-sm rounded-4 mt-3 mt-md-0 role-welcome-card">
						<div class="card-body py-2 px-3">
							<span class="text-secondary">Welcome, </span>
							<strong>System Admin</strong>
						</div>
					</div>
				</div>

				<section class="card border-0 shadow-sm rounded-4">
					<div class="card-body p-4">
						<div class="row g-3 mb-3">
							<div class="col-md-5">
								<label class="form-label">Search User</label>
								<input type="text" class="form-control rounded-3"
									placeholder="Search by name or email">
							</div>
							<div class="col-md-3">
								<label class="form-label">Filter Role</label>
								<select class="form-select rounded-3">
									<option selected>All Roles</option>
									<option>System Admin</option>
									<option>Financial Manager</option>
									<option>Department Manager</option>
									<option>Staff</option>
								</select>
							</div>
							<div class="col-md-3">
								<label class="form-label">Filter Department</label>
								<select class="form-select rounded-3">
									<option selected>All Departments</option>
									<option>Finance</option>
									<option>Sales</option>
									<option>Operations</option>
									<option>Information Technology</option>
								</select>
							</div>
							<div class="col-md-1 d-flex align-items-end">
								<button class="btn btn-danger w-100 rounded-pill">
									<i class="bi bi-search"></i>
								</button>
							</div>
						</div>

						<div class="d-flex justify-content-end mb-4">
							<a class="btn btn-danger rounded-pill px-4" href="admin-user-details.jsp?action=create">
								<i class="bi bi-person-plus me-2"></i>Create New User
							</a>
						</div>

						<div class="table-responsive">
							<table class="table table-hover align-middle mb-0">
								<thead>
									<tr>
										<th>User</th>
										<th>Email</th>
										<th>Role</th>
										<th>Department</th>
										<th>Status</th>
										<th class="text-center">Action</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td><strong>System Admin</strong></td>
										<td>admin@example.com</td>
										<td><span class="badge text-bg-danger rounded-pill">System Admin</span></td>
										<td>Not Applicable</td>
										<td><span class="badge text-bg-success rounded-pill">Active</span></td>
										<td class="text-center">
											<span class="text-secondary">Not Applicable</span>
										</td>
									</tr>
									<tr>
										<td><strong>Abu Bakar</strong></td>
										<td>abu@example.com</td>
										<td><span class="badge text-bg-primary rounded-pill">Financial Manager</span></td>
										<td>Finance</td>
										<td><span class="badge text-bg-success rounded-pill">Active</span></td>
										<td class="text-center">
											<a class="btn btn-sm btn-outline-primary rounded-pill" href="admin-user-details.jsp?action=edit&id=abu"><i class="bi bi-pencil-square"></i></a>
										</td>
									</tr>
									<tr>
										<td><strong>Sarah Ahmad</strong></td>
										<td>sarah@example.com</td>
										<td><span class="badge text-bg-warning rounded-pill">Department Manager</span></td>
										<td>Sales</td>
										<td><span class="badge text-bg-success rounded-pill">Active</span></td>
										<td class="text-center">
											<a class="btn btn-sm btn-outline-primary rounded-pill" href="admin-user-details.jsp?action=edit&id=sarah"><i class="bi bi-pencil-square"></i></a>
										</td>
									</tr>
									<tr>
										<td><strong>Siti Aminah</strong></td>
										<td>siti@example.com</td>
										<td><span class="badge text-bg-secondary rounded-pill">Staff</span></td>
										<td>Operations</td>
										<td><span class="badge text-bg-success rounded-pill">Active</span></td>
										<td class="text-center">
											<a class="btn btn-sm btn-outline-primary rounded-pill" href="admin-user-details.jsp?action=edit&id=siti"><i class="bi bi-pencil-square"></i></a>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</section>
			</main>
		</div>
	</div>

	<jsp:include page="/notification-widget.jsp" />
	<jsp:include page="/chatbot-widget.jsp" />
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
	<script src="<%= request.getContextPath() %>/js/chatbot-widget.js?v=2"></script>
</body>
</html>
