<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="activeMenu" value="${param.activeMenu}" />
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:choose>
    <c:when test="${sessionScope.user.roleId == 1}">
        <c:set var="sidebarTitle" value="System Admin" />
        <c:set var="sidebarIcon" value="bi-shield-lock" />
        <c:set var="sidebarColor" value="#950606" />
        <c:set var="sidebarActiveColor" value="#ff2c2c" />
    </c:when>

    <c:when test="${sessionScope.user.roleId == 2}">
        <c:set var="sidebarTitle" value="Financial Manager" />
        <c:set var="sidebarIcon" value="bi-briefcase" />
        <c:set var="sidebarColor" value="#0F766E" />
        <c:set var="sidebarActiveColor" value="#198754" />
    </c:when>

    <c:when test="${sessionScope.user.roleId == 3}">
        <c:set var="sidebarTitle" value="Department Manager" />
        <c:set var="sidebarIcon" value="bi-person-badge" />
        <c:set var="sidebarColor" value="#4338CA" />
        <c:set var="sidebarActiveColor" value="#312E81" />
    </c:when>

    <c:otherwise>
        <c:set var="sidebarTitle" value="Financial Advisory" />
        <c:set var="sidebarIcon" value="bi-wallet2" />
        <c:set var="sidebarColor" value="#0D6EFD" />
        <c:set var="sidebarActiveColor" value="#084298" />
    </c:otherwise>
</c:choose>
<style>
@media (min-width: 992px) {
    .sidebar-fixed {
        position: sticky;
        top: 0;
        height: 100vh;
        overflow-y: auto;
    }
}
</style>
<aside class="col-12 col-lg-2 text-white p-4 sidebar-fixed" style="background-color: ${sidebarColor};">
    <h4 class="fw-bold mb-4">
        <i class="bi ${sidebarIcon} me-2"></i> ${sidebarTitle}
    </h4>

    <div class="nav flex-column nav-pills gap-2">

        <c:if test="${sessionScope.user.roleId == 1}">
            <a class="nav-link text-white rounded-3 ${activeMenu == 'users' ? 'active' : ''}"
               style="${activeMenu == 'users' ? 'background-color: '.concat(sidebarActiveColor).concat(';') : ''}"
               href="${contextPath}/UserController?action=list">
                <i class="bi bi-people me-2"></i> User List
            </a>

            <a class="nav-link text-white rounded-3 ${activeMenu == 'departments' ? 'active' : ''}"
               style="${activeMenu == 'departments' ? 'background-color: '.concat(sidebarActiveColor).concat(';') : ''}"
               href="${contextPath}/DepartmentController?action=list">
                <i class="bi bi-building me-2"></i> Department List
            </a>

            <a class="nav-link text-white rounded-3 ${activeMenu == 'settings' ? 'active' : ''}"
               style="${activeMenu == 'settings' ? 'background-color: '.concat(sidebarActiveColor).concat(';') : ''}"
               href="${contextPath}/UserController?action=profile">
                <i class="bi bi-gear me-2"></i> Account Settings
            </a>
        </c:if>

        <c:if test="${sessionScope.user.roleId != 1}">
            <a class="nav-link text-white rounded-3 ${activeMenu == 'dashboard' ? 'active' : ''}"
               style="${activeMenu == 'dashboard' ? 'background-color: '.concat(sidebarActiveColor).concat(';') : ''}"
               href="${contextPath}/DashboardController?action=userInfo">
                <i class="bi bi-speedometer2 me-2"></i> Dashboard
            </a>

            <a class="nav-link text-white rounded-3 ${activeMenu == 'transactions' ? 'active' : ''}"
               style="${activeMenu == 'transactions' ? 'background-color: '.concat(sidebarActiveColor).concat(';') : ''}"
               href="${contextPath}/TransactionController?action=list">
                <i class="bi bi-cash-coin me-2"></i> Transactions
            </a>

            <c:if test="${sessionScope.user.roleId == 2 || sessionScope.user.roleId == 3}">
                <a class="nav-link text-white rounded-3 ${activeMenu == 'categories' ? 'active' : ''}"
                   style="${activeMenu == 'categories' ? 'background-color: '.concat(sidebarActiveColor).concat(';') : ''}"
                   href="${contextPath}/CategoryController?action=list">
                    <i class="bi bi-tags me-2"></i> Category
                </a>
            </c:if>
            
            <c:if test="${sessionScope.user.roleId == 2 || sessionScope.user.roleId == 3}">
            	<a class="nav-link text-white rounded-3 ${activeMenu == 'budget' ? 'active' : ''}"
                   style="${activeMenu == 'budget' ? 'background-color: '.concat(sidebarActiveColor).concat(';') : ''}"
                   href="${contextPath}/BudgetController?action=list">
                    <i class="bi bi-wallet2 me-2"></i> Budget
                </a>
            </c:if>

            <c:if test="${sessionScope.user.roleId == 2}">
                <a class="nav-link text-white rounded-3 ${activeMenu == 'statement' ? 'active' : ''}"
                   style="${activeMenu == 'statement' ? 'background-color: '.concat(sidebarActiveColor).concat(';') : ''}"
                   href="${contextPath}/FinancialStatementController?action=preview">
                    <i class="bi bi-file-earmark-bar-graph me-2"></i> Company Statement
                </a>
            </c:if>

            <a class="nav-link text-white rounded-3 ${activeMenu == 'advisory' ? 'active' : ''}"
               style="${activeMenu == 'advisory' ? 'background-color: '.concat(sidebarActiveColor).concat(';') : ''}"
               href="${contextPath}/aiadvisory.jsp">
                <i class="bi bi-robot me-2"></i> AI Advisory
            </a>

            <a class="nav-link text-white rounded-3 ${activeMenu == 'settings' ? 'active' : ''}"
               style="${activeMenu == 'settings' ? 'background-color: '.concat(sidebarActiveColor).concat(';') : ''}"
               href="${contextPath}/UserController?action=profile">
                <i class="bi bi-gear me-2"></i> Account Settings
            </a>
        </c:if>

        <a class="nav-link text-white bg-danger rounded-3 mt-4 shadow-sm fw-bold"
           href="${contextPath}/logout">
            <i class="bi bi-box-arrow-right me-2"></i> Logout
        </a>

    </div>
</aside>
