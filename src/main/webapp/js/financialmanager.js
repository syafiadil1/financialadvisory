const financialManagerChart = document.getElementById("financialManagerChart");

if (financialManagerChart) {
	const labels = window.companyTrendLabels || [];
	const incomeData = window.companyIncomeData || [];
	const expenseData = window.companyExpenseData || [];

	new Chart(financialManagerChart, {
		type: "bar",
		data: {
			labels: labels,
			datasets: [
				{
					label: "Revenue",
					data: incomeData,
					backgroundColor: "#36A2EB"
				},
				{
					label: "Expenses",
					data: expenseData,
					backgroundColor: "#FF6384"
				}
			]
		},
		options: {
			responsive: true,
			maintainAspectRatio: false,
			interaction: {
				mode: "index",
				intersect: false
			},
			plugins: {
				legend: {
					position: "bottom"
				}
			},
			scales: {
				y: {
					beginAtZero: true
				}
			}
		}
	});
}
