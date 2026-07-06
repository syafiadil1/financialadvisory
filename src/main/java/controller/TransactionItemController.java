package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import dao.TransactionItemDAO;
import util.ErrorUtil;

/**
 * Servlet implementation class TransactionItemController
 */
@WebServlet("/TransactionItemController")
public class TransactionItemController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TransactionItemController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
String action = request.getParameter("action");
		
		if (action == null || action.isEmpty()) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST,
					ErrorUtil.format("TransactionItemController.java", "doPost", "Action parameter is missing"));
			return;
		}
		
		switch (action) {
		case "save":
				// Call the method to create a transaction
				break;
				
			case "update":
				// Call the method to update a transaction
				//updateTransaction(request, response);
				break;
			case "delete":
				// Call the method to delete a transaction
				TransactionItemDAO transactionItemDAO = new TransactionItemDAO();
				boolean success = transactionItemDAO.deleteTransactionItem(Integer.parseInt(request.getParameter("itemId")));
				
				response.setContentType("application/json");
				response.getWriter().write("{\"success\":" + success + "}");
				break;
			default:
				response.sendError(HttpServletResponse.SC_BAD_REQUEST,
						ErrorUtil.format("TransactionItemController.java", "doPost", "Invalid action"));
		}
	}

}
