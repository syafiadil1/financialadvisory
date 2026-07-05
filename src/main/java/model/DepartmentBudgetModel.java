package model;

import java.util.Date;

public class DepartmentBudgetModel {

    private Integer departmentBudgetId;
    private Integer departmentId;
    private String departmentName;
    private Integer budgetYear;
    private double initialBudget;
    private double usedBudget;
    private double remainingBudget;
    private Date dateStart;
    private Date dateEnd;
    private boolean activeBudget;

    public DepartmentBudgetModel() {}

    public DepartmentBudgetModel(Integer departmentBudgetId,
                                 Integer departmentId,
                                 double initialBudget,
                                 double remainingBudget,
                                 Date dateStart,
                                 Date dateEnd,
                                 boolean activeBudget) {

        this.departmentBudgetId = departmentBudgetId;
        this.departmentId = departmentId;
        this.initialBudget = initialBudget;
        this.remainingBudget = remainingBudget;
        this.dateStart = dateStart;
        this.dateEnd = dateEnd;
        this.activeBudget = activeBudget;
    }

    public Integer getDepartmentBudgetId() {
        return departmentBudgetId;
    }

    public void setDepartmentBudgetId(Integer departmentBudgetId) {
        this.departmentBudgetId = departmentBudgetId;
    }

    public Integer getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Integer departmentId) {
        this.departmentId = departmentId;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public Integer getBudgetYear() {
        return budgetYear;
    }

    public void setBudgetYear(Integer budgetYear) {
        this.budgetYear = budgetYear;
    }

    public double getInitialBudget() {
        return initialBudget;
    }

    public void setInitialBudget(double initialBudget) {
        this.initialBudget = initialBudget;
    }

    public double getUsedBudget() {
        return usedBudget;
    }

    public void setUsedBudget(double usedBudget) {
        this.usedBudget = usedBudget;
    }

    public double getRemainingBudget() {
        return remainingBudget;
    }

    public void setRemainingBudget(double remainingBudget) {
        this.remainingBudget = remainingBudget;
    }

    public Date getDateStart() {
        return dateStart;
    }

    public void setDateStart(Date dateStart) {
        this.dateStart = dateStart;
    }

    public Date getDateEnd() {
        return dateEnd;
    }

    public void setDateEnd(Date dateEnd) {
        this.dateEnd = dateEnd;
    }

    public boolean isActiveBudget() {
        return activeBudget;
    }

    public void setActiveBudget(boolean activeBudget) {
        this.activeBudget = activeBudget;
    }
}
