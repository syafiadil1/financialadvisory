<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
	
				<!-- SIDEBAR (UNCHANGED) -->
				<aside class="col-12 col-lg-2 text-white p-4"
				       style="background-color: #950606;">
				
				    <h4 class="fw-bold mb-4">
				        <i class="bi bi-shield-lock me-2"></i> System Admin
				    </h4>
				
				    <div class="nav flex-column nav-pills gap-2">
				
				        <a class="nav-link text-white rounded-3"
				           href="UserController?action=list">
				            <i class="bi bi-people me-2"></i> User List
				        </a>
				
				        <a class="nav-link text-white rounded-3"
				           href="DepartmentController?action=list">
				            <i class="bi bi-building me-2"></i> Department List
				        </a>
				
				        <a class="nav-link text-white rounded-3"
				           href="account-settings.jsp?role=admin">
				            <i class="bi bi-gear me-2"></i> Account Settings
				        </a>
				
				        <a class="nav-link text-white bg-danger rounded-3 mt-4 shadow-sm fw-bold"
				           href="index.jsp">
				            <i class="bi bi-box-arrow-right me-2"></i> Logout
				        </a>
				
				    </div>
				</aside>
				
				<!-- MAIN -->
				<main class="col-12 col-lg-10 p-4">
				
					<!-- HEADER -->
					<div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
					
					    <div>
					        <h1 class="fw-bold mb-1">
					
					            <c:choose>
					                <c:when test="${mode == 'create'}">
					                    Create Department
					                </c:when>
					                <c:otherwise>
					                    Department Details
					                </c:otherwise>
					            </c:choose>
					
					        </h1>
					
					        <p class="text-secondary mb-0">
					            Create or update department information and manager assignment.
					        </p>
					    </div>
					
					    <a class="btn btn-outline-secondary rounded-pill px-4"
					       href="DepartmentController?action=list">
					        <i class="bi bi-arrow-left me-2"></i>Back to List
					    </a>
					
					</div>
				
					<!-- FORM -->
					<section class="card border-0 shadow-sm rounded-4">
						<div class="card-body p-4">
						
							<form action="DepartmentController" method="post">
							
							    <!-- USER ID SEND IF MODE == UPDATE -->
					            <c:if test="${mode == 'update'}">
								    <input type="hidden"
								           name="departmentId"
								           value="${dept.departmentId}">
								</c:if>
							    <div class="row g-3">
							
							        <!-- Department Code -->
							        <div class="col-md-4">
							            <label class="form-label">Department Code</label>
							            <input type="text"
										       class="form-control rounded-3"
										       name="departmentCode"
										       value="${dept.departmentId}"
										       ${mode == 'create' ? '' : 'disabled'}>
							        </div>
							
							        <!-- Department Name -->
							        <div class="col-md-8">
							            <label class="form-label">Department Name</label>
							            <input type="text"
							                   class="form-control rounded-3"
							                   name="departmentName"
							                   value="${dept.name}">
							        </div>
							
							        <!-- Description -->
							        <div class="col-12">
							            <label class="form-label">Description</label>
							
							            <textarea class="form-control rounded-3"
							                      rows="4"
							                      name="description">${dept.description}</textarea>
							        </div>
							
							        <!-- BUTTONS -->
							        <div class="col-12 d-flex justify-content-end gap-2">
							
							            <a class="btn btn-outline-secondary rounded-pill px-4"
							               href="DepartmentController?action=list">
							                Cancel
							            </a>
							
							            <button class="btn btn-danger rounded-pill px-4"
							                    type="submit">
							
							                <c:choose>
							                    <c:when test="${mode == 'create'}">
							                        Create Department
							                    </c:when>
							                    <c:otherwise>
							                        Save Changes
							                    </c:otherwise>
							                </c:choose>
							
							            </button>
							
							        </div>
							
							    </div>
							
							</form>
						
						</div>
					</section>
	
				</main>
			</div>
		</div>
	
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
		<script src="js/chatbot-widget.js?v=2"></script>
	
	</body>
</html>