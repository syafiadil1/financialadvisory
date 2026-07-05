package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.*;

import connection.DBConnection;
import model.TransactionModel;
import util.ErrorUtil;

public class TransactionDAO {

	public TransactionModel getTransactionById(Integer transactionId) {
		try {
			Connection conn = DBConnection.getConnection();
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery("SELECT\r\n"
					+ "    transactionid AS transactionId,\r\n"
					+ "    transaction.name AS transactionName,\r\n"
					+ "    transaction.description AS transactionDescription,\r\n"
					+ "    invoiceno AS invoiceNO,\r\n"
					+ "    payer AS payer,\r\n"
					+ "    payee AS payee,\r\n"
					+ "    transaction.categoryId AS categoryId,\r\n"
					+ "    c.name AS categoryName,\r\n"
					+ "    transaction.departmentId AS departmentId,\r\n"
					+ "    d.name AS departmentName,\r\n"
					+ "    transactionType AS transactionType,\r\n"
					+ "    paymentMethod AS paymentMethod,\r\n"
					+ "    totalAmount AS totalAmount,\r\n"
					+ "    currency AS currency,\r\n"
					+ "    dateTransaction AS dateTransaction,\r\n"
					+ "    createdBy AS createdBy,\r\n"
					+ "    created.name AS createdName,\r\n"
					+ "    verifiedBy AS verifiedBy,\r\n"
					+ "    verified.name AS verifiedName,\r\n"
					+ "    status AS status\r\n"
					+ "FROM transaction\r\n"
					+ "LEFT JOIN category c\r\n"
					+ "    ON transaction.categoryid = c.categoryid\r\n"
					+ "LEFT JOIN department d\r\n"
					+ "    ON transaction.departmentid = d.departmentid\r\n"
					+ "LEFT JOIN users created\r\n"
					+ "    ON transaction.createdby = created.userid\r\n"
					+ "LEFT JOIN users verified\r\n"
					+ "    ON transaction.verifiedby = verified.userid\r\n"
					+ "WHERE transactionId = " + transactionId);
			
			while (rs.next()) {
				TransactionModel transaction = new TransactionModel(rs.getInt("transactionId"),
						rs.getString("transactionName"),
						rs.getString("transactionDescription"),
						rs.getString("invoiceNO"),
						rs.getString("payer"),
						rs.getString("payee"),
						rs.getInt("categoryId"),
						rs.getString("categoryName"),
						rs.getInt("departmentId"),
						rs.getString("departmentName"),
						rs.getString("transactionType"),
						rs.getString("paymentMethod"),
						rs.getDouble("totalAmount"),
						rs.getString("currency"),
						rs.getDate("dateTransaction"),
						rs.getString("status"),
						rs.getInt("createdBy"),
						rs.getString("createdName"),
						rs.getInt("verifiedBy"),
						rs.getString("verifiedName"));
				
				return transaction; // Return the transaction object

			}
			conn.close();
			
		} catch (Exception e) {
			ErrorUtil.log("TransactionDAO.java", "getTransactionById", e);
		}
		
		return null; // Placeholder return statement
	}

