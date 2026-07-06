package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.DepartmentDAO;
import dao.RoleDAO;
import dao.UserDAO;
import helper.RoleHelper;
import helper.SessionHelper;
import model.DepartmentModel;
import model.RoleModel;
import model.UserModel;
import util.ErrorUtil;

import dao.RoleDAO;
import model.RoleModel;
/**
 * Servlet implementation class UserController
 */
@WebServlet("/UserController")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserController() {
        super();
        // TODO Auto-generated constructor stub
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
    	String action = request.getParameter("action");
    	
    	try {
        	if("list".equals(action)) {
        		listUser(request, response);
        	}else if("view".equals(action)) {
        		viewUser(request, response);
        	}else if("create".equals(action)) {
        		showCreateForm(request, response);
        	}else if("delete".equals(action)){
        		deleteUser(request, response);
        	}else {
                showProfile(request, response);
        	}
    	}catch(SQLException ex) {
			throw new ServletException(ex);
		}
    }
    
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userId = request.getParameter("userId"); //untuk update process perlu id
		try {
			if(userId == null) {
				addUser(request, response);
			}else
				updateUser(request, response);
			
		} catch (SQLException e) {
			e.printStackTrace();
			setFlash(request, "danger", "User could not be saved. Please try again.");
			response.sendRedirect(request.getContextPath() + "/UserController?action=list");
		}
	}
	
	
	
	
	//This is a method to show all list of user or filtering
	private void listUser(HttpServletRequest request, HttpServletResponse response)
	        throws SQLException, ServletException, IOException {

	    String keyword = request.getParameter("keyword");
	    String roleIdParam = request.getParameter("roleId");
	    String departmentIdParam = request.getParameter("departmentId");

	    List<UserModel> userList;

	    // No filter selected
	    if ((keyword == null || keyword.trim().isEmpty())
	            && (roleIdParam == null || roleIdParam.isEmpty())
	            && (departmentIdParam == null || departmentIdParam.isEmpty())) {

	        userList = UserDAO.getAllUsers();

	    } else {

	        Integer roleId = null;
	        Integer departmentId = null;

	        if (roleIdParam != null && !roleIdParam.isEmpty()) {
	            roleId = Integer.parseInt(roleIdParam);
	        }

	        if (departmentIdParam != null && !departmentIdParam.isEmpty()) {
	            departmentId = Integer.parseInt(departmentIdParam);
	        }

	        userList = UserDAO.filterUsers(keyword, roleId, departmentId);
	    }

	    request.setAttribute("users", userList);
	    request.setAttribute("depts", DepartmentDAO.getAllDept());
	    request.setAttribute("roles", RoleDAO.getAllRoles());

	    request.getRequestDispatcher("admin/admin-user-list.jsp").forward(request, response);
	}
	
	 // this is a method to display details of a user (id)
	private void viewUser(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		int idUser = Integer.parseInt(request.getParameter("id"));
		//System.out.println("RAW ID PARAM = " + idUser);
		
		UserModel existingUser = UserDAO.getUserById(idUser);
		List <DepartmentModel> existingDept = DepartmentDAO.getAllDept();
		List <RoleModel> allRole = RoleDAO.getAllRoles();
		
		request.setAttribute("roles", allRole);
		request.setAttribute("depts", existingDept);
		request.setAttribute("user", existingUser); 
		
		request.setAttribute("mode", "update"); // to trigger the edit form
        request.getRequestDispatcher("admin/admin-user-details.jsp").forward(request, response);
	}
	
	private void showCreateForm (HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {

		List <DepartmentModel> existingDept = DepartmentDAO.getAllDept();
		List <RoleModel> allRole = RoleDAO.getAllRoles();
		
		request.setAttribute("mode", "create");
		request.setAttribute("roles", allRole);
		request.setAttribute("depts", existingDept);
		request.setAttribute("user", new UserModel());
		request.getRequestDispatcher("admin/admin-user-details.jsp").forward(request, response);
	}
	
	private void addUser (HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
		
        String name = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        
        UserModel userData = new UserModel();
        
        userData.setName(name);
        userData.setEmail(email);
        userData.setPassword(password);
        userData.setRoleId(roleId);
        userData.setDepartmentId(departmentId);
        
        if (RoleHelper.isDepartmentManager(userData) && UserDAO.checkIfDepartmentManagerExists(departmentId, null)) {
			setFlash(request, "danger", "A department manager already exists for this department.");
			response.sendRedirect(request.getContextPath() + "/UserController?action=list");
			return;
		}
        
        boolean success = UserDAO.addUser(userData);
        setFlash(request, success ? "success" : "danger",
        		success ? "User created successfully." : "User could not be created. Please try again.");
        
        response.sendRedirect(request.getContextPath() + "/UserController?action=list");
	}
	
	// go to update user UserDAO
	private void updateUser (HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
		
		int userId = Integer.parseInt(request.getParameter("userId"));
		String name = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        
        //System.out.print("password");
        
        // to fetch current passsword
        UserModel existingUser = UserDAO.getUserById(userId);
        
        UserModel userData = new UserModel();
        
        userData.setUserId(userId);
        userData.setName(name);
        userData.setEmail(email);
        userData.setPassword(password);
        userData.setRoleId(roleId);
        userData.setDepartmentId(departmentId);
        
        if (RoleHelper.isDepartmentManager(userData) && UserDAO.checkIfDepartmentManagerExists(departmentId, userId)) {
			setFlash(request, "danger", "A department manager already exists for this department.");
			response.sendRedirect(request.getContextPath() + "/UserController?action=list");
			return;
		}
        
        if (password != null && !password.trim().isEmpty()) {
        	userData.setPassword(password); // new password
        } else {
        	userData.setPassword(existingUser.getPassword()); // keep old password
        }
        
        boolean success = UserDAO.updateUser(userData);
        String source = request.getParameter("source");
        
        UserModel temp = UserDAO.getUserById(userData.getUserId());
        HttpSession session = request.getSession();
        if (temp != null) {
        	session.setAttribute("user", temp);
        }
        setFlash(request, success ? "success" : "danger",
        		success ? "User updated successfully." : "User could not be updated. Please try again.");
        
        if ("profile".equals(source)) {
        	response.sendRedirect(request.getContextPath() + "/UserController?action=showUserProfile");
        }else
        	response.sendRedirect(request.getContextPath() + "/UserController?action=list");
	}
	
	public void deleteUser(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));
		boolean success = UserDAO.deleteUser(id);
		setFlash(request, success ? "success" : "danger",
				success ? "User deleted successfully." : "User could not be deleted. Please try again.");
		response.sendRedirect(request.getContextPath() + "/UserController?action=list");
	}
	
	// this is user setting show form only
	private void showProfile(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException, SQLException {

	    //HttpSession session = request.getSession(false);

	    UserModel loginUser = SessionHelper.getCurrentUser(request);

	    int userId = loginUser.getUserId();

	    //UserDAO dao = new UserDAO();

	    UserModel user = UserDAO.getUserById(userId);
	    
		List <DepartmentModel> existingDept = DepartmentDAO.getAllDept();
		List <RoleModel> allRole = RoleDAO.getAllRoles();
		
		request.setAttribute("roles", allRole);
		request.setAttribute("depts", existingDept);
	    request.setAttribute("user", user);
	    request.setAttribute("roleId", user.getRoleId());
	    request.getRequestDispatcher("account-settings.jsp")
	           .forward(request, response);
	}

	private void setFlash(HttpServletRequest request, String type, String message) {
		HttpSession session = request.getSession();
		session.setAttribute("flashType", type);
		session.setAttribute("flashMessage", message);
	}
	
}
