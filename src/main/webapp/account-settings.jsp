<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
<jsp:include page="/includes/common-head.jsp" />
</head>

<body class="bg-light">

<div class="container-fluid">
<div class="row min-vh-100">

<!-- SIDEBAR -->
<jsp:include page="/includes/sidebar.jsp">
    <jsp:param name="sidebarRole" value="${roleId}" />
    <jsp:param name="activeMenu" value="settings" />
</jsp:include>

<!-- MAIN -->
<main class="col-12 col-lg-10 p-4">

<!-- ROLE CONFIG (JSTL ONLY) -->
<c:choose>

    <c:when test="${roleId == 1}">
        <c:set var="roleName" value="System Admin"/>
        <c:set var="sidebarColor" value="#950606"/>
        <c:set var="profileSubtitle" value="Administration Account"/>
        <c:set var="avatarIcon" value="bi-person-gear"/>
        <c:set var="buttonClass" value="btn-danger"/>
        <c:set var="department" value="Not Applicable"/>
    </c:when>

    <c:when test="${roleId == 2}">
        <c:set var="roleName" value="Financial Manager"/>
        <c:set var="sidebarColor" value="#0F766E"/>
        <c:set var="profileSubtitle" value="Financial Manager"/>
        <c:set var="avatarIcon" value="bi-person-check"/>
        <c:set var="buttonClass" value="btn-success"/>
        <c:set var="department" value="Finance"/>
    </c:when>

    <c:when test="${roleId == 3}">
        <c:set var="roleName" value="Department Manager"/>
        <c:set var="sidebarColor" value="#4338CA"/>
        <c:set var="profileSubtitle" value="Department Manager"/>
        <c:set var="avatarIcon" value="bi-person-badge"/>
        <c:set var="buttonClass" value="btn-primary"/>
        <c:set var="department" value="Sales"/>
    </c:when>

    <c:when test="${roleId == 4}">
        <c:set var="roleName" value="Staff"/>
        <c:set var="sidebarColor" value="#0D6EFD"/>
        <c:set var="profileSubtitle" value="Department Staff"/>
        <c:set var="avatarIcon" value="bi-person"/>
        <c:set var="buttonClass" value="btn-primary"/>
        <c:set var="department" value="Operations"/>
    </c:when>

</c:choose>

<!-- HEADER -->
<div class="d-flex flex-wrap justify-content-between align-items-center mb-4">

    <div>
        <h1 class="fw-bold mb-1">Account Settings</h1>
        <p class="text-secondary mb-0">
            Manage your profile, your details and password.
        </p>
    </div>

</div>

<!-- PROFILE CARD -->
<section class="row g-4">

<div class="col-lg-4">
    <div class="card border-0 shadow-sm rounded-4 h-100">
        <div class="card-body p-4 text-center">

            <div class="text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                 style="width: 92px; height: 92px; background-color: ${sidebarColor};">

                <i class="bi ${avatarIcon} fs-1"></i>

            </div>

            <h5 class="fw-bold mb-1">${user.name}</h5>
            <p class="text-secondary mb-3">${profileSubtitle}</p>

        </div>
    </div>
</div>

<!-- FORM -->
<div class="col-lg-8">

<form action="UserController" method="post">

    <input type="hidden" name="action" value="updateProfile">
    <input type="hidden" name="userId" value="${user.userId}">
	<input type="hidden" name="source" value="profile">
    <!-- PROFILE DETAILS -->
    <div class="card border-0 shadow-sm rounded-4 mb-4">
        <div class="card-body p-4">

            <h5 class="fw-bold mb-3">Profile Details</h5>

            <div class="row g-3">

                <div class="col-md-6">
                    <label class="form-label">Full Name</label>
                    <input type="text" class="form-control rounded-3"
                           name="fullName"
                           value="${user.name}">
                </div>

                <div class="col-md-6">
                    <label class="form-label">Email Address</label>
                    <input type="email" class="form-control rounded-3"
                           name="email"
                           value="${user.email}">
                </div>

				<div class="col-md-6">
				    <label class="form-label">Role</label>
				
				    <c:choose>
				        <c:when test="${user.roleId == 1}">
				
				            <input type="hidden" name="roleId" value="1">
				
				            <select class="form-select rounded-3" disabled>
				                <option selected>System Admin</option>
				            </select>
				
				        </c:when>

				        <c:otherwise>
				
				            <select class="form-select rounded-3" name="roleId">
				
				                <c:forEach var="role" items="${roles}">
				
				                    <option value="${role.roleId}"
				                        ${user.roleId == role.roleId ? 'selected' : ''}>
				
				                        ${role.name}
				
				                    </option>
				
				                </c:forEach>
				
				            </select>
				
				        </c:otherwise>
				
				    </c:choose>
				
				</div>

                <div class="col-md-6">
				    <label class="form-label">Department</label>
				
				    <c:choose>
				        <c:when test="${user.roleId == 1}">
				
				            <input type="hidden" name="departmentId" value="0">
				
				            <select class="form-select rounded-3" disabled>
				                <option selected>Not Applicable</option>
				            </select>
				
				        </c:when>

				        <c:otherwise>
				            <select class="form-select rounded-3" name="departmentId">
				
				                <c:forEach var="dept" items="${depts}">
				
				                    <option value="${dept.departmentId}"
				                        ${user.departmentId == dept.departmentId ? 'selected' : ''}>
				
				                        ${dept.name}
				
				                    </option>
				
				                </c:forEach>
				
				            </select>
				
				        </c:otherwise>
				
				    </c:choose>
				
				</div>

            </div>

        </div>
    </div>

    <!-- SECURITY -->
    <div class="card border-0 shadow-sm rounded-4">
        <div class="card-body p-4">

            <h5 class="fw-bold mb-3">Security and Preferences</h5>

            <div class="row g-3">

			<div class="col-md-6">
			    <label class="form-label">Password</label>
			    <input type="password" class="form-control rounded-3"
			           name="password"
			           placeholder="Leave blank to keep current password">
			</div>

                <div class="col-12 d-flex justify-content-end gap-2">

                    <button type="submit" class="btn ${buttonClass} rounded-pill px-4">
                        Save Settings
                    </button>

                </div>

            </div>

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