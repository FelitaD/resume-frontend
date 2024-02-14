# Front-end 

This repo uses Infrastructure as Code (Terraform) to create all resources.

![diagram](resume-challenge.svg)

## Resources

- **Google Cloud Storage**<br>
Bucket that contains website's HTML, CSS and Javascript files.
- **SSL certificate**<br>
Required for establishing secure connection over HTTPS.
- **Cloud Load Balancer**<br>
Handles traffic distribution, SSL encryption and decryption process, provides security features (DDoS protection and Web Application Firewall capabilities), session persistence, health checks and other features not used for this project such as scalability.
- **DNS**<br>
DNS Provider (Squarespace) translates Load Balancer's static IP into website's domain name. 
