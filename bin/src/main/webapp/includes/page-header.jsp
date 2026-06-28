<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String pageTitle = request.getParameter("pageTitle");
	String pageSubtitle = request.getParameter("pageSubtitle");
	String pageRoleName = request.getParameter("pageRoleName");
%>
<div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
	<div>
		<h1 class="fw-bold mb-1"><%= pageTitle %></h1>
		<p class="text-secondary mb-0"><%= pageSubtitle %></p>
	</div>
	<div class="card border-0 shadow-sm rounded-4 mt-3 mt-md-0 role-welcome-card">
		<div class="card-body py-2 px-3">
			<span class="text-secondary">Welcome, </span>
			<strong><%= pageRoleName %></strong>
		</div>
	</div>
</div>
