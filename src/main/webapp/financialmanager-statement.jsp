<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>

<c:if test="${empty statement}">
	<c:redirect url="/FinancialStatementController?action=preview" />
</c:if>

<c:url var="printUrl" value="/FinancialStatementController">
	<c:param name="action" value="print" />
	<c:param name="departmentId" value="${selectedDepartmentId}" />
	<c:param name="periodType" value="${periodType}" />
	<c:param name="month" value="${selectedMonth}" />
	<c:param name="quarter" value="${selectedQuarter}" />
	<c:param name="year" value="${selectedYear}" />
	<c:param name="startDate" value="${selectedStartDate}" />
	<c:param name="endDate" value="${selectedEndDate}" />
</c:url>

<!DOCTYPE html>
<html lang="en">
<head>
<jsp:include page="/includes/common-head.jsp" />
<style>
	.statement-sheet {
		background: #fff;
	}

	.statement-total-row {
		border-top: 2px solid #212529;
	}

	@media print {
		.no-print,
		.sidebar-fixed,
		.page-header {
			display: none !important;
		}

		body {
			background: #fff !important;
		}

		main {
			width: 100% !important;
			max-width: 100% !important;
			flex: 0 0 100% !important;
			padding: 0 !important;
		}

		.card,
		.statement-sheet {
			border: 0 !important;
			box-shadow: none !important;
		}

		.container-fluid,
		.row {
			margin: 0 !important;
			padding: 0 !important;
		}
	}
</style>
</head>

