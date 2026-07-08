import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import connection.DBConnection;
import util.Encryption;

public class HashExistingPassword {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		try {
			Connection conn = DBConnection.getConnection();
			String sql = "SELECT userid, password FROM users WHERE SALT IS NULL OR SALT = ''";
			
			ResultSet rs = conn.createStatement().executeQuery(sql);
			
			while (rs.next()) {
				int id = rs.getInt("userid");
				String password = rs.getString("password");
				
				// Generate a new salt
				byte[] salt = Encryption.generateSalt();
				
				// Hash the existing password with the new salt
				String hashedPassword = Encryption.hashPassword(password, salt);
				
				// Update the user record with the new hashed password and salt
				String updateSql = "UPDATE users SET password = ?, SALT = ? WHERE userid = ?";
				var pstmt = conn.prepareStatement(updateSql);
				pstmt.setString(1, hashedPassword);
				pstmt.setString(2, Encryption.bytesToHex(salt));
				pstmt.setInt(3, id);
				
				int rowsUpdated = pstmt.executeUpdate();
				
				if (rowsUpdated > 0) {
					System.out.println("Updated user ID " + id + " with new hashed password and salt.");
				} else {
					System.out.println("Failed to update user ID " + id);
				}
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
