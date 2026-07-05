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
				<jsp:include page="/includes/page-header.jsp">
					<jsp:param name="pageTitle" value="Category Management" />
					<jsp:param name="pageSubtitle" value="Create, edit, and manage transaction categories for your department." />
					<jsp:param name="pageRoleName" value="Department Manager" />
				</jsp:include>

				<!-- Category List Section -->
				<section class="card border-0 shadow-sm rounded-4">
					<div class="card-body p-4">
						<form action="${pageContext.request.contextPath}/CategoryController" method="get">
						
						    <input type="hidden" name="action" value="list">
						
						    <div class="row g-3 mb-4">
						
						        <div class="col-md-7">
						            <label class="form-label">Search Category</label>
						
						            <input type="text"
						                   class="form-control rounded-3"
						                   name="keyword"
						                   value="${param.keyword}"
						                   placeholder="Search by category name">
						        </div>

						        <div class="col-md-3">
						            <label class="form-label">Filter Type</label>
						            <select class="form-select rounded-3" name="categoryType">
						                <option value="">All Types</option>
						                <option value="public" ${param.categoryType == 'public' ? 'selected' : ''}>Public</option>
						                <option value="department" ${param.categoryType == 'department' ? 'selected' : ''}>Department</option>
						            </select>
						        </div>
						
						        <div class="col-md-2 d-flex align-items-end">
						            <button type="submit"
						                    class="btn btn-primary flex-fill rounded-pill">
						                <i class="bi bi-search"></i>
						            </button>
						            <a class="btn btn-outline-secondary rounded-pill ms-2"
						               href="${pageContext.request.contextPath}/CategoryController?action=list">
						                <i class="bi bi-x-lg"></i>
						            </a>
						        </div>
						
						    </div>
						
						</form>

						<!-- Add Category Button -->
						<div class="d-flex justify-content-end mb-3">
							<a class="btn btn-primary rounded-pill px-4"
								href="${pageContext.request.contextPath}/CategoryController?action=create">
								<i class="bi bi-plus-circle me-2"></i>Add Category
							</a>
						</div>

						<!-- Table -->
						<div class="table-responsive">
							<table class="table table-hover align-middle mb-0">
								<thead>
									<tr>
										<th>No.</th>
										<th>Category Name</th>
										<th>Type</th>
										<th class="text-center">Action</th>
									</tr>
								</thead>
								<tbody>
								    <c:forEach var="category" items="${categories}" varStatus="status">
								        <tr>
								            <td>${status.count}</td>
								
								            <td class="fw-bold">
								                ${category.name}
								            </td>

								            <td>
								                <c:choose>
								                    <c:when test="${category.generic}">
								                        <span class="badge rounded-pill text-bg-success">Public</span>
								                    </c:when>
								                    <c:otherwise>
								                        <span class="badge rounded-pill text-bg-primary">Department</span>
								                    </c:otherwise>
								                </c:choose>
								            </td>
									
								            <td class="text-center">
								
								                <a href="${pageContext.request.contextPath}/CategoryController?action=view&categoryId=${category.categoryId}"
								                   class="btn btn-sm btn-outline-primary rounded-pill me-1">
								                    <i class="bi bi-pencil-square"></i>
								                </a>
								
								                <a href="${pageContext.request.contextPath}/CategoryController?action=delete&categoryId=${category.categoryId}"
								                   class="btn btn-sm btn-outline-danger rounded-pill"
								                   onclick="return confirm('Delete this category?')">
								                    <i class="bi bi-trash"></i>
								                </a>
								
								            </td>
								        </tr>
								    </c:forEach>
								</tbody>
							</table>
						</div>

						<!-- Pagination -->
						<nav class="mt-3">
							<ul class="pagination justify-content-end mb-0">
								<li class="page-item disabled"><a class="page-link">Previous</a></li>
								<li class="page-item active"><a class="page-link" href="#">1</a></li>
								<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>
							</ul>
						</nav>
					</div>
				</section>
			</main>
		</div>
	</div>
<jsp:include page="/includes/common-scripts.jsp" />
</body>
</html>
