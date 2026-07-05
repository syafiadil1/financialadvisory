<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>

<c:if test="${empty requestScope.user}">
	<c:redirect url="/DashboardController?action=userInfo" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
<jsp:include page="/includes/common-head.jsp" />
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
	html {
		scroll-behavior: smooth;
	}

	section {
		scroll-margin-top: 20px;
	}

	.dashboard-chart {
		display: block;
		width: 100% !important;
		height: 280px !important;
		min-height: 0;
	}

	.dashboard-chart-empty {
		min-height: 280px;
	}
</style>
</head>
<body class="bg-light">
	<div class="container-fluid">
		<div class="row min-vh-100">
			<jsp:include page="/includes/sidebar.jsp">
				<jsp:param name="activeMenu" value="dashboard" />
			</jsp:include>

			<main class="col-12 col-lg-10 p-4">
				<jsp:include page="/includes/page-header.jsp">
					<jsp:param name="pageTitle" value="${dashboardTitle}" />
					<jsp:param name="pageSubtitle" value="${subtitle}" />
					<jsp:param name="pageRoleName" value="${role.name}" />
				</jsp:include>

				<section class="row g-3 mb-4">
					<c:choose>
						<c:when test="${empty summary_cards}">
							<div class="col-12">
								<div class="alert alert-info rounded-4 mb-0">
									No dashboard summary is available for ${dashboardYear}.
								</div>
							</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="card" items="${summary_cards}">
								<div class="col-md-6 col-xl-3">
									<div class="card border-0 shadow-sm rounded-4 h-100 ${card.borderClass}">
										<div class="card-body p-4">
											<div class="d-flex justify-content-between align-items-center">
												<p class="text-secondary mb-1">${card.title}</p>
												<i class="bi ${card.iconClass} fs-3 ${card.colorClass}"></i>
											</div>
											<h3 class="fw-bold mb-2">${card.data}</h3>
											<small class="${card.colorClass}">${card.description}</small>
										</div>
									</div>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</section>

				<section class="row g-4 mb-4">
					<div class="col-lg-8">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<div class="d-flex justify-content-between align-items-center mb-3">
									<h5 class="fw-bold mb-0">
										<i class="bi bi-graph-up me-2"></i>
										<c:choose>
											<c:when test="${user.roleId == 2 || user.roleId == 1}">Company Financial Analytics</c:when>
											<c:otherwise>Department Cashflow Trend</c:otherwise>
										</c:choose>
									</h5>
									<span class="badge rounded-pill text-bg-light">${dashboardYear}</span>
								</div>
								<c:choose>
									<c:when test="${empty cashflowTrend}">
										<div class="text-center text-secondary py-5 dashboard-chart-empty">
											<i class="bi bi-bar-chart fs-1 d-block mb-2"></i>
											No approved transaction trend is available for this year.
										</div>
									</c:when>
									<c:when test="${user.roleId == 2 || user.roleId == 1}">
										<canvas id="financialManagerChart" class="dashboard-chart"></canvas>
									</c:when>
									<c:otherwise>
										<canvas id="cashflowChart" class="dashboard-chart"></canvas>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</div>

					<div class="col-lg-4">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<h5 class="fw-bold mb-3">
									<i class="bi bi-pie-chart me-2"></i> Expense Categories
								</h5>
								<c:choose>
									<c:when test="${empty categoryExpenseSummary}">
										<p class="text-secondary mb-0">No approved expense categories are available for ${dashboardYear}.</p>
									</c:when>
									<c:otherwise>
										<c:forEach var="category" items="${categoryExpenseSummary}" varStatus="s">
											<div class="d-flex justify-content-between py-3 ${!s.last ? 'border-bottom' : ''}">
												<span>${category.label}</span>
												<strong>RM <fmt:formatNumber value="${category.data[0]}" type="number" minFractionDigits="2" maxFractionDigits="2" /></strong>
											</div>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</div>
				</section>

				<c:if test="${user.roleId == 3}">
					<section class="row g-4 mb-4">
						<div class="col-lg-8">
							<div class="card border-0 shadow-sm rounded-4 h-100">
								<div class="card-body p-4">
									<div class="d-flex justify-content-between align-items-center mb-3">
										<h5 class="fw-bold mb-0"><i class="bi bi-wallet2 me-2"></i> Department Budget Usage</h5>
										<span class="badge rounded-pill text-bg-light">${dashboardYear}</span>
									</div>
									<c:choose>
										<c:when test="${empty departmentBudget}">
											<div class="text-center text-secondary py-5 dashboard-chart-empty">
												<i class="bi bi-wallet2 fs-1 d-block mb-2"></i>
												No active department budget is configured for this year.
											</div>
										</c:when>
										<c:otherwise>
											<canvas id="departmentBudgetChart" class="dashboard-chart"></canvas>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
						</div>
						<div class="col-lg-4">
							<div class="card border-0 shadow-sm rounded-4 h-100">
								<div class="card-body p-4">
									<h5 class="fw-bold mb-3"><i class="bi bi-clipboard-data me-2"></i> Budget Snapshot</h5>
									<c:choose>
										<c:when test="${empty departmentBudget}">
											<p class="text-secondary mb-0">Create a department budget to unlock budget usage analytics.</p>
										</c:when>
										<c:otherwise>
											<div class="d-flex justify-content-between py-3 border-bottom">
												<span>Initial Budget</span>
												<strong>RM <fmt:formatNumber value="${departmentBudget.initialBudget}" type="number" minFractionDigits="2" maxFractionDigits="2" /></strong>
											</div>
											<div class="d-flex justify-content-between py-3 border-bottom">
												<span>Used Budget</span>
												<strong class="text-danger">RM <fmt:formatNumber value="${departmentBudget.usedBudget}" type="number" minFractionDigits="2" maxFractionDigits="2" /></strong>
											</div>
											<div class="d-flex justify-content-between py-3">
												<span>Remaining Budget</span>
												<strong class="${departmentBudget.remainingBudget lt 0 ? 'text-danger' : 'text-success'}">RM <fmt:formatNumber value="${departmentBudget.remainingBudget}" type="number" minFractionDigits="2" maxFractionDigits="2" /></strong>
											</div>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
						</div>
					</section>
				</c:if>

				<section class="card border-0 shadow-sm rounded-4 mb-4">
					<div class="card-body p-4">
						<h5 class="fw-bold mb-3">
							<i class="bi bi-pie-chart me-2"></i> Expense Focus Area
						</h5>
						<c:choose>
							<c:when test="${empty categoryExpenseSummary}">
								<p class="text-secondary mb-0">No expense focus area is available yet.</p>
							</c:when>
							<c:otherwise>
								<div class="row g-3">
									<c:forEach var="category" items="${categoryExpenseSummary}" varStatus="s">
										<c:set var="focusClass" value="${s.first ? 'text-danger' : (s.index == 1 ? 'text-warning' : (s.index == 2 ? 'text-primary' : 'text-success'))}" />
										<c:set var="focusLabel" value="${s.first ? 'Highest Spend' : (s.index == 1 ? 'Monitor' : (s.index == 2 ? 'Review' : 'Acceptable'))}" />
										<div class="col-md-6 col-xl-3">
											<div class="border rounded-4 p-3 h-100">
												<p class="text-secondary mb-1">${category.label}</p>
												<strong class="${focusClass}">${focusLabel}</strong>
											</div>
										</div>
									</c:forEach>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</section>

				<c:if test="${user.roleId == 1 || user.roleId == 2 || user.roleId == 3}">
					<section class="card border-0 shadow-sm rounded-4 mb-4" id="pending-verification">
						<div class="card-body p-4">
							<div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
								<div>
									<h5 class="fw-bold mb-1"><i class="bi bi-hourglass-split me-2"></i> Pending Verification</h5>
									<p class="text-secondary mb-0">Review transactions waiting for approval.</p>
								</div>
								<a class="btn btn-outline-primary rounded-pill px-4 mt-3 mt-md-0" href="${pageContext.request.contextPath}/TransactionController?action=list">
									<i class="bi bi-list-ul me-2"></i> View All
								</a>
							</div>
							<div class="table-responsive">
								<table class="table table-hover align-middle mb-0">
									<thead>
										<tr>
											<th>Date</th>
											<th>Submitted By</th>
											<th>Transaction</th>
											<th>Category</th>
											<th class="text-end">Amount</th>
											<th>Status</th>
											<th class="text-center">Action</th>
										</tr>
									</thead>
									<tbody>
										<c:choose>
											<c:when test="${empty pendingTransactions}">
												<tr>
													<td colspan="7" class="text-center text-secondary py-4">No pending transactions for ${dashboardYear}.</td>
												</tr>
											</c:when>
											<c:otherwise>
												<c:forEach var="transaction" items="${pendingTransactions}">
													<tr>
														<td><fmt:formatDate value="${transaction.dateTransaction}" pattern="yyyy-MM-dd" /></td>
														<td>${empty transaction.createdByName ? 'N/A' : transaction.createdByName}</td>
														<td>${transaction.name}</td>
														<td>${empty transaction.categoryName ? 'N/A' : transaction.categoryName}</td>
														<td class="text-end text-danger fw-bold">RM <fmt:formatNumber value="${transaction.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2" /></td>
														<td><span class="badge text-bg-warning rounded-pill">Pending</span></td>
														<td class="text-center">
															<a class="btn btn-sm btn-outline-primary rounded-pill" href="${pageContext.request.contextPath}/TransactionController?action=view-details&transactionId=${transaction.transactionId}">
																<i class="bi bi-eye"></i>
															</a>
														</td>
													</tr>
												</c:forEach>
											</c:otherwise>
										</c:choose>
									</tbody>
								</table>
							</div>
						</div>
					</section>
				</c:if>

				<section class="row g-4">
					<div class="${user.roleId == 1 ? 'col-12' : 'col-lg-8'}">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<div class="d-flex justify-content-between align-items-center mb-3">
									<h5 class="fw-bold mb-0"><i class="bi bi-list-ul me-2"></i> Recent Transactions</h5>
									<a href="${pageContext.request.contextPath}/TransactionController?action=list" class="text-decoration-none">View All</a>
								</div>
								<div class="table-responsive">
									<table class="table table-hover align-middle mb-0">
										<thead>
											<tr>
												<th>Date</th>
												<th>Title</th>
												<th>Type</th>
												<th>Category</th>
												<th class="text-end">Amount</th>
												<th>Status</th>
											</tr>
										</thead>
										<tbody>
											<c:choose>
												<c:when test="${empty recentTransactions}">
													<tr>
														<td colspan="6" class="text-center text-secondary py-4">No transactions are available for ${dashboardYear}.</td>
													</tr>
												</c:when>
												<c:otherwise>
													<c:forEach var="transaction" items="${recentTransactions}">
														<c:set var="typeLower" value="${fn:toLowerCase(transaction.transactionType)}" />
														<c:set var="statusLower" value="${fn:toLowerCase(transaction.status)}" />
														<tr>
															<td><fmt:formatDate value="${transaction.dateTransaction}" pattern="yyyy-MM-dd" /></td>
															<td>${transaction.name}</td>
															<td>
																<span class="badge rounded-pill ${typeLower == 'income' ? 'text-bg-success' : 'text-bg-danger'}">
																	${typeLower == 'income' ? 'Income' : 'Expense'}
																</span>
															</td>
															<td>${empty transaction.categoryName ? 'N/A' : transaction.categoryName}</td>
															<td class="text-end ${typeLower == 'income' ? 'text-success' : 'text-danger'} fw-bold">
																RM <fmt:formatNumber value="${transaction.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2" />
															</td>
															<td>
																<c:choose>
																	<c:when test="${statusLower == 'approved'}"><span class="badge rounded-pill text-bg-success">Approved</span></c:when>
																	<c:when test="${statusLower == 'rejected'}"><span class="badge rounded-pill text-bg-danger">Rejected</span></c:when>
																	<c:when test="${statusLower == 'pending'}"><span class="badge rounded-pill text-bg-warning">Pending</span></c:when>
																	<c:otherwise><span class="badge rounded-pill text-bg-secondary">${transaction.status}</span></c:otherwise>
																</c:choose>
															</td>
														</tr>
													</c:forEach>
												</c:otherwise>
											</c:choose>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>

					<c:if test="${user.roleId != 1}">
						<div class="col-lg-4">
							<div class="card border-0 shadow-sm rounded-4 h-100">
								<div class="card-body p-4">
									<h5 class="fw-bold mb-3"><i class="bi bi-robot me-2"></i> AI Financial Advisor</h5>
									<p class="text-secondary">
										Use the current dashboard analytics as context for budget, spending, and cashflow questions.
									</p>
									<a href="${pageContext.request.contextPath}/AIAdvisoryController?role=${user.roleId == 2 ? 'financialmanager' : (user.roleId == 3 ? 'departmentmanager' : 'staff')}" class="btn btn-primary w-100 rounded-pill">
										Open Advisory Chatbot
									</a>
								</div>
							</div>
						</div>
					</c:if>
				</section>

				<c:if test="${user.roleId == 2}">
					<section class="card border-0 shadow-sm rounded-4 mt-4 mb-4" id="company-statement">
						<div class="card-body p-4">
							<h5 class="fw-bold mb-3"><i class="bi bi-file-earmark-bar-graph me-2"></i> Company Statement Preview</h5>
							<p class="text-secondary">Current-year statement generated from approved company transactions.</p>
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
										<c:forEach var="card" items="${summary_cards}">
											<c:if test="${card.title == 'Total Income' || card.title == 'Total Expenses' || card.title == 'Net Profit' || card.title == 'Net Loss'}">
												<tr>
													<td class="fw-semibold">${card.title}</td>
													<td>${card.description}</td>
													<td class="text-end ${card.colorClass}">${card.data}</td>
												</tr>
											</c:if>
										</c:forEach>
									</tbody>
								</table>
							</div>
							<div class="alert alert-info rounded-4 mb-0">
								Review the analytics above before exporting or sharing this company statement.
							</div>
						</div>
					</section>
				</c:if>
			</main>
		</div>
	</div>

	<jsp:include page="/includes/common-scripts.jsp" />
	<script>
		window.cashflowTrendLabels = [
			<c:forEach var="item" items="${cashflowTrend}" varStatus="s">
				"${item.label}"<c:if test="${!s.last}">,</c:if>
			</c:forEach>
		];
		window.cashflowIncomeData = [
			<c:forEach var="item" items="${cashflowTrend}" varStatus="s">
				${item.data[0]}<c:if test="${!s.last}">,</c:if>
			</c:forEach>
		];
		window.cashflowExpenseData = [
			<c:forEach var="item" items="${cashflowTrend}" varStatus="s">
				${item.data[1]}<c:if test="${!s.last}">,</c:if>
			</c:forEach>
		];
		window.companyTrendLabels = window.cashflowTrendLabels;
		window.companyIncomeData = window.cashflowIncomeData;
		window.companyExpenseData = window.cashflowExpenseData;
		window.departmentBudgetLabels = ["Used Budget", "Remaining Budget"];
		window.departmentBudgetData = [
			<c:choose>
				<c:when test="${empty departmentBudget}">0, 0</c:when>
				<c:otherwise>
					${departmentBudget.usedBudget},
					${departmentBudget.remainingBudget lt 0 ? 0 : departmentBudget.remainingBudget}
				</c:otherwise>
			</c:choose>
		];
	</script>
	<script src="${pageContext.request.contextPath}/js/staff.js"></script>
	<script src="${pageContext.request.contextPath}/js/financialmanager.js"></script>
	<script>
		const departmentBudgetChart = document.getElementById("departmentBudgetChart");
		if (departmentBudgetChart) {
			new Chart(departmentBudgetChart, {
				type: "doughnut",
				data: {
					labels: window.departmentBudgetLabels || [],
					datasets: [{
						data: window.departmentBudgetData || [],
						backgroundColor: ["#FF6384", "#36A2EB"]
					}]
				},
				options: {
					responsive: true,
					maintainAspectRatio: false,
					plugins: {
						legend: {
							position: "bottom"
						}
					}
				}
			});
		}
	</script>
</body>
</html>
