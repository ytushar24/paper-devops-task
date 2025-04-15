# Paper.Social - DevOps Engineer Assessment

This project demonstrates Infrastructure as Code (IaC), configuration management, containerization, CI/CD automation, and scalable deployment practices across AWS.

---

## Project Goals

- Deploy a simple web application on AWS using Infrastructure as Code
- Use Terraform, Ansible, and GitHub Actions for automation
- Host a Dockerized frontend application
- Enable automated builds and deployment via CI/CD pipeline
- Demonstrate logging, scalability considerations, and cost-awareness

---

## Tech Stack

| Layer                 | Tool                              |
| --------------------- | --------------------------------- |
| Cloud Providers       | AWS (EC2), IBM Cloud (optional)   |
| IaC                   | Terraform                         |
| Configuration Mgmt    | Ansible                           |
| App Containerization  | Docker                            |
| CI/CD                 | GitHub Actions                    |
| Monitoring (Optional) | CloudWatch                        |

---

## Infrastructure Setup (Terraform)

Terraform is used to provision infrastructure in AWS:

### AWS Resources Provisioned

- One EC2 instance (Amazon Linux 2)
- Security Group allowing SSH (22) and HTTP (80)
- Key pair for SSH access (already created in EC2 dashboard)

### Setup Steps

```bash
cd paper-social-aws
terraform init
terraform apply -var-file="terraform.tfvars"
```

Output:

- EC2 instance public IP
- SSH key (used in Ansible and GitHub Secrets)

Note- We can also use Terraform userdata feature to install services without Ansible.
---

## Server Configuration (Ansible)

Ansible automates installation and app deployment to the EC2 instance:

### Key Steps in Ansible Playbook

- Install Docker, pip, git
- Add ec2-user to docker group
- Clone the repo to the EC2 instance
- Build Docker image from app code
- Stop & remove existing container (if running)
- Deploy updated container on port 80

> Interpreter used: Python 3.8 installed at `/usr/local/bin/python3.8`

Run it locally:

```bash
ansible-playbook -i hosts.ini ansible/playbook.yml
```

---

## CI/CD Pipeline (GitHub Actions)

A workflow was created to automate deployment whenever the app files change.

### Trigger

```yaml
on:
  push:
    branches:
      - master
    paths:
      - '**/index.html'
      - '**/styles.css'
      - '**/Dockerfile'
```
Note- In this case terraform and Ansible Script is also present in the same git repo, hence we need to explicitly define the trigger paths.

### Steps

- Checkout latest code
- Install Ansible (version < 10 for yum support)
- Set up SSH to EC2 (via GitHub Secrets)
- Run the Ansible playbook remotely to build and deploy the Docker image

> `ansible_python_interpreter` is set to `/usr/local/bin/python3.8`

Note- We are running this ansible playbook on Github action runner, There were some version compatibility issues so use the defined versions only

### Required GitHub Secrets

| Secret Name       | Description                   |
| ----------------- | ----------------------------- |
| `SSH_PRIVATE_KEY` | EC2 private key               |
| `EC2_HOST`        | Public IP of EC2 instance     |
| `EC2_USER`        | SSH user                      |

---

## App Overview (Frontend)

A simple static HTML + CSS site (`app/`) with the following features:


Dockerfile:

```Dockerfile
FROM nginx:alpine
COPY . /usr/share/nginx/html
```

---

## Monitoring & Logging

> Not implemented yet, but here's the plan:

- install AWS Cloudwatch Agent on EC2 machine
- create config.json
- attach this policy to user "CloudWatchAgentServerPolicy"

Note- We can also mount /var/lib/docker/containers inside cloudWatch agent config to push all the container logs


## Redeployment Flow

1. Push changes to `/app/index.html`, `/styles.css`, or `/Dockerfile`
2. GitHub Action triggers
3. Ansible remotely builds Docker image & restarts container
4. Site updates live on: `http://<ec2-ip>`

---

## Troubleshooting

- Make sure Ansible uses `/usr/local/bin/python3.8`
- Use `pip` to install Python packages **not yum** (e.g., `requests`)
- Use `force_source: true` in Docker build task to avoid caching issues

---
