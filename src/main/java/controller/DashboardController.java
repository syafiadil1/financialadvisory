package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ChartDataModel;
import model.DepartmentBudgetModel;
import model.DepartmentModel;
import model.RoleModel;
import model.UserModel;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

import dao.ChartDataDAO;
import dao.DepartmentBudgetDAO;
import dao.DepartmentDAO;
import dao.RoleDAO;
import dao.SummaryCardDAO;
import dao.TransactionDAO;
import helper.RoleHelper;
import helper.SessionHelper;

/**
 * Servlet implementation class DashboardController
 */
@WebServlet("/DashboardController")
public class DashboardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public DashboardController() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String action = request.getParameter("action");
        try {

            if (action == null || action.isBlank() || action.equals("userInfo")) {

                showUserDashboard(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/DashboardController?action=userInfo");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	//(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
	private void showUserDashboard(HttpServletRequest request, HttpServletResponse response)
		        throws ServletException, IOException, SQLException {	
		UserModel user = SessionHelper.getCurrentUser(request);
		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}
		
		int id = user.getDepartmentId();
		DepartmentModel dpt = id > 0 ? DepartmentDAO.getDeptById(id) : null;
		RoleModel role = RoleDAO.getRoleById(user.getRoleId());
		
		// to send subtitle
		request.setAttribute("dashboardTitle", role.getName() + " Dashboard");

		String subtitle;

		switch (role.getRoleId()) {
		    case 1:
		        subtitle = "Manage users, departments, and system activity.";
		        break;
		    case 2:
		        subtitle = "View dashboard, analyze company performance, and generate company statements.";
		        break;
		    case 3:
		        subtitle = "Review department transactions, monitor budget usage, and view department analytics.";
		        break;
		    default:
		        subtitle = "View dashboard, manage transactions, and initiate AI advisory.";
		}
		
		Integer scopedDepartmentId = RoleHelper.isFinancialManager(user) || RoleHelper.isAdmin(user)
				? null
				: user.getDepartmentId();
		List<ChartDataModel> chartData = ChartDataDAO.getCashflowTrend(scopedDepartmentId);
		List<ChartDataModel> categoryExpenseSummary = ChartDataDAO.getCategoryExpenseSummary(scopedDepartmentId, 4);
		TransactionDAO transactionDAO = new TransactionDAO();
		List<DepartmentBudgetModel> budgetRows = user.getRoleId() == RoleHelper.ROLE_DEPARTMENT_MANAGER
				? new DepartmentBudgetDAO().getBudgetRowsForYear(LocalDate.now().getYear(), user.getDepartmentId())
				: List.of();

		request.setAttribute("summary_cards", new SummaryCardDAO().getSummaryCards(user, "dashboard"));
		request.setAttribute("cashflowTrend", chartData);
		request.setAttribute("categoryExpenseSummary", categoryExpenseSummary);
		request.setAttribute("recentTransactions", transactionDAO.getRecentTransactions(scopedDepartmentId, 5));
		request.setAttribute("pendingTransactions", transactionDAO.getPendingTransactions(scopedDepartmentId, 5));
		request.setAttribute("budgetRows", budgetRows);
		request.setAttribute("departmentBudget", budgetRows.isEmpty() ? null : budgetRows.get(0));
		request.setAttribute("dashboardYear", LocalDate.now().getYear());
		
		request.setAttribute("subtitle", subtitle);
		request.setAttribute("user", user);
		request.setAttribute("dept", dpt);
		request.setAttribute("role", role);
		request.getRequestDispatcher("dashboard.jsp").forward(request, response);
	}

}
