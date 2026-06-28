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
		String email = request.getParameter("email");

        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();

        UserModel user = dao.login(email, password);

        //RoleDAO roleDAO = new RoleDAO();
        
        //List<Role> roleList = roleDAO.getAllRoles();
        
        
        
        if (user != null) {

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            int roleId = user.getRoleId();

            // System Admin page because only admin not sharing the same dashboard with other role
            if (roleId == 1) {

                response.sendRedirect("admin/admin-user-list.jsp");
                return;
            }

            // All other users
            response.sendRedirect("dashboard.jsp");

        } else {

            response.sendRedirect("login.jsp?error=1");
        }
	}

}
