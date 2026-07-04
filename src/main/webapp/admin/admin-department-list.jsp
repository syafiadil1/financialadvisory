<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
	<head>
	<meta charset="UTF-8">
	<title>AI Financial Advisory System</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
	<link rel="stylesheet" href="css/chatbot-widget.css?v=2">
	</head>
	
	<body class="bg-light">
	
		<div class="container-fluid">
			<div class="row min-vh-100">
	
				<!-- SIDEBAR -->
				<aside class="col-12 col-lg-2 text-white p-4" style="background-color: #950606;">
				
				    <h4 class="fw-bold mb-4">
				        <i class="bi bi-shield-lock me-2"></i> System Admin
				    </h4>
				
				    <div class="nav flex-column nav-pills gap-2">
				
				        <a class="nav-link text-white rounded-3" href="UserController?action=list">
				            <i class="bi bi-people me-2"></i> User List
				        </a>
				
				        <a class="nav-link active text-white rounded-3" style="background-color:#ff2c2c;"
				           href="DepartmentController?action=list">
				            <i class="bi bi-building me-2"></i> Department List
				        </a>
				
				        <a class="nav-link text-white rounded-3" href="account-settings.jsp?role=admin">
				            <i class="bi bi-gear me-2"></i> Account Settings
				        </a>
				
				        <a class="nav-link text-white bg-danger rounded-3 mt-4 fw-bold" href="LogoutController">
				            <i class="bi bi-box-arrow-right me-2"></i> Logout
				        </a>
				
				    </div>
				</aside>
	
				<!-- MAIN -->
				<main class="col-12 col-lg-10 p-4">
				
				    <!-- HEADER -->
				    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
				
				        <div>
				            <h1 class="fw-bold mb-1">Department List</h1>
				            <p class="text-secondary mb-0">View departments created by System Admin.</p>
				        </div>
				
				        <div class="card border-0 shadow-sm rounded-4 mt-3 mt-md-0 role-welcome-card">
				            <div class="card-body py-2 px-3">
				                <span class="text-secondary">Welcome, </span>
				                <strong>System Admin</strong>
				            </div>
				        </div>
				
				    </div>
	
				    <!-- TABLE CARD -->
				    <section class="card border-0 shadow-sm rounded-4">
				        <div class="card-body p-4">
				
							<!-- SEARCH (UI only for now) -->
							<form action="${pageContext.request.contextPath}/DepartmentController" method="get">
							
							    <input type="hidden" name="action" value="list">
							
							    <div class="row g-3 mb-3">
							
							        <div class="col-md-11">
							            <label class="form-label">Search Department</label>
							
							            <input type="text"
							                   class="form-control rounded-3"
							                   name="keyword"
							                   value="${param.keyword}"
							                   placeholder="Search department name">
							        </div>
							
							        <div class="col-md-1 d-flex align-items-end">
							            <button type="submit"
							                    class="btn btn-danger w-100 rounded-pill">
							                <i class="bi bi-search"></i>
							            </button>
							        </div>
							
							    </div>
							
							</form>
				
				            <!-- CREATE BUTTON -->
				            <div class="d-flex justify-content-end mb-3">
				                <a class="btn btn-danger rounded-pill px-4"
				                   href="DepartmentController?action=create">
				                    <i class="bi bi-building-add me-2"></i>Create Department
				                </a>
				            </div>
				
				            <!-- TABLE -->
				            <div class="table-responsive">
				
				                <table class="table table-hover align-middle">
				
				                    <thead>
				                    <tr>
				                        <th>Department Name</th>
				                        <th>Description</th>
				                        <th class="text-center">Action</th>
				                    </tr>
				                    </thead>
				
				                    <tbody>
				
					                    <c:forEach var="dept" items="${depts}">
					                        <tr>
					                            <td>${dept.name}</td>
					                            <td>${dept.description}</td>
					
					                            <td class="text-center">
					
					                                <a class="btn btn-sm btn-outline-primary rounded-pill"
					                                   href="<%= request.getContextPath() %>/DepartmentController?action=view&id=${dept.departmentId}">	                             
					                                    <i class="bi bi-pencil-square"></i>
					                                </a>
					
					                                <a class="btn btn-sm btn-outline-danger rounded-pill"
					                                   href="DepartmentController?action=delete&id=${dept.departmentId}"
					                                   onclick="return confirm('Delete this department?')">
					                                    <i class="bi bi-trash"></i>
					                                </a>
					
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
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
		<script src="js/chatbot-widget.js?v=2"></script>
	
	</body>
</html>