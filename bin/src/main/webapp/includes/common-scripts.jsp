<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/notification-widget.jsp" />
<jsp:include page="/chatbot-widget.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= request.getContextPath() %>/js/chatbot-widget.js?v=2"></script>
