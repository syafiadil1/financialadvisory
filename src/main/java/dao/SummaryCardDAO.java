package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import connection.DBConnection;
import helper.RoleHelper;
import model.DepartmentBudgetModel;
import model.SummaryCardModel;
import model.UserModel;
import util.ErrorUtil;

public class SummaryCardDAO {

	public List<SummaryCardModel> getSummaryCards(UserModel user, String page) {
		List<SummaryCardModel> summaryCards = new ArrayList<>();

		if (user == null) {
			return summaryCards;
		}

		if ("dashboard".equals(page)) {
			return getDashboardCards(user);
		}

		if ("transaction".equals(page)) {
			boolean departmentSpecific = !RoleHelper.isFinancialManager(user) && !RoleHelper.isAdmin(user);
			Integer departmentId = departmentSpecific ? user.getDepartmentId() : null;
			summaryCards.add(getTotalIncomeCard(departmentSpecific, departmentId));
			summaryCards.add(getTotalExpensesCard(departmentSpecific, departmentId));
			summaryCards.add(getNetCashflowCard(departmentSpecific, departmentId));
			summaryCards.add(getPendingTransactionsCard(departmentSpecific, departmentId, "Transactions awaiting verification"));
		}

		return summaryCards;
	}

	private List<SummaryCardModel> getDashboardCards(UserModel user) {
		List<SummaryCardModel> cards = new ArrayList<>();
		Integer departmentId = user.getDepartmentId();

		if (RoleHelper.isAdmin(user)) {
			cards.add(getTotalUsersCard());
			cards.add(getTotalDepartmentsCard());
			cards.add(getPendingTransactionsCard(false, null, "Company transactions awaiting verification"));
			cards.add(getApprovedTransactionsCard());
			return cards;
		}

		if (RoleHelper.isFinancialManager(user)) {
			double income = getTransactionAmount("income", false, null);
			double expenses = getTransactionAmount("expense", false, null);
			cards.add(totalIncomeCard(income, "Company approved income"));
			cards.add(totalExpensesCard(expenses, "Company approved expenses"));
			cards.add(netCashflowCard(income, expenses, "Current year net profit"));
			cards.add(companyStatusCard(income, expenses));
			return cards;
		}

		if (user.getRoleId() == RoleHelper.ROLE_DEPARTMENT_MANAGER) {
			DepartmentBudgetModel budget = getDepartmentBudget(departmentId);
			double initialBudget = budget != null ? budget.getInitialBudget() : 0.0;
			double usedBudget = budget != null ? budget.getUsedBudget() : getTransactionAmount("expense", true, departmentId);
			double remainingBudget = initialBudget - usedBudget;
			double usageRate = initialBudget > 0 ? (usedBudget / initialBudget) * 100 : 0.0;

			cards.add(new SummaryCardModel("Annual Budget",
					formatCurrency(initialBudget),
					"Current year allocation",
					"border-start border-primary border-5",
					"text-primary",
					"bi-wallet2"));
			cards.add(new SummaryCardModel("Used Budget",
					formatCurrency(usedBudget),
					String.format("%.1f%% used this year", usageRate),
					"border-start border-danger border-5",
					"text-danger",
					"bi-graph-up-arrow"));
			cards.add(new SummaryCardModel("Remaining Budget",
					formatCurrency(remainingBudget),
					"Available balance",
					remainingBudget < 0 ? "border-start border-danger border-5" : "border-start border-success border-5",
					remainingBudget < 0 ? "text-danger" : "text-success",
					remainingBudget < 0 ? "bi-exclamation-triangle" : "bi-cash-stack"));
			cards.add(getPendingTransactionsCard(true, departmentId, "Department transactions awaiting verification"));
			return cards;
		}

		double income = getTransactionAmount("income", true, departmentId);
		double expenses = getTransactionAmount("expense", true, departmentId);
		cards.add(totalIncomeCard(income, "Department approved income"));
		cards.add(totalExpensesCard(expenses, "Department approved expenses"));
		cards.add(netCashflowCard(income, expenses, "Department net cashflow"));
		cards.add(getPendingTransactionsCard(true, departmentId, "Department transactions awaiting verification"));
		return cards;
	}

	private SummaryCardModel getTotalIncomeCard(boolean departmentSpecific, Integer departmentId) {
		return totalIncomeCard(getTransactionAmount("income", departmentSpecific, departmentId), "Approved income records");
	}

	private SummaryCardModel getTotalExpensesCard(boolean departmentSpecific, Integer departmentId) {
		return totalExpensesCard(getTransactionAmount("expense", departmentSpecific, departmentId), "Approved expense records");
	}

	private SummaryCardModel getNetCashflowCard(boolean departmentSpecific, Integer departmentId) {
		double income = getTransactionAmount("income", departmentSpecific, departmentId);
		double expenses = getTransactionAmount("expense", departmentSpecific, departmentId);
		return netCashflowCard(income, expenses, "Income minus expenses");
	}

	private SummaryCardModel totalIncomeCard(double amount, String description) {
		return new SummaryCardModel("Total Income",
				formatCurrency(amount),
				description,
				"border-start border-success border-5",
				"text-success",
				"bi-graph-up-arrow");
	}

