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
				style="background-color: #4338CA;">
				<h4 class="fw-bold mb-4">
					<i class="bi bi-person-badge me-2"></i> Department Manager
				</h4>
				<div class="nav flex-column nav-pills gap-2">
					<a class="nav-link text-white rounded-3" href="dashboard.jsp?role=departmentmanager">
						<i class="bi bi-speedometer2 me-2"></i> Dashboard
					</a>
					<a class="nav-link text-white rounded-3" href="departmentmanager-budget.jsp">
						<i class="bi bi-wallet2 me-2"></i> Budget Management
					</a>
					<a class="nav-link active text-white rounded-3"
						style="background-color: #312E81;" href="departmentmanager-category-list.jsp">
						<i class="bi bi-tags me-2"></i> Category
					</a>
					<a class="nav-link text-white rounded-3" href="departmentmanager-history.jsp">
						<i class="bi bi-receipt me-2"></i> Transactions
					</a>
					<a class="nav-link text-white rounded-3" href="aiadvisory.jsp?role=departmentmanager">
						<i class="bi bi-robot me-2"></i> AI Advisory
					</a>
					<a class="nav-link text-white rounded-3" href="account-settings.jsp?role=departmentmanager">
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
						<h1 class="fw-bold mb-1">Category Management</h1>
						<p class="text-secondary mb-0">
							Create, edit, and manage transaction categories for your department.
						</p>
					</div>

					<div class="card border-0 shadow-sm rounded-4 mt-3 mt-md-0 role-welcome-card">
						<div class="card-body py-2 px-3">
							<span class="text-secondary">Welcome, </span>
							<strong>Department Manager</strong>
						</div>
					</div>
				</div>

				<!-- Category List Section -->
				<section class="card border-0 shadow-sm rounded-4">
					<div class="card-body p-4">
						<!-- Filters -->
						<div class="row g-3 mb-4">
							<div class="col-md-4">
								<label class="form-label">Search Category</label>
								<input type="text" class="form-control rounded-3"
									placeholder="Search by category name">
							</div>
							<div class="col-md-3">
								<label class="form-label">Filter Type</label>
								<select class="form-select rounded-3">
									<option selected>All</option>
									<option>Expense</option>
									<option>Income</option>
								</select>
							</div>
							<div class="col-md-3">
								<label class="form-label">Filter Visibility</label>
								<select class="form-select rounded-3">
									<option selected>All</option>
									<option>Public</option>
									<option>Private</option>
								</select>
							</div>
							<div class="col-md-2 d-flex align-items-end">
								<button class="btn btn-primary w-100 rounded-pill">
									<i class="bi bi-search"></i>
								</button>
							</div>
						</div>

						<!-- Add Category Button -->
						<div class="d-flex justify-content-end mb-3">
							<a class="btn btn-primary rounded-pill px-4"
								href="departmentmanager-category-details.jsp?action=create">
								<i class="bi bi-plus-circle me-2"></i>Add Category
							</a>
						</div>

						<!-- Table -->
						<div class="table-responsive">
							<table class="table table-hover align-middle mb-0">
								<thead>
									<tr>
										<th>No.</th>
										<th>Category Name</th>
										<th>Description</th>
										<th>Type</th>
										<th>Is Public</th>
										<th class="text-center">Action</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>1</td>
										<td class="fw-bold">Marketing</td>
										<td>Expenses related to marketing and advertising campaigns.</td>
										<td><span class="badge text-bg-danger rounded-pill">Expense</span></td>
										<td><span class="badge text-bg-primary rounded-pill">Public</span></td>
										<td class="text-center">
											<a href="departmentmanager-category-details.jsp?action=edit&id=cat-001"
												class="btn btn-sm btn-outline-primary rounded-pill me-1">
												<i class="bi bi-pencil-square"></i>
											</a>
											<a href="#" class="btn btn-sm btn-outline-danger rounded-pill">
												<i class="bi bi-trash"></i>
											</a>
										</td>
									</tr>
									<tr>
										<td>2</td>
										<td class="fw-bold">Travel</td>
										<td>Travel and transportation costs for business purposes.</td>
										<td><span class="badge text-bg-danger rounded-pill">Expense</span></td>
										<td><span class="badge text-bg-secondary rounded-pill">Private</span></td>
										<td class="text-center">
											<a href="departmentmanager-category-details.jsp?action=edit&id=cat-002"
												class="btn btn-sm btn-outline-primary rounded-pill me-1">
												<i class="bi bi-pencil-square"></i>
											</a>
											<a href="#" class="btn btn-sm btn-outline-danger rounded-pill">
												<i class="bi bi-trash"></i>
											</a>
										</td>
									</tr>
									<tr>
										<td>3</td>
										<td class="fw-bold">Supplies</td>
										<td>Office supplies and equipment purchases.</td>
										<td><span class="badge text-bg-danger rounded-pill">Expense</span></td>
										<td><span class="badge text-bg-primary rounded-pill">Public</span></td>
										<td class="text-center">
											<a href="departmentmanager-category-details.jsp?action=edit&id=cat-003"
												class="btn btn-sm btn-outline-primary rounded-pill me-1">
												<i class="bi bi-pencil-square"></i>
											</a>
											<a href="#" class="btn btn-sm btn-outline-danger rounded-pill">
												<i class="bi bi-trash"></i>
											</a>
										</td>
									</tr>
									<tr>
										<td>4</td>
										<td class="fw-bold">Training</td>
										<td>Staff training, workshops, and professional development.</td>
										<td><span class="badge text-bg-danger rounded-pill">Expense</span></td>
										<td><span class="badge text-bg-secondary rounded-pill">Private</span></td>
										<td class="text-center">
											<a href="departmentmanager-category-details.jsp?action=edit&id=cat-004"
												class="btn btn-sm btn-outline-primary rounded-pill me-1">
												<i class="bi bi-pencil-square"></i>
											</a>
											<a href="#" class="btn btn-sm btn-outline-danger rounded-pill">
												<i class="bi bi-trash"></i>
											</a>
										</td>
									</tr>
									<tr>
										<td>5</td>
										<td class="fw-bold">Client Revenue</td>
										<td>Income received from client projects and services.</td>
										<td><span class="badge text-bg-success rounded-pill">Income</span></td>
										<td><span class="badge text-bg-primary rounded-pill">Public</span></td>
										<td class="text-center">
											<a href="departmentmanager-category-details.jsp?action=edit&id=cat-005"
												class="btn btn-sm btn-outline-primary rounded-pill me-1">
												<i class="bi bi-pencil-square"></i>
											</a>
											<a href="#" class="btn btn-sm btn-outline-danger rounded-pill">
												<i class="bi bi-trash"></i>
											</a>
										</td>
									</tr>
									<tr>
										<td>6</td>
										<td class="fw-bold">Utilities</td>
										<td>Monthly utility bills including electricity, water, and internet.</td>
										<td><span class="badge text-bg-danger rounded-pill">Expense</span></td>
										<td><span class="badge text-bg-secondary rounded-pill">Private</span></td>
										<td class="text-center">
											<a href="departmentmanager-category-details.jsp?action=edit&id=cat-006"
												class="btn btn-sm btn-outline-primary rounded-pill me-1">
												<i class="bi bi-pencil-square"></i>
											</a>
											<a href="#" class="btn btn-sm btn-outline-danger rounded-pill">
												<i class="bi bi-trash"></i>
											</a>
										</td>
									</tr>
								</tbody>
							</table>
						</div>

						<!-- Pagination -->
						<nav class="mt-3">
							<ul class="pagination justify-content-end mb-0">
								<li class="page-item disabled"><a class="page-link">Previous</a></li>
								<li class="page-item active"><a class="page-link" href="#">1</a></li>
								<li class="page-item"><a class="page-link" href="#">2</a></li>
								<li class="page-item"><a class="page-link" href="#">Next</a></li>
							</ul>
						</nav>
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