<body class="${printMode ? 'bg-white' : 'bg-light'}">
	<div class="container-fluid">
		<div class="row min-vh-100">
			<c:if test="${!printMode}">
				<jsp:include page="/includes/sidebar.jsp">
					<jsp:param name="sidebarRole" value="financialmanager" />
					<jsp:param name="activeMenu" value="statement" />
				</jsp:include>
			</c:if>

			<main class="${printMode ? 'col-12 p-4' : 'col-12 col-lg-10 p-4'}">
				<c:if test="${!printMode}">
					<div class="page-header">
						<jsp:include page="/includes/page-header.jsp">
							<jsp:param name="pageTitle" value="Generate Company Statement" />
							<jsp:param name="pageSubtitle" value="Generate summary statement for company revenue, expenses, and net profit." />
							<jsp:param name="pageRoleName" value="Financial Manager" />
						</jsp:include>
					</div>
				</c:if>

				<section class="card border-0 shadow-sm rounded-4 mb-4 no-print">
					<div class="card-body p-4">
						<div class="d-flex justify-content-between align-items-center mb-3">
							<h5 class="fw-bold mb-0">
								<i class="bi bi-funnel me-2"></i> Statement Period
							</h5>
						</div>

						<form action="${pageContext.request.contextPath}/FinancialStatementController" method="get">
							<input type="hidden" name="action" value="preview">
							<div class="row g-3 align-items-end">
								<div class="col-md-3">
									<label class="form-label">Department</label>
									<select class="form-select rounded-3" name="departmentId">
										<option value="" ${empty selectedDepartmentId ? 'selected' : ''}>All Departments</option>
										<c:forEach var="department" items="${departments}">
											<option value="${department.departmentId}" ${selectedDepartmentId == department.departmentId ? 'selected' : ''}>
												${department.name}
											</option>
										</c:forEach>
									</select>
								</div>

								<div class="col-md-3">
									<label class="form-label">Statement Type</label>
									<select id="periodType" class="form-select rounded-3" name="periodType">
										<option value="monthly" ${periodType == 'monthly' ? 'selected' : ''}>Monthly Statement</option>
										<option value="quarterly" ${periodType == 'quarterly' ? 'selected' : ''}>Quarterly Statement</option>
										<option value="yearly" ${periodType == 'yearly' ? 'selected' : ''}>Yearly Statement</option>
										<option value="custom" ${periodType == 'custom' ? 'selected' : ''}>Custom Date Range</option>
									</select>
								</div>

								<div class="col-md-2 period-control period-month">
									<label class="form-label">Month</label>
									<select class="form-select rounded-3" name="month">
										<c:forEach var="monthNo" begin="1" end="12">
											<option value="${monthNo}" ${selectedMonth == monthNo ? 'selected' : ''}>
												<c:choose>
													<c:when test="${monthNo == 1}">January</c:when>
													<c:when test="${monthNo == 2}">February</c:when>
													<c:when test="${monthNo == 3}">March</c:when>
													<c:when test="${monthNo == 4}">April</c:when>
													<c:when test="${monthNo == 5}">May</c:when>
													<c:when test="${monthNo == 6}">June</c:when>
													<c:when test="${monthNo == 7}">July</c:when>
													<c:when test="${monthNo == 8}">August</c:when>
													<c:when test="${monthNo == 9}">September</c:when>
													<c:when test="${monthNo == 10}">October</c:when>
													<c:when test="${monthNo == 11}">November</c:when>
													<c:otherwise>December</c:otherwise>
												</c:choose>
											</option>
										</c:forEach>
									</select>
								</div>

								<div class="col-md-2 period-control period-quarter">
									<label class="form-label">Quarter</label>
									<select class="form-select rounded-3" name="quarter">
										<option value="1" ${selectedQuarter == 1 ? 'selected' : ''}>Q1</option>
										<option value="2" ${selectedQuarter == 2 ? 'selected' : ''}>Q2</option>
										<option value="3" ${selectedQuarter == 3 ? 'selected' : ''}>Q3</option>
										<option value="4" ${selectedQuarter == 4 ? 'selected' : ''}>Q4</option>
									</select>
								</div>

								<div class="col-md-2 period-control period-year">
									<label class="form-label">Year</label>
									<select class="form-select rounded-3" name="year">
										<c:forEach var="yearOption" begin="${currentYear - 5}" end="${currentYear + 1}">
											<option value="${yearOption}" ${selectedYear == yearOption ? 'selected' : ''}>${yearOption}</option>
										</c:forEach>
									</select>
								</div>

								<div class="col-md-2 period-control period-custom">
									<label class="form-label">Start Date</label>
									<input class="form-control rounded-3" type="date" name="startDate" value="${selectedStartDate}">
								</div>

								<div class="col-md-2 period-control period-custom">
									<label class="form-label">End Date</label>
									<input class="form-control rounded-3" type="date" name="endDate" value="${selectedEndDate}">
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

				<section class="row g-4 mb-4 no-print">
					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100 border-start border-success border-5">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Total Income</p>
								<h3 class="fw-bold mb-2">RM <fmt:formatNumber value="${statement.totalIncome}" minFractionDigits="2" maxFractionDigits="2" /></h3>
								<small class="text-success">Approved income</small>
							</div>
						</div>
					</div>

					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100 border-start border-danger border-5">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Total Expenses</p>
								<h3 class="fw-bold mb-2">RM <fmt:formatNumber value="${statement.totalExpenses}" minFractionDigits="2" maxFractionDigits="2" /></h3>
								<small class="text-danger">Approved expenses</small>
							</div>
						</div>
					</div>

					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100 border-start ${statement.netProfit >= 0 ? 'border-success' : 'border-danger'} border-5">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">${statement.netProfit >= 0 ? 'Net Profit' : 'Net Loss'}</p>
								<h3 class="fw-bold ${statement.netProfit >= 0 ? 'text-success' : 'text-danger'} mb-2">
									RM <fmt:formatNumber value="${statement.netProfit}" minFractionDigits="2" maxFractionDigits="2" />
								</h3>
								<small class="${statement.netProfit >= 0 ? 'text-success' : 'text-danger'}">Income minus expenses</small>
							</div>
						</div>
					</div>

					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100 border-start border-primary border-5">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Cashflow Status</p>
								<h3 class="fw-bold mb-2">${statement.cashflowStatus}</h3>
								<small class="text-secondary">${statement.transactionCount} approved transaction(s)</small>
							</div>
						</div>
					</div>
				</section>

				<section class="card border-0 shadow-sm rounded-4 mb-4 statement-sheet">
					<div class="card-body p-4 p-lg-5">
						<div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-4">
							<div>
								<h4 class="fw-bold mb-1">Company Financial Statement</h4>
								<p class="text-secondary mb-0">Statement period: ${statement.periodLabel}</p>
								<p class="text-secondary mb-0">Department scope: ${statement.departmentLabel}</p>
							</div>
							<div class="d-flex gap-2 no-print">
								<a class="btn btn-outline-secondary rounded-pill px-4" href="${pageContext.request.contextPath}/FinancialStatementController?action=preview">
									<i class="bi bi-arrow-clockwise me-2"></i> Current Month
								</a>
								<a class="btn btn-primary rounded-pill px-4" href="${printUrl}" target="_blank">
									<i class="bi bi-file-earmark-pdf me-2"></i> Print / Save PDF
								</a>
							</div>
						</div>

						<div class="row g-4 mb-4">
							<div class="col-md-6">
								<div class="border rounded-4 p-3 h-100">
									<p class="text-secondary mb-1">Company</p>
									<h6 class="fw-bold mb-1">LKP RACER GROUP</h6>
									<small class="text-secondary">Scope: ${statement.departmentLabel}</small>
								</div>
							</div>

							<div class="col-md-6">
								<div class="border rounded-4 p-3 h-100">
									<p class="text-secondary mb-1">Generated By</p>
									<h6 class="fw-bold mb-1">${statement.generatedBy}</h6>
									<small class="text-secondary">Generated Date: ${statement.generatedDate}</small>
								</div>
							</div>
						</div>

						<c:if test="${statement == null}">
							<div class="alert alert-info rounded-4">
								<h6 class="fw-bold mb-1">No approved transactions found</h6>
								<p class="mb-0">There are no approved company transactions for ${statement.periodLabel}.</p>
							</div>
						</c:if>

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
										<td>Total Income</td>
										<td>All approved income transactions for the selected period.</td>
										<td class="text-end text-success">RM <fmt:formatNumber value="${statement.totalIncome}" minFractionDigits="2" maxFractionDigits="2" /></td>
									</tr>
									<tr>
										<td>Total Expenses</td>
										<td>All approved expense transactions for the selected period.</td>
										<td class="text-end text-danger">RM <fmt:formatNumber value="${statement.totalExpenses}" minFractionDigits="2" maxFractionDigits="2" /></td>
									</tr>
									<tr class="statement-total-row">
										<td class="fw-bold">${statement.netProfit >= 0 ? 'Net Profit' : 'Net Loss'}</td>
										<td class="fw-bold">Total income minus total expenses.</td>
										<td class="text-end fw-bold ${statement.netProfit >= 0 ? 'text-success' : 'text-danger'}">
											RM <fmt:formatNumber value="${statement.netProfit}" minFractionDigits="2" maxFractionDigits="2" />
										</td>
									</tr>
								</tbody>
							</table>
						</div>

						<h5 class="fw-bold mb-3">
							<i class="bi bi-list-ul me-2 no-print"></i> Category Breakdown
						</h5>
						<div class="table-responsive mb-4">
							<table class="table table-hover align-middle mb-0">
								<thead>
									<tr>
										<th>Category</th>
										<th>Type</th>
										<th class="text-end">Amount</th>
									</tr>
								</thead>
								<tbody>
									<c:choose>
										<c:when test="${empty statement.categoryTotals}">
											<tr>
												<td colspan="3" class="text-center text-secondary py-4">No category totals available for this period.</td>
											</tr>
										</c:when>
										<c:otherwise>
											<c:forEach var="category" items="${statement.categoryTotals}">
												<tr>
													<td>${category.categoryName}</td>
													<td>
														<c:choose>
															<c:when test="${fn:toLowerCase(category.transactionType) == 'income'}">
																<span class="badge rounded-pill text-bg-success">Income</span>
															</c:when>
															<c:otherwise>
																<span class="badge rounded-pill text-bg-danger">Expense</span>
															</c:otherwise>
														</c:choose>
													</td>
													<td class="text-end">RM <fmt:formatNumber value="${category.totalAmount}" minFractionDigits="2" maxFractionDigits="2" /></td>
												</tr>
											</c:forEach>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
						</div>

						<c:choose>
							<c:when test="${statement == null}">
								<div class="alert alert-secondary rounded-4 mb-0">
									<h6 class="fw-bold mb-1">Statement Conclusion</h6>
									<p class="mb-0">No financial conclusion is available because this period has no approved transactions.</p>
								</div>
							</c:when>
							<c:when test="${statement.netProfit >= 0}">
								<div class="alert alert-success rounded-4 mb-0">
									<h6 class="fw-bold mb-1">Statement Conclusion</h6>
									<p class="mb-0">The company is in a healthy financial position for this period because income is higher than expenses.</p>
								</div>
							</c:when>
							<c:otherwise>
								<div class="alert alert-warning rounded-4 mb-0">
									<h6 class="fw-bold mb-1">Statement Conclusion</h6>
									<p class="mb-0">The company recorded a net loss for this period because expenses are higher than income.</p>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</section>
			</main>
		</div>
	</div>

	<jsp:include page="/includes/common-scripts.jsp" />
	<script>
		function updateStatementPeriodControls() {
			const type = document.getElementById('periodType')?.value || 'monthly';
			document.querySelectorAll('.period-control').forEach((element) => {
				element.classList.add('d-none');
			});
			document.querySelectorAll('.period-year').forEach((element) => element.classList.remove('d-none'));
			if (type === 'monthly') {
				document.querySelectorAll('.period-month').forEach((element) => element.classList.remove('d-none'));
			} else if (type === 'quarterly') {
				document.querySelectorAll('.period-quarter').forEach((element) => element.classList.remove('d-none'));
			} else if (type === 'custom') {
				document.querySelectorAll('.period-year').forEach((element) => element.classList.add('d-none'));
				document.querySelectorAll('.period-custom').forEach((element) => element.classList.remove('d-none'));
			}
		}

		document.getElementById('periodType')?.addEventListener('change', updateStatementPeriodControls);
		updateStatementPeriodControls();

		<c:if test="${printMode}">
			window.addEventListener('load', () => window.print());
		</c:if>
	</script>
</body>
</html>
