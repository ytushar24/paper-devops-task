# Paper.Social - DevOps Engineer Assessment (AWS & IBM Cloud)

**Paper.Social** is a modern, resilient social media platform deployed using a multi-cloud strategy with automated DevOps pipelines. This project demonstrates Infrastructure as Code (IaC), configuration management, containerization, CI/CD automation, and scalable deployment practices across AWS (and optionally IBM Cloud).

---

## 🌐 Project Goals

- Deploy a simple web application on AWS (and IBM Cloud) using Infrastructure as Code
- Use Terraform, Ansible, and GitHub Actions for automation
- Host a Dockerized frontend application
- Enable automated builds and deployment via CI/CD pipeline
- Demonstrate logging, scalability considerations, and cost-awareness

---

## ⚖️ Tech Stack

| Layer                 | Tool                              |
| --------------------- | --------------------------------- |
| Cloud Providers       | AWS (EC2), IBM Cloud (optional)   |
| IaC                   | Terraform                         |
| Configuration Mgmt    | Ansible                           |
| App Containerization  | Docker                            |
| CI/CD                 | GitHub Actions                    |
| Monitoring (Optional) | Prometheus + Grafana / CloudWatch |

---

## 🚀 Infrastructure Setup (Terraform)

Terraform is used to provision infrastructure in AWS:

### AWS Resources Provisioned

- One EC2 instance (Amazon Linux 2)
- Security Group allowing SSH (22) and HTTP (80)
- Key pair for SSH access

### Setup Steps

```bash
cd paper-social-aws
terraform init
terraform apply -var-file="terraform.tfvars"
```

Output:

- EC2 instance public IP
- SSH key (used in Ansible and GitHub Secrets)

---

## ⚖️ Server Configuration (Ansible)

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

## ⚙️ CI/CD Pipeline (GitHub Actions)

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

### Steps

- Checkout latest code
- Install Ansible (version < 10 for yum support)
- Set up SSH to EC2 (via GitHub Secrets)
- Run the Ansible playbook remotely to build and deploy the Docker image

> `ansible_python_interpreter` is set to `/usr/local/bin/python3.8`

### Required GitHub Secrets

| Secret Name       | Description                   |
| ----------------- | ----------------------------- |
| `SSH_PRIVATE_KEY` | EC2 private key (PEM format)  |
| `EC2_HOST`        | Public IP of EC2 instance     |
| `EC2_USER`        | SSH user (usually `ec2-user`) |

---

## 📃 App Overview (Frontend)

A simple static HTML + CSS site (`app/`) with the following features:

- Responsive layout
- Custom branding for Paper.Social
- Deployed via Nginx container

Dockerfile:

```Dockerfile
FROM nginx:alpine
COPY . /usr/share/nginx/html
```

---

## 📊 Monitoring & Logging (Optional)

> Not implemented yet, but here's the plan:

- Use AWS CloudWatch Agent or install Prometheus Node Exporter
- Run a basic Grafana dashboard for container health
- Mount logs inside container or export with logging driver

---

## 🛍️ Cost Considerations

- **EC2**: t2.micro used for low-cost development
- **No autoscaling** implemented (but possible via ASGs)
- **Storage**: Minimal (\~8 GB)
- **Monitoring**: Can be done using open-source stack to avoid cost

---

## ⚡ Bonus Features (Optional)

- Support for IBM Cloud provisioning (mirror Terraform code)
- Add domain + SSL (Let's Encrypt)
- Autoscaling and container health checks

---

## 🔄 Redeployment Flow

1. Push changes to `/app/index.html`, `/styles.css`, or `/Dockerfile`
2. GitHub Action triggers
3. Ansible remotely builds Docker image & restarts container
4. Site updates live on: `http://<ec2-ip>`

---

## 🔧 Troubleshooting

- Make sure Ansible uses `/usr/local/bin/python3.8`
- Use `pip` to install Python packages **not yum** (e.g., `requests`)
- Use `force_source: true` in Docker build task to avoid caching issues

---

## 👍 Author & Credits

Created by: Tushar Yadav\
GitHub: [ytushar24](https://github.com/ytushar24)

---

Ready to scale, secure, and monitor in multi-cloud production environments.

---

I want 
