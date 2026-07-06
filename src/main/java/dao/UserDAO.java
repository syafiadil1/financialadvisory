package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.UserModel;
import connection.DBConnection;
import util.ErrorUtil;

public class UserDAO {
	private static Connection conn = null;
	private static PreparedStatement ps = null;
	private static ResultSet rs = null;
	private static String sql = null;

	
	// this is for user login() function
    public UserModel login(String email, String password) {

        UserModel user = null;

        try {

            conn = DBConnection.getConnection();

            sql = "SELECT * FROM USERS WHERE EMAIL=? AND PASSWORD=?";

            ps = conn.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if(rs.next()) {

                user = new UserModel();

                user.setUserId(rs.getInt("USERID"));

                user.setEmail(rs.getString("EMAIL"));

                user.setName(rs.getString("NAME"));

                user.setDepartmentId(rs.getInt("DEPARTMENTID"));

                user.setRoleId(rs.getInt("ROLEID"));
            }

            conn.close();

        } catch(Exception e) {
            ErrorUtil.log("UserDAO.java", "login", e);
        }

        return user; //return Object
    }
	
    // this is for dashboard, that will get the user name and role
    public static UserModel getUserById(int id) throws SQLException{
    	
    	UserModel u = null;
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT u.USERID, u.NAME, u.EMAIL, u.PASSWORD, u.ROLEID, u.DEPARTMENTID, r.NAME AS ROLENAME, d.NAME AS DEPARTMENTNAME FROM users u LEFT JOIN role r ON u.ROLEID = r.ROLEID LEFT JOIN department d ON u.DEPARTMENTID = d.DEPARTMENTID WHERE u.USERID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                u = new UserModel();
                u.setUserId(rs.getInt("USERID"));
                u.setName(rs.getString("NAME"));
                u.setPassword(rs.getString("PASSWORD"));
                u.setEmail(rs.getString("EMAIL"));
                u.setRoleName(rs.getString("ROLENAME"));
                u.setDepartmentName(rs.getString("DEPARTMENTNAME"));
                u.setRoleId(rs.getInt("ROLEID"));
                u.setDepartmentId(rs.getInt("DEPARTMENTID"));
            }
            
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    	
    	return u;
    }
    
    
	// this is for show user information
    public static List<UserModel> getAllUsers() throws SQLException {

        List<UserModel> list = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT u.USERID, u.NAME AS USERNAME, u.EMAIL, u.PASSWORD, u.ROLEID, u.DEPARTMENTID, r.NAME AS ROLENAME, d.NAME AS DEPARTMENTNAME FROM users u LEFT JOIN role r ON u.ROLEID = r.ROLEID LEFT JOIN department d ON u.DEPARTMENTID = d.DEPARTMENTID WHERE u.ROLEID <> 1 ORDER BY u.USERID";
            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UserModel u = new UserModel();
                u.setUserId(rs.getInt("USERID"));
                u.setName(rs.getString("USERNAME"));
                u.setEmail(rs.getString("EMAIL"));
                u.setRoleId(rs.getInt("ROLEID"));
                u.setRoleName(rs.getString("ROLENAME"));
                u.setDepartmentId(rs.getInt("DEPARTMENTID"));
                u.setDepartmentName(rs.getString("DEPARTMENTNAME"));
                

                list.add(u);
            }
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
    //  filtering user
    public static List<UserModel> filterUsers(String keyword, Integer roleId, Integer departmentId)
            throws SQLException {

        List<UserModel> users = new ArrayList<>();

        try {
            conn = DBConnection.getConnection();

            sql = "SELECT u.USERID, u.NAME AS USERNAME, u.EMAIL, u.PASSWORD, u.ROLEID, u.DEPARTMENTID, r.NAME AS ROLENAME, d.NAME AS DEPARTMENTNAME "
                + "FROM USERS u LEFT JOIN role r ON u.ROLEID = r.ROLEID LEFT JOIN department d ON u.DEPARTMENTID = d.DEPARTMENTID WHERE u.ROLEID <> 1";

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql += " AND (LOWER(u.NAME) LIKE ? OR LOWER(u.EMAIL) LIKE ?)";
            }

            if (roleId != null) {
                sql += " AND u.ROLEID = ?";
            }

            if (departmentId != null) {
                sql += " AND u.DEPARTMENTID = ?";
            }

            sql += " ORDER BY u.USERID";

            ps = conn.prepareStatement(sql);

            int index = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchKeyword = "%" + keyword.toLowerCase() + "%";
                ps.setString(index++, searchKeyword);
                ps.setString(index++, searchKeyword);
            }

            if (roleId != null) {
                ps.setInt(index++, roleId);
            }

            if (departmentId != null) {
                ps.setInt(index++, departmentId);
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                UserModel user = new UserModel();

                user.setUserId(rs.getInt("USERID"));
                user.setName(rs.getString("USERNAME"));
                user.setEmail(rs.getString("EMAIL"));
                user.setPassword(rs.getString("PASSWORD"));
                user.setRoleId(rs.getInt("ROLEID"));
                user.setRoleName(rs.getString("ROLENAME"));
                user.setDepartmentId(rs.getInt("DEPARTMENTID"));
                user.setDepartmentName(rs.getString("DEPARTMENTNAME"));

                users.add(user);
            }

            rs.close();
            ps.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }
    
    // add new user
    public static boolean addUser(UserModel data) throws SQLException{
    	try {
    		conn = DBConnection.getConnection();
    		sql = "INSERT INTO USERS (NAME, EMAIL, PASSWORD, ROLEID, DEPARTMENTID) VALUES (?, ?, ?, ?, ?)";
    		
    		ps = conn.prepareStatement(sql);
    	    ps.setString(1, data.getName());
    	    ps.setString(2, data.getEmail());
    	    ps.setString(3, data.getPassword());
    	    ps.setInt(4, data.getRoleId());
    	    if (data.getDepartmentId() == null || data.getDepartmentId() == 0) {
    	        ps.setNull(5, java.sql.Types.INTEGER);
    	    } else {
    	        ps.setInt(5, data.getDepartmentId());
    	    }
    	    
    	    int rowsAffected = ps.executeUpdate();
    	    
    	    ps.close();   
    	    return rowsAffected > 0;
    	    
    	}catch (SQLException e) {
    		e.printStackTrace();
    	}
    	return false;
    }

    // update a user
    public static boolean updateUser(UserModel data) throws SQLException{
    	try {
    		conn = DBConnection.getConnection();
    		sql = "UPDATE USERS SET NAME = ?, EMAIL = ?, PASSWORD = ?, ROLEID = ?, DEPARTMENTID = ? WHERE USERID = ?";
    		ps = conn.prepareStatement(sql);
    	    ps.setString(1, data.getName());
    	    ps.setString(2, data.getEmail());
    	    ps.setString(3, data.getPassword());
    	    ps.setInt(4, data.getRoleId());
    	    if (data.getDepartmentId() == null || data.getDepartmentId() == 0) {
    	        ps.setNull(5, java.sql.Types.INTEGER);
    	    } else {
    	        ps.setInt(5, data.getDepartmentId());
    	    }
    	    //ps.setInt(5, data.getDepartmentId());
    	    ps.setInt(6, data.getUserId());
    		
    	    int rowsAffected = ps.executeUpdate();
    	    
    	    ps.close();
    	    return rowsAffected > 0;
    	    
    	}catch (SQLException e) {
    		e.printStackTrace();
    	}
    	return false;
    }
    
    // delete a user
    public static boolean deleteUser(int id) throws SQLException{
        try {
            conn = DBConnection.getConnection();

            sql = "DELETE FROM USERS WHERE USERID = ?";
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

    public static boolean checkIfDepartmentManagerExists(Integer departmentId, Integer userId) throws SQLException {
		boolean exists = false;
		try {
			conn = DBConnection.getConnection();
			sql = "SELECT COUNT(*) AS count FROM USERS WHERE ROLEID = 3 AND DEPARTMENTID = ?";
			
			if (userId != null) {
				sql += " AND USERID <> ?";
			}
			
			ps = conn.prepareStatement(sql);
			ps.setInt(1, departmentId);
			if (userId != null) {
				ps.setInt(2, userId);
			}
			rs = ps.executeQuery();

			if (rs.next()) {
				int count = rs.getInt("count");
				exists = count > 0;
			}

			rs.close();
			ps.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return exists;
    }
}
