package model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class FinancialStatementModel {
	private LocalDate startDate;
	private LocalDate endDate;
	private String periodLabel;
	private String departmentLabel;
	private String generatedBy;
	private LocalDate generatedDate;
	private double totalIncome;
	private double totalExpenses;
	private int transactionCount;
	private List<FinancialStatementCategoryModel> categoryTotals = new ArrayList<>();

	public LocalDate getStartDate() {
		return startDate;
	}

	public void setStartDate(LocalDate startDate) {
		this.startDate = startDate;
	}

	public LocalDate getEndDate() {
		return endDate;
	}

	public void setEndDate(LocalDate endDate) {
		this.endDate = endDate;
	}

	public String getPeriodLabel() {
		return periodLabel;
	}

	public void setPeriodLabel(String periodLabel) {
		this.periodLabel = periodLabel;
	}

	public String getDepartmentLabel() {
		return departmentLabel;
	}

	public void setDepartmentLabel(String departmentLabel) {
		this.departmentLabel = departmentLabel;
	}

	public String getGeneratedBy() {
		return generatedBy;
	}

	public void setGeneratedBy(String generatedBy) {
		this.generatedBy = generatedBy;
	}

	public LocalDate getGeneratedDate() {
		return generatedDate;
	}

	public void setGeneratedDate(LocalDate generatedDate) {
		this.generatedDate = generatedDate;
	}

	public double getTotalIncome() {
		return totalIncome;
	}

	public void setTotalIncome(double totalIncome) {
		this.totalIncome = totalIncome;
	}

	public double getTotalExpenses() {
		return totalExpenses;
	}

	public void setTotalExpenses(double totalExpenses) {
		this.totalExpenses = totalExpenses;
	}

	public double getNetProfit() {
		return totalIncome - totalExpenses;
	}

	public String getCashflowStatus() {
		if (transactionCount == 0) {
			return "No Data";
		}
		return getNetProfit() >= 0 ? "Healthy" : "At Risk";
	}

	public int getTransactionCount() {
		return transactionCount;
	}

	public void setTransactionCount(int transactionCount) {
		this.transactionCount = transactionCount;
	}

	public boolean isEmpty() {
		return transactionCount == 0;
	}

	public List<FinancialStatementCategoryModel> getCategoryTotals() {
		return categoryTotals;
	}

	public void setCategoryTotals(List<FinancialStatementCategoryModel> categoryTotals) {
		this.categoryTotals = categoryTotals;
	}
}
