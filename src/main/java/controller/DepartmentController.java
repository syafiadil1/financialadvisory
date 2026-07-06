package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DepartmentModel;
import model.UserModel;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.DepartmentDAO;
import dao.UserDAO;

/**
 * Servlet implementation class DepartmentController
 */
@WebServlet("/DepartmentController")
public class DepartmentController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DepartmentController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		
		try {

			if("list".equals(action)) {
				listDepartment(request, response);
			}else if("view".equals(action)) {
        		viewDept(request, response);
        	}else if("create".equals(action)) {
        		showCreateForm(request, response);
			}else if("delete".equals(action)) {
				deleteDept(request, response);
			}
		}catch(SQLException ex) {
			throw new ServletException(ex);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String id = request.getParameter("departmentId");
		try {
			if(id == null) {
				addDept(request, response);
			}else
				updateDept(request, response);
		} catch (SQLException e) {
			e.printStackTrace();
			setFlash(request, "danger", "Department could not be saved. Please try again.");
			response.sendRedirect(request.getContextPath() + "/DepartmentController?action=list");
		}
	}
	
	private void listDepartment(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		String keyword = request.getParameter("keyword");

	    List<DepartmentModel> departments;

	    if (keyword == null || keyword.trim().isEmpty()) {
	        departments = DepartmentDAO.getAllDept();
	    } else {
	        departments = DepartmentDAO.searchDepartment(keyword);
	    }

	    request.setAttribute("depts", departments);

	    request.getRequestDispatcher("admin/admin-department-list.jsp").forward(request, response);
	}
	
	private void viewDept(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		int deptId = Integer.parseInt(request.getParameter("id"));
		
		DepartmentModel existingDept = DepartmentDAO.getDeptById(deptId);
		
		request.setAttribute("dept", existingDept);
		
		request.setAttribute("mode", "update"); // to trigger the action button in jsp
		request.getRequestDispatcher("admin/admin-department-details.jsp").forward(request, response);
	}
	
	private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		//List<DepartmentModel> deptList= DepartmentDAO.getAllDept();
        //request.setAttribute("depts", deptList);
		 request.setAttribute("dept", new DepartmentModel());
		 
		 request.setAttribute("mode", "create"); // to trigger the action button in jsp
         request.getRequestDispatcher("admin/admin-department-details.jsp").forward(request, response);
	}

	
	public void addDept (HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
		String deptName = request.getParameter("departmentName");
		String desc = request.getParameter("description");
		
		DepartmentModel deptData = new DepartmentModel();
		
		deptData.setName(deptName);
		deptData.setDescription(desc);
		
		boolean success = DepartmentDAO.addDepartment(deptData);
		setFlash(request, success ? "success" : "danger",
				success ? "Department created successfully." : "Department could not be created. Please try again.");
        response.sendRedirect(request.getContextPath() + "/DepartmentController?action=list");
	}
	
	public void updateDept(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
		int deptId = Integer.parseInt(request.getParameter("departmentCode"));
		String deptName = request.getParameter("departmentName");
		String desc = request.getParameter("description");
		
		DepartmentModel deptData = new DepartmentModel();
		
		deptData.setDepartmentId(deptId);
		deptData.setName(deptName);
		deptData.setDescription(desc);
		
		boolean success = DepartmentDAO.updateDept(deptData);
		setFlash(request, success ? "success" : "danger",
				success ? "Department updated successfully." : "Department could not be updated. Please try again.");
        response.sendRedirect(request.getContextPath() + "/DepartmentController?action=list");
	}
	
	public void deleteDept(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));
		boolean success = DepartmentDAO.deleteDept(id);
		setFlash(request, success ? "success" : "danger",
				success ? "Department deleted successfully." : "Department could not be deleted. Please try again.");
		response.sendRedirect(request.getContextPath() + "/DepartmentController?action=list");
	}

	private void setFlash(HttpServletRequest request, String type, String message) {
		HttpSession session = request.getSession();
		session.setAttribute("flashType", type);
		session.setAttribute("flashMessage", message);
	}
}
