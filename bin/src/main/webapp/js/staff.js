const ctx = document.getElementById("cashflowChart");

if (ctx) {
    new Chart(ctx, {
        type: "line",
        data: {
            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
            datasets: [
                {
                    label: "Revenue",
                    data: [12000, 15000, 14000, 18000, 22000, 24500],
                    borderWidth: 3,
                    tension: 0.4,
                    borderColor: "#36A2EB",
                    backgroundColor: "#9BD0F5"
                },
                {
                    label: "Expenses",
                    data: [8000, 9500, 11000, 12000, 14200, 15200],
                    borderWidth: 3,
                    tension: 0.4,
                    borderColor: "#FF6384",
                    backgroundColor: "#FFB1C1"
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