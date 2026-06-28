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
					<a class="nav-link text-white rounded-3" href="admin-user-list.jsp">
						<i class="bi bi-people me-2"></i> User List
					</a>
					<a class="nav-link active text-white rounded-3"
						style="background-color: #ff2c2c;" href="admin-department-list.jsp">
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
						<h1 class="fw-bold mb-1">Department List</h1>
						<p class="text-secondary mb-0">
							View departments created by the System Admin.
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
								<label class="form-label">Search Department</label>
								<input type="text" class="form-control rounded-3"
									placeholder="Search by department code or name">
							</div>

							<div class="col-md-3">
								<label class="form-label">Filter Manager</label>
								<select class="form-select rounded-3">
									<option selected>All Managers</option>
									<option>Abu Bakar</option>
									<option>Sarah Ahmad</option>
									<option>Mohd Farhan</option>
									<option>Not Assigned</option>
								</select>
							</div>

							<div class="col-md-3">
								<label class="form-label">Filter Status</label>
								<select class="form-select rounded-3">
									<option selected>All Status</option>
									<option>Active</option>
									<option>Inactive</option>
									<option>Pending Department Manager</option>
								</select>
							</div>

							<div class="col-md-1 d-flex align-items-end">
								<button class="btn btn-danger w-100 rounded-pill">
									<i class="bi bi-search"></i>
								</button>
							</div>
						</div>

						<div class="d-flex justify-content-end mb-4">
							<a class="btn btn-danger rounded-pill px-4" href="admin-department-details.jsp?action=create">
								<i class="bi bi-building-add me-2"></i>Create New Department
							</a>
						</div>

						<div class="table-responsive">
							<table class="table table-hover align-middle mb-0">
								<thead>
									<tr>
										<th>Department Code</th>
										<th>Department Name</th>
										<th>Assigned Department Manager</th>
										<th>Status</th>
										<th class="text-center">Action</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>DPT-001</td>
										<td>Finance</td>
										<td>Abu Bakar</td>
										<td><span class="badge text-bg-success rounded-pill">Active</span></td>
										<td class="text-center">
											<a class="btn btn-sm btn-outline-primary rounded-pill" href="admin-department-details.jsp?action=edit&id=dpt-001"><i class="bi bi-pencil-square"></i></a>
										</td>
									</tr>
									<tr>
										<td>DPT-002</td>
										<td>Sales</td>
										<td>Sarah Ahmad</td>
										<td><span class="badge text-bg-success rounded-pill">Active</span></td>
										<td class="text-center">
											<a class="btn btn-sm btn-outline-primary rounded-pill" href="admin-department-details.jsp?action=edit&id=dpt-002"><i class="bi bi-pencil-square"></i></a>
										</td>
									</tr>
									<tr>
										<td>DPT-005</td>
										<td>Operations</td>
										<td>Not Assigned</td>
										<td><span class="badge text-bg-warning rounded-pill">Pending Department Manager</span></td>
										<td class="text-center">
											<a class="btn btn-sm btn-outline-primary rounded-pill" href="admin-department-details.jsp?action=edit&id=dpt-005"><i class="bi bi-pencil-square"></i></a>
										</td>
									</tr>
									<tr>
										<td>DPT-006</td>
										<td>Information Technology</td>
										<td>Not Assigned</td>
										<td><span class="badge text-bg-warning rounded-pill">Pending Department Manager</span></td>
										<td class="text-center">
											<a class="btn btn-sm btn-outline-primary rounded-pill" href="admin-department-details.jsp?action=edit&id=dpt-006"><i class="bi bi-pencil-square"></i></a>
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
	<script src="js/chatbot-widget.js?v=2"></script>
</body>
</html>
