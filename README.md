# Google Cloud hosted resume - Front-end 

## Description

This project is the front-end of my cloud-hosted resume at [felitadonor.com](https://felitadonor.com/). ([back-end here](https://github.com/FelitaD/resume-backend))

![diagram](resume-challenge.svg)

## Features

- The HTML and CSS are deployed online as a static website using Google Cloud Storage.
- The website uses Cloud Load Balancer to provide security with HTTPS and caching is provided through Cloud CDN.
- Cloud resources are managed with Infrastructure as Code (Terraform).

## Technologies Used

- **Google Cloud Storage**<br>
Bucket that contains website's HTML, CSS and Javascript files.
- **SSL certificate**<br>
Required for establishing secure connection over HTTPS.
- **Cloud Load Balancer**<br>
Handles traffic distribution, SSL encryption and decryption process, provides security features (DDoS protection and Web Application Firewall capabilities), session persistence, health checks and other features not used for this project such as scalability.
- **Cloud CDN**
Provides caching for the website. Enabled when creating the Load Balancer.
- **DNS**<br>
DNS Provider (Squarespace) translates Load Balancer's static IP into website's domain name. 

## TODO

- [ ] Finish integrating smoke test to Cloud Build