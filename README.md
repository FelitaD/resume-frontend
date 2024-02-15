# Google Cloud hosted resume - Front-end 

## Description

This project is the front-end of my cloud-hosted resume at [felitadonor.com](https://felitadonor.com/). ([back-end here](https://github.com/FelitaD/resume-backend))

![diagram](resume-challenge.svg)

## Features

- The HTML and CSS are deployed online as a static website using Google Cloud Storage.
- The website uses Cloud Load Balancer to provide security with HTTPS and caching is provided through Cloud CDN.
- Cloud resources are managed with Infrastructure as Code (Terraform).

## Technologies Used

- **[Google Cloud Storage](https://cloud.google.com/storage?hl=en)**<br>
Multi-class multi-region object storage. Bucket contains website's assets.
- **SSL certificate**<br>
Required for establishing secure connection over HTTPS.
- **[External HTTP Load Balancer](https://cloud.google.com/load-balancing?hl=en)**<br>
Handles traffic distribution, SSL encryption and decryption process, provides security features (DDoS protection and Web Application Firewall capabilities), session persistence, health checks and other features not used for this project such as scalability.
- **[Cloud CDN](https://cloud.google.com/cdn?hl=en)**
Provides caching for the website. Enabled when creating the Load Balancer.
- **DNS**<br>
DNS Provider (Squarespace) translates Load Balancer's static IP into website's domain name. 
- **[Cloud Build](https://cloud.google.com/build?hl=en)**<br>
Devops automation platform. 2 triggers: one for IaC and one for the website's files to avoid rerunning the IaC pipeline for example when the HTML is changed.
- **[Terraform](https://www.terraform.io/)**<br>
Creates and manages all Cloud resources.

## TODO

- [ ] Finish integrating smoke test to Cloud Build