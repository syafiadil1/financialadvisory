package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DepartmentModel;
import model.RoleModel;
import model.UserModel;

import java.io.IOException;
import java.sql.SQLException;

import dao.DepartmentDAO;
import dao.RoleDAO;
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

            if (action.equals("userInfo")) {

                showUserDashboard(request, response);
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
		
		int id = user.getDepartmentId();
		DepartmentModel dpt = DepartmentDAO.getDeptById(id);
		RoleModel role = RoleDAO.getRoleById(user.getRoleId());
		
		// to send subtitle
		request.setAttribute("dashboardTitle", role.getName() + " Dashboard");

		String subtitle;

		switch (role.getRoleId()) {
		    case 1:
		        subtitle = "Manage users, departments and system configuration.";
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

		request.setAttribute("subtitle", subtitle);
		request.setAttribute("user", user);
		request.setAttribute("dept", dpt);
		request.setAttribute("role", role);
		request.getRequestDispatcher("dashboard.jsp").forward(request, response);
	}

}
