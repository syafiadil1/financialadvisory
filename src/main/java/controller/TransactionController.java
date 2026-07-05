package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.TransactionModel;
import model.UserModel;
import model.AttachmentModel;
import model.CategoryModel;
import model.SummaryCardModel;
import model.TransactionItemModel;
import util.ErrorUtil;


import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

import dao.AttachmentDAO;
import dao.CategoryDAO;
import dao.DepartmentDAO;
import dao.SummaryCardDAO;
import dao.TransactionDAO;
import dao.TransactionItemDAO;
import helper.RoleHelper;
import helper.SessionHelper;

/**
 * Servlet implementation class TransactionController
 */
@MultipartConfig
@WebServlet("/TransactionController")
public class TransactionController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TransactionController() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Handle GET requests if needed
    	
    	String action = request.getParameter("action");
    	
    	if (action == null || action.isEmpty()) {
    		response.sendError(HttpServletResponse.SC_BAD_REQUEST,
    				ErrorUtil.format("TransactionController.java", "doGet", "Action parameter is missing"));
    		return;
    	}
    	
    	switch (action) {
    		case "list" -> listTransactions(request, response);
    		
    		case "view-details" -> viewTransactionDetails(request, response);
    		
    		case "create-details" -> createTransactionDetails(request, response);
    		
    		default -> response.sendError(HttpServletResponse.SC_BAD_REQUEST,
    				ErrorUtil.format("TransactionController.java", "doGet", "Invalid action"));
    	}
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String action = request.getParameter("action");
		
		if (action == null || action.isEmpty()) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST,
					ErrorUtil.format("TransactionController.java", "doPost", "Action parameter is missing"));
			return;
		}
		
		switch (action) {
			case "create" -> createTransaction(request, response, false);
				
			case "update" -> updateTransaction(request, response, false);
				
			case "delete" -> deleteTransaction(request, response);
				
			case "submit" -> submitTransaction(request, response);
			
			case "approve" -> confirmApproval(request, response, true);
			
			case "reject" -> confirmApproval(request, response, false);
				
			default -> response.sendError(HttpServletResponse.SC_BAD_REQUEST,
					ErrorUtil.format("TransactionController.java", "doPost", "Invalid action"));
		}
	}
	
	private void createTransaction(HttpServletRequest request, HttpServletResponse response, boolean isSubmit) throws ServletException, IOException {
		
		UserModel curr_user = SessionHelper.getCurrentUser(request);
		
		TransactionModel transaction = buildTransaction(request, true);
		ArrayList<TransactionItemModel> items = buildTransactionItems(request);
		
		
		transaction.setStatus(isSubmit ? "pending" : "draft");
		transaction.setDepartmentId(curr_user.getDepartmentId());
		transaction.setCreatedBy(curr_user.getUserId());
		
		
		// Save the transaction and its items to the database (this is just a placeholder)
		TransactionDAO transactionDAO = new TransactionDAO();
		Integer updatedTransactionId = transactionDAO.createTransaction(transaction);
		
		TransactionItemDAO transactionItemDAO = new TransactionItemDAO();
		transactionItemDAO.upsertAllTransactionItems(items, updatedTransactionId);
		saveUploadedAttachments(request, updatedTransactionId);

		listTransactions(request, response);	
	} 
	
	private void updateTransaction(HttpServletRequest request, HttpServletResponse response, boolean isSubmit) throws ServletException, IOException {

		UserModel curr_user = SessionHelper.getCurrentUser(request);
		
		TransactionModel transaction = buildTransaction(request, false);
		ArrayList<TransactionItemModel> items = buildTransactionItems(request);

		transaction.setStatus(isSubmit ? "pending" : "draft");
		transaction.setDepartmentId(curr_user.getDepartmentId());
		transaction.setCreatedBy(curr_user.getUserId());
		
		// Save the transaction and its items to the database (this is just a placeholder)
		TransactionDAO transactionDAO = new TransactionDAO();
		Integer updatedTransactionId = transactionDAO.updateTransaction(transaction);
		
		TransactionItemDAO transactionItemDAO = new TransactionItemDAO();
		transactionItemDAO.upsertAllTransactionItems(items, updatedTransactionId);
		saveUploadedAttachments(request, updatedTransactionId);

		listTransactions(request, response);
	} 
	
	private void deleteTransaction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    int transactionId = getIntParameter(request, "transactionId");
	    
	    TransactionDAO transactionDAO = new TransactionDAO();
	    AttachmentDAO attachmentDAO = new AttachmentDAO();
	    ArrayList<AttachmentModel> attachments = attachmentDAO.getAttachmentsByTransactionId(transactionId);
	    boolean success = transactionDAO.deleteTransaction(transactionId);
	    
	    if (success) {
	    	for (AttachmentModel attachment : attachments) {
	    		if (attachment.getFilePath() != null) {
	    			try {
	    				Files.deleteIfExists(Paths.get(attachment.getFilePath()).normalize());
	    			} catch (IOException e) {
	    				ErrorUtil.log("TransactionController.java", "deleteTransaction", e);
	    			}
	    		}
	    	}
	    	response.sendRedirect("transaction.jsp"); // Redirect to a success page after creation
	    }
	}

	private void submitTransaction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		updateTransaction(request, response, true);
	}

	private void confirmApproval(HttpServletRequest request, HttpServletResponse response, boolean isApproved) throws ServletException, IOException {
		UserModel curr_user = SessionHelper.getCurrentUser(request);
		
		if (curr_user == null || (!RoleHelper.isFinancialManager(curr_user) && !RoleHelper.isDepartmentManager(curr_user))) {
	        response.sendError(HttpServletResponse.SC_FORBIDDEN,
	        		ErrorUtil.format("TransactionController.java", "confirmApproval",
	        				"You do not have permission to approve or reject transactions."));
	        return;
	    }
		
		int transactionId = getIntParameter(request, "transactionId");
	    
	    TransactionDAO transactionDAO = new TransactionDAO();
	    TransactionModel transaction = transactionDAO.getTransactionById(transactionId);
	    
	    if (transaction == null) {
	        response.sendError(HttpServletResponse.SC_BAD_REQUEST,
	        		ErrorUtil.format("TransactionController.java", "confirmApproval",
	        				"Transaction not found or not in pending status"));
	        return;
	    }
	    
	    if (curr_user.getDepartmentId() != transaction.getDepartmentId()) {
	        response.sendError(HttpServletResponse.SC_FORBIDDEN,
	        		ErrorUtil.format("TransactionController.java", "confirmApproval",
	        				"You do not have permission to approve or reject this transaction."));
	        return;
	    }
	    
	    if (transaction != null && "pending".equalsIgnoreCase(transaction.getStatus())) {
	    	
	        transaction.setStatus(isApproved ? "approved" : "rejected");
	        transaction.setVerifiedBy(curr_user.getUserId());
	        
	        boolean success = transactionDAO.updateTransaction(transaction) != null;
	        
	        if (success) {
	        	listTransactions(request, response); // Redirect to a success page after approval
	        }
	    } else {
	        response.sendError(HttpServletResponse.SC_BAD_REQUEST,
	        		ErrorUtil.format("TransactionController.java", "confirmApproval",
	        				"Transaction not found or not in pending status"));
	    }
	}
	
	private void listTransactions(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Implementation for listing transactions
		
		TransactionDAO transactionDAO = new TransactionDAO();
		UserModel curr_user = SessionHelper.getCurrentUser(request);
		CategoryDAO categoryDAO = new CategoryDAO();

		String keyword = getStringParameter(request, "keyword");
		String transactionType = getStringParameter(request, "transactionType");
		Integer departmentId = null;
		if (curr_user != null && RoleHelper.isFinancialManager(curr_user)) {
			departmentId = getNullableIntParameter(request, "departmentId");
		} else if (curr_user != null && (RoleHelper.isDepartmentManager(curr_user) || RoleHelper.isStaff(curr_user))) {
			departmentId = curr_user.getDepartmentId();
		}
		Integer categoryId = getNullableIntParameter(request, "categoryId");
		String paymentMethod = getStringParameter(request, "paymentMethod");
		String status = getStringParameter(request, "status");

		ArrayList<TransactionModel> transactions = transactionDAO.filterTransactions(keyword, transactionType,
				departmentId, categoryId, paymentMethod, status);
		
		request.setAttribute("transactions_list", transactions);
		
		request.setAttribute("isReadOnly", curr_user != null && !RoleHelper.isStaff(curr_user));
		request.setAttribute("categories_dropdown", categoryDAO.getAllCategories(departmentId));
		try {
			request.setAttribute("departments", RoleHelper.isFinancialManager(curr_user)
					? DepartmentDAO.getAllDept()
					: new ArrayList<>());
		} catch (Exception e) {
			ErrorUtil.log("TransactionController.java", "listTransactions", e);
			request.setAttribute("departments", new ArrayList<>());
		}
		
		// prepare summary cards
		List<SummaryCardModel> summaryCards = new SummaryCardDAO().getSummaryCards(curr_user, "transaction");
		request.setAttribute("summary_cards", summaryCards);
		
		request.getRequestDispatcher("transaction.jsp").forward(request, response);
	}	
	
	private void viewTransactionDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    int transactionId = getIntParameter(request, "transactionId");
	    
	    UserModel user = SessionHelper.getCurrentUser(request);
	    
	    TransactionDAO transactionDAO = new TransactionDAO();
	    TransactionModel transaction = transactionDAO.getTransactionById(transactionId);
	    List<CategoryModel> categories = new CategoryDAO().getAllCategories(user != null ? user.getDepartmentId() : null);
	    UserModel curr_user = SessionHelper.getCurrentUser(request);
	    
	    if (transaction != null) {
	        TransactionItemDAO transactionItemDAO = new TransactionItemDAO();
	        List<TransactionItemModel> items = transactionItemDAO.getTransactionItemsByTransactionId(transactionId);
	        List<AttachmentModel> attachments = new AttachmentDAO().getAttachmentsByTransactionId(transactionId);
	        
	        // data list
	        request.setAttribute("transaction", transaction);
	        request.setAttribute("transaction_items", items);
	        request.setAttribute("transaction_attachments", attachments);
	        
	        // dropdown list
	        request.setAttribute("categories_dropdown", categories);
	        
	        boolean isEditable = curr_user != null 
	        					&& RoleHelper.isStaff(curr_user)  // is Staff
	        					&& curr_user.getDepartmentId() == transaction.getDepartmentId()  // Staff of the same department as transaction
	        					&& (transaction.getStatus().equalsIgnoreCase("draft")
	        							|| transaction.getStatus().equalsIgnoreCase("rejected"));  // transaction is draft or rejected
	        
	        boolean isApprover = curr_user != null 
	        					&& RoleHelper.isDepartmentManager(curr_user)  // is HoD or Financial Manager
	        					&& curr_user.getDepartmentId() == transaction.getDepartmentId()  // HoD of the same department as transaction
	        					&& transaction.getStatus().equalsIgnoreCase("pending");
	        
	        // helper variable
	        request.setAttribute("isEditable", isEditable);
	        request.setAttribute("isApprover", isApprover);
	        
	        request.getRequestDispatcher("transaction-details.jsp").forward(request, response);
	    } else {
	        response.sendError(HttpServletResponse.SC_NOT_FOUND,
	        		ErrorUtil.format("TransactionController.java", "viewTransactionDetails", "Transaction not found"));
	    }
	}

	private void createTransactionDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		UserModel user = SessionHelper.getCurrentUser(request);
		
		List<CategoryModel> categories = new CategoryDAO().getAllCategories(user != null ? user.getDepartmentId() : null);

		request.setAttribute("categories_dropdown", categories);
		request.setAttribute("isEditable", true);
		request.getRequestDispatcher("transaction-details.jsp").forward(request, response);
	}

	private TransactionModel buildTransaction(HttpServletRequest request, boolean isNewRecord) {

	    TransactionModel transaction = new TransactionModel();
	    
	    if (isNewRecord) {
	    	transaction.setTransactionId(null);
	    } else {
	    	transaction.setTransactionId(getIntParameter(request, "transactionId"));
	    }

	    transaction.setName(getStringParameter(request, "title"));
	    transaction.setDescription(getStringParameter(request, "description"));
	    transaction.setInvoiceNo(getStringParameter(request, "invoiceNo"));
	    transaction.setPayer(getStringParameter(request, "payer"));
	    transaction.setPayee(getStringParameter(request, "payee"));

	    transaction.setCategoryId(getIntParameter(request, "categoryId"));
	    transaction.setDepartmentId(getIntParameter(request, "departmentId"));

	    transaction.setTransactionType(
	        getStringParameter(request, "transactionType"));

	    transaction.setPaymentMethod(
	        getStringParameter(request, "paymentMethod"));

	    transaction.setTotalAmount(
	        getDoubleParameter(request, "totalAmount"));

	    transaction.setCurrency(
	        getStringParameter(request, "currency"));

	    transaction.setDateTransaction(
	        Date.valueOf(getStringParameter(request, "transactionDate")));

	    transaction.setStatus(
	        getStringParameter(request, "status"));

	    return transaction;
	}

	private ArrayList<TransactionItemModel> buildTransactionItems(HttpServletRequest request) {
	    ArrayList<TransactionItemModel> items = new ArrayList<>();

	    String[] itemIds = request.getParameterValues("itemId");
	    String[] itemNames = request.getParameterValues("itemName");
	    String[] itemDescriptions = request.getParameterValues("itemDescription");
	    String[] itemUnitPrices = request.getParameterValues("itemUnitPrice");
	    String[] itemQuantities = request.getParameterValues("itemQuantity");

	    if (itemNames != null && itemDescriptions != null && itemUnitPrices != null && itemQuantities != null) {
	        for (int i = 0; i < itemNames.length; i++) {
	            TransactionItemModel item = new TransactionItemModel();
	            item.setTransactionItemId(itemIds != null && itemIds.length > i ? Integer.parseInt(itemIds[i]) : null);
	            item.setName(itemNames[i]);
	            item.setDescription(itemDescriptions[i]);
	            item.setUnitPrice(Double.parseDouble(itemUnitPrices[i]));
	            item.setQuantity(Integer.parseInt(itemQuantities[i]));
	            items.add(item);
	        }
	    }

	    return items;
	}

	private void saveUploadedAttachments(HttpServletRequest request, Integer transactionId) throws IOException, ServletException {
		if (transactionId == null || transactionId == 0) {
			return;
		}

		Collection<Part> parts = request.getParts();
		AttachmentDAO attachmentDAO = new AttachmentDAO();

		for (Part part : parts) {
			if (!"attachments".equals(part.getName()) || part.getSize() <= 0) {
				continue;
			}

			String submittedFileName = part.getSubmittedFileName();
			if (submittedFileName == null || submittedFileName.isBlank()) {
				continue;
			}
			submittedFileName = Paths.get(submittedFileName).getFileName().toString();

			Path uploadDirectory = getUploadDirectory(request);
			Files.createDirectories(uploadDirectory);

			String storedFileName = UUID.randomUUID() + "_" + sanitizeFileName(submittedFileName);
			Path targetFile = uploadDirectory.resolve(storedFileName).normalize();
			part.write(targetFile.toString());

			AttachmentModel attachment = new AttachmentModel();
			attachment.setTransactionId(transactionId);
			attachment.setName(submittedFileName);
			attachment.setDescription("");
			attachment.setFileType(part.getContentType());
			attachment.setFilePath(targetFile.toString());

			attachmentDAO.addAttachment(attachment);
		}
	}

	private Path getUploadDirectory(HttpServletRequest request) {
		String realPath = request.getServletContext().getRealPath("/uploads/transaction-attachments");
		if (realPath != null) {
			return Paths.get(realPath);
		}

		return Paths.get(System.getProperty("user.home"), "aiadvisoryfinancial", "transaction-attachments");
	}

	private String sanitizeFileName(String fileName) {
		return fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
	}

	private String getStringParameter(HttpServletRequest request, String key) {
		String value = request.getParameter(key);
		return (value == null || value.trim().isEmpty()) ? "" : value.trim();
	}

	private int getIntParameter(HttpServletRequest request, String key) {
		String value = getStringParameter(request, key);
		return value.isEmpty() ? 0 : Integer.parseInt(value);
	}

	private Integer getNullableIntParameter(HttpServletRequest request, String key) {
		String value = getStringParameter(request, key);
		if (value.isEmpty()) {
			return null;
		}

		try {
			return Integer.parseInt(value);
		} catch (NumberFormatException e) {
			return null;
		}
	}

	private double getDoubleParameter(HttpServletRequest request, String key) {
		String value = getStringParameter(request, key);
		return value.isEmpty() ? 0.0 : Double.parseDouble(value);
	}

	
}
