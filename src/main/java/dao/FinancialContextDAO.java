package dao;

import connection.DBConnection;
import helper.RoleHelper;
import model.FinancialContextModel;
import model.UserModel;
import util.ErrorUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class FinancialContextDAO {

    public FinancialContextModel getFinancialContext(UserModel user) {
        FinancialContextModel context = new FinancialContextModel();

        if (user == null) {
            context.setScopeDescription("No logged-in user");
            return context;
        }

        boolean companyScope = RoleHelper.isFinancialManager(user);
        Integer departmentId = user.getDepartmentId();
        context.setScopeDescription(companyScope ? "Company-wide" : "Department ID " + departmentId);

        loadOverallSummary(context, companyScope, departmentId);
        context.setDepartmentSummaries(loadGroupedSummary("NVL(d.name, 'Unassigned Department')", companyScope, departmentId, true));
        context.setStatusSummaries(loadGroupedSummary("NVL(t.status, 'No Status')", companyScope, departmentId, false));
        context.setCategorySummaries(loadGroupedSummary("NVL(c.name, 'Uncategorized')", companyScope, departmentId, true));
        context.setPaymentMethodSummaries(loadGroupedSummary("NVL(t.paymentmethod, 'No Payment Method')", companyScope, departmentId, false));
        context.setRecentTransactions(loadRecentTransactions(companyScope, departmentId));
        context.setBudgetSummary(loadBudgetSummary(companyScope, departmentId));

        return context;
    }

    private void loadOverallSummary(FinancialContextModel context, boolean companyScope, Integer departmentId) {
        String sql = """
                SELECT COUNT(*) AS transaction_count,
                       SUM(CASE WHEN LOWER(transactiontype) IN ('income', 'revenue') THEN totalamount ELSE 0 END) AS income_total,
                       SUM(CASE WHEN LOWER(transactiontype) IN ('expense', 'expenses') THEN totalamount ELSE 0 END) AS expense_total
                FROM transaction
                WHERE 1 = 1
                """ + scopeClause(companyScope);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            bindScope(pstmt, companyScope, departmentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    double income = rs.getDouble("income_total");
                    double expense = rs.getDouble("expense_total");
                    context.setTransactionCount(rs.getInt("transaction_count"));
                    context.setIncomeTotal(income);
                    context.setExpenseTotal(expense);
                    context.setNetTotal(income - expense);
                }
            }
        } catch (Exception e) {
            ErrorUtil.log("FinancialContextDAO.java", "loadOverallSummary", e);
        }
    }

    private ArrayList<FinancialContextModel.SummaryRow> loadGroupedSummary(String labelExpression,
                                                                           boolean companyScope,
                                                                           Integer departmentId,
                                                                           boolean joinLookupTables) {
        ArrayList<FinancialContextModel.SummaryRow> rows = new ArrayList<>();
        String joins = joinLookupTables
                ? """
                  LEFT JOIN department d ON t.departmentid = d.departmentid
                  LEFT JOIN category c ON t.categoryid = c.categoryid
                  """
                : "";

        String sql = """
                SELECT %s AS label,
                       COUNT(*) AS transaction_count,
                       SUM(CASE WHEN LOWER(t.transactiontype) IN ('income', 'revenue') THEN t.totalamount ELSE 0 END) AS income_total,
                       SUM(CASE WHEN LOWER(t.transactiontype) IN ('expense', 'expenses') THEN t.totalamount ELSE 0 END) AS expense_total
                FROM transaction t
                %s
                WHERE 1 = 1
                %s
                GROUP BY %s
                ORDER BY transaction_count DESC
                FETCH FIRST 8 ROWS ONLY
                """.formatted(labelExpression, joins, scopeClauseForAlias(companyScope, "t"), labelExpression);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            bindScope(pstmt, companyScope, departmentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    double income = rs.getDouble("income_total");
                    double expense = rs.getDouble("expense_total");
                    rows.add(new FinancialContextModel.SummaryRow(
                            rs.getString("label"),
                            rs.getInt("transaction_count"),
                            income,
                            expense
                    ));
                }
            }
        } catch (Exception e) {
            ErrorUtil.log("FinancialContextDAO.java", "loadGroupedSummary", e);
        }

        return rows;
    }

    private ArrayList<String> loadRecentTransactions(boolean companyScope, Integer departmentId) {
        ArrayList<String> transactions = new ArrayList<>();
        String sql = """
                SELECT *
                FROM (
                    SELECT t.name, t.transactiontype, t.totalamount, t.currency, t.status, t.datetransaction,
                           NVL(d.name, 'Unassigned Department') AS department_name,
                           NVL(c.name, 'Uncategorized') AS category_name
                    FROM transaction t
                    LEFT JOIN department d ON t.departmentid = d.departmentid
                    LEFT JOIN category c ON t.categoryid = c.categoryid
                    WHERE 1 = 1
                    %s
                    ORDER BY t.datetransaction DESC, t.transactionid DESC
                )
                WHERE ROWNUM <= 8
                """.formatted(scopeClauseForAlias(companyScope, "t"));

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            bindScope(pstmt, companyScope, departmentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    transactions.add(rs.getString("name")
                            + " | " + rs.getString("transactiontype")
                            + " | " + rs.getDouble("totalamount") + " " + rs.getString("currency")
                            + " | " + rs.getString("status")
                            + " | " + rs.getString("department_name")
                            + " | " + rs.getString("category_name"));
                }
            }
        } catch (Exception e) {
            ErrorUtil.log("FinancialContextDAO.java", "loadRecentTransactions", e);
        }

        return transactions;
    }

    private String loadBudgetSummary(boolean companyScope, Integer departmentId) {
        if (companyScope) {
            return "Budget context is department-specific and was not applied to company-wide scope.";
        }

        String sql = """
                SELECT initialbudget, remainingbudget, datestart, dateend
                FROM departmentbudget
                WHERE departmentid = ? AND isactivebudget = 1
                ORDER BY dateend DESC
                FETCH FIRST 1 ROW ONLY
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, departmentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return "Initial budget " + rs.getDouble("initialbudget")
                            + ", remaining budget " + rs.getDouble("remainingbudget")
                            + ", period " + rs.getDate("datestart") + " to " + rs.getDate("dateend");
                }
            }
        } catch (Exception e) {
            ErrorUtil.log("FinancialContextDAO.java", "loadBudgetSummary", e);
        }

        return "No active department budget record found.";
    }

    private String scopeClause(boolean companyScope) {
        return companyScope ? "" : " AND departmentid = ?";
    }

    private String scopeClauseForAlias(boolean companyScope, String alias) {
        return companyScope ? "" : " AND " + alias + ".departmentid = ?";
    }

    private void bindScope(PreparedStatement pstmt, boolean companyScope, Integer departmentId) throws Exception {
        if (!companyScope) {
            pstmt.setInt(1, departmentId == null ? 0 : departmentId);
        }
    }
}
