package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import connection.DBConnection;
import model.FinancialStatementCategoryModel;
import model.FinancialStatementModel;
import util.ErrorUtil;

public class FinancialStatementDAO {
	public FinancialStatementModel getStatement(LocalDate startDate, LocalDate endDate, Integer departmentId) {
		FinancialStatementModel statement = new FinancialStatementModel();
		statement.setStartDate(startDate);
		statement.setEndDate(endDate);
		statement.setCategoryTotals(getCategoryTotals(startDate, endDate, departmentId));

		StringBuilder sql = new StringBuilder("""
				SELECT
				    NVL(SUM(CASE WHEN LOWER(transactionType) = 'income' THEN totalAmount ELSE 0 END), 0) AS totalIncome,
				    NVL(SUM(CASE WHEN LOWER(transactionType) = 'expense' THEN totalAmount ELSE 0 END), 0) AS totalExpenses,
				    COUNT(*) AS transactionCount
				FROM transaction
				WHERE LOWER(status) = 'approved'
				  AND dateTransaction >= ?
				  AND dateTransaction < ?
				""");

		if (departmentId != null) {
			sql.append(" AND departmentId = ?");
		}

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString())) {
			ps.setDate(1, Date.valueOf(startDate));
			ps.setDate(2, Date.valueOf(endDate.plusDays(1)));
			if (departmentId != null) {
				ps.setInt(3, departmentId);
			}

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					statement.setTotalIncome(rs.getDouble("totalIncome"));
					statement.setTotalExpenses(rs.getDouble("totalExpenses"));
					statement.setTransactionCount(rs.getInt("transactionCount"));
				}
			}
		} catch (Exception e) {
			ErrorUtil.log("FinancialStatementDAO", "getStatement", e);
		}

		return statement;
	}

	private List<FinancialStatementCategoryModel> getCategoryTotals(LocalDate startDate, LocalDate endDate,
			Integer departmentId) {
		List<FinancialStatementCategoryModel> categoryTotals = new ArrayList<>();
		StringBuilder sql = new StringBuilder("""
				SELECT
				    NVL(c.name, 'Uncategorized') AS categoryName,
				    LOWER(t.transactionType) AS transactionType,
				    SUM(t.totalAmount) AS totalAmount
				FROM transaction t
				LEFT JOIN category c
				    ON t.categoryId = c.categoryId
				WHERE LOWER(t.status) = 'approved'
				  AND t.dateTransaction >= ?
				  AND t.dateTransaction < ?
				""");

		if (departmentId != null) {
			sql.append(" AND t.departmentId = ?");
		}

		sql.append("""
				GROUP BY NVL(c.name, 'Uncategorized'), LOWER(t.transactionType)
				ORDER BY LOWER(t.transactionType), SUM(t.totalAmount) DESC, NVL(c.name, 'Uncategorized')
				""");

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString())) {
			ps.setDate(1, Date.valueOf(startDate));
			ps.setDate(2, Date.valueOf(endDate.plusDays(1)));
			if (departmentId != null) {
				ps.setInt(3, departmentId);
			}

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					categoryTotals.add(new FinancialStatementCategoryModel(
							rs.getString("categoryName"),
							rs.getString("transactionType"),
							rs.getDouble("totalAmount")));
				}
			}
		} catch (Exception e) {
			ErrorUtil.log("FinancialStatementDAO", "getCategoryTotals", e);
		}

		return categoryTotals;
	}
}
