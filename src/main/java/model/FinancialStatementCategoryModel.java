package model;

public class FinancialStatementCategoryModel {
	private String categoryName;
	private String transactionType;
	private double totalAmount;

	public FinancialStatementCategoryModel() {
	}

	public FinancialStatementCategoryModel(String categoryName, String transactionType, double totalAmount) {
		this.categoryName = categoryName;
		this.transactionType = transactionType;
		this.totalAmount = totalAmount;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}

	public String getTransactionType() {
		return transactionType;
	}

	public void setTransactionType(String transactionType) {
		this.transactionType = transactionType;
	}

	public double getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}
}
