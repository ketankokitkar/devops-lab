# DevOps Lab

Hands-on DevOps learning repository covering **AWS, Terraform, Ansible, and Linux automation**. Each folder contains practice labs, configuration examples, and notes that I build and document while learning.

I work as a Project Engineer II at Evertz Microsystems, running production infrastructure, Linux deployments, and SaltStack-based automation. This repo is where I extend that experience into Infrastructure as Code and cloud engineering.

## Repository Structure

| Folder | What it covers |
|---|---|
| [AWS](./AWS) | Cloud Practitioner (CLF-C02) study notes and an EC2 Node.js deployment walkthrough |
| [Ansible](./Ansible) | Basics, AWS automation, dynamic inventory, Ansible Vault, and a final project |
| [Terraform](./Terraform) | Fundamentals, configuration, modules, remote state, workspaces, and secrets management |

## Contents

### AWS
- `CLF-C02`: AWS Certified Cloud Practitioner preparation notes
- `ec2-nodejs-deployment.md`: deploying a Node.js application on an EC2 instance

### Ansible
- `basics`: inventory, ad-hoc commands, and playbook fundamentals
- `aws`: managing AWS resources with Ansible
- `dynamic-inventory`: building inventory from AWS dynamically
- `vault`: encrypting secrets with Ansible Vault
- `final-project`: an end-to-end automation project combining the topics above

### Terraform
1. Fundamentals: providers, resources, and the init/plan/apply workflow
2. Configuration: variables, outputs, and data sources
3. Modules: reusable infrastructure modules
4. State and collaboration: remote state and locking
5. Workspaces: managing multiple environments
6. Secrets management: handling sensitive values safely

## Tools and Technologies

`AWS (EC2, S3, VPC, IAM)` · `Terraform` · `Ansible` · `Linux (Ubuntu)` · `Git & GitHub` · `Shell scripting` · `Python`

## Roadmap

- [x] Terraform fundamentals through secrets management
- [x] Ansible basics, dynamic inventory, and vault
- [x] AWS EC2 deployment walkthrough
- [ ] Docker: containerizing a sample application
- [ ] CI/CD: GitHub Actions pipeline to build and push images
- [ ] Kubernetes basics
- [ ] Monitoring with Prometheus and Grafana

## How to Use This Repo

1. Clone the repository:
```bash
   git clone https://github.com/ketankokitkar/devops-lab.git
   cd devops-lab
```
2. Open the folder for the topic you want and read its `README.md` first.
3. For Terraform labs, run `terraform init`, then `terraform plan`, before `terraform apply`.
4. Remember to run `terraform destroy` after testing to avoid AWS charges.

> **Note:** No credentials or secrets are stored in this repo. Use your own AWS profile and environment variables when running the labs.

## About Me

**Ketan Kokitkar**: Project Engineer II | Linux · AWS · SaltStack · Python

[LinkedIn](https://www.linkedin.com/in/ketankokitkar/) · [GitHub](https://github.com/ketankokitkar)

---
*This repository is actively updated as I learn and build.*
