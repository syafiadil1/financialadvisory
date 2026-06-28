<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String action = request.getParameter("action");
	boolean isCreate = "create".equals(action);
	boolean isEdit = "edit".equals(action);
%>

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
						<a class="btn btn-sm btn-outline-secondary rounded-pill mb-3"
							href="departmentmanager-category-list.jsp">
							<i class="bi bi-arrow-left me-1"></i>Back to Category List
						</a>
						<h1 class="fw-bold mb-1"><%= isCreate ? "Add New Category" : "Edit Category" %></h1>
						<p class="text-secondary mb-0">
							<%= isCreate ? "Create a new transaction category for your department." : "Update the details of an existing category." %>
						</p>
					</div>

					<div class="card border-0 shadow-sm rounded-4 mt-3 mt-md-0 role-welcome-card">
						<div class="card-body py-2 px-3">
							<span class="text-secondary">Welcome, </span>
							<strong>Department Manager</strong>
						</div>
					</div>
				</div>

				<!-- Category Form -->
				<section class="card border-0 shadow-sm rounded-4">
					<div class="card-body p-4">
						<h5 class="fw-bold mb-3">
							<i class="bi bi-tags me-2"></i> <%= isCreate ? "Category Information" : "Category Details" %>
						</h5>
						<form action="#" method="post">
							<div class="row g-3">
								<div class="col-md-6">
									<label class="form-label">Category Name</label>
									<input type="text" class="form-control rounded-3"
										name="categoryName"
										placeholder="Enter category name"
										value="<%= isCreate ? "" : "Marketing" %>" required>
								</div>
								<div class="col-md-6">
								<label class="form-label">Parent Category</label>
								<select class="form-select rounded-3" name="parentCategory">
									<option value="" <%= isCreate ? "selected" : "" %>>None</option>
									<option value="cat-001" <%= !isCreate ? "selected" : "" %>>Marketing</option>
									<option value="cat-002">Travel</option>
									<option value="cat-003">Supplies</option>
									<option value="cat-004">Training</option>
									<option value="cat-005">Client Revenue</option>
									<option value="cat-006">Utilities</option>
								</select>
							</div>
								<div class="col-md-6 d-flex align-items-center mt-4">
									<div class="form-check form-switch pt-2">
										<input class="form-check-input" type="checkbox" role="switch" name="isPublic" id="isPublic" <%= !isCreate ? "checked" : "" %>>
										<label class="form-check-label ms-2" for="isPublic">Public Category</label>
									</div>
								</div>
								<div class="col-12 d-flex justify-content-end gap-2 mt-4">
									<a class="btn btn-outline-secondary rounded-pill px-4"
										href="departmentmanager-category-list.jsp">Cancel</a>
									<button class="btn btn-primary rounded-pill px-4" type="submit">
										<i class="bi bi-save me-2"></i><%= isCreate ? "Create Category" : "Save Changes" %>
									</button>
								</div>
							</div>
						</form>
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
