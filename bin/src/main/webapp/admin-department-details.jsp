<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String action = request.getParameter("action");
	boolean isCreate = "create".equals(action);
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
				<jsp:param name="sidebarRole" value="admin" />
				<jsp:param name="activeMenu" value="departments" />
			</jsp:include>

			<main class="col-12 col-lg-10 p-4">
				<div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
					<div>
						<h1 class="fw-bold mb-1"><%= isCreate ? "Create Department" : "Department Details" %></h1>
						<p class="text-secondary mb-0">Create or update department information and manager assignment.</p>
					</div>
					<a class="btn btn-outline-secondary rounded-pill px-4" href="admin-department-list.jsp">
						<i class="bi bi-arrow-left me-2"></i>Back to List
					</a>
				</div>

				<section class="card border-0 shadow-sm rounded-4">
					<div class="card-body p-4">
						<form action="#" method="post">
							<div class="row g-3">
								<div class="col-md-4">
									<label class="form-label">Department Code</label>
									<input type="text" class="form-control rounded-3" name="departmentCode"
										value="<%= isCreate ? "" : "DPT-002" %>" placeholder="Example: DPT-007">
								</div>
								<div class="col-md-8">
									<label class="form-label">Department Name</label>
									<input type="text" class="form-control rounded-3" name="departmentName"
										value="<%= isCreate ? "" : "Sales" %>" placeholder="Enter department name">
								</div>
								<div class="col-md-6">
									<label class="form-label">Assigned Department Manager</label>
									<select class="form-select rounded-3" name="departmentManager">
										<option <%= isCreate ? "selected" : "" %>>Not Assigned</option>
										<option>Sarah Ahmad</option>
										<option>Abu Bakar</option>
										<option>Mohd Farhan</option>
									</select>
								</div>
								<div class="col-md-6">
									<label class="form-label">Department Status</label>
									<select class="form-select rounded-3" name="status">
										<option selected>Active</option>
										<option>Inactive</option>
										<option>Pending Department Manager</option>
									</select>
								</div>
								<div class="col-12">
									<label class="form-label">Description</label>
									<textarea class="form-control rounded-3" rows="4" name="description"
										placeholder="Describe department responsibility"><%= isCreate ? "" : "Handles sales operations, client activity, and revenue tracking." %></textarea>
								</div>
								<div class="col-12 d-flex justify-content-end gap-2">
									<a class="btn btn-outline-secondary rounded-pill px-4" href="admin-department-list.jsp">Cancel</a>
									<button class="btn btn-danger rounded-pill px-4" type="submit">
										<i class="bi bi-save me-2"></i><%= isCreate ? "Create Department" : "Save Changes" %>
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
