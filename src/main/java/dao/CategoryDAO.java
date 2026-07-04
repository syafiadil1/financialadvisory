package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import connection.DBConnection;
import model.CategoryAccessModel;
import model.CategoryModel;
import util.ErrorUtil;

public class CategoryDAO {
	public CategoryModel getCategoryById(int categoryId) {
		try {
			Connection conn = DBConnection.getConnection();
			//Statement stmt = conn.createStatement();
			String sql = "SELECT * FROM category WHERE categoryId = ?";
			PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, categoryId);
            //ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
			//rs = stmt.executeQuery("SELECT * FROM category WHERE categoryId = " + categoryId);
			
			if (rs.next()) {
				CategoryModel category = new CategoryModel();
				category.setCategoryId(rs.getInt("CATEGORYID"));
	            category.setName(rs.getString("NAME"));
	            category.setGeneric(rs.getInt("ISGENERIC") == 1);
	            category.setParentCategoryId(rs.getInt("PARENTCATEGORYID"));
				
				return category; // Return the category object

			}
			conn.close();
			
		} catch (Exception e) {
			ErrorUtil.log("CategoryDAO.java", "getCategoryById", e);
		}
		
		return null; // Placeholder return statement
	}
	
	public static String getCategoryLabelById(int categoryId) {
		try {
			Connection conn = DBConnection.getConnection();
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery("SELECT name FROM category WHERE categoryId = " + categoryId);
			
			if (rs.next()) {
				return rs.getString("name");
			}
			
			conn.close();
			
		} catch (Exception e) {
			ErrorUtil.log("CategoryDAO.java", "getCategoryLabelById", e);
			
		}
		return null;
	}
	
	public ArrayList<CategoryModel> getAllCategories() {
		try {
			Connection conn = DBConnection.getConnection();
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery("SELECT * FROM category");
			
			ArrayList<CategoryModel> categories = new ArrayList<>();
			
			while (rs.next()) {
				CategoryModel category = new CategoryModel(rs.getInt("categoryId"),
						rs.getString("name"),
						rs.getInt("isGeneric") == 1, // Assuming isGeneric is stored as an integer (1 for true, 0 for false)
						rs.getInt("parentCategoryId"));
				
				categories.add(category);
			}
			
			conn.close();
			return categories;
			
		} catch (Exception e) {
			ErrorUtil.log("CategoryDAO.java", "getAllCategories", e);
		}
		
		return null; // Placeholder return statement
	}
	
	
	// return semua id category sahaja based on deptID
	public ArrayList<Integer> getCategoryIdsByDepartmentId(int departmentId) {

	    ArrayList<Integer> categoryIds = new ArrayList<>();

	    String sql = "SELECT CATEGORYID FROM CATEGORYACCESS WHERE DEPARTMENTID = ?";

	    try {
	    	Connection conn = DBConnection.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql);
	        ps.setInt(1, departmentId);

	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            categoryIds.add(rs.getInt("CATEGORYID"));
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return categoryIds;
	}
	
    public static void addCategory(CategoryModel data) {

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO CATEGORY "
                + "(CATEGORYID, NAME, ISGENERIC, PARENTCATEGORYID) "
                + "VALUES (CATEGORY_SEQ.NEXTVAL, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, data.getName());
            ps.setInt(2, data.isGeneric() ? 1 : 0);

            // You chose option 2: store 0 for parent category
            ps.setInt(3, 0);

            ps.executeUpdate();

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static int getLatestCategoryId() {

        int categoryId = 0;

        try {
        	Connection conn = DBConnection.getConnection();

        	String sql = "SELECT MAX(CATEGORYID) AS CATEGORYID FROM CATEGORY";

        	PreparedStatement ps = conn.prepareStatement(sql);
        	ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                categoryId = rs.getInt("CATEGORYID");
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return categoryId;
    }

    public static void addCategoryAccess(CategoryAccessModel data) {

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO CATEGORYACCESS "
                + "(CATEGORYACCESSID, DEPARTMENTID, CATEGORYID) "
                + "VALUES (CATEGORYACCESS_SEQ.NEXTVAL, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, data.getDepartmentId());
            ps.setInt(2, data.getCategoryId());

            ps.executeUpdate();

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void updateCategory(CategoryModel data){

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE CATEGORY "
                + "SET NAME = ?, ISGENERIC = ?, PARENTCATEGORYID = ? "
                + "WHERE CATEGORYID = ?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, data.getName());
            ps.setInt(2, data.isGeneric() ? 1 : 0);

            // You decided parent category is not used yet
            ps.setInt(3, 0);

            ps.setInt(4, data.getCategoryId());

            ps.executeUpdate();

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void deleteCategoryAccess(int departmentId, int categoryId){

        try {
        	Connection conn = DBConnection.getConnection();

            String sql = "DELETE FROM CATEGORYACCESS WHERE DEPARTMENTID = ? AND CATEGORYID = ?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, departmentId);
            ps.setInt(2, categoryId);

            ps.executeUpdate();

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void deleteCategory(int categoryId){

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "DELETE FROM CATEGORY WHERE CATEGORYID = ?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, categoryId);

            ps.executeUpdate();

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