	public ArrayList<TransactionModel> getAllTransactions() {
		try {
			Connection conn = DBConnection.getConnection();
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery("""
					SELECT
					    transactionid AS transactionId,
					    transaction.name AS transactionName,
					    transaction.description AS transactionDescription,
					    invoiceno AS invoiceNO,
					    payer AS payer,
					    payee AS payee,
					    transaction.categoryId AS categoryId,
					    c.name AS categoryName,
					    transaction.departmentId AS departmentId,
					    d.name AS departmentName,
					    transactionType AS transactionType,
					    paymentMethod AS paymentMethod,
					    totalAmount AS totalAmount,
					    currency AS currency,
					    dateTransaction AS dateTransaction,
					    createdBy AS createdBy,
					    created.name AS createdName,
					    verifiedBy AS verifiedBy,
					    verified.name AS verifiedName,
					    status AS status
					FROM transaction
					LEFT JOIN category c
					    ON transaction.categoryid = c.categoryid
					LEFT JOIN department d
					    ON transaction.departmentid = d.departmentid
					LEFT JOIN users created
					    ON transaction.createdby = created.userid
					LEFT JOIN users verified
					    ON transaction.verifiedby = verified.userid
					ORDER BY dateTransaction DESC
					""");
			
			ArrayList<TransactionModel> transactions = new ArrayList<>();
			
			while (rs.next()) {
				TransactionModel transaction = new TransactionModel(rs.getInt("transactionId"),
						rs.getString("transactionName"),
						rs.getString("transactionDescription"),
						rs.getString("invoiceNO"),
						rs.getString("payer"),
						rs.getString("payee"),
						rs.getInt("categoryId"),
						rs.getString("CategoryName"),
						rs.getInt("departmentId"),
						rs.getString("DepartmentName"),
						rs.getString("transactionType"),
						rs.getString("paymentMethod"),
						rs.getDouble("totalAmount"),
						rs.getString("currency"),
						rs.getDate("dateTransaction"),
						rs.getString("status"),
						rs.getInt("createdBy"),
						rs.getString("createdName"),
						rs.getInt("verifiedBy"),
						rs.getString("verifiedName"));
				
				transactions.add(transaction);
			}
			
			conn.close();
			return transactions;
			
		} catch (Exception e) {
			ErrorUtil.log("TransactionDAO.java", "getAllTransactions", e);
		}
		
		return new ArrayList<>(); // Placeholder return statement
	}
	
	public ArrayList<TransactionModel> getTransactionsByDepartmentId(Integer departmentId) {
		try {
			Connection conn = DBConnection.getConnection();
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery("SELECT\r\n"
					+ "    transactionid AS transactionId,\r\n"
					+ "    transaction.name AS transactionName,\r\n"
					+ "    transaction.description AS transactionDescription,\r\n"
					+ "    invoiceno AS invoiceNO,\r\n"
					+ "    payer AS payer,\r\n"
					+ "    payee AS payee,\r\n"
					+ "    transaction.categoryId AS categoryId,\r\n"
					+ "    c.name AS categoryName,\r\n"
					+ "    transaction.departmentId AS departmentId,\r\n"
					+ "    d.name AS departmentName,\r\n"
					+ "    transactionType AS transactionType,\r\n"
					+ "    paymentMethod AS paymentMethod,\r\n"
					+ "    totalAmount AS totalAmount,\r\n"
					+ "    currency AS currency,\r\n"
					+ "    dateTransaction AS dateTransaction,\r\n"
					+ "    createdBy AS createdBy,\r\n"
					+ "    created.name AS createdName,\r\n"
					+ "    verifiedBy AS verifiedBy,\r\n"
					+ "    verified.name AS verifiedName,\r\n"
					+ "    status AS status\r\n"
					+ "FROM transaction\r\n"
					+ "LEFT JOIN category c\r\n"
					+ "    ON transaction.categoryid = c.categoryid\r\n"
					+ "LEFT JOIN department d\r\n"
					+ "    ON transaction.departmentid = d.departmentid\r\n"
					+ "LEFT JOIN users created\r\n"
					+ "    ON transaction.createdby = created.userid\r\n"
					+ "LEFT JOIN users verified\r\n"
					+ "    ON transaction.verifiedby = verified.userid\r\n"
					+ "WHERE transaction.departmentId = "+departmentId);
			
			ArrayList<TransactionModel> transactions = new ArrayList<>();
			
			while (rs.next()) {
				TransactionModel transaction = new TransactionModel(rs.getInt("transactionId"),
						rs.getString("transactionName"),
						rs.getString("transactionDescription"),
						rs.getString("invoiceNO"),
						rs.getString("payer"),
						rs.getString("payee"),
						rs.getInt("categoryId"),
						rs.getString("CategoryName"),
						rs.getInt("departmentId"),
						rs.getString("DepartmentName"),
						rs.getString("transactionType"),
						rs.getString("paymentMethod"),
						rs.getDouble("totalAmount"),
						rs.getString("currency"),
						rs.getDate("dateTransaction"),
						rs.getString("status"),
						rs.getInt("createdBy"),
						rs.getString("createdName"),
						rs.getInt("verifiedBy"),
						rs.getString("verifiedName"));
				
				transactions.add(transaction);
			}
			
			conn.close();
			return transactions;
			
		} catch (Exception e) {
			ErrorUtil.log("TransactionDAO.java", "getTransactionsByDepartmentId", e);
		}
		
		return new ArrayList<>(); // Placeholder return statement
	}

