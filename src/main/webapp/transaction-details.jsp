<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.TransactionModel, dao.TransactionDAO" %>
<%@ page import="model.TransactionItemModel, dao.TransactionItemDAO" %>
<%@ page import="model.AttachmentModel, dao.AttachmentDAO" %>
<%@ page import="dao.CategoryDAO, model.CategoryModel" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	String action = request.getParameter("action");
	boolean isCreate = "create".equals(action) || "create-details".equals(action);
	boolean isEdit = "edit".equals(action);%>

<c:set var="disabledAttr" value="${isEditable ? '' : 'disabled'}" />

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
		grid-template-columns: 150px minmax(180px, 1fr) 120px 140px 140px 44px;
		gap: .75rem;
		align-items: center;
	}

	.attachment-row {
		display: grid;
		grid-template-columns: minmax(180px, 1fr) minmax(140px, 220px) 44px 44px;
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
			
			<!-- Sidebar -->
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
						<a class="btn btn-outline-secondary rounded-pill px-4" href="TransactionController?action=list">
							<i class="bi bi-arrow-left me-2"></i>Back to List
						</a>
					</div>

					<section class="card border-0 shadow-sm transaction-form-card">
						<div class="card-body p-4">
							<form id="transactionForm" action="TransactionController" method="post" enctype="multipart/form-data">
								<input type="hidden" name="transactionId" value="${transaction != null ? transaction.getTransactionId() : null}">
								<div id="pendingAttachmentInputs" class="d-none"></div>
							
								<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 pb-3 mb-4 border-bottom">
									<h5 class="fw-bold mb-0">
										<i class="bi bi-receipt me-2"></i><%= isCreate ? "Add New Transaction" : "Edit Transaction" %>
									</h5>
									<c:if test="${isEditable}">
										<button class="btn btn-outline-primary rounded-pill px-4" type="button"
											data-bs-toggle="modal" data-bs-target="#extractUploadModal">
											<i class="bi bi-file-earmark-arrow-up me-2"></i>Extract from PDF
										</button>
									</c:if>
								</div>

								<!-- mainform -->
								<div class="row g-3 mb-4">
								
									<!--  1st row -->
									<div class="col-md-6">
										<label class="form-label">
											Transaction Title <span class="text-danger">*</span>
										</label> 
										<input type="text" class="form-control rounded-3" name="title" required ${disabledAttr}
											value="${transaction != null ? transaction.name : ''}" placeholder="Example: Office Rent">
									</div>
									<div class="col-md-3">
										<label class="form-label">Type</label>
										<select class="form-select rounded-3" name="transactionType" ${disabledAttr}>
											<option value="income" <c:if test="${transaction != null && fn:toLowerCase(transaction.transactionType) eq 'income'}">selected</c:if>>Income</option>
											<option value="expense" <c:if test="${transaction != null && fn:toLowerCase(transaction.transactionType) eq 'expense'}">selected</c:if>>Expense</option>
										</select>
									</div>
									<div class="col-md-3">
										<label class="form-label">
											Category <span class="text-danger">*</span>
										</label>
										<select class="form-select rounded-3" name="categoryId" required ${disabledAttr}>
												<option value="">Select Category</option>
												<c:forEach var="category" items="${categories_dropdown}">
													<option value="${category.categoryId}" ${transaction != null && transaction.categoryId == category.categoryId ? 'selected' : ''}>
	                                        			${category.name}
	                                        		</option>
												</c:forEach>
										</select>
									</div>
									
									<!-- 2nd row -->
									<div class="col-md-3">
                                        <label class="form-label">Currency</label>
                                        <select class="form-select rounded-3" name="currency" ${disabledAttr}>
                                        	<option value="" <c:if test="${transaction != null && (transaction.currency == null || transaction.currency == '')}">selected</c:if>>Select Currency</option>
                                            <option value="MYR" <c:if test="${transaction != null && fn:toUpperCase(transaction.currency) eq 'MYR'}">selected</c:if>>MYR (Malaysian Ringgit)</option>
                                            <option value="USD" <c:if test="${transaction != null && fn:toUpperCase(transaction.currency) eq 'USD'}">selected</c:if>>USD (United States Dollar)</option>
                                            <option value="EUR" <c:if test="${transaction != null && fn:toUpperCase(transaction.currency) eq 'EUR'}">selected</c:if>>EUR (Euro)</option>
                                            <option value="GBP" <c:if test="${transaction != null && fn:toUpperCase(transaction.currency) eq 'GBP'}">selected</c:if>>GBP (British Pound)</option>
                                            <option value="JPY" <c:if test="${transaction != null && fn:toUpperCase(transaction.currency) eq 'JPY'}">selected</c:if>>JPY (Japanese Yen)</option>
                                            <!-- Add more currencies as needed -->
                                        </select>
                                    </div>
									<div class="col-md-3">
										<label class="form-label">Amount (RM)</label>
										<input type="number" step="0.01" class="form-control rounded-3" ${disabledAttr}
											name="amount" value="${transaction != null ? transaction.totalAmount : ''}" placeholder="0.00">
									</div>
									<div class="col-md-3">
										<label class="form-label">
											Transaction Date <span class="text-danger">*</span>
										</label>
										<input type="date" class="form-control rounded-3" required ${disabledAttr}
											name="transactionDate" value="${transaction != null ? transaction.dateTransaction : ''}" placeholder="Select transaction date">
									</div>
									<div class="col-md-3">
										<label class="form-label">Payment Method</label>
										<input type="text" class="form-control rounded-3" ${disabledAttr}
											name="paymentMethod" value="${transaction != null ? transaction.paymentMethod : ''}" placeholder="e.g. Bank Transfer, Credit Card, Cash">
									</div>
									
									<!-- 3rd row -->
									<div class="col-md-6">
										<label class="form-label">Invoice / Reference Number</label>
										<input type="text" class="form-control rounded-3" name="invoiceNo" ${disabledAttr}
											value="${transaction != null ? transaction.invoiceNo : ''}" placeholder="Invoice or payment reference">
									</div>
									<div class="col-md-3">
										<label class="form-label">Payer Name</label>
										<input type="text" class="form-control rounded-3" name="payer" ${disabledAttr}
											value="${transaction != null ? transaction.payer : ''}" placeholder="Payer or company name">
									</div>
									<div class="col-md-3">
										<label class="form-label">Vendor / Payee Name</label>
										<input type="text" class="form-control rounded-3" name="payee" ${disabledAttr}
											value="${transaction != null ? transaction.payee : ''}" placeholder="Vendor, customer, or payee">
									</div>
									
									<!-- 4th row -->
									<div class="col-12">
										<label class="form-label">Reason / Description</label>
										<textarea class="form-control rounded-3" rows="4" name="description" ${disabledAttr}
											placeholder="Explain transaction purpose">${transaction != null ? transaction.description : ''}</textarea>
									</div>
								</div>

								<!--  itemlist -->
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
										<c:forEach var="item" items="${transaction_items}">
                                            <div class="line-item-grid line-item-row">
                                                <input type="hidden" name="itemId" value="${item.transactionItemId}">
                                                <input type="text" class="form-control rounded-3" name="itemName" value="${item.name != null ? item.name : ''}" ${disabledAttr}>
                                                <input type="text" class="form-control rounded-3" name="itemDescription" value="${item.description != null ? item.description : ''}" ${disabledAttr}>
                                                <input type="number" class="form-control rounded-3 item-qty" name="itemQuantity" value="${item.quantity}" min="0" step="1" ${disabledAttr}>
                                                <input type="number" class="form-control rounded-3 item-price" name="itemUnitPrice" value="${item.unitPrice}" min="0" step="0.01" ${disabledAttr}>
                                                <input type="number" class="form-control rounded-3 item-total fw-bold" name="itemTotal" value="${item.quantity * item.unitPrice}" min="0" step="0.01" ${disabledAttr}>
                                                <button type="button" class="btn btn-outline-danger rounded-circle remove-row" aria-label="Delete item" ${disabledAttr}>
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
										</c:forEach>
										
										<c:if test="${transaction_items == null || transaction_items.isEmpty()}">
                                            <div class="no-items-message text-center text-muted py-3" id="noItemsMessage">
                                                No items to show. <c:if test="${isEditable}">Click "Add Item" to start.</c:if>
                                            </div>
										</c:if>
									</div>

									<div class="d-flex flex-wrap align-items-center mt-3">

								    <!-- LEFT SIDE (optional button) -->
								    <div>
								    	<c:if test="${isEditable}">
								            <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3" id="addItemBtn">
								                <i class="bi bi-plus-circle me-2"></i>Add Item
								            </button>
								       	</c:if>
								    </div>
								
								    <!-- RIGHT SIDE (always pushed right) -->
								    <div class="ms-auto d-flex align-items-center gap-3">
								
								        <span class="fw-bold">Grand Total</span>
								
								        <input type="number"
								               class="form-control rounded-3 fw-bold text-danger"
								               id="totalAmount"
								               step="0.05"
								               name="totalAmount"
								               value="<c:out value='${transaction != null ? transaction.totalAmount : 0.00}'/>"
								               style="max-width: 160px;"
								               ${disabledAttr}>
								    </div>
								
								</div>
								</div>

								<!--  attachmentlist -->
								<div class="border rounded-3 p-3 mb-4">
									<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
										<h6 class="fw-bold mb-0">
											<i class="bi bi-paperclip me-2"></i>Attachment List
										</h6>
										<c:if test="${isEditable}">
                                            <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3"
                                                data-bs-toggle="modal" data-bs-target="#attachmentUploadModal">
                                                <i class="bi bi-upload me-2"></i>Upload Attachment
                                            </button>
                                   		</c:if>
									</div>

									<div id="attachmentList" class="vstack gap-2">
									
									<c:choose >
										<c:when test="${transaction_attachments != null && !transaction_attachments.isEmpty()}">
	                                        <c:forEach var="attachment" items="${transaction_attachments}">
		                                    <div class="attachment-row border-bottom pb-2" data-attachment-id="${attachment.attachmentId}">
												<div>
													<i class="bi bi-file-earmark-pdf text-danger me-2"></i>
													<span class="fw-semibold">${attachment.name}</span>
												</div>
												<span class="text-secondary small">${ empty attachment.description ? 'No description available' : attachment.description }</span>
												<a class="btn btn-outline-primary rounded-circle enabled"
													href="AttachmentController?action=download&attachmentId=${attachment.attachmentId}"
													aria-label="Download attachment" title="Download attachment">
													<i class="bi bi-download"></i>
												</a>
												<c:if test="${isEditable}">
													<button type="button" class="btn btn-outline-danger rounded-circle remove-attachment" aria-label="Delete attachment" title="Delete attachment" ${disabledAttr}>
														<i class="bi bi-trash"></i>
													</button>
												</c:if>
											</div>
	                                        
	                                        </c:forEach>
                                    	</c:when>
                                    	
                                    	<c:otherwise>
                                    		<div class="no-items-message text-center text-muted py-3" id="noAttachmentsMessage">
                                                No attachment to show. <c:if test="${isEditable}">Click "Upload Attachment" to add.</c:if>
                                            </div>
                                    	</c:otherwise>
									</c:choose>
									</div>
								</div>

								<div class="d-flex flex-wrap justify-content-end gap-2">
								
								<c:if test="${isEditable }">
									<a class="btn btn-outline-secondary rounded-pill px-4" href="TransactionController?action=list">Cancel</a>
										
									<button class="btn <c:if test="${transaction != null}">btn-outline-primary</c:if><c:if test="${transaction == null}">btn-primary</c:if> rounded-pill px-4" type="submit" name="action" value="${ empty transaction ? 'create' : 'update' }">
										<i class="bi bi-floppy2 me-2"></i>Save
									</button>
									
									<c:if test="${transaction != null && transaction.status == 'draft'}">
                                        <button class="btn btn-primary rounded-pill px-4" type="submit" name="action" value="submit">
                                            <i class="bi bi-send-check me-2"></i>Submit Transaction
                                    	</button>
									</c:if>
								</c:if>
								</div>
								
								<div class="d-flex flex-wrap justify-content-end gap-2">
								<c:if test="${ !isEditable && isApprover}">
                                    <button class="btn btn-danger rounded-pill px-4" type="submit" name="action" value="reject">
										<i class="bi bi-x-circle me-3"></i>Reject
									</button>
									<button class="btn btn-success rounded-pill px-4" type="submit" name="action" value="approve">
										<i class="bi bi-check2-circle me-3"></i>Approve
									</button>
								</c:if>
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
						<span class="fw-bold">Upload supporting attachment</span>
						<span class="text-secondary small">Drag and drop file here, or click to browse</span>
						<span class="selected-file text-primary small mt-2"></span>
						<input id="attachmentFileInput" class="d-none upload-input" type="file" accept=".pdf,.jpg,.jpeg,.png,.doc,.docx,.xls,.xlsx">
					</label>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
					<button id="confirmAttachmentUpload" type="button" class="btn btn-primary rounded-pill px-4" data-bs-dismiss="modal">Confirm</button>
				</div>
			</div>
		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
	<script src="js/chatbot-widget.js?v=2"></script>
	<script>
		const lineItems = document.getElementById("lineItems");
		const grandTotal = document.getElementById("totalAmount");
		const contextPath = "${pageContext.request.contextPath}";
		const attachmentList = document.getElementById("attachmentList");
		const pendingAttachmentInputs = document.getElementById("pendingAttachmentInputs");
		const confirmAttachmentUpload = document.getElementById("confirmAttachmentUpload");
		const attachmentModal = document.getElementById("attachmentUploadModal");

		// 
		function updateLineTotal(row) {
			const qty = Number(row.querySelector(".item-qty").value) || 0;
			const price = Number(row.querySelector(".item-price").value) || 0;
			row.querySelector(".item-total").value = (qty * price).toFixed(2);
			updateGrandTotal();
		}

		function updateGrandTotal() {
		    const inputs = lineItems.querySelectorAll(".item-total");

		    let total = 0;

		    inputs.forEach(input => {
		        const value = parseFloat(input.value);
		        if (!isNaN(value)) {
		            total += value;
		        }
		    });

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

		const addItemBtn = document.getElementById("addItemBtn");
		if (addItemBtn) {
			addItemBtn.addEventListener("click", () => {
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
		}

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

		lineItems.addEventListener("click", async (event) => {
			const button = event.target.closest(".remove-row");
			
			if (!button) {
				return;
			}
			
			const row = button.closest(".line-item-row");
			const itemIdInput = row.querySelector("input[name='itemId']");
			const itemId = itemIdInput ? itemIdInput.value : null;
			
			const isConfirmed = confirm("Are you sure you want to delete this line item?");
			if (!isConfirmed) return;
			
			if (!itemId) {
			    row.remove();
			    updateGrandTotal();
			    return;
			}
			
			try {
				const formData = new URLSearchParams();
				formData.append("action", "delete");
				formData.append("itemId", itemId)
				
		        const res = await fetch(`${contextPath}/TransactionItemController`, {
		            method: "POST",
		            headers: {
		                "Content-Type": "application/x-www-form-urlencoded"
		            },
		            body: formData.toString()
		        });

		        if (!res.ok) throw new Error("Failed request");

		        let result;

		        try {
		            result = await res.json();
		        } catch (err) {
		            console.error("Invalid JSON response", err);
		            alert("Server returned invalid response");
		            return;
		        }

		        if (!result.success) {
		            alert("Delete failed on server");
		            return;
		        } 
		        
		        alert("Item deleted successfully.");
		        
				row.remove();
				
				// If there are no more line items, show the "no items" message
				const remainingRows = lineItems.querySelectorAll(".line-item-row");
				const noItemsMessage = document.getElementById("noItemsMessage");
				
				if (remainingRows.length === 0 && noItemsMessage) {
	               noItemsMessage.classList.remove("d-none");
	            }
				
				updateGrandTotal();
			
			} catch (err) {
				console.error(err);
				alert("Server error while deleting item.")
			}
		});

		attachmentList.addEventListener("click", async (event) => {
			const button = event.target.closest(".remove-attachment");
			if (!button) {
				return;
			}

			const row = button.closest(".attachment-row");
			const pendingInputId = row.dataset.pendingInputId;
			const attachmentId = row.dataset.attachmentId;

			if (pendingInputId) {
				document.getElementById(pendingInputId)?.remove();
				row.remove();
				toggleAttachmentEmptyMessage();
				return;
			}

			if (!attachmentId || !confirm("Are you sure you want to delete this attachment?")) {
				return;
			}

			try {
				const formData = new URLSearchParams();
				formData.append("action", "delete");
				formData.append("attachmentId", attachmentId);

				const res = await fetch(`${contextPath}/AttachmentController`, {
					method: "POST",
					headers: {
						"Content-Type": "application/x-www-form-urlencoded"
					},
					body: formData.toString()
				});

				if (!res.ok) throw new Error("Failed request");

				const result = await res.json();
				if (!result.success) {
					alert("Delete failed on server");
					return;
				}

				row.remove();
				toggleAttachmentEmptyMessage();
			} catch (err) {
				console.error(err);
				alert("Server error while deleting attachment.");
			}
		});

		if (confirmAttachmentUpload) {
			confirmAttachmentUpload.addEventListener("click", () => {
				const input = document.getElementById("attachmentFileInput");
				if (!input || !input.files || input.files.length === 0) {
					return;
				}

				const file = input.files[0];
				const pendingInputId = `pendingAttachment_${Date.now()}`;
				input.id = pendingInputId;
				input.name = "attachments";
				input.classList.add("d-none");
				pendingAttachmentInputs.appendChild(input);
				addPendingAttachmentRow(file.name, pendingInputId);
				resetAttachmentFileInput();
			});
		}

		if (attachmentModal) {
			attachmentModal.addEventListener("hidden.bs.modal", () => {
				const input = document.getElementById("attachmentFileInput");
				if (input) {
					input.value = "";
				}
				const selectedFile = attachmentModal.querySelector(".selected-file");
				if (selectedFile) {
					selectedFile.textContent = "";
				}
			});
		}

		function addPendingAttachmentRow(fileName, pendingInputId) {
			removeEmptyMessage("attachmentList");

			const row = document.createElement("div");
			row.className = "attachment-row border-bottom pb-2";
			row.dataset.pendingInputId = pendingInputId;

			const fileContainer = document.createElement("div");
			const icon = document.createElement("i");
			icon.className = "bi bi-file-earmark text-primary me-2";
			const name = document.createElement("span");
			name.className = "fw-semibold";
			name.textContent = fileName;
			fileContainer.append(icon, name);

			const status = document.createElement("span");
			status.className = "text-secondary small";
			status.textContent = "Pending save";

			const downloadPlaceholder = document.createElement("span");

			const deleteButton = document.createElement("button");
			deleteButton.type = "button";
			deleteButton.className = "btn btn-outline-danger rounded-circle remove-attachment";
			deleteButton.setAttribute("aria-label", "Delete attachment");
			deleteButton.setAttribute("title", "Delete attachment");
			deleteButton.innerHTML = '<i class="bi bi-trash"></i>';

			row.append(fileContainer, status, downloadPlaceholder, deleteButton);
			attachmentList.appendChild(row);
		}

		function resetAttachmentFileInput() {
			const dropZone = document.querySelector("#attachmentUploadModal .drop-zone");
			const input = document.createElement("input");
			input.id = "attachmentFileInput";
			input.className = "d-none upload-input";
			input.type = "file";
			input.accept = ".pdf,.jpg,.jpeg,.png,.doc,.docx,.xls,.xlsx";
			dropZone.appendChild(input);
			wireDropZone(dropZone);
		}

		function toggleAttachmentEmptyMessage() {
			const hasRows = attachmentList.querySelectorAll(".attachment-row").length > 0;
			let noAttachmentsMessage = document.getElementById("noAttachmentsMessage");
			if (!noAttachmentsMessage && !hasRows) {
				noAttachmentsMessage = document.createElement("div");
				noAttachmentsMessage.id = "noAttachmentsMessage";
				noAttachmentsMessage.className = "no-items-message text-center text-muted py-3";
				noAttachmentsMessage.textContent = "No attachment to show. Click \"Upload Attachment\" to add.";
				attachmentList.appendChild(noAttachmentsMessage);
			}
			if (noAttachmentsMessage) {
				noAttachmentsMessage.classList.toggle("d-none", hasRows);
			}
		}

		function wireDropZone(zone) {
			const input = zone.querySelector(".upload-input");
			const selectedFile = zone.querySelector(".selected-file");
			if (!input || input.dataset.wired === "true") {
				return;
			}
			input.dataset.wired = "true";

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
		}

		document.querySelectorAll(".drop-zone").forEach((zone) => wireDropZone(zone));
	</script>
</body>
</html>
