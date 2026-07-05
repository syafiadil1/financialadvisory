<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ page import="dao.TransactionDAO,model.TransactionModel" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="en">
<head>
<jsp:include page="/includes/common-head.jsp" />

<c:set var="first_card" value="${summary_cards[0]}" />

<style>
	html {
		scroll-behavior: smooth;
	}

	section {
		scroll-margin-top: 20px;
	}
</style>
</head>

<body class="bg-light">

	<div class="container-fluid">
		<div class="row min-vh-100">

			<!-- Sidebar -->
			<jsp:include page="/includes/sidebar.jsp">
				<jsp:param name="sidebarRole" value="staff" />
				<jsp:param name="activeMenu" value="transactions" />
			</jsp:include>

			<!-- Main Content -->
			<main class="col-12 col-lg-10 p-4">

				<!-- Header -->
				<jsp:include page="/includes/page-header.jsp">
					<jsp:param name="pageTitle" value="Transaction Management" />
					<jsp:param name="pageSubtitle" value="Record, upload invoice, and submit company transactions for approval." />
					<jsp:param name="pageRoleName" value="Staff" />
				</jsp:include>

				<!-- Summary Cards -->
				<div class="row g-3">
				    <c:forEach var="card" items="${summary_cards}">
				        <div class="col">
				            <div class="card border-0 shadow-sm rounded-4 h-100 ${card.borderClass}">
				                <div class="card-body p-4">
				                    <div class="d-flex justify-content-between align-items-center">
				                        <p class="text-secondary mb-1">${card.title}</p>
				                        <i class="bi bi-arrow-down-circle fs-2 ${card.colorClass}"></i>
				                    </div>
				
				                    <h3 class="fw-bold mb-0">${card.data}</h3>
				                    <small class="${card.colorClass}">${card.description}</small>
				                </div>
				            </div>
				        </div>
				    </c:forEach>
				</div>

					<!-- Transaction Table -->
				<section class="card border-0 shadow-sm rounded-4">
					<div class="card-body p-4">
						<div class="d-flex justify-content-between align-items-center mb-3">
							<h5 class="fw-bold mb-0">
								<i class="bi bi-list-ul me-2"></i> Transaction List
							</h5>
							<div class="d-flex gap-2">
									<c:if test="${!isReadOnly}">
                                        <a href="TransactionController?action=create-details" class="btn btn-primary rounded-pill px-4">
											<i class="bi bi-plus-circle me-2"></i>Create New
										</a>
                                     </c:if>
									<a href="#" class="btn btn-outline-primary rounded-pill px-4">
										<i class="bi bi-download me-2"></i>Export
									</a>
								</div>
						</div>

						<form action="${pageContext.request.contextPath}/TransactionController" method="get" class="mb-4">
							<input type="hidden" name="action" value="list">
							<div class="row g-3 align-items-end">
								<div class="col-md-3">
									<label class="form-label">Search Transaction</label>
									<input type="text" class="form-control rounded-3" name="keyword"
										value="${param.keyword}" placeholder="Title, invoice, payer, payee">
								</div>
								<div class="col-md-2">
									<label class="form-label">Type</label>
									<select class="form-select rounded-3" name="transactionType">
										<option value="">All Types</option>
										<option value="income" ${param.transactionType == 'income' ? 'selected' : ''}>Income</option>
										<option value="expense" ${param.transactionType == 'expense' ? 'selected' : ''}>Expense</option>
									</select>
								</div>
								<c:if test="${not empty departments}">
									<div class="col-md-2">
										<label class="form-label">Department</label>
										<select class="form-select rounded-3" name="departmentId">
											<option value="">All Departments</option>
											<c:forEach var="department" items="${departments}">
												<option value="${department.departmentId}" ${param.departmentId == department.departmentId.toString() ? 'selected' : ''}>
													${department.name}
												</option>
											</c:forEach>
										</select>
									</div>
								</c:if>
								<div class="col-md-2">
									<label class="form-label">Category</label>
									<select class="form-select rounded-3" name="categoryId">
										<option value="">All Categories</option>
										<c:forEach var="category" items="${categories_dropdown}">
											<option value="${category.categoryId}" ${param.categoryId == category.categoryId.toString() ? 'selected' : ''}>
												${category.name}
											</option>
										</c:forEach>
									</select>
								</div>
								<div class="col-md-2">
									<label class="form-label">Payment</label>
									<input type="text" class="form-control rounded-3" name="paymentMethod"
										value="${param.paymentMethod}" placeholder="Method">
								</div>
								<div class="col-md-2">
									<label class="form-label">Status</label>
									<select class="form-select rounded-3" name="status">
										<option value="">All Statuses</option>
										<option value="draft" ${param.status == 'draft' ? 'selected' : ''}>Draft</option>
										<option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
										<option value="approved" ${param.status == 'approved' ? 'selected' : ''}>Approved</option>
										<option value="rejected" ${param.status == 'rejected' ? 'selected' : ''}>Rejected</option>
									</select>
								</div>
								<div class="col-md-1 d-flex gap-2">
									<button type="submit" class="btn btn-primary w-100 rounded-pill" title="Apply filters">
										<i class="bi bi-search"></i>
									</button>
									<a class="btn btn-outline-secondary rounded-pill" href="${pageContext.request.contextPath}/TransactionController?action=list" title="Clear filters">
										<i class="bi bi-x-lg"></i>
									</a>
								</div>
							</div>
						</form>

						<div class="table-responsive">
							<table class="table table-hover align-middle">
								<thead>
									<tr>
										<th>Date</th>
										<th>Title</th>
										<th>Type</th>
										<th>Department</th>
										<th>Category</th>
										<th>Payment</th>
										<th class="text-end">Amount</th>
										<th>Approval Status</th>
										<th class="text-center">Action</th>
									</tr>
								</thead>

									<tbody>
										<c:forEach var="transaction" items="${transactions_list}">
											<tr>
												<td>${transaction.dateTransaction}</td>
												<td>${transaction.getName()}</td>
												<td><c:choose>
														<c:when test="${transaction.transactionType eq 'income'}">
															<span class="badge rounded-pill text-bg-success">Income</span>
														</c:when>
														<c:otherwise>
														<span class="badge rounded-pill text-bg-danger">Expense</span>
														</c:otherwise>
												</c:choose>
												</td>
												<td>${ empty transaction.departmentName ? 'N/A' : transaction.departmentName}</td>
												<td>${ empty transaction.categoryName ? 'N/A' : transaction.categoryName}</td>
												<td>${ empty transaction.paymentMethod ? 'N/A' : transaction.paymentMethod}</td>
												<td class="text-end text-success fw-bold">RM ${transaction.totalAmount}</td>
												
												<c:choose>
													<c:when test="${fn:toLowerCase(transaction.status) eq 'approved'}">
                                                        <td><span class="badge rounded-pill text-bg-success">Approved</span></td>
                                                    </c:when>
                                                    <c:when test="${fn:toLowerCase(transaction.status) eq 'rejected'}">
                                                        <td><span class="badge rounded-pill text-bg-danger">Rejected</span></td>
                                                    </c:when>
                                                    <c:when test="${fn:toLowerCase(transaction.status) eq 'pending'}">
                                                        <td><span class="badge rounded-pill text-bg-warning">Pending Verification</span></td>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <td><span class="badge rounded-pill text-bg-secondary">Draft</span></td>
                                                    </c:otherwise>
												</c:choose>
													
												<td class="text-center">
													<a class="btn btn-sm btn-outline-primary rounded-pill" href="TransactionController?action=view-details&transactionId=${transaction.transactionId}"><i class="bi bi-eye"></i></a>
													<form action="TransactionController" method="post" style="display:inline;">
														<input type="hidden" name="action" value="delete">
														<input type="hidden" name="transactionId" value="${transaction.transactionId}">
														<a href="#" class="btn btn-sm btn-outline-danger rounded-pill" onclick="if(confirm('Are you sure you want to delete this transaction?')) { this.closest('form').submit(); } return false;" name="action" value="delete"><i class="bi bi-trash"></i></a>
													</form>
												</td>
											</tr>
										</c:forEach>
										<!-- <tr>
											<td>2026-01-08</td>
											<td>Office Rent</td>
											<td><span class="badge rounded-pill text-bg-danger">Expense</span></td>
											<td>Rent</td>
											<td>Bank Transfer</td>
											<td class="text-end text-danger fw-bold">RM 32,471.00</td>
											<td><span class="badge rounded-pill text-bg-warning">Pending Verification</span></td>
											<td class="text-center">
												<a class="btn btn-sm btn-outline-secondary rounded-pill" href="transaction-details.jsp?id=rent-001"><i class="bi bi-eye"></i></a>
												<a href="transaction-details.jsp?action=edit&id=rent-001" class="btn btn-sm btn-outline-primary rounded-pill"><i class="bi bi-pencil-square"></i></a>
												<a href="#" class="btn btn-sm btn-outline-danger rounded-pill"><i class="bi bi-trash"></i></a>
											</td>
										</tr>
										<tr>
											<td>2026-01-10</td>
											<td>Internet Bill</td>
					s						<td><span class="badge rounded-pill text-bg-danger">Expense</span></td>
											<td>Utilities</td>
											<td>Online Payment</td>
											<td class="text-end text-danger fw-bold">RM 76,432.00</td>
											<td><span class="badge rounded-pill text-bg-danger">Rejected</span></td>
											<td class="text-center">
												<a class="btn btn-sm btn-outline-secondary rounded-pill" href="transaction-details.jsp?id=internet-001"><i class="bi bi-eye"></i></a>
												<a href="transaction-details.jsp?action=edit&id=internet-001" class="btn btn-sm btn-outline-primary rounded-pill"><i class="bi bi-pencil-square"></i></a>
												<a href="#" class="btn btn-sm btn-outline-danger rounded-pill"><i class="bi bi-trash"></i></a>
											</td>
										</tr>
										<tr>
											<td>2026-01-14</td>
											<td>Marketing Campaign</td>
											<td><span class="badge rounded-pill text-bg-danger">Expense</span></td>
											<td>Marketing</td>
											<td>Credit Card</td>
											<td class="text-end text-danger fw-bold">RM 46,832.00</td>
											<td><span class="badge rounded-pill text-bg-warning">Pending Verification</span></td>
											<td class="text-center">
												<a class="btn btn-sm btn-outline-secondary rounded-pill" href="transaction-details.jsp?id=marketing-001"><i class="bi bi-eye"></i></a>
												<a href="transaction-details.jsp?action=edit&id=marketing-001" class="btn btn-sm btn-outline-primary rounded-pill"><i class="bi bi-pencil-square"></i></a>
												<a href="#" class="btn btn-sm btn-outline-danger rounded-pill"><i class="bi bi-trash"></i></a>
											</td>
										</tr>
										<tr>
											<td>2026-01-20</td>
											<td>ABC Supplier Sdn Bhd - INV-0001</td>
											<td><span class="badge rounded-pill text-bg-danger">Expense</span></td>
											<td>Supplies</td>
											<td>Invoice</td>
											<td class="text-end text-danger fw-bold">RM 477.00</td>
											<td><span class="badge rounded-pill text-bg-warning">Pending Verification</span></td>
											<td class="text-center">
												<a class="btn btn-sm btn-outline-secondary rounded-pill" href="transaction-details.jsp?id=invoice-001"><i class="bi bi-eye"></i></a>
												<a href="transaction-details.jsp?action=edit&id=invoice-001" class="btn btn-sm btn-outline-primary rounded-pill"><i class="bi bi-pencil-square"></i></a>
												<a href="#" class="btn btn-sm btn-outline-danger rounded-pill"><i class="bi bi-trash"></i></a>
											</td>
										</tr> -->
									</tbody>
							</table>
						</div>

						<nav class="mt-3">
							<ul class="pagination justify-content-end mb-0">
								<li class="page-item disabled">
									<a class="page-link">Previous</a>
								</li>
								<li class="page-item active">
									<a class="page-link" href="#">1</a>
								</li>
								<li class="page-item">
									<a class="page-link" href="#">2</a>
								</li>
								<li class="page-item">
									<a class="page-link" href="#">Next</a>
								</li>
							</ul>
						</nav>
					</div>
				</section>

			</main>
		</div>
	</div>
<!-- Bootstrap JS -->
	<jsp:include page="/includes/common-scripts.jsp" />

	<!-- Chatbot Widget JS -->

</body>
</html>
