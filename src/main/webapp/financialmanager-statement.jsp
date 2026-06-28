<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:redirect url="dashboard.jsp?role=financialmanager#company-statement" />

<!DOCTYPE html>
<html lang="en">
<head>
<jsp:include page="/includes/common-head.jsp" />
</head>

<body class="bg-light">
	<div class="container-fluid">
		<div class="row min-vh-100">
			<jsp:include page="/includes/sidebar.jsp">
				<jsp:param name="sidebarRole" value="financialmanager" />
				<jsp:param name="activeMenu" value="" />
			</jsp:include>

			<main class="col-12 col-lg-10 p-4">
				<jsp:include page="/includes/page-header.jsp">
					<jsp:param name="pageTitle" value="Generate Company Statement" />
					<jsp:param name="pageSubtitle" value="Generate summary statement for company revenue, expenses, and net profit." />
					<jsp:param name="pageRoleName" value="Financial Manager" />
				</jsp:include>

				<!-- Statement Filter -->
				<section class="card border-0 shadow-sm rounded-4 mb-4">
					<div class="card-body p-4">
						<div class="d-flex justify-content-between align-items-center mb-3">
							<h5 class="fw-bold mb-0">
								<i class="bi bi-funnel me-2"></i> Statement Period
							</h5>
						</div>

						<form action="#" method="post">
							<div class="row g-3 align-items-end">
								<div class="col-md-3">
									<label class="form-label">Statement Month</label>
									<select class="form-select rounded-3" name="statementMonth">
										<option selected>June</option>
										<option>May</option>
										<option>April</option>
										<option>March</option>
									</select>
								</div>

								<div class="col-md-3">
									<label class="form-label">Statement Year</label>
									<select class="form-select rounded-3" name="statementYear">
										<option selected>2026</option>
										<option>2025</option>
										<option>2024</option>
									</select>
								</div>

								<div class="col-md-3">
									<label class="form-label">Statement Type</label>
									<select class="form-select rounded-3" name="statementType">
										<option selected>Monthly Statement</option>
										<option>Quarterly Statement</option>
										<option>Yearly Statement</option>
									</select>
								</div>

								<div class="col-md-3">
									<button class="btn btn-primary rounded-pill w-100" type="submit">
										<i class="bi bi-file-earmark-text me-2"></i> Generate Preview
									</button>
								</div>
							</div>
						</form>
					</div>
				</section>

				<!-- Statement Summary -->
				<section class="row g-4 mb-4">
					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Total Revenue</p>
								<h3 class="fw-bold mb-2">RM 67,676,767.00</h3>
								<small class="text-success">Income received</small>
							</div>
						</div>
					</div>

					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Total Expenses</p>
								<h3 class="fw-bold mb-2">RM 676,767.00</h3>
								<small class="text-danger">Verified expenses</small>
							</div>
						</div>
					</div>

					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Net Profit</p>
								<h3 class="fw-bold text-success mb-2">RM 67,000,000.00</h3>
								<small class="text-success">Positive statement</small>
							</div>
						</div>
					</div>

					<div class="col-md-6 col-xl-3">
						<div
							class="card border-0 shadow-sm rounded-4 h-100 border-start border-success border-5">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Cashflow Status</p>
								<h3 class="fw-bold mb-2">Healthy</h3>
								<small class="text-success">Revenue exceeds expenses</small>
							</div>
						</div>
					</div>
				</section>

				<!-- Company Statement Preview -->
				<section class="card border-0 shadow-sm rounded-4 mb-4">
					<div class="card-body p-4">
						<div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
							<div>
								<h5 class="fw-bold mb-1">
									<i class="bi bi-file-earmark-bar-graph me-2"></i> Company Statement Preview
								</h5>
								<p class="text-secondary mb-0">
									Statement for June 2026 generated from verified company transactions.
								</p>
							</div>
						</div>

						<div class="row g-4 mb-4">
							<div class="col-md-6">
								<div class="border rounded-4 p-3 h-100">
									<p class="text-secondary mb-1">Company</p>
									<h6 class="fw-bold mb-1">LKP RACER GROUP</h6>
									<small class="text-secondary">Company Financial Behavior Analysis & Advisory System</small>
								</div>
							</div>

							<div class="col-md-6">
								<div class="border rounded-4 p-3 h-100">
									<p class="text-secondary mb-1">Generated By</p>
									<h6 class="fw-bold mb-1">Financial Manager</h6>
									<small class="text-secondary">Generated Date: 30 May 2026</small>
								</div>
							</div>
						</div>

						<div class="table-responsive mb-4">
							<table class="table table-hover align-middle">
								<thead>
									<tr>
										<th>Statement Item</th>
										<th>Description</th>
										<th class="text-end">Amount</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>Total Revenue</td>
										<td>All verified income transactions for the selected period.</td>
										<td class="text-end text-success">RM 67,676,767.00</td>
									</tr>
									<tr>
										<td>Total Expenses</td>
										<td>All verified expense transactions for the selected period.</td>
										<td class="text-end text-danger">RM 676,767.00</td>
									</tr>
									<tr>
										<td class="fw-bold">Net Profit</td>
										<td class="fw-bold">Total revenue minus total expenses.</td>
										<td class="text-end fw-bold text-success">RM 67,000,000.00</td>
									</tr>
								</tbody>
							</table>
						</div>

						<div class="alert alert-success rounded-4 mb-0">
							<h6 class="fw-bold mb-1">Statement Conclusion</h6>
							<p class="mb-0">
								The company is in a healthy financial position for this period because
								revenue is higher than expenses, resulting in positive net profit.
							</p>
						</div>
					</div>
				</section>

				<!-- Transaction Summary and Export Actions -->
				<section class="row g-4">
					<div class="col-lg-6">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<h5 class="fw-bold mb-3">
									<i class="bi bi-list-ul me-2"></i> Statement Transaction Summary
								</h5>

								<div class="table-responsive">
									<table class="table table-hover align-middle mb-0">
										<thead>
											<tr>
												<th>Category</th>
												<th>Type</th>
												<th class="text-end">Amount</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>Sales</td>
												<td>
													<span class="badge rounded-pill text-bg-success">Income</span>
												</td>
												<td class="text-end">RM 67,676,767.00</td>
											</tr>
											<tr>
												<td>Rent</td>
												<td>
													<span class="badge rounded-pill text-bg-danger">Expense</span>
												</td>
												<td class="text-end">RM 400,000.00</td>
											</tr>
											<tr>
												<td>Utilities</td>
												<td>
													<span class="badge rounded-pill text-bg-danger">Expense</span>
												</td>
												<td class="text-end">RM 76,767.00</td>
											</tr>
											<tr>
												<td>Supplies</td>
												<td>
													<span class="badge rounded-pill text-bg-danger">Expense</span>
												</td>
												<td class="text-end">RM 200,000.00</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>

					<div class="col-lg-6">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<h5 class="fw-bold mb-1">Export Statement</h5>
								<p class="text-secondary mb-4">
									Download or print the generated company statement for reporting.
								</p>

								<div class="d-grid gap-3">
									<button class="btn btn-outline-primary rounded-pill px-4" type="button">
									<i class="bi bi-printer me-2"></i> Print
									</button>

									<button class="btn btn-outline-success rounded-pill px-4" type="button">
										<i class="bi bi-file-earmark-spreadsheet me-2"></i> Export Excel
									</button>

									<button class="btn btn-primary rounded-pill px-4" type="button">
										<i class="bi bi-file-earmark-pdf me-2"></i> Download PDF
									</button>
								</div>
							</div>
						</div>
					</div>
				</section>
			</main>
		</div>
	</div>
<jsp:include page="/includes/common-scripts.jsp" />
</body>
</html>
