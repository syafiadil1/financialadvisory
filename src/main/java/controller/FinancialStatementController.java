package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.Month;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import dao.DepartmentDAO;
import dao.FinancialStatementDAO;
import helper.RoleHelper;
import helper.SessionHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DepartmentModel;
import model.FinancialStatementModel;
import model.UserModel;

@WebServlet("/FinancialStatementController")
public class FinancialStatementController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final DateTimeFormatter DATE_LABEL_FORMAT = DateTimeFormatter.ofPattern("dd MMM yyyy", Locale.ENGLISH);

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		UserModel user = SessionHelper.getCurrentUser(request);
		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}

		if (!RoleHelper.isFinancialManager(user)) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only Financial Manager can generate company statements.");
			return;
		}

		String action = getStringParameter(request, "action");
		if (action.isEmpty()) {
			action = "preview";
		}

		if (!"preview".equals(action) && !"print".equals(action)) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid statement action.");
			return;
		}

		Integer departmentId = getNullableIntParameter(request, "departmentId");
		List<DepartmentModel> departments = getDepartments();
		String departmentLabel = resolveDepartmentLabel(departments, departmentId);

		StatementPeriod period = resolvePeriod(request);
		FinancialStatementModel statement = new FinancialStatementDAO().getStatement(period.startDate(), period.endDate(),
				departmentId);
		statement.setPeriodLabel(period.label());
		statement.setDepartmentLabel(departmentLabel);
		statement.setGeneratedBy(user.getName());
		statement.setGeneratedDate(LocalDate.now());

		request.setAttribute("statement", statement);
		request.setAttribute("departments", departments);
		request.setAttribute("selectedDepartmentId", departmentId);
		request.setAttribute("periodType", period.periodType());
		request.setAttribute("selectedMonth", period.month());
		request.setAttribute("selectedQuarter", period.quarter());
		request.setAttribute("selectedYear", period.year());
		request.setAttribute("selectedStartDate", period.startDate().toString());
		request.setAttribute("selectedEndDate", period.endDate().toString());
		request.setAttribute("currentYear", LocalDate.now().getYear());
		request.setAttribute("printMode", "print".equals(action));

		request.getRequestDispatcher("financialmanager-statement.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

	private StatementPeriod resolvePeriod(HttpServletRequest request) {
		LocalDate today = LocalDate.now();
		String periodType = getStringParameter(request, "periodType");
		if (periodType.isEmpty()) {
			periodType = "monthly";
		}

		int year = parseInt(getStringParameter(request, "year"), today.getYear());
		int month = clamp(parseInt(getStringParameter(request, "month"), today.getMonthValue()), 1, 12);
		int quarter = clamp(parseInt(getStringParameter(request, "quarter"), ((today.getMonthValue() - 1) / 3) + 1), 1, 4);

		return switch (periodType) {
			case "quarterly" -> quarterlyPeriod(year, quarter);
			case "yearly" -> yearlyPeriod(year);
			case "custom" -> customPeriod(request, today, year, month);
			default -> monthlyPeriod(year, month);
		};
	}

	private StatementPeriod monthlyPeriod(int year, int month) {
		LocalDate startDate = LocalDate.of(year, month, 1);
		LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());
		String monthLabel = Month.of(month).getDisplayName(TextStyle.FULL, Locale.ENGLISH);
		return new StatementPeriod("monthly", startDate, endDate, monthLabel + " " + year, month, 1, year);
	}

	private StatementPeriod quarterlyPeriod(int year, int quarter) {
		int startMonth = ((quarter - 1) * 3) + 1;
		LocalDate startDate = LocalDate.of(year, startMonth, 1);
		LocalDate endDate = startDate.plusMonths(2).withDayOfMonth(startDate.plusMonths(2).lengthOfMonth());
		return new StatementPeriod("quarterly", startDate, endDate, "Q" + quarter + " " + year, startMonth, quarter, year);
	}

	private StatementPeriod yearlyPeriod(int year) {
		LocalDate startDate = LocalDate.of(year, 1, 1);
		LocalDate endDate = LocalDate.of(year, 12, 31);
		return new StatementPeriod("yearly", startDate, endDate, String.valueOf(year), 1, 1, year);
	}

	private StatementPeriod customPeriod(HttpServletRequest request, LocalDate today, int fallbackYear, int fallbackMonth) {
		LocalDate defaultStart = LocalDate.of(fallbackYear, fallbackMonth, 1);
		LocalDate defaultEnd = defaultStart.withDayOfMonth(defaultStart.lengthOfMonth());
		LocalDate startDate = parseDate(getStringParameter(request, "startDate"), defaultStart);
		LocalDate endDate = parseDate(getStringParameter(request, "endDate"), defaultEnd);

		if (endDate.isBefore(startDate)) {
			LocalDate swap = startDate;
			startDate = endDate;
			endDate = swap;
		}

		String label = startDate.format(DATE_LABEL_FORMAT) + " - " + endDate.format(DATE_LABEL_FORMAT);
		return new StatementPeriod("custom", startDate, endDate, label, today.getMonthValue(), 1, today.getYear());
	}

	private LocalDate parseDate(String value, LocalDate defaultValue) {
		if (value == null || value.isBlank()) {
			return defaultValue;
		}

		try {
			return LocalDate.parse(value);
		} catch (Exception e) {
			return defaultValue;
		}
	}

	private int parseInt(String value, int defaultValue) {
		if (value == null || value.isBlank()) {
			return defaultValue;
		}

		try {
			return Integer.parseInt(value);
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}

	private int clamp(int value, int min, int max) {
		return Math.max(min, Math.min(max, value));
	}

	private Integer getNullableIntParameter(HttpServletRequest request, String key) {
		String value = getStringParameter(request, key);
		if (value.isEmpty()) {
			return null;
		}

		try {
			int parsed = Integer.parseInt(value);
			return parsed > 0 ? parsed : null;
		} catch (NumberFormatException e) {
			return null;
		}
	}

	private List<DepartmentModel> getDepartments() {
		try {
			return DepartmentDAO.getAllDept();
		} catch (Exception e) {
			return new ArrayList<>();
		}
	}

	private String resolveDepartmentLabel(List<DepartmentModel> departments, Integer departmentId) {
		if (departmentId == null) {
			return "All Departments";
		}

		for (DepartmentModel department : departments) {
			if (department.getDepartmentId() != null && department.getDepartmentId().equals(departmentId)) {
				return department.getName();
			}
		}

		return "Selected Department";
	}

	private String getStringParameter(HttpServletRequest request, String key) {
		String value = request.getParameter(key);
		return value == null ? "" : value.trim();
	}

	private record StatementPeriod(String periodType, LocalDate startDate, LocalDate endDate, String label,
			int month, int quarter, int year) {
	}
}
