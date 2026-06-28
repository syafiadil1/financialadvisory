<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<<<<<<< HEAD
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>User List (Frontend Demo)</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">
	<div class="container py-5">
		<div class="d-flex justify-content-between align-items-center mb-4">
			<div>
				<h1 class="h3 fw-bold mb-1">User List</h1>
				<p class="text-secondary mb-0">Static frontend demo data.</p>
			</div>
			<a class="btn btn-outline-secondary rounded-pill" href="../admin-user-list.jsp">Back</a>
		</div>
		<div class="card border-0 shadow-sm rounded-4">
			<div class="table-responsive">
				<table class="table table-hover align-middle mb-0">
					<thead>
						<tr>
							<th>User</th>
							<th>Email</th>
							<th>Role</th>
							<th>Department</th>
							<th>Status</th>
							<th class="text-center">Action</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><strong>Siti Aminah</strong></td>
							<td>siti@example.com</td>
							<td><span class="badge text-bg-secondary">Staff</span></td>
							<td>Operations</td>
							<td><span class="badge text-bg-success">Active</span></td>
							<td class="text-center">
								<a class="btn btn-sm btn-outline-primary rounded-pill" href="../admin-user-details.jsp?action=edit&id=siti">
									<i class="bi bi-pencil-square me-1"></i>Edit
								</a>
							</td>
						</tr>
						<tr>
							<td><strong>Sarah Ahmad</strong></td>
							<td>sarah@example.com</td>
							<td><span class="badge text-bg-warning">Department Manager</span></td>
							<td>Sales</td>
							<td><span class="badge text-bg-success">Active</span></td>
							<td class="text-center">
								<a class="btn btn-sm btn-outline-primary rounded-pill" href="../admin-user-details.jsp?action=edit&id=sarah">
									<i class="bi bi-pencil-square me-1"></i>Edit
								</a>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
=======
<%@ page import="java.sql.*" %>
<%@ page import="connection.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User List (helper)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<div class="container mt-5">
		<div class="table-responsive">
	    <table class="table table-hover align-middle mb-0">
	        <thead>
	        <tr>
	            <th>User</th>
	            <th>Email</th>
	            <th>Role</th>
	            <th>Department</th>
	            <th>Status</th>
	            <th class="text-center">Action</th>
	        </tr>
	        </thead>
	        <tbody>
	        <%
	            Connection conn = null;
	            PreparedStatement ps = null;
	            ResultSet rs = null;
	            
	            try {
	                conn = DBConnection.getConnection();
	          
	                // NOTE: adjust column names / table name to match your schema.
	                String sql = "SELECT UserId, email, name, departmentid, roleid FROM users";
	                ps = conn.prepareStatement(sql);
	                rs = ps.executeQuery();
	                while (rs.next()) {
	                    int id = rs.getInt(1);
	                    String email = rs.getString(2);
	                    String name = rs.getString(3);
	                    String dept = rs.getString(4); // You may need to join with department table to get name
	                    String role = rs.getString(5); // You may need to join with role table
	                    String status = "Active"; // You may need to get this from DB as well
	        %>
	        <tr>
	            <td><strong><%= name %></strong></td>
	            <td><%= email %></td>
	            <td><span class="badge bg-secondary"><%= role %></span></td>
	            <td><%= (dept == null ? "-" : dept) %></td>
	            <td><span class="badge <%= ("active".equalsIgnoreCase(status) ? "bg-success" : "bg-secondary") %>"><%= status %></span></td>
	            <td class="text-center">
	                <a class="btn btn-sm btn-outline-primary rounded-pill" href="admin-user-details.jsp?action=edit&id=<%= id %>"><i class="bi bi-pencil-square"></i>Edit</a>
	                &nbsp;
	                <!-- Developer-only: login as this user. The servlet will verify remote address (localhost) before impersonating -->
	                <a class="btn btn-sm btn-danger rounded-pill" href="<%= request.getContextPath() %>/loginAsUser?id=<%= id %>&role=<%= (role == null ? "1" : role.toLowerCase()) %>">Login as</a>
	            </td>
	        </tr>
	        <%
	                }
	            } catch (Exception e) {
	                // If DB access fails, show example rows so page is still usable
	        %>
	        <tr>
	            <td><strong>Example User</strong></td>
	            <td>example@example.com</td>
	            <td><span class="badge bg-primary">Staff</span></td>
	            <td>Finance</td>
	            <td><span class="badge bg-success">Active</span></td>
	            <td class="text-center">
	                <span class="text-secondary">Unavailable (DB error)</span>
	            </td>
	        </tr>
	        <%
	                out.println("<!-- DB error: " + e.getMessage() + " -->");
	            } finally {
	                try { if (rs != null) rs.close(); } catch (Exception ignored) {}
	                try { if (ps != null) ps.close(); } catch (Exception ignored) {}
	                try { if (conn != null) conn.close(); } catch (Exception ignored) {}
	            }
	        %>
	        </tbody>
	    </table>
		</div>
		
	</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
>>>>>>> main
