// Define the URL to fetch JSON data
const url = 'https://browniecoins.org/home/coin_stats/';

// Function to fetch JSON data from the URL
async function fetchData() {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        const textData = await response.text();

        // Check if the data starts with a double quote and a [
        if (textData.startsWith('"[') && textData.endsWith(']"')) {
            // Remove both the leading and trailing double quotes
            const cleanedData = textData.slice(2, -2);

            const jsonData = JSON.parse(cleanedData); // Parse the cleaned data as JSON
            return jsonData; // The data should be an array of objects
        } else {
            console.error('Data does not start and end with a double quote and a [:', textData);
            return [];
        }
    } catch (error) {
        console.error('Error fetching or parsing data:', error);
        return [];
    }
}

function createLineChart(data) {
    // Check if data is an array before using map
    if (!Array.isArray(data)) {
        console.error('Data is not an array:', data);
        return;
    }

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
