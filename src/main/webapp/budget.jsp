<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
<jsp:include page="/includes/common-head.jsp" />
</head>

<body class="bg-light">
	<div class="container-fluid">
		<div class="row min-vh-100">
			<jsp:include page="/includes/sidebar.jsp">
				<jsp:param name="activeMenu" value="budget" />
			</jsp:include>

			<main class="col-12 col-lg-10 p-4">
				<jsp:include page="/includes/page-header.jsp">
					<jsp:param name="pageTitle" value="Department Budget" />
					<jsp:param name="pageSubtitle" value="Set and monitor yearly department budget allocations." />
					<jsp:param name="pageRoleName" value="${roleName}" />
				</jsp:include>

				<c:if test="${saved == '1'}">
					<div class="alert alert-success rounded-4" role="alert">
						Budget saved successfully.
					</div>
				</c:if>

				<c:if test="${error == 'invalid'}">
					<div class="alert alert-danger rounded-4" role="alert">
						Please select a department, year, and valid budget amount.
					</div>
				</c:if>

				<c:if test="${error == 'save'}">
					<div class="alert alert-danger rounded-4" role="alert">
						Budget could not be saved. Please try again.
					</div>
				</c:if>

				<section class="row g-4 mb-4">
					<div class="col-md-4">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<div class="d-flex justify-content-between align-items-center">
									<p class="text-secondary mb-1">Allocated Budget</p>
									<i class="bi bi-wallet2 fs-3 text-primary"></i>
								</div>
								<h3 class="fw-bold mb-0">RM <fmt:formatNumber value="${totalAllocated}" minFractionDigits="2" maxFractionDigits="2" /></h3>
								<small class="text-secondary">${selectedYear} yearly allocation</small>
							</div>
						</div>
					</div>
					<div class="col-md-4">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<div class="d-flex justify-content-between align-items-center">
									<p class="text-secondary mb-1">Used Budget</p>
									<i class="bi bi-cash-coin fs-3 text-danger"></i>
								</div>
								<h3 class="fw-bold text-danger mb-0">RM <fmt:formatNumber value="${totalUsed}" minFractionDigits="2" maxFractionDigits="2" /></h3>
								<small class="text-secondary">Approved expenses in ${selectedYear}</small>
							</div>
						</div>
					</div>
					<div class="col-md-4">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<div class="d-flex justify-content-between align-items-center">
									<p class="text-secondary mb-1">Remaining Budget</p>
									<i class="bi bi-piggy-bank fs-3 text-success"></i>
								</div>
								<h3 class="fw-bold text-success mb-0">RM <fmt:formatNumber value="${totalRemaining}" minFractionDigits="2" maxFractionDigits="2" /></h3>
								<small class="text-secondary">Available yearly balance</small>
							</div>
						</div>
					</div>
				</section>

				<section class="card border-0 shadow-sm rounded-4 mb-4">
					<div class="card-body p-4">
						<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
							<h5 class="fw-bold mb-0">
								<i class="bi bi-calendar3 me-2"></i> Budget Year
							</h5>
							<form action="${pageContext.request.contextPath}/BudgetController" method="get" class="row g-2 align-items-end">
								<input type="hidden" name="action" value="list">
								<div class="col-auto">
									<label class="form-label small text-secondary mb-1">Year</label>
									<select class="form-select rounded-3" name="year" aria-label="Budget year">
										<c:forEach var="yearOption" items="${yearOptions}">
											<option value="${yearOption}" ${yearOption == selectedYear ? 'selected' : ''}>${yearOption}</option>
										</c:forEach>
									</select>
								</div>
								<c:if test="${isFinancialManager}">
									<div class="col-auto">
										<label class="form-label small text-secondary mb-1">Department</label>
										<select class="form-select rounded-3" name="departmentId">
											<option value="">All Departments</option>
											<c:forEach var="department" items="${departments}">
												<option value="${department.departmentId}" ${selectedDepartmentId == department.departmentId ? 'selected' : ''}>${department.name}</option>
											</c:forEach>
										</select>
									</div>
								</c:if>
								<div class="col-auto">
									<label class="form-label small text-secondary mb-1">Status</label>
									<select class="form-select rounded-3" name="status">
										<option value="">All Statuses</option>
										<option value="set" ${selectedStatus == 'set' ? 'selected' : ''}>Set</option>
										<option value="not-set" ${selectedStatus == 'not-set' ? 'selected' : ''}>Not Set</option>
									</select>
								</div>
								<div class="col-auto d-flex gap-2">
									<button class="btn btn-outline-primary rounded-pill px-4" type="submit">
										<i class="bi bi-funnel me-2"></i>View
									</button>
									<a class="btn btn-outline-secondary rounded-pill" href="${pageContext.request.contextPath}/BudgetController?action=list">
										<i class="bi bi-x-lg"></i>
									</a>
								</div>
							</form>
						</div>

						<c:if test="${isFinancialManager}">
							<form action="${pageContext.request.contextPath}/BudgetController" method="post" class="border-top pt-4 mt-4">
								<input type="hidden" name="action" value="save">
								<div class="row g-3 align-items-end">
									<div class="col-md-4">
										<label class="form-label">Department</label>
										<select class="form-select rounded-3" name="departmentId" required>
											<option value="">Select department</option>
											<c:forEach var="department" items="${departments}">
												<option value="${department.departmentId}">${department.name}</option>
											</c:forEach>
										</select>
									</div>
									<div class="col-md-3">
										<label class="form-label">Budget Year</label>
										<select class="form-select rounded-3" name="year" required>
											<c:forEach var="yearOption" items="${yearOptions}">
												<option value="${yearOption}" ${yearOption == selectedYear ? 'selected' : ''}>${yearOption}</option>
											</c:forEach>
										</select>
									</div>
									<div class="col-md-3">
										<label class="form-label">Budget Amount</label>
										<input type="number" class="form-control rounded-3" name="budgetAmount"
											min="0" step="0.01" placeholder="50000.00" required>
									</div>
									<div class="col-md-2">
										<button class="btn btn-primary rounded-pill w-100" type="submit">
											<i class="bi bi-save me-2"></i>Save
										</button>
									</div>
								</div>
							</form>
						</c:if>
					</div>
				</section>

				<section class="card border-0 shadow-sm rounded-4">
					<div class="card-body p-4">
						<div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
							<h5 class="fw-bold mb-0">
								<i class="bi bi-list-ul me-2"></i> Yearly Budget Summary
							</h5>
							<span class="badge rounded-pill text-bg-light text-secondary">${selectedYear}</span>
						</div>

						<div class="table-responsive">
							<table class="table table-hover align-middle">
								<thead>
									<tr>
										<th>Department</th>
										<th>Year</th>
										<th>Date Range</th>
										<th class="text-end">Allocated</th>
										<th class="text-end">Used</th>
										<th class="text-end">Remaining</th>
										<th>Status</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="budget" items="${budgetRows}">
										<tr>
											<td class="fw-semibold">${budget.departmentName}</td>
											<td>${budget.budgetYear}</td>
											<td>
												<fmt:formatDate value="${budget.dateStart}" pattern="dd MMM yyyy" />
												-
												<fmt:formatDate value="${budget.dateEnd}" pattern="dd MMM yyyy" />
											</td>
											<td class="text-end">RM <fmt:formatNumber value="${budget.initialBudget}" minFractionDigits="2" maxFractionDigits="2" /></td>
											<td class="text-end text-danger">RM <fmt:formatNumber value="${budget.usedBudget}" minFractionDigits="2" maxFractionDigits="2" /></td>
											<td class="text-end ${budget.remainingBudget lt 0 ? 'text-danger' : 'text-success'} fw-bold">
												RM <fmt:formatNumber value="${budget.remainingBudget}" minFractionDigits="2" maxFractionDigits="2" />
											</td>
											<td>
												<c:choose>
													<c:when test="${budget.activeBudget}">
														<span class="badge rounded-pill text-bg-success">Set</span>
													</c:when>
													<c:otherwise>
														<span class="badge rounded-pill text-bg-secondary">Not Set</span>
													</c:otherwise>
												</c:choose>
											</td>
										</tr>
									</c:forEach>
									<c:if test="${empty budgetRows}">
										<tr>
											<td colspan="7" class="text-center text-secondary py-4">No budget records found.</td>
										</tr>
									</c:if>
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
