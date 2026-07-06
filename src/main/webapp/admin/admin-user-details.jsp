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

<!-- SIDEBAR -->
<aside class="col-12 col-lg-2 text-white p-4" style="background-color: #950606;">
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
            <i class="bi bi-box-arrow-right me-2"></i> <b>Logout</b>
        </a>

    </div>
</aside>

<!-- MAIN -->
<main class="col-12 col-lg-10 p-4">

    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">

        <div>
            <h1 class="fw-bold mb-1">
                <c:choose>
                    <c:when test="${mode == 'create'}">
                        Create User
                    </c:when>
                    <c:otherwise>
                        User Details
                    </c:otherwise>
                </c:choose>
            </h1>

            <p class="text-secondary mb-0">
                Create or update user profile, role, department, and account status.
            </p>
        </div>

        <a class="btn btn-outline-secondary rounded-pill px-4"
           href="UserController?action=list">
            <i class="bi bi-arrow-left me-2"></i>Back to List
        </a>

    </div>

    <!-- FORM -->
    <section class="card border-0 shadow-sm rounded-4">
    <div class="card-body p-4">

        <form action="UserController" method="post">

            <!-- USER ID SEND IF MODE == UPDATE -->
            <c:if test="${mode == 'update'}">
			    <input type="hidden"
			           name="userId"
			           value="${user.userId}">
			</c:if>

            <div class="row g-3">

                <!-- NAME -->
                <div class="col-md-6">
                    <label class="form-label">Full Name <span class="text-danger">*</span></label>
                    <input type="text" class="form-control rounded-3"
                           name="fullName"
                           value="${user.name}"
                           placeholder="Enter full name"
                           required>
                </div>

                <!-- EMAIL -->
                <div class="col-md-6">
                    <label class="form-label">Email Address <span class="text-danger">*</span></label>
                    <input type="email" class="form-control rounded-3"
                           name="email"
                           value="${user.email}"
                           placeholder="Enter email"
                           required>
                </div>

                <!-- ROLE -->
                <div class="col-md-4">
                    <label class="form-label">Role <span class="text-danger">*</span></label>
                    <select class="form-select rounded-3" name="roleId">

                        <c:forEach var="role" items="${roles}">
                        	<option value="${role.roleId}"
				                ${user.roleId == role.roleId ? 'selected' : ''}>
				
				                ${role.name}
				
				            </option>
                       </c:forEach>

                    </select>
                </div>

                <!-- DEPARTMENT -->
				<div class="col-md-4">
				    <label class="form-label">Department <span class="text-danger">*</span></label>
				
				    <select class="form-select rounded-3" name="departmentId">

				        <option value="0" ${empty user.departmentId || user.departmentId == 0 ? 'selected' : ''}>
				            Not Applicable
				        </option>
				
				        <c:forEach var="dept" items="${depts}">
				
				            <option value="${dept.departmentId}"
				                ${user.departmentId == dept.departmentId ? 'selected' : ''}>
				
				                ${dept.name}
				
				            </option>
				
				        </c:forEach>
				
				    </select>
				</div>

                <!-- STATUS (kept as UI only if not in DB) -->
                <div class="col-md-4">
                    <label class="form-label">Account Status</label>
                    <select class="form-select rounded-3" name="status">
                        <option selected>Active</option>
                        <option>Inactive</option>
                    </select>
                </div>

                <!-- PASSWORD -->
                <div class="col-md-6">
                    <label class="form-label">Temporary Password <span class="text-danger">*</span></label>
                    <input type="password" class="form-control rounded-3"
                           name="password"
                           placeholder="${mode == 'create'
                                ? 'Set temporary password'
                                : 'Leave blank to keep current password'}"
                           required>
                </div>

                <!-- BUTTONS -->
                <div class="col-12 d-flex justify-content-end gap-2">

                    <a class="btn btn-outline-secondary rounded-pill px-4"
                       href="UserController?action=list">
                        Cancel
                    </a>

                    <button class="btn btn-danger rounded-pill px-4" type="submit">
                        <i class="bi bi-save me-2"></i>

                        <c:choose>
                            <c:when test="${mode == 'create'}">
                                Create User
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
