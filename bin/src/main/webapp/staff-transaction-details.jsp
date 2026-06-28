<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.TransactionModel, dao.TransactionDAO" %>
<%@ page import="model.TransactionItemModel, dao.TransactionItemDAO" %>
<%@ page import="model.AttachmentModel, dao.AttachmentDAO" %>
<%@ page import="dao.CategoryDAO, model.CategoryModel" %>
<%@ page import="java.util.ArrayList" %>

<%
	TransactionDAO transactionDAO = new TransactionDAO();
	TransactionItemDAO transactionItemDAO = new TransactionItemDAO();
	AttachmentDAO attachmentDAO = new AttachmentDAO();

	String action = request.getParameter("action");
	boolean isCreate = "create".equals(action);
	boolean isEdit = "edit".equals(action);
	
	int id = request.getParameter("id") != null ? Integer.parseInt(request.getParameter("id")) : -1;
	
	TransactionModel local_transaction = transactionDAO.getTransactionById(id);
	ArrayList<TransactionItemModel> local_items = transactionItemDAO.getTransactionItemsByTransactionId(id);
	ArrayList<AttachmentModel> local_attachments = attachmentDAO.getAttachmentsByTransactionId(id);
%>

<!DOCTYPE html>
<html lang="en">
<head>
<jsp:include page="/includes/common-head.jsp" />
<style>
	.transaction-workspace {
		max-width: 1180px;
	}

	.transaction-form-card {
		border-radius: 8px;
	}

	.drop-zone {
		border: 2px dashed #9ec5fe;
		border-radius: 8px;
		background: #f8fbff;
		cursor: pointer;
		min-height: 180px;
		transition: border-color .15s ease, background-color .15s ease;
	}

	.drop-zone.drag-over {
		border-color: #0d6efd;
		background: #edf5ff;
	}

	.line-item-grid {
		display: grid;
		grid-template-columns: 110px 110px 150px minmax(180px, 1fr) 120px 140px 140px 44px;
		gap: .75rem;
		align-items: center;
	}

	.attachment-row {
		display: grid;
		grid-template-columns: 110px 110px minmax(180px, 1fr) 180px 120px minmax(180px, 1fr) 44px;
		gap: .75rem;
		align-items: center;
	}

	@media (max-width: 767.98px) {
		.line-item-grid,
		.attachment-row {
			grid-template-columns: 1fr;
		}
	}
