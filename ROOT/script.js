// Define the URL to fetch JSON data
const url = 'https://browniecoins.org/home/coin_stats/';

// Function to fetch JSON data from the URL
async function fetchData() {
    try {
        const response = await fetch(url);

        const textData = await response.text();
        const cleanedData = textData.substring(1, textData.length - 1);

        const jsonData = JSON.parse(cleanedData);

        return jsonData; // The data should be an array of objects
    } catch (error) {
        console.error('Error fetching data:', error);
        return [];
    }
}

function createLineChart(data) {
    // Extract timestamp and hash power data from the JSON objects
    const timestamps = data.map(entry => new Date(entry.fields.timestamp));
    const hashPowerValues = data.map(entry => entry.fields.current_hash_power);

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
