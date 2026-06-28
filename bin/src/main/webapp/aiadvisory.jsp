<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String role = request.getParameter("role");
	if (role == null || role.trim().isEmpty()) {
		role = "staff";
	}

	String roleName = "Staff";

	if ("departmentmanager".equals(role)) {
		roleName = "Department Manager";
	} else if ("financialmanager".equals(role)) {
		roleName = "Financial Manager";
	} else {
		role = "staff";
	}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<jsp:include page="/includes/common-head.jsp" />
</head>

<body class="bg-light">
	<div class="container-fluid">
		<div class="row min-vh-100">
			<jsp:include page="/includes/sidebar.jsp">
				<jsp:param name="sidebarRole" value="<%= role %>" />
				<jsp:param name="activeMenu" value="advisory" />
			</jsp:include>

			<main class="col-12 col-lg-10 p-4">
				<jsp:include page="/includes/page-header.jsp">
					<jsp:param name="pageTitle" value="AI Advisory Module" />
					<jsp:param name="pageSubtitle" value="Chatbot-based financial suggestions using the latest approved financial data." />
					<jsp:param name="pageRoleName" value="<%= roleName %>" />
				</jsp:include>

				<section class="card border-0 shadow-sm rounded-4 mb-4">
					<div class="card-body p-4">
						<div class="d-flex justify-content-between align-items-center mb-3">
							<h5 class="fw-bold mb-0">
								<i class="bi bi-lightbulb me-2"></i> AI Advisory Suggestion
							</h5>
						</div>

						<div class="alert alert-success rounded-4 mb-3">
							<h6 class="fw-bold mb-2">Financial Status: Positive</h6>
							<p class="mb-0">
								The current financial position is positive because income is higher than
								expenses for the selected period.
							</p>
						</div>

						<div class="alert alert-warning rounded-4 mb-0">
							<h6 class="fw-bold mb-2">AI Recommendation</h6>
							<p class="mb-0">
								Continue monitoring fixed costs, review high-value expenses, and prioritize
								spending that directly supports business operations.
							</p>
						</div>
					</div>
				</section>

				<section class="row g-4 mb-4">
					<div class="col-12">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<h5 class="fw-bold mb-3">
									<i class="bi bi-shield-check me-2"></i> Risk Evaluation
								</h5>

								<div class="alert alert-primary rounded-4 mb-3">
									<h6 class="fw-bold mb-1">Risk Level: Low Risk</h6>
									<p class="mb-0">
										The financial position is currently stable, but recurring expenses
										should continue to be reviewed.
									</p>
								</div>

								<p class="text-secondary mb-0">
									The system recommends ongoing monitoring of high-cost categories to
									maintain positive cashflow.
								</p>
							</div>
						</div>
					</div>
				</section>

				<section class="card border-0 shadow-sm rounded-4 overflow-hidden">
					<div class="row g-0">
						<div class="col-lg-4 border-end bg-white">
							<div class="p-4 h-100">
								<div class="d-flex justify-content-between align-items-center mb-3">
									<h5 class="fw-bold mb-0">
										<i class="bi bi-chat-left-text me-2"></i> Previous Chats
									</h5>
									<a class="btn btn-sm btn-primary rounded-pill" href="aiadvisory.jsp?role=<%= role %>">
										<i class="bi bi-plus-lg me-1"></i>New
									</a>
								</div>

								<div class="list-group list-group-flush border rounded-3 overflow-hidden">
									<a href="aiadvisory.jsp?role=<%= role %>&chat=monthly-focus"
										class="list-group-item list-group-item-action active">
										<div class="d-flex w-100 justify-content-between gap-3">
											<strong>Monthly focus</strong>
											<small>Today</small>
										</div>
										<small>Review fixed costs and cashflow position.</small>
									</a>

									<a href="aiadvisory.jsp?role=<%= role %>&chat=expense-review"
										class="list-group-item list-group-item-action">
										<div class="d-flex w-100 justify-content-between gap-3">
											<strong>Expense review</strong>
											<small>Yesterday</small>
										</div>
										<small>Check high-value operational expenses.</small>
									</a>

									<a href="aiadvisory.jsp?role=<%= role %>&chat=budget-risk"
										class="list-group-item list-group-item-action">
										<div class="d-flex w-100 justify-content-between gap-3">
											<strong>Budget risk</strong>
											<small>28 May</small>
										</div>
										<small>Assess risk level for recurring costs.</small>
									</a>

									<a href="aiadvisory.jsp?role=<%= role %>&chat=profit-plan"
										class="list-group-item list-group-item-action">
										<div class="d-flex w-100 justify-content-between gap-3">
											<strong>Profit plan</strong>
											<small>24 May</small>
										</div>
										<small>Identify spending controls for next month.</small>
									</a>
								</div>
							</div>
						</div>

						<div class="col-lg-8 bg-white">
							<div class="p-4 h-100">
								<div class="d-flex justify-content-between align-items-center mb-3">
									<h5 class="fw-bold mb-0">
										<i class="bi bi-robot me-2"></i> Chatbot-Based Advisory
									</h5>
								</div>

								<div class="bg-light rounded-4 p-3 mb-3" style="min-height: 300px;">
									<div class="d-flex mb-3">
										<div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2"
											style="width: 35px; height: 35px;">
											<i class="bi bi-robot"></i>
										</div>
										<div class="bg-white border rounded-4 p-3 shadow-sm">
											<p class="mb-0">
												Hi! I can suggest financial actions based on current financial data.
											</p>
										</div>
									</div>

									<div class="d-flex justify-content-end mb-3">
										<div class="bg-primary text-white rounded-4 p-3 shadow-sm">
											<p class="mb-0">
												What should I focus on this month?
											</p>
										</div>
									</div>

									<div class="d-flex mb-3">
										<div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2"
											style="width: 35px; height: 35px;">
											<i class="bi bi-robot"></i>
										</div>
										<div class="bg-white border rounded-4 p-3 shadow-sm">
											<p class="mb-0">
												Focus on monitoring fixed costs, reviewing high-value expenses,
												and protecting positive cashflow.
											</p>
										</div>
									</div>
								</div>

								<form action="#" method="post">
									<div class="input-group">
										<input type="text" class="form-control rounded-start-pill"
											name="question" placeholder="Ask AI for financial suggestion...">
										<button class="btn btn-primary rounded-end-pill px-4" type="submit">
											<i class="bi bi-send me-2"></i> Send
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
<jsp:include page="/includes/common-scripts.jsp" />
</body>
</html>
