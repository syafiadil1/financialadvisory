<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dao.ChatHistoryDAO" %>
<%@ page import="dao.ChatSessionDAO" %>
<%@ page import="dao.FinancialContextDAO" %>
<%@ page import="helper.RoleHelper" %>
<%@ page import="helper.SessionHelper" %>
<%@ page import="model.ChatHistoryModel" %>
<%@ page import="model.ChatSessionModel" %>
<%@ page import="model.FinancialContextModel" %>
<%@ page import="model.UserModel" %>
<%!
	private String escapeHtml(String value) {
		if (value == null) {
			return "";
		}
		return value.replace("&", "&amp;")
				.replace("<", "&lt;")
				.replace(">", "&gt;")
				.replace("\"", "&quot;")
				.replace("'", "&#39;");
	}

	private String formatMessage(String value) {
		return escapeHtml(value).replace("\r\n", "\n").replace("\n", "<br>");
	}

	private Integer parseInteger(String value) {
		try {
			return value == null || value.trim().isEmpty() ? null : Integer.parseInt(value.trim());
		} catch (NumberFormatException e) {
			return null;
		}
	}

	private String formatDate(java.util.Date date) {
		if (date == null) {
			return "";
		}
		return new SimpleDateFormat("dd MMM").format(date);
	}

	private String formatAmount(double amount) {
		return String.format("%,.2f", amount);
	}
%>
<%
	UserModel currentUser = SessionHelper.getCurrentUser(request);

	String role = null;
	if (currentUser != null && RoleHelper.isFinancialManager(currentUser)) {
		role = "financialmanager";
	} else if (currentUser != null && RoleHelper.isDepartmentManager(currentUser)) {
		role = "departmentmanager";
	} else if (currentUser != null && RoleHelper.isStaff(currentUser)) {
		role = "staff";
	}

	if (role == null || role.trim().isEmpty()) {
		role = "staff";
	}

	String roleName = "Staff";
	if ("departmentmanager".equals(role)) {
		roleName = "Department Manager";
	} else if ("financialmanager".equals(role)) {
		roleName = "Financial Manager";
	} else {
		role = "staff";
	}

	ChatSessionDAO chatSessionDAO = new ChatSessionDAO();
	ChatHistoryDAO chatHistoryDAO = new ChatHistoryDAO();
	ArrayList<ChatSessionModel> chatSessions = new ArrayList<>();
	ArrayList<ChatHistoryModel> chatMessages = new ArrayList<>();
	ChatSessionModel selectedSession = null;
	Integer selectedChatId = parseInteger(request.getParameter("chatId"));

	if (currentUser != null) {
		chatSessions = chatSessionDAO.getSessionsByUserId(currentUser.getUserId());

		if (selectedChatId != null) {
			selectedSession = chatSessionDAO.getSessionByIdAndUserId(selectedChatId, currentUser.getUserId());
			if (selectedSession != null) {
				chatMessages = chatHistoryDAO.getMessagesByChatId(selectedChatId);
			}
		}
	}

	FinancialContextModel financialContext = new FinancialContextDAO().getFinancialContext(currentUser);
	boolean positivePosition = financialContext.getNetTotal() >= 0;
	String chatError = request.getParameter("chatError");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<jsp:include page="/includes/common-head.jsp" />
</head>

