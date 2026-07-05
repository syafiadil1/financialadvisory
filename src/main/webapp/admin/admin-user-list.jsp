<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    

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
				style="background-color: #950606;">
				<h4 class="fw-bold mb-4">
					<i class="bi bi-shield-lock me-2"></i> System Admin
				</h4>
				<div class="nav flex-column nav-pills gap-2">
					<a class="nav-link active text-white rounded-3"
						style="background-color: #ff2c2c;" href="<%= request.getContextPath() %>/UserController?action=list">
						<i class="bi bi-people me-2"></i> User List
					</a>
					<a class="nav-link text-white rounded-3" href="<%= request.getContextPath() %>/DepartmentController?action=list">
						<i class="bi bi-building me-2"></i> Department List
					</a>
					<a class="nav-link text-white rounded-3" href="<%= request.getContextPath() %>/UserController?action=profile">
						<i class="bi bi-gear me-2"></i> Account Settings
					</a>

					<a class="nav-link text-white bg-danger rounded-3 mt-4 shadow-sm fw-bold" href="<%= request.getContextPath() %>/logout">
						<i class="bi bi-box-arrow-right me-2"></i> <b>Logout</b>
					</a>
				</div>
			</aside>

			<main class="col-12 col-lg-10 p-4">
				<div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
					<div>
						<h1 class="fw-bold mb-1">User List</h1>
						<p class="text-secondary mb-0">
							View and manage users created by the System Admin.
						</p>
					</div>

					<div class="card border-0 shadow-sm rounded-4 mt-3 mt-md-0 role-welcome-card">
						<div class="card-body py-2 px-3">
							<span class="text-secondary">Welcome, </span>
							<strong>System Admin</strong>
						</div>
					</div>
				</div>

				<section class="card border-0 shadow-sm rounded-4">
					<div class="card-body p-4">
					
						<form action="${pageContext.request.contextPath}/UserController" method="get">
						
						    <input type="hidden" name="action" value="list">
						
						    <div class="row g-3 mb-3">
						
						        <!-- Search -->
						        <div class="col-md-4">
						            <label class="form-label">Search User</label>
						            <input type="text"
						                   class="form-control rounded-3"
						                   name="keyword"
						                   value="${param.keyword}"
						                   placeholder="Search by name or email">
						        </div>
						
						        <!-- Role -->
						        <div class="col-md-3">
						            <label class="form-label">Filter Role</label>
						
						            <select class="form-select rounded-3" name="roleId">
						
						                <option value="">All Roles</option>
						
						                <c:forEach var="role" items="${roles}">
						                    <option value="${role.roleId}"
						                        ${param.roleId == role.roleId.toString() ? 'selected' : ''}>
						                        ${role.name}
						                    </option>
						                </c:forEach>
						
						            </select>
						        </div>
						
						        <!-- Department -->
						        <div class="col-md-3">
						            <label class="form-label">Filter Department</label>
						
						            <select class="form-select rounded-3" name="departmentId">
						
						                <option value="">All Departments</option>
						
						                <c:forEach var="dept" items="${depts}">
						                    <option value="${dept.departmentId}"
						                        ${param.departmentId == dept.departmentId.toString() ? 'selected' : ''}>
						                        ${dept.name}
						                    </option>
						                </c:forEach>
						
						            </select>
						        </div>
						
						        <!-- Search Button -->
						        <div class="col-md-2 d-flex align-items-end gap-2">
						            <button type="submit"
						                    class="btn btn-danger flex-fill rounded-pill">
						                <i class="bi bi-search"></i>
						            </button>
						            <a class="btn btn-outline-secondary rounded-pill"
						               href="${pageContext.request.contextPath}/UserController?action=list">
						                <i class="bi bi-x-lg"></i>
						            </a>
						        </div>
						
						    </div>
						
						</form>

						<div class="d-flex justify-content-end mb-4">
							<a class="btn btn-danger rounded-pill px-4" href="UserController?action=create">
								<i class="bi bi-person-plus me-2"></i>Create New User
							</a>
						</div>

						<div class="table-responsive">
							<table class="table table-hover align-middle mb-0">
							    <thead>
							        <tr>
							            <th>User</th>
							            <th>Email</th>
							            <th>Role</th>
							            <th>Department</th>
							            <th class="text-center">Action</th>
							        </tr>
							    </thead>
							
							    <tbody>
							
							        <c:forEach var="user" items="${users}">
							            <tr>
							                <td>${user.name}</td>
							                <td>${user.email}</td>
							                <td>
							                    <c:choose>
							                        <c:when test="${user.roleId == 1}">
							                            <span class="badge text-bg-danger rounded-pill">System Admin</span>
							                        </c:when>
							
							                        <c:when test="${user.roleId == 2}">
							                            <span class="badge text-bg-primary rounded-pill">Financial Manager</span>
							                        </c:when>
							
							                        <c:when test="${user.roleId == 3}">
							                            <span class="badge text-bg-warning rounded-pill">Department Manager</span>
							                        </c:when>
							
							                        <c:otherwise>
							                            <span class="badge text-bg-secondary rounded-pill">Staff</span>
							                        </c:otherwise>
							                    </c:choose>
							                </td>
							
							                <td>
							                    <c:choose>
							                        <c:when test="${user.departmentId == 0}">
							                            Not Applicable
							                        </c:when>
							                        <c:otherwise>
							                            ${user.departmentId}
							                        </c:otherwise>
							                    </c:choose>
							                </td>
							                <td class="text-center">
							
							                    <c:choose>
							                        <c:when test="${user.roleId == 1}">
							                            <span class="text-secondary">Not Applicable</span>
							                        </c:when>
							                        <c:otherwise>
							                            <a class="btn btn-sm btn-outline-primary rounded-pill"
							                               href="<%= request.getContextPath() %>/UserController?action=view&id=${user.userId}">
							                                <i class="bi bi-pencil-square"></i>
							                            </a>
							                        <a class="btn btn-sm btn-outline-danger rounded-pill"
					                                   href="UserController?action=delete&id=${user.userId}"
					                                   onclick="return confirm('Delete this user?')">
					                                    <i class="bi bi-trash"></i>
					                                </a>
							                        </c:otherwise>
							                    </c:choose>
							                </td>
							            </tr>
							
							        </c:forEach>
							
							    </tbody>
							
							</table>
						</div>
					</div>
				</section>
			</main>
		</div>
	</div>


	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
	<script src="<%= request.getContextPath() %>/js/chatbot-widget.js?v=2"></script>
</body>
</html>
