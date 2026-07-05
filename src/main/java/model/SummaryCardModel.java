package model;

public class SummaryCardModel {

	private String title;
	private String data;
	private String description;
	private String iconClass;
	
	// style
	private String borderClass; // border-start border-warning border-5
	private String colorClass; // text-warning
	
	public SummaryCardModel() {
		this.title = "Error! No Title";
		this.data = "Error! No Data";
		this.description = "";
		this.iconClass = "bi-info-circle";
		this.borderClass = "border-start border-secondary border-5"; // default style
		this.colorClass = "text-secondary"; // default color
	}

	public SummaryCardModel(String title, String data, String description, String borderClass, String colorClass) {
		this(title, data, description, borderClass, colorClass, "bi-info-circle");
	}

	public SummaryCardModel(String title, String data, String description, String borderClass, String colorClass, String iconClass) {
		this.title = title; // Total income
		this.data = data; // RM 67, 676, 767
		this.description = description; // approved income record
		this.borderClass = borderClass;// custom style
		this.colorClass = colorClass; // custom color
		this.iconClass = iconClass;
	}

	// Getters and setters
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getData() {
		return data;
	}

	public void setData(String data) {
		this.data = data;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getIconClass() {
		return iconClass;
	}

	public void setIconClass(String iconClass) {
		this.iconClass = iconClass;
	}

	public String getBorderClass() {
		return borderClass;
	}

	public void setBorderClass(String borderClass) {
		this.borderClass = borderClass;
	}

	public String getColorClass() {
		return colorClass;
	}

	public void setColorClass(String colorClass) {
		this.colorClass = colorClass;
	}
}
