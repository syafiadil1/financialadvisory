package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import model.UserModel;
import dao.UserDAO;
import helper.RoleHelper;
import util.ErrorUtil;

/**
 * Servlet implementation class LoginController
 */
@WebServlet("/LoginController")
public class LoginController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginController() {
        super();
        // TODO Auto-generated constructor stub
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// to store the email and password enter by the user
		String email = request.getParameter("email");
        String password = request.getParameter("password");

        // create UserDAO object
        UserDAO dao = new UserDAO();

        // to store the data if TRUE
        UserModel user = dao.login(email, password);
        
        if (user != null) {

            HttpSession session = request.getSession();
            session.setAttribute("user", user); // only save that user information id, name rold id, etc
            //session.setMaxInactiveInterval(60 * 30); // 30 minutes

            
            
            //session.setAttribute("isAdmin", RoleHelper.isAdmin(user));
            //session.setAttribute("isDepartmentManager", RoleHelper.isDepartmentManager(user));
            //session.setAttribute("isFinancialManager", RoleHelper.isFinancialManager(user));
            //session.setAttribute("isStaff", RoleHelper.isStaff(user));

            //int roleId = user.getRoleId(); // to send the user login according to it role page

            // System Admin page because only admin not sharing the same dashboard with other role for now
            if (RoleHelper.isAdmin(user)) {

            	response.sendRedirect("UserController?action=list");
                return;
            }

            // All other users
            response.sendRedirect("DashboardController?action=userInfo");

        } else {

            request.getSession().setAttribute("error",
                    ErrorUtil.format("LoginController.java", "doPost", "Invalid email or password"));
            response.sendRedirect("login.jsp?error=1");
        }
	}

}
