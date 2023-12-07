async function postData(url = "", data = {}) {
    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
        });

        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        return response.json();
    } catch (error) {
        console.error('Error:', error);
    }
}

document.addEventListener('DOMContentLoaded', function() {
    // Call the postData function when the DOM content is loaded
    postData('https://gateway-jq4t4jadfq-od.a.run.app/update_visitor_count', { visitor_count: 1 }).then((data) => {
        console.log(data);
    });
});