package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.*;

import connection.DBConnection;
import model.TransactionItemModel;
import util.ErrorUtil;

public class TransactionItemDAO {
	public ArrayList<TransactionItemModel> getTransactionItemsByTransactionId(int transactionId) {
		ArrayList<TransactionItemModel> items = new ArrayList<>();
		
		try {
			Connection conn = DBConnection.getConnection();
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery("SELECT * FROM transactionitem WHERE transactionId = " + transactionId);
			
			while (rs.next()) {
				TransactionItemModel item = new TransactionItemModel(rs.getInt("transactionItemId"),
						rs.getInt("transactionId"),
						rs.getString("name"),
						rs.getString("description"),
						rs.getDouble("unitPrice"),
						rs.getInt("quantity"));
				
				items.add(item); // Add the item to the list
			}
			conn.close();
			
		} catch (Exception e) {
			ErrorUtil.log("TransactionItemDAO.java", "getTransactionItemsByTransactionId", e);
		}
		
		return items; // Return the list of items
	}
	
	private boolean addTransactionItem(TransactionItemModel item) {
		try {
			Connection conn = DBConnection.getConnection();
			
			String sql = "INSERT INTO transactionitem (transactionId, name, description, unitPrice, quantity) VALUES (?, ?, ?, ?, ?)";
			
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, item.getTransactionId());
			pstmt.setString(2, item.getName());
			pstmt.setString(3, item.getDescription());
			pstmt.setDouble(4, item.getUnitPrice());
			pstmt.setInt(5, item.getQuantity());
			
			int rowsAffected = pstmt.executeUpdate();
			conn.close();
			
			return rowsAffected > 0; // Return true if the insert was successful
			
		} catch (Exception e) {
			ErrorUtil.log("TransactionItemDAO.java", "addTransactionItem", e);
			return false; // Return false if there was an error
		}
	}
	
	public boolean addAllTransactionItems(ArrayList<TransactionItemModel> items) {
		boolean allSuccessful = true;
		
		for (TransactionItemModel item : items) {
			boolean success = addTransactionItem(item);
			if (!success) {
				allSuccessful = false; // If any insert fails, set to false
			}
		}
		
		return allSuccessful; // Return true if all inserts were successful
	}

	private boolean updateTransactionItem(TransactionItemModel item) {
		try {
			Connection conn = DBConnection.getConnection();
			
			String sql = "UPDATE transactionitem SET name = ?, description = ?, unitPrice = ?, quantity = ? WHERE transactionItemId = ?";
			
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, item.getName());
			pstmt.setString(2, item.getDescription());
			pstmt.setDouble(3, item.getUnitPrice());
			pstmt.setInt(4, item.getQuantity());
			pstmt.setInt(5, item.getTransactionItemId());
			
			int rowsAffected = pstmt.executeUpdate();
			conn.close();
			
			return rowsAffected > 0; // Return true if the update was successful
			
		} catch (Exception e) {
			ErrorUtil.log("TransactionItemDAO.java", "updateTransactionItem", e);
			return false; // Return false if there was an error
		}
	}
	
	public boolean updateAllTransactionItems(ArrayList<TransactionItemModel> items, Integer transactionId) {
		boolean allSuccessful = true;
		
		for (TransactionItemModel item : items) {
			item.setTransactionId(transactionId); // Ensure the transactionId is set for each item	
			boolean success = updateTransactionItem(item);
			if (!success) {
				allSuccessful = false; // If any update fails, set to false
			}
		}
		
		return allSuccessful; // Return true if all updates were successful
	}
	
	public boolean upsertAllTransactionItems(ArrayList<TransactionItemModel> items, Integer transactionId) {
		boolean allSuccessful = true;
		
		for (TransactionItemModel item : items) {
			item.setTransactionId(transactionId); // Ensure the transactionId is set for each item
			
			if (item.getTransactionItemId() == null) {
				// If transactionItemId is null, it's a new item, so add it
				boolean success = addTransactionItem(item);
				if (!success) {
					allSuccessful = false; // If the insert fails, set to false
				}
			} else {
				// If transactionItemId is not null, it's an existing item, so update it
				boolean success = updateTransactionItem(item);
				if (!success) {
					allSuccessful = false; // If the update fails, set to false
				}
			}
		}
		
		return allSuccessful; // Return true if all operations were successful
	}
	
	public boolean deleteTransactionItem(Integer transactionItemId) {
		try {
			Connection conn = DBConnection.getConnection();
			
			String sql = "DELETE FROM transactionitem WHERE transactionItemId = ?";
			
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, transactionItemId);
			
			int rowsAffected = pstmt.executeUpdate();
			conn.close();
			
			return rowsAffected > 0; // Return true if the delete was successful
			
		} catch (Exception e) {
			ErrorUtil.log("TransactionItemDAO.java", "deleteTransactionItem", e);
			return false; // Return false if there was an error
		}
	}

	public boolean deleteTransactionItems(Integer transactionId, List<Integer> transactionItemIds) {
		if (transactionId == null || transactionItemIds == null || transactionItemIds.isEmpty()) {
			return true;
		}

		try {
			Connection conn = DBConnection.getConnection();

			String placeholders = String.join(", ", Collections.nCopies(transactionItemIds.size(), "?"));
			String sql = "DELETE FROM transactionitem WHERE transactionId = ? AND transactionItemId IN (" + placeholders + ")";

			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, transactionId);
			for (int i = 0; i < transactionItemIds.size(); i++) {
				pstmt.setInt(i + 2, transactionItemIds.get(i));
			}

			pstmt.executeUpdate();
			conn.close();

			return true;

		} catch (Exception e) {
			ErrorUtil.log("TransactionItemDAO.java", "deleteTransactionItems", e);
			return false;
		}
	}

	public boolean deleteTransactionItemsByTransactionId(Integer transactionId) {
		try {
			Connection conn = DBConnection.getConnection();
			
			String sql = "DELETE FROM transactionitem WHERE transactionId = ?";
			
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, transactionId);
			
			int rowsAffected = pstmt.executeUpdate();
			conn.close();
			
			return rowsAffected > 0; // Return true if the delete was successful
			
		} catch (Exception e) {
			ErrorUtil.log("TransactionItemDAO.java", "deleteTransactionItemsByTransactionId", e);
			return false; // Return false if there was an error
		}
	}
}
