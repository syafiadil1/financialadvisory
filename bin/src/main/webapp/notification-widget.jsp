<style>
	.notification-widget {
		position: fixed;
		top: 18px;
		right: 24px;
		z-index: 1040;
	}

	.notification-button {
		width: 46px;
		height: 46px;
		background-color: var(--notification-color, #0d6efd);
		border-color: var(--notification-color, #0d6efd);
	}

	.notification-button:hover,
	.notification-button:focus {
		background-color: var(--notification-color, #0d6efd);
		border-color: var(--notification-color, #0d6efd);
		opacity: 0.95;
	}

	.notification-menu {
		width: min(360px, calc(100vw - 32px));
	}

	.notification-item-icon {
		width: 34px;
		height: 34px;
		flex: 0 0 34px;
	}

	@media (max-width: 991px) {
		.notification-widget {
			top: 14px;
			right: 14px;
		}
	}

	.role-welcome-card {
		margin-right: 76px;
	}

	@media (max-width: 991px) {
		.role-welcome-card {
			margin-right: 64px;
		}
	}

	@media (max-width: 576px) {
		.role-welcome-card {
			margin-right: 0;
			width: 100%;
		}
	}
</style>

<div class="dropdown notification-widget">
	<button class="btn btn-primary notification-button rounded-circle shadow-sm position-relative"
		type="button" data-bs-toggle="dropdown" data-bs-auto-close="outside"
		aria-expanded="false" aria-label="Open important notifications">
		<i class="bi bi-bell-fill"></i>
		<span
			class="position-absolute top-0 start-100 translate-middle badge rounded-pill text-bg-danger">
			3
			<span class="visually-hidden">important notifications</span>
		</span>
	</button>

	<div class="dropdown-menu dropdown-menu-end notification-menu border-0 shadow rounded-4 p-0">
		<div class="p-3 border-bottom">
			<div class="d-flex justify-content-between align-items-center">
				<h6 class="fw-bold mb-0">Important Notifications</h6>
				<span class="badge text-bg-danger rounded-pill">3 New</span>
			</div>
		</div>

		<div class="list-group list-group-flush">
			<a href="departmentmanager-history.jsp"
				class="list-group-item list-group-item-action p-3 notification-role-item"
				data-roles="departmentmanager">
				<div class="d-flex gap-3">
					<div
						class="notification-item-icon rounded-circle bg-warning-subtle text-warning d-flex align-items-center justify-content-center">
						<i class="bi bi-hourglass-split"></i>
					</div>
					<div>
						<div class="fw-semibold">Pending transaction review</div>
						<small class="text-secondary">
							5 staff transactions are waiting for verification.
						</small>
					</div>
				</div>
			</a>

			<a href="departmentmanager-budget.jsp"
				class="list-group-item list-group-item-action p-3 notification-role-item"
				data-roles="departmentmanager">
				<div class="d-flex gap-3">
					<div
						class="notification-item-icon rounded-circle bg-danger-subtle text-danger d-flex align-items-center justify-content-center">
						<i class="bi bi-exclamation-triangle"></i>
					</div>
					<div>
						<div class="fw-semibold">Budget usage is above 60%</div>
						<small class="text-secondary">
							Review department spending before approving new expenses.
						</small>
					</div>
				</div>
			</a>

			<a href="aiadvisory.jsp?role=departmentmanager"
				class="list-group-item list-group-item-action p-3 notification-role-item"
				data-roles="departmentmanager">
				<div class="d-flex gap-3">
					<div
						class="notification-item-icon rounded-circle bg-primary-subtle text-primary d-flex align-items-center justify-content-center">
						<i class="bi bi-robot"></i>
					</div>
					<div>
						<div class="fw-semibold">AI advisory available</div>
						<small class="text-secondary">
							New cashflow insight is ready based on recent transactions.
						</small>
					</div>
				</div>
			</a>

			<a href="staff-transaction.jsp"
				class="list-group-item list-group-item-action p-3 notification-role-item"
				data-roles="staff">
				<div class="d-flex gap-3">
					<div
						class="notification-item-icon rounded-circle bg-success-subtle text-success d-flex align-items-center justify-content-center">
						<i class="bi bi-check-circle"></i>
					</div>
					<div>
						<div class="fw-semibold">Transaction approved</div>
						<small class="text-secondary">
							Your latest expense transaction has been verified.
						</small>
					</div>
				</div>
			</a>

			<a href="staff-transaction.jsp"
				class="list-group-item list-group-item-action p-3 notification-role-item"
				data-roles="staff">
				<div class="d-flex gap-3">
					<div
						class="notification-item-icon rounded-circle bg-warning-subtle text-warning d-flex align-items-center justify-content-center">
						<i class="bi bi-receipt"></i>
					</div>
					<div>
						<div class="fw-semibold">Receipt required</div>
						<small class="text-secondary">
							One transaction needs a supporting document.
						</small>
					</div>
				</div>
			</a>

			<a href="aiadvisory.jsp?role=staff"
				class="list-group-item list-group-item-action p-3 notification-role-item"
				data-roles="staff">
				<div class="d-flex gap-3">
					<div
						class="notification-item-icon rounded-circle bg-primary-subtle text-primary d-flex align-items-center justify-content-center">
						<i class="bi bi-robot"></i>
					</div>
					<div>
						<div class="fw-semibold">AI advisory available</div>
						<small class="text-secondary">
							New cashflow insight is ready based on recent transactions.
						</small>
					</div>
				</div>
			</a>

			<a href="dashboard.jsp?role=financialmanager#company-statement"
				class="list-group-item list-group-item-action p-3 notification-role-item"
				data-roles="financialmanager">
				<div class="d-flex gap-3">
					<div
						class="notification-item-icon rounded-circle bg-success-subtle text-success d-flex align-items-center justify-content-center">
						<i class="bi bi-file-earmark-text"></i>
					</div>
					<div>
						<div class="fw-semibold">Statement ready</div>
						<small class="text-secondary">
							Monthly company statement is ready for review.
						</small>
					</div>
				</div>
			</a>

			<a href="dashboard.jsp?role=financialmanager"
				class="list-group-item list-group-item-action p-3 notification-role-item"
				data-roles="financialmanager">
				<div class="d-flex gap-3">
					<div
						class="notification-item-icon rounded-circle bg-danger-subtle text-danger d-flex align-items-center justify-content-center">
						<i class="bi bi-graph-down-arrow"></i>
					</div>
					<div>
						<div class="fw-semibold">Expense increase detected</div>
						<small class="text-secondary">
							Approved expenses increased compared to last month.
						</small>
					</div>
				</div>
			</a>

			<a href="aiadvisory.jsp?role=financialmanager"
				class="list-group-item list-group-item-action p-3 notification-role-item"
				data-roles="financialmanager">
				<div class="d-flex gap-3">
					<div
						class="notification-item-icon rounded-circle bg-primary-subtle text-primary d-flex align-items-center justify-content-center">
						<i class="bi bi-robot"></i>
					</div>
					<div>
						<div class="fw-semibold">Company advisory updated</div>
						<small class="text-secondary">
							New AI recommendation is available for company performance.
						</small>
					</div>
				</div>
			</a>

			<a href="admin-user-list.jsp"
				class="list-group-item list-group-item-action p-3 notification-role-item"
				data-roles="admin">
				<div class="d-flex gap-3">
					<div
						class="notification-item-icon rounded-circle bg-danger-subtle text-danger d-flex align-items-center justify-content-center">
						<i class="bi bi-person-exclamation"></i>
					</div>
					<div>
						<div class="fw-semibold">Inactive user account</div>
						<small class="text-secondary">
							One user account requires admin review.
						</small>
					</div>
				</div>
			</a>

			<a href="admin-department-list.jsp"
				class="list-group-item list-group-item-action p-3 notification-role-item"
				data-roles="admin">
				<div class="d-flex gap-3">
					<div
						class="notification-item-icon rounded-circle bg-warning-subtle text-warning d-flex align-items-center justify-content-center">
						<i class="bi bi-building-exclamation"></i>
					</div>
					<div>
						<div class="fw-semibold">Department manager missing</div>
						<small class="text-secondary">
							A department has not been assigned to a manager yet.
						</small>
					</div>
				</div>
			</a>

			<a href="account-settings.jsp?role=admin"
				class="list-group-item list-group-item-action p-3 notification-role-item"
				data-roles="admin">
				<div class="d-flex gap-3">
					<div
						class="notification-item-icon rounded-circle bg-primary-subtle text-primary d-flex align-items-center justify-content-center">
						<i class="bi bi-shield-check"></i>
					</div>
					<div>
						<div class="fw-semibold">Security check recommended</div>
						<small class="text-secondary">
							Review your admin account settings and password.
						</small>
					</div>
				</div>
			</a>
		</div>

		<div class="p-3 border-top text-center">
			<button type="button" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
				Mark all as read
			</button>
		</div>
	</div>
</div>

<script>
	document.addEventListener("DOMContentLoaded", function () {
		const sidebar = document.querySelector("aside[style*='background-color']");
		const button = document.querySelector(".notification-button");
		const path = window.location.pathname;
<<<<<<< HEAD
		const selectedRole = new URLSearchParams(window.location.search).get("role");
		const role = selectedRole || (path.includes("departmentmanager")
=======
		const role = path.includes("departmentmanager")
>>>>>>> main
			? "departmentmanager"
			: path.includes("financialmanager")
				? "financialmanager"
				: path.includes("admin")
					? "admin"
<<<<<<< HEAD
					: "staff");
=======
					: "staff";
>>>>>>> main

		if (sidebar && button) {
			button.style.setProperty("--notification-color",
				window.getComputedStyle(sidebar).backgroundColor);
		}

		document.querySelectorAll(".notification-role-item").forEach(function (item) {
			if (!item.dataset.roles.split(" ").includes(role)) {
				item.remove();
			}
		});
	});
</script>
