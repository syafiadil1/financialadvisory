package controller;

import dao.DepartmentBudgetDAO;
import dao.DepartmentDAO;
import helper.RoleHelper;
import helper.SessionHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DepartmentBudgetModel;
import model.DepartmentModel;
import model.UserModel;
import util.ErrorUtil;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/BudgetController")
public class BudgetController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final DepartmentBudgetDAO departmentBudgetDAO = new DepartmentBudgetDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = getStringParameter(request, "action");
        if (action.isEmpty()) {
            action = "list";
        }

        if ("list".equals(action)) {
            listBudgets(request, response);
            return;
        }

        response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                ErrorUtil.format("BudgetController.java", "doGet", "Invalid action"));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = getStringParameter(request, "action");
        if ("save".equals(action)) {
            saveBudget(request, response);
            return;
        }

        response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                ErrorUtil.format("BudgetController.java", "doPost", "Invalid action"));
    }

    private void listBudgets(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = SessionHelper.getCurrentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (!canViewBudget(user)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    ErrorUtil.format("BudgetController.java", "listBudgets",
                            "You do not have permission to view budgets."));
            return;
        }

        int selectedYear = getYearParameter(request);
        boolean isFinancialManager = RoleHelper.isFinancialManager(user);
        if (!isFinancialManager && user.getDepartmentId() == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    ErrorUtil.format("BudgetController.java", "listBudgets",
                            "Department managers must be assigned to a department to view budgets."));
            return;
        }

        Integer selectedDepartmentId = isFinancialManager ? getNullableIntParameter(request, "departmentId") : user.getDepartmentId();
        String budgetStatus = getStringParameter(request, "status");
        List<DepartmentBudgetModel> budgetRows =
                departmentBudgetDAO.getBudgetRowsForYear(selectedYear, selectedDepartmentId);
        budgetRows = filterBudgetRowsByStatus(budgetRows, budgetStatus);

        request.setAttribute("user", user);
        request.setAttribute("roleName", RoleHelper.getRoleName(user.getRoleId()));
        request.setAttribute("isFinancialManager", isFinancialManager);
        request.setAttribute("selectedYear", selectedYear);
        request.setAttribute("selectedDepartmentId", selectedDepartmentId);
        request.setAttribute("selectedStatus", budgetStatus);
        request.setAttribute("yearOptions", buildYearOptions(selectedYear));
        request.setAttribute("budgetRows", budgetRows);
        request.setAttribute("totalAllocated", sumAllocated(budgetRows));
        request.setAttribute("totalUsed", sumUsed(budgetRows));
        request.setAttribute("totalRemaining", sumRemaining(budgetRows));
        request.setAttribute("saved", getStringParameter(request, "saved"));
        request.setAttribute("error", getStringParameter(request, "error"));

        if (isFinancialManager) {
            try {
                request.setAttribute("departments", DepartmentDAO.getAllDept());
            } catch (SQLException e) {
                ErrorUtil.log("BudgetController.java", "listBudgets", e);
                request.setAttribute("departments", new ArrayList<DepartmentModel>());
            }
        }

        request.getRequestDispatcher("/budget.jsp").forward(request, response);
    }

    private void saveBudget(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = SessionHelper.getCurrentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (!RoleHelper.isFinancialManager(user)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    ErrorUtil.format("BudgetController.java", "saveBudget",
                            "Only financial managers can set department budgets."));
            return;
        }

        int selectedYear = getYearParameter(request);
        int departmentId = getIntParameter(request, "departmentId");
        double budgetAmount = getDoubleParameter(request, "budgetAmount");

        if (departmentId <= 0 || selectedYear < 2000 || selectedYear > 2100 || budgetAmount < 0) {
            response.sendRedirect(request.getContextPath()
                    + "/BudgetController?action=list&year=" + selectedYear + "&error=invalid");
            return;
        }

        boolean success = departmentBudgetDAO.upsertDepartmentBudget(departmentId, selectedYear, budgetAmount);
        response.sendRedirect(request.getContextPath()
                + "/BudgetController?action=list&year=" + selectedYear
                + (success ? "&saved=1" : "&error=save"));
    }

    private boolean canViewBudget(UserModel user) {
        return RoleHelper.isFinancialManager(user) || user.getRoleId() == RoleHelper.ROLE_DEPARTMENT_MANAGER;
    }

    private int getYearParameter(HttpServletRequest request) {
        int currentYear = LocalDate.now().getYear();
        int year = getIntParameter(request, "year");
        if (year < 2000 || year > 2100) {
            return currentYear;
        }
        return year;
    }

    private List<Integer> buildYearOptions(int selectedYear) {
        int currentYear = LocalDate.now().getYear();
        int firstYear = Math.min(selectedYear, currentYear) - 2;
        int lastYear = Math.max(selectedYear, currentYear) + 2;
        List<Integer> years = new ArrayList<>();
        for (int year = lastYear; year >= firstYear; year--) {
            years.add(year);
        }
        return years;
    }

    private double sumAllocated(List<DepartmentBudgetModel> rows) {
        return rows.stream().mapToDouble(DepartmentBudgetModel::getInitialBudget).sum();
    }

    private double sumUsed(List<DepartmentBudgetModel> rows) {
        return rows.stream().mapToDouble(DepartmentBudgetModel::getUsedBudget).sum();
    }

    private double sumRemaining(List<DepartmentBudgetModel> rows) {
        return rows.stream().mapToDouble(DepartmentBudgetModel::getRemainingBudget).sum();
    }

    private List<DepartmentBudgetModel> filterBudgetRowsByStatus(List<DepartmentBudgetModel> rows, String status) {
        if (status.isEmpty()) {
            return rows;
        }

        List<DepartmentBudgetModel> filteredRows = new ArrayList<>();
        for (DepartmentBudgetModel row : rows) {
            if ("set".equals(status) && row.isActiveBudget()) {
                filteredRows.add(row);
            } else if ("not-set".equals(status) && !row.isActiveBudget()) {
                filteredRows.add(row);
            }
        }

        return filteredRows;
    }

    private String getStringParameter(HttpServletRequest request, String key) {
        String value = request.getParameter(key);
        return value == null ? "" : value.trim();
    }

    private int getIntParameter(HttpServletRequest request, String key) {
        String value = getStringParameter(request, key);
        if (value.isEmpty()) {
            return 0;
        }

        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private Integer getNullableIntParameter(HttpServletRequest request, String key) {
        int value = getIntParameter(request, key);
        return value <= 0 ? null : value;
    }

    private double getDoubleParameter(HttpServletRequest request, String key) {
        String value = getStringParameter(request, key);
        if (value.isEmpty()) {
            return 0.0;
        }

        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return -1.0;
        }
    }
}