<body class="bg-light">
	<div class="container-fluid">
		<div class="row min-vh-100">
			<jsp:include page="/includes/sidebar.jsp">
				<jsp:param name="sidebarRole" value="<%= role %>" />
				<jsp:param name="activeMenu" value="advisory" />
			</jsp:include>

			<main class="col-12 col-lg-10 p-4">
				<jsp:include page="/includes/page-header.jsp">
					<jsp:param name="pageTitle" value="AI Advisory Module" />
					<jsp:param name="pageSubtitle" value="Chatbot-based financial suggestions using the latest approved financial data." />
					<jsp:param name="pageRoleName" value="<%= roleName %>" />
				</jsp:include>

				<% if (chatError != null && !chatError.trim().isEmpty()) { %>
					<div class="alert alert-warning rounded-4">
						<%= escapeHtml(chatError) %>
					</div>
				<% } %>

				<section class="row g-4 mb-4">
					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Transactions</p>
								<h3 class="fw-bold mb-0"><%= financialContext.getTransactionCount() %></h3>
								<small class="text-secondary"><%= escapeHtml(financialContext.getScopeDescription()) %></small>
							</div>
						</div>
					</div>
					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Income</p>
								<h3 class="fw-bold text-success mb-0">RM <%= formatAmount(financialContext.getIncomeTotal()) %></h3>
								<small class="text-secondary">Recorded income total</small>
							</div>
						</div>
					</div>
					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Expenses</p>
								<h3 class="fw-bold text-danger mb-0">RM <%= formatAmount(financialContext.getExpenseTotal()) %></h3>
								<small class="text-secondary">Recorded expense total</small>
							</div>
						</div>
					</div>
					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Net Position</p>
								<h3 class="fw-bold <%= positivePosition ? "text-success" : "text-danger" %> mb-0">RM <%= formatAmount(financialContext.getNetTotal()) %></h3>
								<small class="text-secondary"><%= positivePosition ? "Income exceeds expenses" : "Expenses exceed income" %></small>
							</div>
						</div>
					</div>
				</section>

				<section class="card border-0 shadow-sm rounded-4 mb-4">
					<div class="card-body p-4">
						<div class="d-flex justify-content-between align-items-center mb-3">
							<h5 class="fw-bold mb-0">
								<i class="bi bi-shield-check me-2"></i> Current Financial Snapshot
							</h5>
						</div>

						<div class="alert <%= positivePosition ? "alert-success" : "alert-danger" %> rounded-4 mb-3">
							<h6 class="fw-bold mb-2">Financial Status: <%= positivePosition ? "Positive" : "Attention Required" %></h6>
							<p class="mb-0">
								The current net position is RM <%= formatAmount(financialContext.getNetTotal()) %>
								for <%= escapeHtml(financialContext.getScopeDescription()) %>.
							</p>
						</div>

						<div class="alert alert-primary rounded-4 mb-0">
							<h6 class="fw-bold mb-2">Budget Context</h6>
							<p class="mb-0"><%= escapeHtml(financialContext.getBudgetSummary()) %></p>
						</div>
					</div>
				</section>

				<section class="card border-0 shadow-sm rounded-4 overflow-hidden">
					<div class="row g-0">
						<div class="col-lg-4 border-end bg-white">
							<div class="p-4 h-100">
								<div class="d-flex justify-content-between align-items-center mb-3">
									<h5 class="fw-bold mb-0">
										<i class="bi bi-chat-left-text me-2"></i> Previous Chats
									</h5>
									<a class="btn btn-sm btn-primary rounded-pill" href="aiadvisory.jsp?role=<%= role %>">
										<i class="bi bi-plus-lg me-1"></i>New
									</a>
								</div>

								<div class="list-group list-group-flush border rounded-3 overflow-hidden">
									<% if (chatSessions.isEmpty()) { %>
										<div class="list-group-item text-secondary small">
											No saved advisory chats yet.
										</div>
									<% } %>

									<% for (ChatSessionModel chatSession : chatSessions) {
										boolean active = selectedChatId != null && selectedChatId.equals(chatSession.getChatId());
									%>
										<a href="aiadvisory.jsp?role=<%= role %>&chatId=<%= chatSession.getChatId() %>"
											class="list-group-item list-group-item-action <%= active ? "active" : "" %>">
											<div class="d-flex w-100 justify-content-between gap-3">
												<strong><%= escapeHtml(chatSession.getName()) %></strong>
												<small><%= formatDate(chatSession.getDateUpdated() != null ? chatSession.getDateUpdated() : chatSession.getDateStart()) %></small>
											</div>
											<small><%= active ? "Open conversation" : "Reload previous conversation" %></small>
										</a>
									<% } %>
								</div>
							</div>
						</div>

						<div class="col-lg-8 bg-white">
							<div class="p-4 h-100">
								<div class="d-flex justify-content-between align-items-center mb-3">
									<h5 class="fw-bold mb-0">
										<i class="bi bi-robot me-2"></i>
										<%= selectedSession == null ? "New Advisory Chat" : escapeHtml(selectedSession.getName()) %>
									</h5>
								</div>

								<div class="d-flex flex-wrap gap-2 mb-3">
									<%
										String[] promptLabels = {
											"What should I focus on this month?",
											"Summarize department spending risks.",
											"Which statuses need follow-up?",
											"Recommend actions to improve cashflow."
										};
										for (String promptLabel : promptLabels) {
									%>
										<form action="<%= request.getContextPath() %>/sendPrompt" method="post" class="ai-prompt-bubble-form">
											<input type="hidden" name="action" value="send">
											<input type="hidden" name="role" value="<%= role %>">
											<% if (selectedChatId != null) { %>
												<input type="hidden" name="chatId" value="<%= selectedChatId %>">
											<% } %>
											<input type="hidden" name="prompt" value="<%= escapeHtml(promptLabel) %>">
											<button type="submit" class="btn btn-outline-primary btn-sm rounded-pill">
												<%= escapeHtml(promptLabel) %>
											</button>
										</form>
									<% } %>
								</div>

								<div class="bg-light rounded-4 p-3 mb-3 overflow-auto" id="advisoryChatMessages" style="min-height: 360px; max-height: 560px;">
									<% if (chatMessages.isEmpty()) { %>
										<div class="d-flex mb-3">
											<div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2 flex-shrink-0"
												style="width: 35px; height: 35px;">
												<i class="bi bi-robot"></i>
											</div>
											<div class="bg-white border rounded-4 p-3 shadow-sm">
												<p class="mb-0">
													Hi! Ask me for financial advice based on the latest transaction summaries.
												</p>
											</div>
										</div>
									<% } %>

									<% for (ChatHistoryModel message : chatMessages) {
										boolean isUserMessage = message.isPromptOrResponse();
									%>
										<% if (isUserMessage) { %>
											<div class="d-flex justify-content-end mb-3">
												<div class="bg-primary text-white rounded-4 p-3 shadow-sm" style="max-width: 78%;">
													<p class="mb-0"><%= formatMessage(message.getContent()) %></p>
												</div>
											</div>
										<% } else { %>
											<div class="d-flex mb-3">
												<div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2 flex-shrink-0"
													style="width: 35px; height: 35px;">
													<i class="bi bi-robot"></i>
												</div>
												<div class="bg-white border rounded-4 p-3 shadow-sm" style="max-width: 78%;">
													<p class="mb-0"><%= formatMessage(message.getContent()) %></p>
												</div>
											</div>
										<% } %>
									<% } %>
								</div>

								<form action="<%= request.getContextPath() %>/sendPrompt" method="post">
									<input type="hidden" name="action" value="send">
									<input type="hidden" name="role" value="<%= role %>">
									<% if (selectedChatId != null) { %>
										<input type="hidden" name="chatId" value="<%= selectedChatId %>">
									<% } %>
									<div class="input-group">
										<input type="text" class="form-control rounded-start-pill"
											name="prompt" maxlength="1200" autocomplete="off"
											placeholder="Ask AI for financial suggestion...">
										<button class="btn btn-primary rounded-end-pill px-4" type="submit">
											<i class="bi bi-send me-2"></i> Send
										</button>
									</div>
								</form>
							</div>
						</div>
					</div>
				</section>
			</main>
		</div>
	</div>
	<script>
		(function () {
			var messages = document.getElementById("advisoryChatMessages");
			if (messages) {
				messages.scrollTop = messages.scrollHeight;
			}
		}());
	</script>
<jsp:include page="/includes/common-scripts.jsp" />
</body>
</html>
