package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.CategoryAccessModel;
import model.CategoryModel;
import model.UserModel;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dao.CategoryDAO;
import helper.SessionHelper;

/**
 * Servlet implementation class CategoryController
 */
@WebServlet("/CategoryController")
public class CategoryController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CategoryController() {
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
				listCategory(request, response);
			}else if ("view".equals(action)) {
			    viewCategory(request, response);
			}
		    else if ("create".equals(action)) {
		        showCreateForm(request, response);
		    }else if ("delete".equals(action)) {
		        deleteCategory(request, response);
		    }
		}catch(SQLException ex) {
			throw new ServletException(ex);
		}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    String action = request.getParameter("action");
	    try {
		    if ("save".equals(action)) {
		        saveCategory(request, response);
		    }
		}catch(SQLException ex) {
			throw new ServletException(ex);
		}
	}
	
	public void listCategory(HttpServletRequest request, HttpServletResponse response)
	        throws SQLException, ServletException, IOException {

		UserModel currUser = SessionHelper.getCurrentUser(request);

	    if (currUser == null) {
	        response.sendRedirect(request.getContextPath() + "/login.jsp");
	        return;
	    }

	    String keyword = request.getParameter("keyword");
	    CategoryDAO categoryDAO = new CategoryDAO();
	    List<Integer> categoryIds = categoryDAO.getCategoryIdsByDepartmentId(currUser.getDepartmentId());

	    List<CategoryModel> categories = new ArrayList<>();

	    for (int categoryId : categoryIds) {
	        CategoryModel category = categoryDAO.getCategoryById(categoryId);

	        if (category != null) {
	        	// No keyword entered by the user(alah maksudnya user tak cari pape)
	            if (keyword == null || keyword.trim().isEmpty()
	                    || category.getName().toLowerCase().contains(keyword.toLowerCase())) {

	                categories.add(category);
	            }
	        }
	    }

	    request.setAttribute("categories", categories);

	    request.getRequestDispatcher("departmentmanager-category-list.jsp")
	            .forward(request, response);
	}
	
	private void viewCategory(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    int categoryId = Integer.parseInt(request.getParameter("categoryId"));

	    CategoryDAO categoryDAO = new CategoryDAO();

	    CategoryModel category = categoryDAO.getCategoryById(categoryId);
	    List<CategoryModel> parentCategories = categoryDAO.getAllCategories();

	    if (category == null) {
	        response.sendRedirect(request.getContextPath() + "/CategoryController?action=list");
	        return;
	    }

	    request.setAttribute("category", category);
	    request.setAttribute("parentCategories", parentCategories);
	    request.setAttribute("mode", "edit");

	    request.getRequestDispatcher("/departmentmanager-category-details.jsp")
	           .forward(request, response);
	}
	
	private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    CategoryDAO categoryDAO = new CategoryDAO();

	    List<CategoryModel> parentCategories = categoryDAO.getAllCategories();

	    request.setAttribute("mode", "create");
	    request.setAttribute("parentCategories", parentCategories);

	    request.getRequestDispatcher("/departmentmanager-category-details.jsp")
	           .forward(request, response);
	}
	
    private void saveCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        UserModel currUser = SessionHelper.getCurrentUser(request);

        String categoryIdParam = request.getParameter("categoryId");
        String categoryName = request.getParameter("categoryName");
        boolean isPublic = request.getParameter("isPublic") != null;

        boolean isCreate = categoryIdParam == null || categoryIdParam.trim().isEmpty();

        
    	CategoryModel category = new CategoryModel();
        category.setName(categoryName);
        category.setGeneric(isPublic);
        
        if(isCreate) {
            CategoryDAO.addCategory(category);

            int newCategoryId = CategoryDAO.getLatestCategoryId();

            CategoryAccessModel access = new CategoryAccessModel();
            access.setDepartmentId(currUser.getDepartmentId());
            access.setCategoryId(newCategoryId);

            CategoryDAO.addCategoryAccess(access);
        } else {
            int categoryId = Integer.parseInt(categoryIdParam);

            category.setCategoryId(categoryId);

            CategoryDAO.updateCategory(category);
        }

        response.sendRedirect(request.getContextPath() + "/CategoryController?action=list");
    }
    
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        UserModel currUser = SessionHelper.getCurrentUser(request);

        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        CategoryDAO.deleteCategoryAccess(currUser.getDepartmentId(), categoryId);

        CategoryDAO.deleteCategory(categoryId);

        response.sendRedirect(request.getContextPath() + "/CategoryController?action=list");
    }
}
