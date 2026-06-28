<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>AI Financial Advisory System</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Bootstrap Icons -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

<style>
	html {
		scroll-behavior: smooth;
	}

	section {
		scroll-margin-top: 90px;
	}
</style>
</head>

<body class="bg-light">

	<!-- Navbar -->
	<nav class="navbar navbar-expand-lg bg-white shadow-sm fixed-top">
		<div class="container">
			<a class="navbar-brand fw-bold text-primary fs-4" href="#home">
				Financial Advisory System
			</a>

			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#mainNavbar">
				<span class="navbar-toggler-icon"></span>
			</button>

			<div class="collapse navbar-collapse" id="mainNavbar">
				<ul class="navbar-nav ms-auto align-items-lg-center gap-lg-3">
					<li class="nav-item">
						<a class="nav-link active" href="#home">Home</a>
					</li>

					<li class="nav-item">
						<a class="nav-link" href="#features">Features</a>
					</li>

					<li class="nav-item">
						<a class="nav-link" href="#about">About</a>
					</li>

					<li class="nav-item">
						<a class="btn btn-outline-primary rounded-pill px-4"
							href="login.jsp">Preview System</a>
						<c:choose>
							<c:when test="${not empty sessionScope.user}">
								<a class="btn btn-primary rounded-pill px-4"
									href="dashboard.jsp?role=staff">
									Dashboard
								</a>
							</c:when>

							<c:otherwise>
								<a class="btn btn-outline-primary rounded-pill px-4"
									href="login.jsp">
									Login
								</a>
							</c:otherwise>
						</c:choose>
					</li>
				</ul>
			</div>
		</div>
	</nav>

	<!-- Hero Section -->
	<section id="home" class="min-vh-100 d-flex align-items-center pt-5">
		<div class="container py-5">
			<div class="row align-items-center g-5">

				<!-- Left content -->
				<div class="col-lg-7">
					<span
						class="badge rounded-pill text-bg-primary-subtle text-primary px-3 py-2 mb-3">
						AI-Powered Financial Management
					</span>

					<h1 class="display-4 fw-bold mb-4">
						Track Cashflow. Understand Spending. Make Smarter Business Decisions.
					</h1>

					<p class="lead text-secondary mb-4">
						Company Financial Behavior Analysis & Advisory System helps
						companies record income and expenses, monitor financial health,
						analyze cashflow trends, and receive advisory suggestions based on
						business performance.
					</p>

					<div class="d-flex flex-wrap gap-3">
						<a href="login.jsp"
							class="btn btn-primary btn-lg rounded-pill px-4">
							Get Started
						</a>

						<a href="#features"
							class="btn btn-outline-primary btn-lg rounded-pill px-4">
							View Features
						</a>
					</div>
				</div>

				<!-- Right financial card -->
				<div class="col-lg-5">
					<div class="card border-0 shadow-lg rounded-4">
						<div class="card-body p-4">

							<div
								class="d-flex justify-content-between align-items-center mb-4">
								<h5 class="fw-bold mb-0">Financial Snapshot</h5>
								<span class="badge text-bg-success rounded-pill">Positive</span>
							</div>

							<div class="bg-light rounded-4 p-3 mb-3">
								<div class="d-flex justify-content-between">
									<span class="text-secondary">Total Revenue</span>
									<strong>RM 67,676,767.67</strong>
								</div>
							</div>

							<div class="bg-light rounded-4 p-3 mb-3">
								<div class="d-flex justify-content-between">
									<span class="text-secondary">Total Expenses</span>
									<strong>RM 676,767.67</strong>
								</div>
							</div>

							<div class="bg-light rounded-4 p-3 mb-3">
								<div class="d-flex justify-content-between">
									<span class="text-secondary">Net Profit</span>
									<strong class="text-success">RM 676,767.67</strong>
								</div>
							</div>

							<div class="alert alert-success rounded-4 mb-0">
								Cashflow Status: Your company is currently in a healthy position.
							</div>

						</div>
					</div>
				</div>

			</div>
		</div>
	</section>

	<!-- Features Section -->
	<section class="py-5" id="features">
		<div class="container">
			<div class="row g-4">

				<div class="col-md-6 col-lg-3">
					<div class="card h-100 border-0 shadow-sm rounded-4">
						<div class="card-body p-4">
							<div class="fs-1 mb-3">
								<i class="bi bi-cash-stack"></i>
							</div>

							<h5 class="fw-bold">Transaction Recording</h5>
							<p class="text-secondary mb-0">
								Record and manage income and expenses in a structured financial system.
							</p>
						</div>
					</div>
				</div>

				<div class="col-md-6 col-lg-3">
					<div class="card h-100 border-0 shadow-sm rounded-4">
						<div class="card-body p-4">
							<div class="fs-1 mb-3">
								<i class="bi bi-graph-up-arrow"></i>
							</div>

							<h5 class="fw-bold">Financial Dashboard</h5>
							<p class="text-secondary mb-0">
								View revenue, expenses, net profit, and cashflow status using simple visuals.
							</p>
						</div>
					</div>
				</div>

				<div class="col-md-6 col-lg-3">
					<div class="card h-100 border-0 shadow-sm rounded-4">
						<div class="card-body p-4">
							<div class="fs-1 mb-3">
								<i class="bi bi-receipt"></i>
							</div>

							<h5 class="fw-bold">Invoice Extraction</h5>
							<p class="text-secondary mb-0">
								Upload invoices and reduce manual entry through document extraction.
							</p>
						</div>
					</div>
				</div>

				<div class="col-md-6 col-lg-3">
					<div class="card h-100 border-0 shadow-sm rounded-4">
						<div class="card-body p-4">
							<div class="fs-1 mb-3">
								<i class="bi bi-robot"></i>
							</div>

							<h5 class="fw-bold">AI Advisory</h5>
							<p class="text-secondary mb-0">
								Receive financial suggestions based on company spending and profit trends.
							</p>
						</div>
					</div>
				</div>

			</div>
		</div>
	</section>

	<!-- About Section -->
	<section class="py-5 bg-white" id="about">
		<div class="container">
			<div class="row justify-content-center text-center">
				<div class="col-lg-8">

					<span
						class="badge rounded-pill text-bg-primary-subtle text-primary px-3 py-2 mb-3">
						Why Our System?
					</span>

					<h2 class="fw-bold mb-3">
						Built for companies that need better financial visibility
					</h2>

					<p class="text-secondary">
						Many businesses still depend on spreadsheets or manual records,
						which can cause errors, poor tracking, and delays in financial
						decision-making. Financial Advisory System provides a cleaner way
						to manage company cashflow in one system.
					</p>

				</div>
			</div>
		</div>
	</section>

	<!-- CTA Section -->
	<section class="py-5">
		<div class="container">
			<div class="bg-primary text-white text-center rounded-5 p-5">
				<h2 class="fw-bold mb-3">
					Start monitoring your company cashflow today
				</h2>

				<p class="mb-4">
					Manage transactions, analyze financial health, and improve business
					decision-making in one platform.
				</p>

				<a href="login.jsp" class="btn btn-light btn-lg rounded-pill px-4">
					Go to Login
				</a>
			</div>
		</div>
	</section>

	<!-- Footer -->
	<footer class="py-4 bg-white border-top">
		<div class="container text-center text-secondary">
			<small>© 2026 LKP RACER GROUP</small>
		</div>
	</footer>

	<!-- Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