	private SummaryCardModel totalExpensesCard(double amount, String description) {
		return new SummaryCardModel("Total Expenses",
				formatCurrency(amount),
				description,
				"border-start border-danger border-5",
				"text-danger",
				"bi-wallet2");
	}

	private SummaryCardModel netCashflowCard(double income, double expenses, String description) {
		double net = income - expenses;
		boolean positive = net >= 0;
		return new SummaryCardModel(positive ? "Net Profit" : "Net Loss",
				formatCurrency(net),
				description,
				positive ? "border-start border-success border-5" : "border-start border-danger border-5",
				positive ? "text-success" : "text-danger",
				positive ? "bi-cash-stack" : "bi-graph-down-arrow");
	}

	private SummaryCardModel companyStatusCard(double income, double expenses) {
		double net = income - expenses;
		if (income == 0 && expenses == 0) {
			return new SummaryCardModel("Company Status",
					"No Data",
					"No approved transactions this year",
					"border-start border-secondary border-5",
					"text-secondary",
					"bi-info-circle");
		}

		if (net >= 0) {
			return new SummaryCardModel("Company Status",
					"Healthy",
					"Revenue exceeds expenses",
					"border-start border-primary border-5",
					"text-primary",
					"bi-shield-check");
		}

		return new SummaryCardModel("Company Status",
				"At Risk",
				"Expenses exceed revenue",
				"border-start border-warning border-5",
				"text-warning",
				"bi-exclamation-triangle");
	}

	private SummaryCardModel getPendingTransactionsCard(boolean departmentSpecific, Integer departmentId, String description) {
		int count = getTransactionCount("pending", departmentSpecific, departmentId);
		return new SummaryCardModel("Pending Verification",
				String.valueOf(count),
				description,
				"border-start border-warning border-5",
				"text-warning",
				"bi-hourglass-split");
	}

	private SummaryCardModel getApprovedTransactionsCard() {
		int count = getTransactionCount("approved", false, null);
		return new SummaryCardModel("Approved Transactions",
				String.valueOf(count),
				"Approved transactions this year",
				"border-start border-success border-5",
				"text-success",
				"bi-check-circle");
	}

	private SummaryCardModel getTotalUsersCard() {
		return new SummaryCardModel("Total Users",
				String.valueOf(getTableCount("users", "roleid <> 1")),
				"Registered non-admin users",
				"border-start border-primary border-5",
				"text-primary",
				"bi-people");
	}

	private SummaryCardModel getTotalDepartmentsCard() {
		return new SummaryCardModel("Departments",
				String.valueOf(getTableCount("department", null)),
				"Departments configured",
				"border-start border-info border-5",
				"text-info",
				"bi-building");
	}

	private double getTransactionAmount(String transactionType, boolean departmentSpecific, Integer departmentId) {
		StringBuilder sql = new StringBuilder("""
				SELECT NVL(SUM(totalamount), 0) AS totalamount
				FROM transaction
				WHERE LOWER(transactiontype) = ?
				  AND LOWER(status) = 'approved'
				  AND EXTRACT(YEAR FROM datetransaction) = ?
				""");

		if (departmentSpecific) {
			sql.append(" AND departmentid = ?");
		}

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString())) {
			ps.setString(1, transactionType.toLowerCase());
			ps.setInt(2, currentYear());
			if (departmentSpecific) {
				ps.setInt(3, departmentId == null ? 0 : departmentId);
			}

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return rs.getDouble("totalamount");
				}
			}
		} catch (Exception e) {
			ErrorUtil.log("SummaryCardDAO", "getTransactionAmount", e);
		}

		return 0.0;
	}

	private int getTransactionCount(String status, boolean departmentSpecific, Integer departmentId) {
		StringBuilder sql = new StringBuilder("""
				SELECT COUNT(*) AS transactioncount
				FROM transaction
				WHERE LOWER(status) = ?
				  AND EXTRACT(YEAR FROM datetransaction) = ?
				""");

		if (departmentSpecific) {
			sql.append(" AND departmentid = ?");
		}

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString())) {
			ps.setString(1, status.toLowerCase());
			ps.setInt(2, currentYear());
			if (departmentSpecific) {
				ps.setInt(3, departmentId == null ? 0 : departmentId);
			}

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return rs.getInt("transactioncount");
				}
			}
		} catch (Exception e) {
			ErrorUtil.log("SummaryCardDAO", "getTransactionCount", e);
		}

		return 0;
	}

	private int getTableCount(String tableName, String whereClause) {
		String sql = "SELECT COUNT(*) AS rowcount FROM " + tableName
				+ (whereClause == null || whereClause.isBlank() ? "" : " WHERE " + whereClause);

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next()) {
				return rs.getInt("rowcount");
			}
		} catch (Exception e) {
			ErrorUtil.log("SummaryCardDAO", "getTableCount", e);
		}

		return 0;
	}

	private DepartmentBudgetModel getDepartmentBudget(Integer departmentId) {
		if (departmentId == null) {
			return null;
		}

		List<DepartmentBudgetModel> rows = new DepartmentBudgetDAO().getBudgetRowsForYear(currentYear(), departmentId);
		return rows.isEmpty() ? null : rows.get(0);
	}

	private int currentYear() {
		return LocalDate.now().getYear();
	}

	private String formatCurrency(double amount) {
		return "RM " + String.format("%,.2f", amount);
	}
}
