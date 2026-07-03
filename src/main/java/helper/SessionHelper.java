package helper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.UserModel;

public class SessionHelper {
	public static UserModel getCurrentUser(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session != null) {
			return (UserModel) session.getAttribute("user");
		}
		return null;
	}
	
	public static boolean isUserLoggedIn(HttpServletRequest request) {
		return getCurrentUser(request) != null;
	}
	
	
	// no need to use, redudant with isUserAdmin in RoleHelper
	public static boolean isUserAdmin(HttpServletRequest request) {
		UserModel user = getCurrentUser(request);
		return user != null && user.getRoleId() == 1; // Assuming roleId 1 is for admin
	}
}