	public ArrayList<TransactionModel> filterTransactions(String keyword, String transactionType, Integer departmentId,
			Integer categoryId, String paymentMethod, String status) {
		ArrayList<TransactionModel> transactions = new ArrayList<>();

		StringBuilder sql = new StringBuilder("""
				SELECT
				    transactionid AS transactionId,
				    transaction.name AS transactionName,
				    transaction.description AS transactionDescription,
				    invoiceno AS invoiceNO,
				    payer AS payer,
				    payee AS payee,
				    transaction.categoryId AS categoryId,
				    c.name AS categoryName,
				    transaction.departmentId AS departmentId,
				    d.name AS departmentName,
				    transactionType AS transactionType,
				    paymentMethod AS paymentMethod,
				    totalAmount AS totalAmount,
				    currency AS currency,
				    dateTransaction AS dateTransaction,
				    createdBy AS createdBy,
				    created.name AS createdName,
				    verifiedBy AS verifiedBy,
				    verified.name AS verifiedName,
				    status AS status
				FROM transaction
				LEFT JOIN category c
				    ON transaction.categoryid = c.categoryid
				LEFT JOIN department d
				    ON transaction.departmentid = d.departmentid
				LEFT JOIN users created
				    ON transaction.createdby = created.userid
				LEFT JOIN users verified
				    ON transaction.verifiedby = verified.userid
				WHERE 1 = 1
				""");

		boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
		boolean hasType = transactionType != null && !transactionType.trim().isEmpty();
		boolean hasPaymentMethod = paymentMethod != null && !paymentMethod.trim().isEmpty();
		boolean hasStatus = status != null && !status.trim().isEmpty();

		if (hasKeyword) {
			sql.append("""
					 AND (LOWER(transaction.name) LIKE ?
					  OR LOWER(transaction.description) LIKE ?
					  OR LOWER(invoiceno) LIKE ?
					  OR LOWER(payer) LIKE ?
					  OR LOWER(payee) LIKE ?)
					""");
		}

		if (hasType) {
			sql.append(" AND LOWER(transactionType) = ?");
		}

		if (departmentId != null) {
			sql.append(" AND transaction.departmentId = ?");
		}

		if (categoryId != null) {
			sql.append(" AND transaction.categoryId = ?");
		}

		if (hasPaymentMethod) {
			sql.append(" AND LOWER(paymentMethod) LIKE ?");
		}

		if (hasStatus) {
			sql.append(" AND LOWER(status) = ?");
		}

		sql.append(" ORDER BY dateTransaction DESC, transactionid DESC");

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
			int index = 1;

			if (hasKeyword) {
				String searchKeyword = "%" + keyword.trim().toLowerCase() + "%";
				for (int i = 0; i < 5; i++) {
					pstmt.setString(index++, searchKeyword);
				}
			}

			if (hasType) {
				pstmt.setString(index++, transactionType.trim().toLowerCase());
			}

			if (departmentId != null) {
				pstmt.setInt(index++, departmentId);
			}

			if (categoryId != null) {
				pstmt.setInt(index++, categoryId);
			}

			if (hasPaymentMethod) {
				pstmt.setString(index++, "%" + paymentMethod.trim().toLowerCase() + "%");
			}

			if (hasStatus) {
				pstmt.setString(index, status.trim().toLowerCase());
			}

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					transactions.add(new TransactionModel(rs.getInt("transactionId"),
							rs.getString("transactionName"),
							rs.getString("transactionDescription"),
							rs.getString("invoiceNO"),
							rs.getString("payer"),
							rs.getString("payee"),
							rs.getInt("categoryId"),
							rs.getString("CategoryName"),
							rs.getInt("departmentId"),
							rs.getString("DepartmentName"),
							rs.getString("transactionType"),
							rs.getString("paymentMethod"),
							rs.getDouble("totalAmount"),
							rs.getString("currency"),
							rs.getDate("dateTransaction"),
							rs.getString("status"),
							rs.getInt("createdBy"),
							rs.getString("createdName"),
							rs.getInt("verifiedBy"),
							rs.getString("verifiedName")));
				}
			}
		} catch (Exception e) {
			ErrorUtil.log("TransactionDAO.java", "filterTransactions", e);
		}

		return transactions;
	}
	
	public Integer createTransaction(TransactionModel transaction) {
		// Code to create a new transaction in the database
		
		try {
			Connection conn = DBConnection.getConnection();
			
			String sql = "INSERT INTO transaction (name, description, invoiceNo, payer, payee, categoryId, departmentId, transactionType, paymentMethod, totalAmount, currency, dateTransaction, status, createdBy, verifiedBy) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			
			
			PreparedStatement pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, transaction.getName());
			pstmt.setString(2, transaction.getDescription());
			pstmt.setString(3, transaction.getInvoiceNo());
			pstmt.setString(4, transaction.getPayer());
			pstmt.setString(5, transaction.getPayee());
			pstmt.setInt(6, transaction.getCategoryId());
			pstmt.setInt(7, transaction.getDepartmentId());
			pstmt.setString(8, transaction.getTransactionType());
			pstmt.setString(9, transaction.getPaymentMethod());
			pstmt.setDouble(10, transaction.getTotalAmount());
			pstmt.setString(11, transaction.getCurrency());
			pstmt.setDate(12, (Date) transaction.getDateTransaction());
			pstmt.setString(13, transaction.getStatus());
			pstmt.setInt(14, transaction.getCreatedBy());
			pstmt.setInt(15, transaction.getVerifiedBy());

			boolean success = pstmt.executeUpdate() > 0;
			
			if (success) {
				sql = "SELECT transactionId from transaction ORDER BY transactionId DESC FETCH FIRST 1 row only";
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(sql);
				if (rs.next()) {
					return rs.getInt("transactionId");
				}
			} else {
				return null; // Return null if the insert was not successful
			}

			conn.close();
			
		} catch (Exception e) {
			ErrorUtil.log("TransactionDAO.java", "createTransaction", e);
		}
		return null; // Return null for now, you can modify this to return the generated transaction ID if needed
	}
	
	public Integer updateTransaction(TransactionModel transaction) {
		// Code to update the transaction in the database
		 
		 try {
				Connection conn = DBConnection.getConnection();
				
				TransactionModel existingTransaction = getTransactionById(transaction.getTransactionId());
				
				if (existingTransaction == null) {
					System.out.println(ErrorUtil.format("TransactionDAO.java", "updateTransaction",
							"Transaction with ID " + transaction.getTransactionId() + " does not exist."));
					return null;
				}
				
				transaction.setTransactionId(existingTransaction.getTransactionId()); // Ensure the transaction ID is set correctly
				
				String sql = "UPDATE transaction SET name=?, description=?, invoiceNo=?, payer=?, payee=?, categoryId=?, departmentId=?, transactionType=?, paymentMethod=?, totalAmount=?, currency=?, dateTransaction=?, status=?, createdBy=?, verifiedBy=? WHERE transactionId=?";
				PreparedStatement pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, transaction.getName());
				pstmt.setString(2, transaction.getDescription());
				pstmt.setString(3, transaction.getInvoiceNo());
				pstmt.setString(4, transaction.getPayer());
				pstmt.setString(5, transaction.getPayee());
				pstmt.setInt(6, transaction.getCategoryId());
				pstmt.setInt(7, transaction.getDepartmentId());
				pstmt.setString(8, transaction.getTransactionType());
				pstmt.setString(9, transaction.getPaymentMethod());
				pstmt.setDouble(10, transaction.getTotalAmount());
				pstmt.setString(11, transaction.getCurrency());
				pstmt.setDate(12, (Date) transaction.getDateTransaction());
				pstmt.setString(13, transaction.getStatus());
				pstmt.setInt(14, transaction.getCreatedBy());
				
				if (transaction.getVerifiedBy() != null) {
				    pstmt.setInt(15, transaction.getVerifiedBy());
				} else {
				    pstmt.setNull(15, java.sql.Types.INTEGER); // Set to NULL if verifiedBy is null
				}
				
				pstmt.setInt(16, transaction.getTransactionId());
				
				if (pstmt.executeUpdate() > 0) {
					// Transaction updated successfully
					return existingTransaction.getTransactionId(); // Return the transaction ID
				} else {
					return null; // Return null if the update was not successful
				}
				
			} catch (Exception e) {
				ErrorUtil.log("TransactionDAO.java", "updateTransaction", e);
			}
		 return null; // Return null if an error occurs
	}
	
	public boolean deleteTransaction(Integer transactionId) {
		// Code to delete a transaction from the database by its ID
		
		try {
				Connection conn = DBConnection.getConnection();
				
				TransactionModel existingTransaction = getTransactionById(transactionId);
				
				if (existingTransaction == null) {
					return false; // Transaction does not exist
				}
				
				TransactionItemDAO transactionItemDAO = new TransactionItemDAO();
				transactionItemDAO.deleteTransactionItemsByTransactionId(transactionId);
				
				AttachmentDAO attachmentDAO = new AttachmentDAO();
				attachmentDAO.deleteAttachmentsByTransactionId(transactionId);
				
				String sql = "DELETE FROM transaction WHERE transactionId=?";
				PreparedStatement pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, transactionId);
				pstmt.executeUpdate();
				return true; // Return true to indicate successful deletion
				
			} catch (Exception e) {
				ErrorUtil.log("TransactionDAO.java", "deleteTransaction", e);
		}
		return false; // Return false if an error occurs
	}

	public ArrayList<TransactionModel> getRecentTransactions(Integer departmentId, int limit) {
		return getDashboardTransactions(null, departmentId, limit);
	}

	public ArrayList<TransactionModel> getPendingTransactions(Integer departmentId, int limit) {
		return getDashboardTransactions("pending", departmentId, limit);
	}

	private ArrayList<TransactionModel> getDashboardTransactions(String status, Integer departmentId, int limit) {
		ArrayList<TransactionModel> transactions = new ArrayList<>();
		StringBuilder sql = new StringBuilder("""
				SELECT *
				FROM (
				    SELECT
				        transactionid AS transactionId,
				        transaction.name AS transactionName,
				        transaction.description AS transactionDescription,
				        invoiceno AS invoiceNO,
				        payer AS payer,
				        payee AS payee,
				        transaction.categoryId AS categoryId,
				        c.name AS categoryName,
				        transaction.departmentId AS departmentId,
				        d.name AS departmentName,
				        transactionType AS transactionType,
				        paymentMethod AS paymentMethod,
				        totalAmount AS totalAmount,
				        currency AS currency,
				        dateTransaction AS dateTransaction,
				        createdBy AS createdBy,
				        created.name AS createdName,
				        verifiedBy AS verifiedBy,
				        verified.name AS verifiedName,
				        status AS status
				    FROM transaction
				    LEFT JOIN category c
				        ON transaction.categoryid = c.categoryid
				    LEFT JOIN department d
				        ON transaction.departmentid = d.departmentid
				    LEFT JOIN users created
				        ON transaction.createdby = created.userid
				    LEFT JOIN users verified
				        ON transaction.verifiedby = verified.userid
				    WHERE EXTRACT(YEAR FROM dateTransaction) = EXTRACT(YEAR FROM SYSDATE)
				""");

		if (status != null) {
			sql.append(" AND LOWER(status) = ?");
		}

		if (departmentId != null) {
			sql.append(" AND transaction.departmentId = ?");
		}

		sql.append("""
				    ORDER BY dateTransaction DESC, transactionid DESC
				)
				WHERE ROWNUM <= ?
				""");

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
			int index = 1;
			if (status != null) {
				pstmt.setString(index++, status.toLowerCase());
			}
			if (departmentId != null) {
				pstmt.setInt(index++, departmentId);
			}
			pstmt.setInt(index, limit);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					transactions.add(new TransactionModel(rs.getInt("transactionId"),
							rs.getString("transactionName"),
							rs.getString("transactionDescription"),
							rs.getString("invoiceNO"),
							rs.getString("payer"),
							rs.getString("payee"),
							rs.getInt("categoryId"),
							rs.getString("categoryName"),
							rs.getInt("departmentId"),
							rs.getString("departmentName"),
							rs.getString("transactionType"),
							rs.getString("paymentMethod"),
							rs.getDouble("totalAmount"),
							rs.getString("currency"),
							rs.getDate("dateTransaction"),
							rs.getString("status"),
							rs.getInt("createdBy"),
							rs.getString("createdName"),
							rs.getInt("verifiedBy"),
							rs.getString("verifiedName")));
				}
			}
		} catch (Exception e) {
			ErrorUtil.log("TransactionDAO.java", "getDashboardTransactions", e);
		}

		return transactions;
	}
	}
