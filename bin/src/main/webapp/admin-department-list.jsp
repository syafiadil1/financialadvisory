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
				<jsp:param name="activeMenu" value="departments" />
			</jsp:include>

			<main class="col-12 col-lg-10 p-4">
				<jsp:include page="/includes/page-header.jsp">
					<jsp:param name="pageTitle" value="Department List" />
					<jsp:param name="pageSubtitle" value="View departments created by the System Admin." />
					<jsp:param name="pageRoleName" value="System Admin" />
				</jsp:include>

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
<jsp:include page="/includes/common-scripts.jsp" />
</body>
</html>
