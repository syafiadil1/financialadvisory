const ctx = document.getElementById("cashflowChart");

if (ctx) {
    const labels = window.cashflowTrendLabels || [];
    const incomeData = window.cashflowIncomeData || [];
    const expenseData = window.cashflowExpenseData || [];

    new Chart(ctx, {
        type: "line",
        data: {
            labels: labels,
            datasets: [
                {
                    label: "Income",
                    data: incomeData,
                    borderWidth: 3,
                    tension: 0.4,
                    borderColor: "#36A2EB",
                    backgroundColor: "#9BD0F5"
                },
                {
                    label: "Expenses",
                    data: expenseData,
                    borderWidth: 3,
                    tension: 0.4,
                    borderColor: "#FF6384",
                    backgroundColor: "#FFB1C1"
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
