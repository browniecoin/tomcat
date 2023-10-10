// Define the URL to fetch plain text data
const url = 'https://browniecoins.org/home/coin_stats/';

// Function to fetch plain text data from the URL
async function fetchData() {
    try {
        const response = await fetch(url);
        const textData = await response.text();
        return textData; // The data should be plain text
    } catch (error) {
        console.error('Error fetching data:', error);
        return '';
    }
}

function createLineChart(data) {
    // Split the plain text into lines by newline characters
    const lines = data.split('\n');

    // Process the lines to extract timestamp and hash power data
    const timestamps = [];
    const hashPowerValues = [];

    for (const line of lines) {
        const parts = line.split(','); // Assuming data is comma-separated
        if (parts.length === 3) {
            const timestamp = new Date(parts[0]);
            const hashPower = parseFloat(parts[2]);
            timestamps.push(timestamp);
            hashPowerValues.push(hashPower);
        }
    }

    // Create the line chart
    const ctx = document.getElementById('hashPowerChart').getContext('2d');

    const chartData = {
        labels: timestamps,
        datasets: [
            {
                label: 'Current Hash Power',
                borderColor: 'blue',
                data: hashPowerValues,
                fill: false,
            },
        ],
    };

    const chartConfig = {
        type: 'line',
        data: chartData,
        options: {
            responsive: true,
            scales: {
                x: {
                    type: 'time',
                    time: {
                        unit: 'minute',
                    },
                },
                y: {
                    title: {
                        display: true,
                        text: 'Hash Power',
                    },
                },
            },
        },
    };

    new Chart(ctx, chartConfig);
}

// Fetch data and create the chart
fetchData().then(data => {
    createLineChart(data);
});
