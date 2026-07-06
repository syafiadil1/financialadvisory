package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import connection.DBConnection;
import model.DepartmentModel;
import model.UserModel;

public class DepartmentDAO {
	private static Connection conn = null;
	private static PreparedStatement ps = null;
	private static ResultSet rs = null;
	private static String sql = null;
	
	public static List<DepartmentModel> getAllDept() throws SQLException{
		
		List<DepartmentModel> list = new ArrayList<>();;
		
		try {
			conn = DBConnection.getConnection();
			sql = "SELECT * FROM DEPARTMENT";
			ps = conn.prepareStatement(sql);
			
			rs = ps.executeQuery();
			
			while(rs.next()) {
				DepartmentModel dept = new DepartmentModel();
				
				dept.setDepartmentId(rs.getInt("DEPARTMENTID"));
				dept.setName(rs.getString("NAME"));
				dept.setDescription(rs.getString("DESCRIPTION"));
				
				list.add(dept);
			}
            rs.close();
            ps.close();		
		} catch (SQLException e) {
            e.printStackTrace();
        }
		
		return list;
		
	}
	
	public static List<DepartmentModel> searchDepartment(String keyword)
	        throws SQLException {

	    List<DepartmentModel> departments = new ArrayList<>();

	    try {

	        conn = DBConnection.getConnection();

	        sql = "SELECT * "
	            + "FROM DEPARTMENT "
	            + "WHERE LOWER(NAME) LIKE ? "
	            + "ORDER BY DEPARTMENTID";

	        ps = conn.prepareStatement(sql);

	        ps.setString(1, "%" + keyword.toLowerCase() + "%");

	        rs = ps.executeQuery();

	        while (rs.next()) {

	            DepartmentModel dept = new DepartmentModel();

	            dept.setDepartmentId(rs.getInt("DEPARTMENTID"));
	            dept.setName(rs.getString("NAME"));
	            dept.setDescription(rs.getString("DESCRIPTION"));

	            departments.add(dept);
	        }

	        rs.close();
	        ps.close();

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return departments;
	}
	
    public static DepartmentModel getDeptById(int id) throws SQLException{
    	
    	DepartmentModel d = null;
        try {
            conn = DBConnection.getConnection();

            sql = "SELECT * FROM DEPARTMENT WHERE DEPARTMENTID = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                d = new DepartmentModel();
                d.setDepartmentId(rs.getInt("DEPARTMENTID"));
                d.setName(rs.getString("NAME"));
                d.setDescription(rs.getString("DESCRIPTION"));
            }
            
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    	
    	return d;
    }
    
    public static boolean addDepartment(DepartmentModel data) throws SQLException{
        try {
            conn = DBConnection.getConnection();

            sql = "INSERT INTO DEPARTMENT (NAME, DESCRIPTION) VALUES (?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, data.getName());
            ps.setString(2, data.getDescription());
            int rowsAffected = ps.executeUpdate();

            ps.close();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // update a department
    public static boolean updateDept(DepartmentModel data) throws SQLException{
    	try {
            conn = DBConnection.getConnection();

            sql = "UPDATE DEPARTMENT SET NAME=?, DESCRIPTION=? WHERE DEPARTMENTID=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, data.getName());
            ps.setString(2, data.getDescription());
            ps.setInt(3, data.getDepartmentId());
            int rowsAffected = ps.executeUpdate();

            ps.close();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public static boolean deleteDept(int id) throws SQLException{
        try {
            conn = DBConnection.getConnection();

            sql = "DELETE FROM DEPARTMENT WHERE DEPARTMENTID = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int rowsAffected = ps.executeUpdate();

            ps.close();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
