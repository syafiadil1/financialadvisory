package model;

import java.util.List;

public class ChartDataModel {
	private String label;
	private List<Double> data;
	
	public ChartDataModel() {
		// TODO Auto-generated constructor stub
	}

	public ChartDataModel(String label, List<Double> data) {
		this.label = label;
		this.data = data;
	}

	public String getLabel() {
		return label;
	}
	
	public void setLabel(String label) {
		this.label = label;
	}
	
	public List<Double> getData() {
		return data;
	}
	
	public void setData(List<Double> data) {
		this.data = data;
	}
}