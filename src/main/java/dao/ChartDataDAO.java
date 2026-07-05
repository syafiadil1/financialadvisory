package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import connection.DBConnection;
import model.ChartDataModel;
import util.ErrorUtil;

public class ChartDataDAO {
	public static List<ChartDataModel> getCashflowTrend(Integer departmentId) {
		List<ChartDataModel> chartDataList = new ArrayList<>();

		StringBuilder sql = new StringBuilder("""
				SELECT
				    TO_CHAR(dateTransaction, 'Mon') AS monthLabel,
				    TO_NUMBER(TO_CHAR(dateTransaction, 'MM')) AS monthNumber,
				    SUM(CASE WHEN LOWER(transactionType) = 'income' THEN totalAmount ELSE 0 END) AS totalIncome,
				    SUM(CASE WHEN LOWER(transactionType) = 'expense' THEN totalAmount ELSE 0 END) AS totalExpenses
				FROM transaction
				WHERE EXTRACT(YEAR FROM dateTransaction) = EXTRACT(YEAR FROM SYSDATE)
				  AND LOWER(status) = 'approved'
				""");

		if (departmentId != null) {
			sql.append(" AND departmentId = ?");
		}

		sql.append("""
				GROUP BY
				    TO_CHAR(dateTransaction, 'Mon'),
				    TO_NUMBER(TO_CHAR(dateTransaction, 'MM'))
				ORDER BY monthNumber
				""");

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
			if (departmentId != null) {
				pstmt.setInt(1, departmentId);
			}
			
			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					ChartDataModel chartData = new ChartDataModel();
					chartData.setLabel(rs.getString("monthLabel"));
					chartData.setData(List.of(rs.getDouble("totalIncome"), rs.getDouble("totalExpenses")));
					chartDataList.add(chartData);
				}
			}
		} catch (Exception e) {
			ErrorUtil.log("ChartDataDAO", "getCashflowTrend", e);
			
		}
		
		return chartDataList;
	}

	public static List<ChartDataModel> getCategoryExpenseSummary(Integer departmentId, int limit) {
		List<ChartDataModel> chartDataList = new ArrayList<>();
		StringBuilder sql = new StringBuilder("""
				SELECT *
				FROM (
				    SELECT
				        NVL(c.name, 'Uncategorized') AS categoryLabel,
				        SUM(t.totalAmount) AS totalExpenses
				    FROM transaction t
				    LEFT JOIN category c
				        ON t.categoryId = c.categoryId
				    WHERE EXTRACT(YEAR FROM t.dateTransaction) = EXTRACT(YEAR FROM SYSDATE)
				      AND LOWER(t.transactionType) = 'expense'
				      AND LOWER(t.status) = 'approved'
				""");

		if (departmentId != null) {
			sql.append(" AND t.departmentId = ?");
		}

		sql.append("""
				    GROUP BY NVL(c.name, 'Uncategorized')
				    ORDER BY totalExpenses DESC
				)
				WHERE ROWNUM <= ?
				""");

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
			int index = 1;
			if (departmentId != null) {
				pstmt.setInt(index++, departmentId);
			}
			pstmt.setInt(index, limit);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					ChartDataModel chartData = new ChartDataModel();
					chartData.setLabel(rs.getString("categoryLabel"));
					chartData.setData(List.of(rs.getDouble("totalExpenses")));
					chartDataList.add(chartData);
				}
			}
		} catch (Exception e) {
			ErrorUtil.log("ChartDataDAO", "getCategoryExpenseSummary", e);
		}

		return chartDataList;
	}
}
