<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div id="actionAlertContainer">
	<c:set var="actionAlertMessage" value="${not empty requestScope.flashMessage ? requestScope.flashMessage : sessionScope.flashMessage}" />
	<c:set var="actionAlertType" value="${not empty requestScope.flashType ? requestScope.flashType : sessionScope.flashType}" />
	<c:if test="${not empty actionAlertMessage}">
		<div class="alert alert-${empty actionAlertType ? 'info' : actionAlertType} alert-dismissible fade show shadow-sm rounded-4"
			role="alert">
			<c:choose>
				<c:when test="${actionAlertType == 'success'}">
					<i class="bi bi-check-circle me-2"></i>
				</c:when>
				<c:when test="${actionAlertType == 'danger'}">
					<i class="bi bi-exclamation-triangle me-2"></i>
				</c:when>
				<c:otherwise>
					<i class="bi bi-info-circle me-2"></i>
				</c:otherwise>
			</c:choose>
			<c:out value="${actionAlertMessage}" />
			<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
		</div>
		<c:remove var="flashMessage" scope="session" />
		<c:remove var="flashType" scope="session" />
	</c:if>
</div>

<script>
	window.showActionAlert = function (type, message) {
		const container = document.getElementById("actionAlertContainer");
		if (!container || !message) {
			return;
		}

		const safeType = ["success", "danger", "warning", "info"].includes(type) ? type : "info";
		const icon = safeType === "success" ? "bi-check-circle"
			: safeType === "danger" ? "bi-exclamation-triangle"
				: "bi-info-circle";

		const alert = document.createElement("div");
		alert.className = `alert alert-${safeType} alert-dismissible fade show shadow-sm rounded-4`;
		alert.setAttribute("role", "alert");
		alert.innerHTML = `
			<i class="bi ${icon} me-2"></i>
			<span></span>
			<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>`;
		alert.querySelector("span").textContent = message;
		container.replaceChildren(alert);

		window.setTimeout(() => {
			if (window.bootstrap && bootstrap.Alert) {
				bootstrap.Alert.getOrCreateInstance(alert).close();
			} else {
				alert.remove();
			}
		}, 4500);
	};
</script>
