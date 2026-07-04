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

            String sql = "SELECT * FROM users WHERE USERID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                u = new UserModel();
                u.setUserId(rs.getInt("USERID"));
                u.setName(rs.getString("NAME"));
                u.setPassword(rs.getString("PASSWORD"));
                u.setEmail(rs.getString("EMAIL"));
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

            String sql = "SELECT * FROM users WHERE ROLEID <> 1";
            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UserModel u = new UserModel();
                u.setUserId(rs.getInt("USERID"));
                u.setName(rs.getString("NAME"));
                u.setEmail(rs.getString("EMAIL"));
                u.setRoleId(rs.getInt("ROLEID"));
                u.setDepartmentId(rs.getInt("DEPARTMENTID"));
                

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

            sql = "SELECT USERID, NAME, EMAIL, PASSWORD, ROLEID, DEPARTMENTID "
                + "FROM USERS WHERE ROLEID<> 1";

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql += " AND (LOWER(NAME) LIKE ? OR LOWER(EMAIL) LIKE ?)";
            }

            if (roleId != null) {
                sql += " AND ROLEID = ?";
            }

            if (departmentId != null) {
                sql += " AND DEPARTMENTID = ?";
            }

            sql += " ORDER BY USERID";

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
                user.setName(rs.getString("NAME"));
                user.setEmail(rs.getString("EMAIL"));
                user.setPassword(rs.getString("PASSWORD"));
                user.setRoleId(rs.getInt("ROLEID"));
                user.setDepartmentId(rs.getInt("DEPARTMENTID"));

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
    public static void addUser(UserModel data) throws SQLException{
    	try {
    		conn = DBConnection.getConnection();
    		sql = "INSERT INTO USERS (NAME, EMAIL, PASSWORD, ROLEID, DEPARTMENTID) VALUES (?, ?, ?, ?, ?)";
    		
    		ps = conn.prepareStatement(sql);
    	    ps.setString(1, data.getName());
    	    ps.setString(2, data.getEmail());
    	    ps.setString(3, data.getPassword());
    	    ps.setInt(4, data.getRoleId());
    	    ps.setInt(5, data.getDepartmentId());
    	    
    	    rs = ps.executeQuery();
    	    
    	    rs.close();
    	    ps.close();   
    	    
    	}catch (SQLException e) {
    		e.printStackTrace();
    	}
    }

    // update a user
    public static void updateUser(UserModel data) throws SQLException{
    	try {
    		conn = DBConnection.getConnection();
    		sql = "UPDATE USERS SET NAME = ?, EMAIL = ?, PASSWORD = ?, ROLEID = ?, DEPARTMENTID = ? WHERE USERID = ?";
    		ps = conn.prepareStatement(sql);
    	    ps.setString(1, data.getName());
    	    ps.setString(2, data.getEmail());
    	    ps.setString(3, data.getPassword());
    	    ps.setInt(4, data.getRoleId());
    	    if (data.getDepartmentId() == 0) {
    	        ps.setNull(5, java.sql.Types.INTEGER);
    	    } else {
    	        ps.setInt(5, data.getDepartmentId());
    	    }
    	    //ps.setInt(5, data.getDepartmentId());
    	    ps.setInt(6, data.getUserId());
    		
    	    rs = ps.executeQuery();
    	    
    	    rs.close();
    	    ps.close();
    	    
    	}catch (SQLException e) {
    		e.printStackTrace();
    	}
    }
    
    // delete a user
    public static void deleteUser(int id) throws SQLException{
        try {
            conn = DBConnection.getConnection();

            sql = "DELETE FROM USERS WHERE USERID = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            
            
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
