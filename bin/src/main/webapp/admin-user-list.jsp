<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
<head>
<jsp:include page="/includes/common-head.jsp" />
</head>

<body class="bg-light">
	<div class="container-fluid">
		<div class="row min-vh-100">
			<jsp:include page="/includes/sidebar.jsp">
				<jsp:param name="sidebarRole" value="admin" />
				<jsp:param name="activeMenu" value="users" />
			</jsp:include>

			<main class="col-12 col-lg-10 p-4">
				<jsp:include page="/includes/page-header.jsp">
					<jsp:param name="pageTitle" value="User List" />
					<jsp:param name="pageSubtitle" value="View and manage users created by the System Admin." />
					<jsp:param name="pageRoleName" value="System Admin" />
				</jsp:include>

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
<jsp:include page="/includes/common-scripts.jsp" />
</body>
</html>
