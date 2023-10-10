// Define the URL to fetch JSON data
const url = 'https://browniecoins.org/home/coin_stats/';

// Function to fetch JSON data from the URL
async function fetchData() {
    try {
        const response = await fetch(url);
        const textData = await response.text();
        const data = JSON.parse(textData);
        return data; // The data should be an array of objects
    } catch (error) {
        console.error('Error fetching data:', error);
        return [];
    }
}

function createLineChart(data) {
    const timestamps = data.map(entry => new Date(entry.fields.timestamp));
    const hashPowerValues = data.map(entry => entry.fields.current_hash_power);

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
