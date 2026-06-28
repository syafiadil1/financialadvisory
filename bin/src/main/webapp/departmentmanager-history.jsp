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
				<jsp:param name="sidebarRole" value="departmentmanager" />
				<jsp:param name="activeMenu" value="transactions" />
			</jsp:include>

			<main class="col-12 col-lg-10 p-4">
				<jsp:include page="/includes/page-header.jsp">
					<jsp:param name="pageTitle" value="Transactions" />
					<jsp:param name="pageSubtitle" value="View pending, approved, and rejected department transactions in one listing." />
					<jsp:param name="pageRoleName" value="Department Manager" />
				</jsp:include>

				<section class="card border-0 shadow-sm rounded-4">
					<div class="card-body p-4">
						<div class="row g-3 mb-4">
							<div class="col-md-4">
								<label class="form-label">Search Transaction</label>
								<input type="text" class="form-control rounded-3"
									placeholder="Search by transaction, staff, or category">
							</div>
							<div class="col-md-3">
								<label class="form-label">Filter Category</label>
								<select class="form-select rounded-3">
									<option selected>All Categories</option>
									<option>Marketing</option>
									<option>Travel</option>
									<option>Supplies</option>
									<option>Training</option>
									<option>Utilities</option>
								</select>
							</div>
							<div class="col-md-2">
								<label class="form-label">Filter Status</label>
								<select class="form-select rounded-3">
									<option selected>All Status</option>
									<option>Pending</option>
									<option>Approved</option>
									<option>Rejected</option>
								</select>
							</div>
							<div class="col-md-2">
								<label class="form-label">Transaction Month</label>
								<input type="month" class="form-control rounded-3">
							</div>
							<div class="col-md-1 d-flex align-items-end">
								<button class="btn btn-primary w-100 rounded-pill">
									<i class="bi bi-search"></i>
								</button>
							</div>
						</div>

						<div class="table-responsive">
							<table class="table table-hover align-middle mb-0">
								<thead>
									<tr>
										<th>Date</th>
										<th>Transaction</th>
										<th>Submitted By</th>
										<th>Category</th>
										<th class="text-end">Amount</th>
										<th>Status</th>
										<th class="text-center">Action</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>2026-05-14</td>
										<td>Client Meeting Travel</td>
										<td>Aiman Hakim</td>
										<td>Travel</td>
										<td class="text-end text-danger fw-bold">RM 850.00</td>
										<td><span class="badge text-bg-warning rounded-pill">Pending</span></td>
										<td class="text-center">
											<a class="btn btn-sm btn-outline-primary rounded-pill"
												href="departmentmanager-transaction-details.jsp?id=travel-001">
												<i class="bi bi-eye me-1"></i>View Details
											</a>
										</td>
									</tr>
									<tr>
										<td>2026-05-13</td>
										<td>Marketing Material Printing</td>
										<td>Nur Sofia</td>
										<td>Marketing</td>
										<td class="text-end text-danger fw-bold">RM 1,250.00</td>
										<td><span class="badge text-bg-warning rounded-pill">Pending</span></td>
										<td class="text-center">
											<a class="btn btn-sm btn-outline-primary rounded-pill"
												href="departmentmanager-transaction-details.jsp?id=marketing-001">
												<i class="bi bi-eye me-1"></i>View Details
											</a>
										</td>
									</tr>
									<tr>
										<td>2026-05-10</td>
										<td>Social Media Advertisement</td>
										<td>Aiman Hakim</td>
										<td>Marketing</td>
										<td class="text-end text-danger fw-bold">RM 4,500.00</td>
										<td><span class="badge text-bg-success rounded-pill">Approved</span></td>
										<td class="text-center">
											<a class="btn btn-sm btn-outline-secondary rounded-pill"
												href="departmentmanager-transaction-details.jsp?id=marketing-002">
												<i class="bi bi-eye me-1"></i>View Details
											</a>
										</td>
									</tr>
									<tr>
										<td>2026-05-08</td>
										<td>Office Supplies</td>
										<td>Nur Sofia</td>
										<td>Supplies</td>
										<td class="text-end text-danger fw-bold">RM 750.00</td>
										<td><span class="badge text-bg-success rounded-pill">Approved</span></td>
										<td class="text-center">
											<a class="btn btn-sm btn-outline-secondary rounded-pill"
												href="departmentmanager-transaction-details.jsp?id=supplies-001">
												<i class="bi bi-eye me-1"></i>View Details
											</a>
										</td>
									</tr>
									<tr>
										<td>2026-05-02</td>
										<td>Marketing Workshop</td>
										<td>Aiman Hakim</td>
										<td>Training</td>
										<td class="text-end text-danger fw-bold">RM 2,300.00</td>
										<td><span class="badge text-bg-danger rounded-pill">Rejected</span></td>
										<td class="text-center">
											<a class="btn btn-sm btn-outline-secondary rounded-pill"
												href="departmentmanager-transaction-details.jsp?id=training-001">
												<i class="bi bi-eye me-1"></i>View Details
											</a>
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
