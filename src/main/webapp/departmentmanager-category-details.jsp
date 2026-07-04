<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
            <jsp:param name="activeMenu" value="categories" />
        </jsp:include>

        <main class="col-12 col-lg-10 p-4">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
                <div>
                    <a class="btn btn-sm btn-outline-secondary rounded-pill mb-3"
                       href="${pageContext.request.contextPath}/CategoryController?action=list">
                        <i class="bi bi-arrow-left me-1"></i>Back to Category List
                    </a>

                    <h1 class="fw-bold mb-1">
                        <c:choose>
                            <c:when test="${mode == 'create'}">Add New Category</c:when>
                            <c:otherwise>Edit Category</c:otherwise>
                        </c:choose>
                    </h1>

                    <p class="text-secondary mb-0">
                        <c:choose>
                            <c:when test="${mode == 'create'}">
                                Create a new transaction category for your department.
                            </c:when>
                            <c:otherwise>
                                Update the details of an existing category.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <div class="card border-0 shadow-sm rounded-4 mt-3 mt-md-0 role-welcome-card">
                    <div class="card-body py-2 px-3">
                        <span class="text-secondary">Welcome, </span>
                        <strong>${sessionScope.user.name}</strong>
                    </div>
                </div>
            </div>

            <section class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4">
                    <h5 class="fw-bold mb-3">
                        <i class="bi bi-tags me-2"></i>
                        <c:choose>
                            <c:when test="${mode == 'create'}">Category Information</c:when>
                            <c:otherwise>Category Details</c:otherwise>
                        </c:choose>
                    </h5>

                    <form action="${pageContext.request.contextPath}/CategoryController?action=save" method="post">
                        <input type="hidden" name="categoryId" value="${category.categoryId}">

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Category Name</label>
                                <input type="text"
                                       class="form-control rounded-3"
                                       name="categoryName"
                                       placeholder="Enter category name"
                                       value="${category.name}"
                                       required>
                            </div>
                            <div class="form-check form-switch mt-3">
                                <div class="form-check form-switch pt-2">
                                    <input class="form-check-input"
                                           type="checkbox"
                                           role="switch"
                                           name="isPublic"
                                           id="isPublic"
                                           <c:if test="${category.generic}">checked</c:if> disabled>

                                    <label class="form-check-label ms-2" for="isPublic">
                                        Public Category
                                    </label>
                                </div>
                            </div>

                            <div class="col-12 d-flex justify-content-end gap-2 mt-4">
                                <a class="btn btn-outline-secondary rounded-pill px-4"
                                   href="${pageContext.request.contextPath}/CategoryController?action=list">
                                    Cancel
                                </a>

                                <button class="btn btn-primary rounded-pill px-4" type="submit">
                                    <i class="bi bi-save me-2"></i>
                                    <c:choose>
                                        <c:when test="${mode == 'create'}">Create Category</c:when>
                                        <c:otherwise>Save Changes</c:otherwise>
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
<jsp:include page="/includes/common-scripts.jsp" />
</body>
</html>