const financialManagerChart = document.getElementById("financialManagerChart");

if (financialManagerChart) {
	new Chart(financialManagerChart, {
		type: "bar",
		data: {
			labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
			datasets: [
				{
					label: "Revenue",
					data: [12000, 15000, 14000, 18000, 22000, 24500],
					backgroundColor: "#36A2EB"
				},
				{
					label: "Expenses",
					data: [8000, 9500, 11000, 12000, 14200, 15200],
					backgroundColor: "#FF6384"
				}
			]
		},
		options: {
			responsive: true,
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
