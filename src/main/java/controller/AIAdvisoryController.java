package controller;

import dao.ChatHistoryDAO;
import dao.ChatSessionDAO;
import dao.FinancialContextDAO;
import gemini.GeminiService;
import helper.RoleHelper;
import helper.SessionHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ChatHistoryModel;
import model.ChatSessionModel;
import model.FinancialContextModel;
import model.UserModel;
import util.ErrorUtil;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

@WebServlet("/AIAdvisoryController")
public class AIAdvisoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int MAX_PROMPT_LENGTH = 1200;
    private static final String[] PREDEFINED_PROMPTS = {
            "What should I focus on this month?",
            "Summarize department spending risks.",
            "Which statuses need follow-up?",
            "Recommend actions to improve cashflow."
    };

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserModel user = SessionHelper.getCurrentUser(request);

    	
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        prepareAdvisoryPage(request, user);
        request.getRequestDispatcher("/aiadvisory.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserModel user = SessionHelper.getCurrentUser(request);
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = getStringParameter(request, "action");
        if (!"send".equalsIgnoreCase(action)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    ErrorUtil.format("AIAdvisoryController.java", "doPost", "Invalid chat action"));
            return;
        }

        sendPrompt(request, response, user);
    }

    private void prepareAdvisoryPage(HttpServletRequest request, UserModel user) {
        String role = resolveRole(user, request.getParameter("role"));
        Integer selectedChatId = getIntegerParameter(request, "chatId");

        ChatSessionDAO chatSessionDAO = new ChatSessionDAO();
        ChatHistoryDAO chatHistoryDAO = new ChatHistoryDAO();
        ArrayList<ChatSessionModel> chatSessions = chatSessionDAO.getSessionsByUserId(user.getUserId());
        ArrayList<ChatHistoryModel> chatMessages = new ArrayList<>();
        ChatSessionModel selectedSession = null;

        if (selectedChatId != null) {
            selectedSession = chatSessionDAO.getSessionByIdAndUserId(selectedChatId, user.getUserId());
            if (selectedSession != null) {
                chatMessages = chatHistoryDAO.getMessagesByChatId(selectedChatId);
            } else {
                selectedChatId = null;
            }
        }

        FinancialContextModel financialContext = new FinancialContextDAO().getFinancialContext(user);

        request.setAttribute("advisoryViewReady", true);
        request.setAttribute("role", role);
        request.setAttribute("roleName", getRoleName(role));
        request.setAttribute("selectedChatId", selectedChatId);
        request.setAttribute("selectedSession", selectedSession);
        request.setAttribute("chatSessions", chatSessions);
        request.setAttribute("chatMessages", chatMessages);
        request.setAttribute("financialContext", financialContext);
        request.setAttribute("positivePosition", financialContext.getNetTotal() >= 0);
        request.setAttribute("chatError", request.getParameter("chatError"));
        request.setAttribute("predefinedPrompts", PREDEFINED_PROMPTS);
    }

    private void sendPrompt(HttpServletRequest request, HttpServletResponse response, UserModel user) throws IOException {
        String role = resolveRole(user, request.getParameter("role"));
        String prompt = getStringParameter(request, "prompt");

        if (prompt.isEmpty()) {
            redirectToChat(response, role, null, "Please enter a question before sending.");
            return;
        }

        if (prompt.length() > MAX_PROMPT_LENGTH) {
            prompt = prompt.substring(0, MAX_PROMPT_LENGTH);
        }

        ChatSessionDAO chatSessionDAO = new ChatSessionDAO();
        ChatHistoryDAO chatHistoryDAO = new ChatHistoryDAO();
        Integer chatId = getIntegerParameter(request, "chatId");

        if (chatId != null) {
            ChatSessionModel chatSession = chatSessionDAO.getSessionByIdAndUserId(chatId, user.getUserId());
            if (chatSession == null) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                        ErrorUtil.format("AIAdvisoryController.java", "sendPrompt", "Chat session does not belong to current user"));
                return;
            }
        } else {
            chatId = chatSessionDAO.createSession(user.getUserId(), buildSessionName(prompt));
            if (chatId == null) {
                redirectToChat(response, role, null, "Could not create chat session. Please confirm the chat database tables exist.");
                return;
            }
        }

        ArrayList<ChatHistoryModel> recentMessages = chatHistoryDAO.getRecentMessages(chatId, 8);
        FinancialContextModel financialContext = new FinancialContextDAO().getFinancialContext(user);
        String geminiPrompt = buildGeminiPrompt(prompt, financialContext, recentMessages);

        boolean userMessageSaved = chatHistoryDAO.addMessage(chatId, true, prompt);
        String assistantResponse = new GeminiService().generateAdvisory(geminiPrompt);
        boolean responseSaved = chatHistoryDAO.addMessage(chatId, false, assistantResponse);
        chatSessionDAO.touchSession(chatId);

        if (!userMessageSaved || !responseSaved) {
            redirectToChat(response, role, chatId, "Message was generated, but one or more chat records could not be saved.");
            return;
        }

        redirectToChat(response, role, chatId, null);
    }

    private String buildGeminiPrompt(String userPrompt,
                                     FinancialContextModel financialContext,
                                     ArrayList<ChatHistoryModel> recentMessages) {
        StringBuilder builder = new StringBuilder();
        builder.append("You are an AI financial advisory assistant for an internal financial advisory system.\n");
        builder.append("Use only the provided financial data context. Do not invent database records.\n");
        builder.append("Answer in 2 to 4 short lines, under 5 lines total.\n");
        builder.append("Be compact and complete: no long intro, no markdown headings, no unfinished list items.\n");
        builder.append("Give only the most important recommendation, reason, and next action.\n");
        builder.append("Do not produce SQL. Do not request or reveal secrets.\n\n");

        builder.append("Financial context:\n");
        builder.append(financialContext.toPromptText()).append('\n');

        builder.append("Recent chat history:\n");
        if (recentMessages == null || recentMessages.isEmpty()) {
            builder.append("- None\n");
        } else {
            for (ChatHistoryModel message : recentMessages) {
                builder.append(message.isPromptOrResponse() ? "User: " : "Assistant: ");
                builder.append(limitForPrompt(message.getContent(), 500)).append('\n');
            }
        }

        builder.append("\nCurrent user question:\n");
        builder.append(userPrompt);

        return builder.toString();
    }

    private String resolveRole(UserModel user, String requestedRole) {
        if (RoleHelper.isFinancialManager(user)) {
            return "financialmanager";
        }
        if (RoleHelper.isDepartmentManager(user)) {
            return "departmentmanager";
        }
        if (RoleHelper.isStaff(user)) {
            return "staff";
        }
        return normalizeRole(requestedRole);
    }

    private String getRoleName(String role) {
        if ("financialmanager".equals(role)) {
            return "Financial Manager";
        }
        if ("departmentmanager".equals(role)) {
            return "Department Manager";
        }
        return "Staff";
    }

    private String buildSessionName(String prompt) {
        String normalized = prompt.replaceAll("\\s+", " ").trim();
        if (normalized.length() > 60) {
            return normalized.substring(0, 60);
        }
        return normalized.isEmpty() ? "New advisory chat" : normalized;
    }

    private String limitForPrompt(String value, int maxLength) {
        if (value == null) {
            return "";
        }
        return value.length() > maxLength ? value.substring(0, maxLength) : value;
    }

    private void redirectToChat(HttpServletResponse response, String role, Integer chatId, String error) throws IOException {
        StringBuilder url = new StringBuilder("AIAdvisoryController?role=").append(encode(role));
        if (chatId != null) {
            url.append("&chatId=").append(chatId);
        }
        if (error != null && !error.trim().isEmpty()) {
            url.append("&chatError=").append(encode(error));
        }
        response.sendRedirect(url.toString());
    }

    private Integer getIntegerParameter(HttpServletRequest request, String key) {
        String value = getStringParameter(request, key);
        if (value.isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String getStringParameter(HttpServletRequest request, String key) {
        String value = request.getParameter(key);
        return value == null ? "" : value.trim();
    }

    private String normalizeRole(String role) {
        if ("departmentmanager".equals(role) || "financialmanager".equals(role) || "staff".equals(role)) {
            return role;
        }
        return "staff";
    }

    private String encode(String value) {
        return URLEncoder.encode(value == null ? "" : value, StandardCharsets.UTF_8);
    }
}
