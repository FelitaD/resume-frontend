document.addEventListener('DOMContentLoaded', function () {
    const apiUrl = 'https://resume-gateway-46hn0g06.ew.gateway.dev/update_visitor_count';

    // Make a CORS request using Fetch API with POST method
    fetch(apiUrl, { method: 'POST', mode: 'cors' })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // Update the visitor count on the HTML page
            const visitorCountElement = document.getElementById('visitorCount');
            if (visitorCountElement) {
                visitorCountElement.textContent = data.count;
            } else {
                console.error('Visitor count element not found in the HTML.');
            }
        })
        .catch(error => {
            console.error('There was a problem with the fetch operation:', error);
        });
});
