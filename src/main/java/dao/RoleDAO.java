package dao;

import connection.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.RoleModel;
import model.UserModel;
import util.ErrorUtil;
import connection.DBConnection;

public class RoleDAO {
	private static Connection conn = null;
	private static PreparedStatement ps = null;
	private static ResultSet rs = null;
	private static String sql = null;
	
	public static List<RoleModel> getAllRoles() throws SQLException{
		
        List<RoleModel> list = new ArrayList<RoleModel>();

        try {
        	
        	conn = DBConnection.getConnection();
        	sql = "SELECT roleid, name FROM role";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
            	RoleModel r = new RoleModel();
                r.setRoleId(rs.getInt("roleid"));
                r.setName(rs.getString("name"));
                r.setDescription(rs.getString("description"));
                list.add(r);
            }

        } catch(Exception e) {
            ErrorUtil.log("RoleDAO.java", "getAllRoles", e);
        }

        return list;
    }
	
    public static RoleModel getRoleById(int id) throws SQLException {
    	
    	RoleModel r = null;
    	try {
    		conn = DBConnection.getConnection();
    		sql = "SELECT * FROM ROLE WHERE roleId = ?";
    		ps = conn.prepareStatement(sql);
    		ps.setInt(1, id);
    		rs = ps.executeQuery();
    		
    		if(rs.next()) {
    			r = new RoleModel();
                r.setRoleId(rs.getInt("ROLEID"));
                r.setName(rs.getString("NAME"));
                r.setDescription(rs.getString("DESCRIPTION"));
    		}
    		
    		ps.close();
    		rs.close();
    		 
    	} catch(SQLException e) {
            e.printStackTrace();
        }
    	
    	return r;
    }

}
