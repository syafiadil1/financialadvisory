import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import model.UserModel;
import util.ErrorUtil;

import java.io.IOException;

import helper.RoleHelper;
import helper.SessionHelper;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String contextPath = req.getContextPath();
        String url = req.getRequestURI().substring(contextPath.length());

        HttpSession session = req.getSession(false);

        // PUBLIC PAGES
        // User can access without the need to login first
        if (url.startsWith("/login.jsp") ||
            url.startsWith("/index.jsp") ||
            url.startsWith("/admin/admin-user-details.jsp") ||
            url.startsWith("/LoginController") || // allow it because the LoginController need to process the info first, still consider as user == null
            url.startsWith("/css/") ||
            url.startsWith("/js/") ||
            url.startsWith("/images/") ||
            url.startsWith("/bootstrap/")) {

            chain.doFilter(request, response);
            return; // is needed because the same request is still running inside the filter, even though a redirect has already been sent to the browser.
        }

     // LOGIN CHECK
        if (!SessionHelper.isUserLoggedIn(req)) {
            res.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        UserModel user = SessionHelper.getCurrentUser(req);

        // ROLE PROTECTION
        
        // SYSTEM ADMIN ONLY PAGES
        if (url.contains("/admin/") && !RoleHelper.isAdmin(user)) {

            session.setAttribute("error", ErrorUtil.format("AuthFilter.java", "doFilter", "Access denied"));

            res.sendRedirect(contextPath + "/admin/admin-user-list.jsp");
            return;
        }

            //res.sendRedirect(contextPath + "/admin/admin-user-list.jsp");
            //return;
        //}

        // FINANCIAL MANAGER ONLY PAGES
        if (url.contains("financialmanager-") && !RoleHelper.isFinancialManager(user)) {

            session.setAttribute("error", "Access denied");
            
            res.sendRedirect(contextPath + "/DashboardController?action=userInfo");
            return;
        }

        // DEPARTMENT MANAGER ONLY PAGES
        if (url.contains("/department/") && !RoleHelper.isDepartmentManager(user)) {

            session.setAttribute("error", ErrorUtil.format("AuthFilter.java", "doFilter", "Access denied"));

            res.sendRedirect(contextPath + "/DashboardController?action=userInfo");
            return;
        }

        // STAFF ONLY PAGES
        if (url.contains("staff-") && !RoleHelper.isStaff(user)) {

            session.setAttribute("error", ErrorUtil.format("AuthFilter.java", "doFilter", "Access denied"));

            res.sendRedirect(contextPath + "/DashboardController?action=userInfo");
            return;
        }

        // ALLOW ACCESS
        chain.doFilter(request, response);
    }
}
