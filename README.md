# status-api - Dockerized app on AWS with Terraform + GitHub Actions CI/CD

A small API deployed to a hardened EC2 host, provisioned entirely with Terraform, with an Nginx reverse proxy handling TLS and a GitHub Actions pipeline that builds, tests, and ships every push to main with zero manual steps.

## Stack

- App: Node.js/Express, containerized, non-root user, health check endpoint
- Infra: Terraform (EC2, security group, Elastic IP, default VPC)
- Reverse proxy: Nginx with Let's Encrypt (certbot) TLS termination
- CI/CD: GitHub Actions - test, build image, push to GHCR, SSH-deploy to the host
- Registry: GitHub Container Registry

## Architecture

```
GitHub push to main
  -> Actions: npm test
  -> Actions: docker build, push to ghcr.io
  -> Actions: SSH to EC2, docker compose pull + up
EC2 host
  -> nginx (443/80) -> app container (3000)
  -> certbot renews TLS cert on a loop
```

## Setup

1. Provision the host:
   ```
   cd infra
   cp terraform.tfvars.example terraform.tfvars
   terraform init
   terraform apply
   ```
2. Point your domain's A record at the Elastic IP from terraform output public_ip.
3. SSH into the host and copy docker-compose.yml and nginx/ into /opt/status-api, then run scripts/init-letsencrypt.sh once to issue the first certificate.
4. In the GitHub repo, add these secrets: EC2_HOST (the Elastic IP), EC2_SSH_KEY (private key matching your key_name).
5. Push to main - the pipeline tests, builds, and deploys automatically.

## Why this setup

Most "deploy a Docker app to AWS" requests on Upwork ask for exactly this combination: a working CI/CD pipeline, infrastructure defined as code instead of clicked together in the console, and HTTPS handled properly. This project is built so it can be handed to a client and modified for their actual application in a day or two rather than built from scratch.

## Result

- Push-to-deploy: a code change goes from git push to live on the server in under two minutes
- Zero manual server configuration after the first Terraform apply
- TLS certificates renew automatically, no expiry risk