</style>
</head>
<body class="bg-light">
	<div class="container-fluid">
		<div class="row min-vh-100">
			<jsp:include page="/includes/sidebar.jsp">
				<jsp:param name="sidebarRole" value="staff" />
				<jsp:param name="activeMenu" value="transactions" />
			</jsp:include>

			<main class="col-12 col-lg-10 p-4">
				<div class="transaction-workspace mx-auto">
					<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
						<div>
							<h1 class="fw-bold mb-1"><%= isCreate ? "Add New Transaction" : "Transaction Details" %></h1>
							<p class="text-secondary mb-0">Record transaction information, item lines, and supporting attachments.</p>
						</div>
						<a class="btn btn-outline-secondary rounded-pill px-4" href="staff-transaction.jsp">
							<i class="bi bi-arrow-left me-2"></i>Back to List
						</a>
					</div>

					<section class="card border-0 shadow-sm transaction-form-card">
						<div class="card-body p-4">
							<form action="TransactionController" method="post" enctype="multipart/form-data">
								<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 pb-3 mb-4 border-bottom">
									<h5 class="fw-bold mb-0">
										<i class="bi bi-receipt me-2"></i><%= isCreate ? "Add New Transaction" : "Edit Transaction" %>
									</h5>
									<button class="btn btn-outline-primary rounded-pill px-4" type="button"
										data-bs-toggle="modal" data-bs-target="#extractUploadModal">
										<i class="bi bi-file-earmark-arrow-up me-2"></i>Extract from PDF
									</button>
								</div>

								<div class="row g-3 mb-4">
									<div class="col-md-6">
										<label class="form-label">Transaction Title</label>
										<input type="text" class="form-control rounded-3" name="title"
											value="<%= local_transaction != null ? local_transaction.getName() : "" %>" placeholder="Example: Office Rent">
									</div>
									<div class="col-md-3">
										<label class="form-label">Type</label>
										<select class="form-select rounded-3" name="transactionType">
											<option value="income" <%= (local_transaction != null && "income".equalsIgnoreCase(local_transaction.getTransactionType())) ? "selected" : "" %>>Income</option>
											<option value="expense" <%= (local_transaction != null && "expense".equalsIgnoreCase(local_transaction.getTransactionType())) ? "selected" : "" %>>Expense</option>
										</select>
									</div>
									<div class="col-md-3">
										<label class="form-label">Category</label>
										<select class="form-select rounded-3" name="categoryId">
												<option value="">Select Category</option>
	                                        <%
	                                        	CategoryDAO categoryDAO = new CategoryDAO();
	                                        	ArrayList<CategoryModel> categories = categoryDAO.getAllCategories();
	                                        	for (CategoryModel category : categories) {
	                                        %>
	                                        	<option value="<%= category.getCategoryId() %>" <%= (local_transaction != null && local_transaction.getCategoryId() == category.getCategoryId()) ? "selected" : "" %>>
	                                        		<%= category.getName() %>
	                                        	</option>
	                                        <%
	                                        	}
	                                        %>
										</select>
									</div>
									<div class="col-md-4">
										<label class="form-label">Amount (RM)</label>
										<input type="number" step="0.01" class="form-control rounded-3"
											name="amount" value="<%= local_transaction != null ? local_transaction.getTotalAmount() : "" %>" placeholder="0.00">
									</div>
									<div class="col-md-4">
										<label class="form-label">Transaction Date</label>
										<input type="date" class="form-control rounded-3"
											name="transactionDate" value="<%= local_transaction != null ? local_transaction.getDateTransaction() : "" %>" placeholder="Select transaction date">
									</div>
									<div class="col-md-4">
										<label class="form-label">Payment Method</label>
										<input type="text" class="form-control rounded-3"
											name="paymentMethod" value="<%= local_transaction != null ? local_transaction.getPaymentMethod() : "" %>" placeholder="e.g. Bank Transfer, Credit Card, Cash">
									</div>
									<div class="col-md-4">
										<label class="form-label">Currency</label>
										<select class="form-select rounded-3" name="currency">
											<option selected>MYR</option>
											<option>USD</option>
											<option>AUD</option>
										</select>
									</div>
									<div class="col-md-4">
										<label class="form-label">Status</label>
										<select class="form-select rounded-3" name="status">
											<option selected>Pending Verification</option>
											<option>Approved</option>
											<option>Rejected</option>
										</select>\
									</div>
									<div class="col-md-6">
										<label class="form-label">Invoice / Reference Number</label>
										<input type="text" class="form-control rounded-3" name="invoiceNo"
											value="<%= local_transaction != null ? local_transaction.getInvoiceNo() : "" %>" placeholder="Invoice or payment reference">
									</div>
									<div class="col-md-6">
										<label class="form-label">Vendor / Payee Name</label>
										<input type="text" class="form-control rounded-3" name="payee"
											value="<%= local_transaction != null ? local_transaction.getPayee() : "" %>" placeholder="Vendor, customer, or payee">
									</div>
									<div class="col-12">
										<label class="form-label">Reason / Description</label>
										<textarea class="form-control rounded-3" rows="4" name="description"
											placeholder="Explain transaction purpose"><%= local_transaction != null ? local_transaction.getDescription() : "" %></textarea>
									</div>
								</div>

								<div class="border rounded-3 p-3 mb-4">
									<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
										<div>
											<h6 class="fw-bold mb-1">
												<i class="bi bi-list-check me-2"></i>Editable Item List
											</h6>
											<p class="text-secondary small mb-0">Review and edit transaction line items before submitting.</p>
										</div>
									</div>

									<div class="line-item-grid text-secondary small fw-semibold mb-2 d-none d-md-grid">
										<span>Item</span>
										<span>Description</span>
										<span>Quantity</span>
										<span>Unit Price</span>
										<span>Total</span>
										<span></span>
									</div>

									<div id="lineItems" class="vstack gap-2">
										<%
											if (local_items != null && !local_items.isEmpty()) {
                                                for (TransactionItemModel item : local_items) {
										%>
											<div class="line-item-grid line-item-row">
												<input type="text" class="form-control rounded-3" name="itemName" value="<%= item.getName() %>">
												<input type="text" class="form-control rounded-3" name="itemDescription" value="<%= item.getDescription() %>">
												<input type="number" class="form-control rounded-3 item-qty" name="itemQuantity" value="<%= item.getQuantity() %>" min="0" step="1">
												<input type="number" class="form-control rounded-3 item-price" name="itemUnitPrice" value="<%= item.getUnitPrice() %>" min="0" step="0.01">
												<input type="number" class="form-control rounded-3 item-total fw-bold" name="itemTotal" value="<%= item.getQuantity() * item.getUnitPrice() %>" min="0" step="0.01">
												<button type="button" class="btn btn-outline-danger rounded-circle remove-row" aria-label="Delete item">
													<i class="bi bi-trash"></i>
												</button>
											</div>
											<%
                                                }
                                            } else {
										%>
											<div class="no-items-message text-center text-muted py-3">
                                                No items added yet. Click "Add Item" to start.
                                            </div>
                                        	<%
                                            }
										%>
									</div>

									<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mt-3">
										<button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3" id="addItemBtn">
											<i class="bi bi-plus-circle me-2"></i>Add Item
										</button>
										<div class="d-flex align-items-center gap-3">
											<span class="fw-bold">Grand Total</span>
											<input type="number" class="form-control rounded-3 fw-bold text-danger" id="totalAmount"
												name="totalAmount" value="<%= local_transaction != null ? local_transaction.getTotalAmount() : "" %>" readonly style="max-width: 160px;">
										</div>
									</div>
								</div>

								<div class="border rounded-3 p-3 mb-4">
									<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
										<h6 class="fw-bold mb-0">
											<i class="bi bi-paperclip me-2"></i>Attachment List
										</h6>
										<button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3"
											data-bs-toggle="modal" data-bs-target="#attachmentUploadModal">
											<i class="bi bi-upload me-2"></i>Upload Attachment
										</button>
									</div>

									<div id="attachmentList" class="vstack gap-2">
									
									<% if (local_attachments != null && !local_attachments.isEmpty()) {
									   		for (AttachmentModel attachment : local_attachments) { %>
										<div class="attachment-row border-bottom pb-2">
											<div>
												<i class="bi bi-file-earmark-pdf text-danger me-2"></i>
												<span class="fw-semibold"><%= attachment.getName() %></span>
											</div>
											<span class="text-secondary small"><%= attachment.getDescription() %></span>
											<button type="button" class="btn btn-outline-danger rounded-circle remove-attachment" aria-label="Delete attachment">
												<i class="bi bi-trash"></i>
											</button>
										</div>
										<%
                                                }
                                            } else {
										%>
											<div class="no-items-message text-center text-muted py-3">
                                                No items added yet. Click "Upload Attachment" to start.
                                            </div>
                                        	<%
                                            }
										%>
									</div>
								</div>

								<div class="d-flex flex-wrap justify-content-end gap-2">
									<a class="btn btn-outline-secondary rounded-pill px-4" href="staff-transaction.jsp">Cancel</a>
									
									<button class="btn btn-primary rounded-pill px-4" type="submit" name="action" value="save">
										<i class="bi bi-send-check me-2"></i>Save
									</button>
									
									<button class="btn btn-primary rounded-pill px-4" type="submit" name="action" value="submit">
										<i class="bi bi-send-check me-2"></i>Submit Transaction
									</button>
								</div>
							</form>
						</div>
					</section>
				</div>
			</main>
		</div>
	</div>

	<div class="modal fade" id="extractUploadModal" tabindex="-1" aria-labelledby="extractUploadModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content border-0 shadow">
				<div class="modal-header">
					<h5 class="modal-title fw-bold" id="extractUploadModalLabel">Extract Transaction from PDF</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<label class="drop-zone d-flex flex-column justify-content-center align-items-center text-center p-4 w-100">
						<i class="bi bi-cloud-arrow-up fs-1 text-primary mb-2"></i>
						<span class="fw-bold">Upload invoice PDF or image</span>
						<span class="text-secondary small">Drag and drop file here, or click to browse</span>
						<span class="selected-file text-primary small mt-2"></span>
						<input class="d-none upload-input" type="file" accept=".pdf,.jpg,.jpeg,.png">
					</label>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
					<button type="button" class="btn btn-primary rounded-pill px-4" data-bs-dismiss="modal">Confirm</button>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="attachmentUploadModal" tabindex="-1" aria-labelledby="attachmentUploadModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content border-0 shadow">
				<div class="modal-header">
					<h5 class="modal-title fw-bold" id="attachmentUploadModalLabel">Upload Attachment</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<label class="drop-zone d-flex flex-column justify-content-center align-items-center text-center p-4 w-100">
						<i class="bi bi-paperclip fs-1 text-primary mb-2"></i>
						<span class="fw-bold">Upload supporting attachment</span>
						<span class="text-secondary small">Drag and drop file here, or click to browse</span>
						<span class="selected-file text-primary small mt-2"></span>
						<input class="d-none upload-input" type="file" accept=".pdf,.jpg,.jpeg,.png,.doc,.docx,.xls,.xlsx">
					</label>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
					<button type="button" class="btn btn-primary rounded-pill px-4" data-bs-dismiss="modal">Confirm</button>
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="notification-widget.jsp" />
	<jsp:include page="chatbot-widget.jsp" />
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
	<script src="js/chatbot-widget.js?v=2"></script>
	<script>
		const lineItems = document.getElementById("lineItems");
		const grandTotal = document.getElementById("grandTotal");

		function updateLineTotal(row) {
			const qty = Number(row.querySelector(".item-qty").value) || 0;
			const price = Number(row.querySelector(".item-price").value) || 0;
			row.querySelector(".item-total").value = (qty * price).toFixed(2);
			updateGrandTotal();
		}

		function updateGrandTotal() {
			const total = [...document.querySelectorAll(".item-total")]
				.reduce((sum, input) => sum + (Number(input.value) || 0), 0);
			grandTotal.value = total.toFixed(2);
		}
		
		function removeEmptyMessage(containerId) {
            const noItemsMessage = document.getElementById(containerId).querySelector(".no-items-message");
            if (noItemsMessage) {
                noItemsMessage.classList.add("d-none");
            }
        }
		
		function addEmptyMessage(containerId, message) {
			const noItemsMessage = document.getElementById(containerId).querySelector(".no-items-message");
			if (noItemsMessage) {
				noItemsMessage.classList.remove("d-none");
			}
        }

		document.getElementById("addItemBtn").addEventListener("click", () => {
			removeEmptyMessage("lineItems");
			
			const row = document.createElement("div");
			row.className = "line-item-grid line-item-row";
			row.innerHTML = `
				<input type="text" class="form-control rounded-3" name="itemName" placeholder="Item name">
				<input type="text" class="form-control rounded-3" name="itemDescription" placeholder="Item description">
				<input type="number" class="form-control rounded-3 item-qty" name="itemQuantity" value="1" min="0" step="1">
				<input type="number" class="form-control rounded-3 item-price" name="itemUnitPrice" value="0.00" min="0" step="0.01">
				<input type="number" class="form-control rounded-3 item-total fw-bold" name="itemTotal" value="0.00" min="0" step="0.01">
				<button type="button" class="btn btn-outline-danger rounded-circle remove-row" aria-label="Delete item">
					<i class="bi bi-trash"></i>
				</button>`;
			lineItems.appendChild(row);
		});

		lineItems.addEventListener("input", (event) => {
			const row = event.target.closest(".line-item-row");
			if (!row) {
				return;
			}
			if (event.target.classList.contains("item-qty") || event.target.classList.contains("item-price")) {
				updateLineTotal(row);
			}
			if (event.target.classList.contains("item-total")) {
				updateGrandTotal();
			}
		});

		lineItems.addEventListener("click", (event) => {
			const button = event.target.closest(".remove-row");
			if (!button) {
				return;
			}
			button.closest(".line-item-row").remove();
			
			// If there are no more line items, show the "no items" message
			const remainingRows = lineItems.querySelectorAll(".line-item-row");
			const noItemsMessage = document.getElementById("noItemsMessage");
			
			if (remainingRows.length === 0 && noItemsMessage) {
               noItemsMessage.classList.remove("d-none");
            }
			
			updateGrandTotal();
		});

		document.getElementById("attachmentList").addEventListener("click", (event) => {
			const button = event.target.closest(".remove-attachment");
			if (button) {
				button.closest(".attachment-row").remove();
			}
		});

		document.querySelectorAll(".drop-zone").forEach((zone) => {
			const input = zone.querySelector(".upload-input");
			const selectedFile = zone.querySelector(".selected-file");

			function setSelectedFile(files) {
				selectedFile.textContent = files && files.length ? files[0].name : "";
			}

			zone.addEventListener("dragover", (event) => {
				event.preventDefault();
				zone.classList.add("drag-over");
			});

			zone.addEventListener("dragleave", () => zone.classList.remove("drag-over"));

			zone.addEventListener("drop", (event) => {
				event.preventDefault();
				zone.classList.remove("drag-over");
				input.files = event.dataTransfer.files;
				setSelectedFile(input.files);
			});

			input.addEventListener("change", () => setSelectedFile(input.files));
		});
	</script>
</body>
</html>
