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
				<jsp:param name="activeMenu" value="budget" />
			</jsp:include>

			<main class="col-12 col-lg-10 p-4">
				<jsp:include page="/includes/page-header.jsp">
					<jsp:param name="pageTitle" value="Department Budget Management" />
					<jsp:param name="pageSubtitle" value="Set and monitor department budget usage." />
					<jsp:param name="pageRoleName" value="Department Manager" />
				</jsp:include>

				<section class="row g-4 mb-4">
					<div class="col-md-4">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Allocated Budget</p>
								<h3 class="fw-bold mb-0">RM 50,000.00</h3>
							</div>
						</div>
					</div>
					<div class="col-md-4">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Used Budget</p>
								<h3 class="fw-bold text-danger mb-0">RM 31,250.00</h3>
							</div>
						</div>
					</div>
					<div class="col-md-4">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Remaining Budget</p>
								<h3 class="fw-bold text-success mb-0">RM 18,750.00</h3>
							</div>
						</div>
					</div>
				</section>

				<section class="card border-0 shadow-sm rounded-4">
					<div class="card-body p-4">
						<h5 class="fw-bold mb-3">
							<i class="bi bi-pencil-square me-2"></i> Set Department Budget
						</h5>
						<form action="#" method="post">
							<div class="row g-3">
								<div class="col-md-4">
									<label class="form-label">Budget Month</label>
									<input type="month" class="form-control rounded-3" name="budgetMonth">
								</div>
								<div class="col-md-4">
									<label class="form-label">Budget Amount</label>
									<input type="number" class="form-control rounded-3"
										name="budgetAmount" placeholder="50000">
								</div>
								<div class="col-md-4 d-flex align-items-end">
									<button class="btn btn-primary rounded-pill w-100" type="submit">
										<i class="bi bi-save me-2"></i> Set Budget
									</button>
								</div>
							</div>
						</form>
					</div>
				</section>
			</main>
		</div>
	</div>
<jsp:include page="/includes/common-scripts.jsp" />
</body>
</html>
