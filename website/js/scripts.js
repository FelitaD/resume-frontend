/*!
* Start Bootstrap - Resume v7.0.6 (https://startbootstrap.com/theme/resume)
* Copyright 2013-2023 Start Bootstrap
* Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-resume/blob/master/LICENSE)
*/
//
// Scripts
// 

window.addEventListener('DOMContentLoaded', event => {

    // Activate Bootstrap scrollspy on the main nav element
    const sideNav = document.body.querySelector('#sideNav');
    if (sideNav) {
        new bootstrap.ScrollSpy(document.body, {
            target: '#sideNav',
            rootMargin: '0px 0px -40%',
        });
    };

    // Collapse responsive navbar when toggler is visible
    const navbarToggler = document.body.querySelector('.navbar-toggler');
    const responsiveNavItems = [].slice.call(
        document.querySelectorAll('#navbarResponsive .nav-link')
    );
    responsiveNavItems.map(function (responsiveNavItem) {
        responsiveNavItem.addEventListener('click', () => {
            if (window.getComputedStyle(navbarToggler).display !== 'none') {
                navbarToggler.click();
            }
        });
    });

});

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
