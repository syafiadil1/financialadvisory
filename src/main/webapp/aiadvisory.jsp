<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>


<c:if test="${empty advisoryViewReady}">
	<c:redirect url="/AIAdvisoryController">
		<c:param name="role" value="${param.role}" />
		<c:param name="chatId" value="${param.chatId}" />
	</c:redirect>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
<jsp:include page="/includes/common-head.jsp" />
</head>

<body class="bg-light">
	<div class="container-fluid">
		<div class="row min-vh-100">
			<jsp:include page="/includes/sidebar.jsp">
				<jsp:param name="sidebarRole" value="${role}" />
				<jsp:param name="activeMenu" value="advisory" />
			</jsp:include>

			<main class="col-12 col-lg-10 p-4">
				<jsp:include page="/includes/page-header.jsp">
					<jsp:param name="pageTitle" value="AI Advisory Module" />
					<jsp:param name="pageSubtitle" value="Chatbot-based financial suggestions using the latest approved financial data." />
					<jsp:param name="pageRoleName" value="${roleName}" />
				</jsp:include>

				<c:if test="${not empty chatError}">
					<div class="alert alert-warning rounded-4">
						<c:out value="${chatError}" />
					</div>
				</c:if>

				<section class="row g-4 mb-4">
					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Transactions</p>
								<h3 class="fw-bold mb-0"><c:out value="${financialContext.transactionCount}" /></h3>
								<small class="text-secondary"><c:out value="${financialContext.scopeDescription}" /></small>
							</div>
						</div>
					</div>
					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Income</p>
								<h3 class="fw-bold text-success mb-0">
									RM <fmt:formatNumber value="${financialContext.incomeTotal}" pattern="#,##0.00" />
								</h3>
								<small class="text-secondary">Recorded income total</small>
							</div>
						</div>
					</div>
					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Expenses</p>
								<h3 class="fw-bold text-danger mb-0">
									RM <fmt:formatNumber value="${financialContext.expenseTotal}" pattern="#,##0.00" />
								</h3>
								<small class="text-secondary">Recorded expense total</small>
							</div>
						</div>
					</div>
					<div class="col-md-6 col-xl-3">
						<div class="card border-0 shadow-sm rounded-4 h-100">
							<div class="card-body p-4">
								<p class="text-secondary mb-1">Net Position</p>
								<h3 class="fw-bold ${positivePosition ? 'text-success' : 'text-danger'} mb-0">
									RM <fmt:formatNumber value="${financialContext.netTotal}" pattern="#,##0.00" />
								</h3>
								<small class="text-secondary">${positivePosition ? 'Income exceeds expenses' : 'Expenses exceed income'}</small>
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

						<div class="alert ${positivePosition ? 'alert-success' : 'alert-danger'} rounded-4 mb-3">
							<h6 class="fw-bold mb-2">Financial Status: ${positivePosition ? 'Positive' : 'Attention Required'}</h6>
							<p class="mb-0">
								The current net position is RM
								<fmt:formatNumber value="${financialContext.netTotal}" pattern="#,##0.00" />
								for <c:out value="${financialContext.scopeDescription}" />.
							</p>
						</div>

						<div class="alert alert-primary rounded-4 mb-0">
							<h6 class="fw-bold mb-2">Budget Context</h6>
							<p class="mb-0"><c:out value="${financialContext.budgetSummary}" /></p>
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
									<a class="btn btn-sm btn-primary rounded-pill" href="${pageContext.request.contextPath}/AIAdvisoryController?role=${role}">
										<i class="bi bi-plus-lg me-1"></i>New
									</a>
								</div>

								<div class="list-group list-group-flush border rounded-3 overflow-hidden">
									<c:if test="${empty chatSessions}">
										<div class="list-group-item text-secondary small">
											No saved advisory chats yet.
										</div>
									</c:if>

									<c:forEach var="chatSession" items="${chatSessions}">
										<c:set var="activeChat" value="${selectedChatId == chatSession.chatId}" />
										<a href="${pageContext.request.contextPath}/AIAdvisoryController?role=${role}&chatId=${chatSession.chatId}"
											class="list-group-item list-group-item-action ${activeChat ? 'active' : ''}">
											<div class="d-flex w-100 justify-content-between gap-3">
												<strong><c:out value="${chatSession.name}" /></strong>
												<small>
													<fmt:formatDate value="${empty chatSession.dateUpdated ? chatSession.dateStart : chatSession.dateUpdated}" pattern="dd MMM" />
												</small>
											</div>
											<small>${activeChat ? 'Open conversation' : 'Reload previous conversation'}</small>
										</a>
									</c:forEach>
								</div>
							</div>
						</div>

						<div class="col-lg-8 bg-white">
							<div class="p-4 h-100">
								<div class="d-flex justify-content-between align-items-center mb-3">
									<h5 class="fw-bold mb-0">
										<i class="bi bi-robot me-2"></i>
										<c:choose>
											<c:when test="${empty selectedSession}">New Advisory Chat</c:when>
											<c:otherwise><c:out value="${selectedSession.name}" /></c:otherwise>
										</c:choose>
									</h5>
								</div>

								<div class="d-flex flex-wrap gap-2 mb-3">
									<c:forEach var="promptLabel" items="${predefinedPrompts}">
										<form action="${pageContext.request.contextPath}/AIAdvisoryController" method="post" class="ai-prompt-bubble-form">
											<input type="hidden" name="action" value="send">
											<input type="hidden" name="role" value="${role}">
											<c:if test="${not empty selectedChatId}">
												<input type="hidden" name="chatId" value="${selectedChatId}">
											</c:if>
											<input type="hidden" name="prompt" value="${promptLabel}">
											<button type="submit" class="btn btn-outline-primary btn-sm rounded-pill">
												<c:out value="${promptLabel}" />
											</button>
										</form>
									</c:forEach>
								</div>

								<div class="bg-light rounded-4 p-3 mb-3 overflow-auto" id="advisoryChatMessages" style="min-height: 360px; max-height: 560px;">
									<c:if test="${empty chatMessages}">
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
									</c:if>

									<c:forEach var="message" items="${chatMessages}">
										<c:choose>
											<c:when test="${message.promptOrResponse}">
												<div class="d-flex justify-content-end mb-3">
													<div class="bg-primary text-white rounded-4 p-3 shadow-sm" style="max-width: 78%; white-space: pre-wrap;"><c:out value="${message.content}" /></div>
												</div>
											</c:when>
											<c:otherwise>
												<div class="d-flex mb-3">
													<div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2 flex-shrink-0"
														style="width: 35px; height: 35px;">
														<i class="bi bi-robot"></i>
													</div>
													<div class="bg-white border rounded-4 p-3 shadow-sm" style="max-width: 78%; white-space: pre-wrap;"><c:out value="${message.content}" /></div>
												</div>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</div>

								<form action="${pageContext.request.contextPath}/AIAdvisoryController" method="post">
									<input type="hidden" name="action" value="send">
									<input type="hidden" name="role" value="${role}">
									<c:if test="${not empty selectedChatId}">
										<input type="hidden" name="chatId" value="${selectedChatId}">
									</c:if>
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
