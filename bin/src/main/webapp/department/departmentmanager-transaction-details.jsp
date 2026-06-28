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
					<a class="nav-link text-white rounded-3" href="departmentmanager-category-list.jsp">
						<i class="bi bi-tags me-2"></i> Category
					</a>
					<a class="nav-link active text-white rounded-3"
						style="background-color: #312E81;" href="departmentmanager-history.jsp">
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
						<a class="btn btn-sm btn-outline-secondary rounded-pill mb-3"
							href="departmentmanager-history.jsp">
							<i class="bi bi-arrow-left me-1"></i>Back to Transactions
						</a>
						<h1 class="fw-bold mb-1">Transaction Details</h1>
						<p class="text-secondary mb-0">
							View submitted transaction data before approving or rejecting.
						</p>
					</div>

					<div class="card border-0 shadow-sm rounded-4 mt-3 mt-md-0 role-welcome-card">
						<div class="card-body py-2 px-3">
							<span class="text-secondary">Welcome, </span>
							<strong>Department Manager</strong>
						</div>
					</div>
				</div>

				<section class="row g-4">
					<div class="col-lg-8">
						<div class="card border-0 shadow-sm rounded-4 mb-4">
							<div class="card-body p-4">
								<div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
									<div>
										<h5 class="fw-bold mb-1">
											<i class="bi bi-receipt me-2"></i> Client Meeting Travel
										</h5>
										<p class="text-secondary mb-0">Submitted by Aiman Hakim on 14 May 2026.</p>
									</div>
								</div>

								<div class="row g-3 mb-4">
									<div class="col-md-4">
										<p class="text-secondary mb-1">Transaction Type</p>
										<strong>Expense</strong>
									</div>
									<div class="col-md-4">
										<p class="text-secondary mb-1">Category</p>
										<strong>Travel</strong>
									</div>
									<div class="col-md-4">
										<p class="text-secondary mb-1">Payment Method</p>
										<strong>Online Payment</strong>
									</div>
									<div class="col-md-4">
										<p class="text-secondary mb-1">Amount</p>
										<strong class="text-danger">RM 850.00</strong>
									</div>
									<div class="col-md-4">
										<p class="text-secondary mb-1">Department</p>
										<strong>Sales Department</strong>
									</div>
									<div class="col-md-4">
										<p class="text-secondary mb-1">Current Status</p>
										<strong class="text-warning">Pending Review</strong>
									</div>
								</div>

								<div class="mb-4">
									<p class="text-secondary mb-1">Reason</p>
									<div class="border rounded-4 p-3 bg-light">
										Travel cost for client meeting and sales discussion.
									</div>
								</div>

								<div class="table-responsive">
									<table class="table table-sm align-middle mb-0">
										<thead>
											<tr>
												<th>Item / Purpose</th>
												<th class="text-center">Quantity</th>
												<th class="text-end">Unit Price</th>
												<th class="text-end">Total</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>Transport to client office</td>
												<td class="text-center">1</td>
												<td class="text-end">RM 850.00</td>
												<td class="text-end fw-bold">RM 850.00</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>

					<div class="col-lg-4">
						<div class="card border-0 shadow-sm rounded-4">
							<div class="card-body p-4">
								<h5 class="fw-bold mb-3">
									<i class="bi bi-check2-circle me-2"></i> Review Decision
								</h5>

								<form action="#" method="post">
									<div class="mb-3">
										<label class="form-label">Department Manager Comment</label>
										<textarea class="form-control rounded-3" rows="4"
											placeholder="Add approval or rejection comment"></textarea>
									</div>

									<div class="d-grid gap-2">
										<button type="submit" class="btn btn-success rounded-pill">
											<i class="bi bi-check-circle me-2"></i>Approve Transaction
										</button>
										<button type="button" class="btn btn-outline-danger rounded-pill">
											<i class="bi bi-x-circle me-2"></i>Reject Transaction
										</button>
									</div>
								</form>
							</div>
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
