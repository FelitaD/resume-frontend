# Front-end 

This repo uses Infrastructure as Code (Terraform) to create all resources.

![diagram](diagram.png)

## Resources

- **Google Cloud Storage**
Bucket that contains website's HTML, CSS and Javascript files.
- **SSL certificate**
Required for establishing secure connection over HTTPS.
- **Cloud Load Balancer**
Handles traffic distribution, SSL encryption and decryption process, provides security features (DDoS protection and Web Application Firewall capabilities), session persistence, health checks and other features not used for this project such as scalability.
- **DNS**
DNS Provider (Squarespace) translates Load Balancer's static IP into website's domain name. 

## TODO

- [ ] Create Github Actions to automatically build and deploy updates to static website with 3 steps workflow:
    - [ ] Build step
    - [ ] Deploy step
    - [ ] Smoke test step