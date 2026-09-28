# Terraform Secrets Management with HashiCorp Vault

## Overview

This project demonstrates how Terraform integrates with HashiCorp Vault to retrieve sensitive information and use the retrieved value while provisioning AWS infrastructure.

### What this lab covers

- HashiCorp Vault installation
- KV v2 Secrets Engine
- Creating and reading secrets
- Vault Policies
- AppRole Authentication
- Role ID and Secret ID
- Terraform Vault Provider
- Terraform Data Sources
- Retrieving secrets from Vault
- Using Vault values with AWS infrastructure
- AWS EC2 provisioning using Terraform
- Troubleshooting Vault connectivity and Terraform state locks

---

## Architecture

```text
                  HashiCorp Vault
                 ┌───────────────┐
                 │    KV v2      │
                 │               │
                 │ test-secret   │
                 │ username      │
                 │ password      │
                 └───────┬───────┘
                         │
                    AppRole Auth
                  Role ID + Secret ID
                         │
                         ▼
                 ┌───────────────┐
                 │   Terraform   │
                 │               │
                 │ Vault Provider│
                 │ Data Source   │
                 └───────┬───────┘
                         │
                  Retrieved Value
                         │
                         ▼
                 ┌───────────────┐
                 │ AWS Provider  │
                 └───────┬───────┘
                         │
                         ▼
                 ┌───────────────┐
                 │    AWS EC2    │
                 │               │
                 │  t3.micro     │
                 │               │
                 │ VaultUsername │
                 │     = value   │
                 └───────────────┘
````

---

## Important Concept

**Vault does NOT create the EC2 instance.**

Terraform creates the EC2 instance using the AWS provider.

Vault's role is to securely store and provide sensitive information to authorized clients such as Terraform or applications.

The overall flow is:

```text
Vault
  ↓
Store Secret
  ↓
Terraform authenticates using AppRole
  ↓
Terraform retrieves Secret
  ↓
Terraform uses the retrieved value
  ↓
AWS Provider
  ↓
EC2 Instance
```

Terraform can create EC2 instances without Vault.

Vault is introduced when sensitive information needs to be securely managed.

---

## Lab Components

### 1. Vault EC2

A separate temporary EC2 instance was created specifically to run HashiCorp Vault.

Purpose:

* Run HashiCorp Vault
* Store secrets
* Configure policies
* Configure AppRole authentication
* Provide secrets to Terraform

### 2. Terraform EC2

A separate EC2 instance was created by Terraform to demonstrate how a value retrieved from Vault can be consumed during infrastructure provisioning.

---

# Vault Configuration

## 1. Install HashiCorp Vault

Vault was installed on an Ubuntu EC2 instance using the HashiCorp package repository.

Verify the installation:

```bash
vault version
```

---

## 2. Start Vault Development Server

For this learning lab, Vault was started in development mode:

```bash
vault server -dev -dev-listen-address="0.0.0.0:8200"
```

Development mode is suitable for learning and demonstrations.

Production Vault deployments require production-grade configuration, persistent storage, TLS, access controls, and appropriate operational practices.

---

## 3. Configure Vault CLI

Inside the Vault EC2:

```bash
export VAULT_ADDR="http://127.0.0.1:8200"
```

Verify Vault:

```bash
vault status
```

Expected:

```text
Initialized    true
Sealed         false
```

---

# KV v2 Secrets Engine

A KV v2 secrets engine was enabled at:

```text
kv/
```

Command:

```bash
vault secrets enable -path=kv kv-v2
```

---

## Create a Test Secret

A dummy secret was created for the lab:

```bash
vault kv put kv/test-secret \
  username="terraform-user" \
  password="demo-password-123"
```

Read the secret:

```bash
vault kv get kv/test-secret
```

Example structure:

```text
username = terraform-user
password = demo-password-123
```

> The values used in this lab are dummy values and are not production credentials.

---

# Vault Policy

A policy was created to allow Terraform to read secrets from the `kv` mount.

Example policy:

```hcl
# Allow Terraform to read secrets from the KV v2 mount
path "kv/data/*" {
  capabilities = ["read"]
}
```

Create the policy:

```bash
vault policy write terraform terraform-policy.hcl
```

Verify:

```bash
vault policy read terraform
```

The policy provides **read-only** access.

---

# AppRole Authentication

AppRole authentication was enabled for Terraform.

Enable AppRole:

```bash
vault auth enable approle
```

Create the Terraform AppRole:

```bash
vault write auth/approle/role/terraform \
  token_policies="terraform" \
  token_ttl=1h \
  token_max_ttl=4h
```

Retrieve the Role ID:

```bash
vault read auth/approle/role/terraform/role-id
```

Generate the Secret ID:

```bash
vault write -f auth/approle/role/terraform/secret-id
```

The Role ID and Secret ID are sensitive credentials and must never be committed to GitHub.

---

# Terraform Integration

Terraform uses the HashiCorp Vault provider to communicate with Vault.

Example:

```hcl
terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.0"
    }
  }
}

provider "vault" {
  # Vault server address
  address = "http://VAULT_SERVER_IP:8200"

  # Prevent Vault from creating a child token
  skip_child_token = true

  # Authenticate using AppRole
  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = var.vault_role_id
      secret_id = var.vault_secret_id
    }
  }
}
```

The actual Role ID and Secret ID are supplied through local variables and are not stored in Git.

---

# Terraform Variables

Example:

```hcl
variable "vault_role_id" {
  description = "Role ID for the Terraform AppRole in Vault"
  type        = string
  sensitive   = true
}

variable "vault_secret_id" {
  description = "Secret ID for the Terraform AppRole in Vault"
  type        = string
  sensitive   = true
}
```

Local `terraform.tfvars` contains the actual credentials.

Example structure:

```hcl
vault_role_id   = "YOUR_ROLE_ID"
vault_secret_id = "YOUR_SECRET_ID"
```

This file must not be committed to GitHub.

---

# Reading Secrets Using Terraform

Terraform uses a `data` block to retrieve an existing secret.

```hcl
data "vault_kv_secret_v2" "test_secret" {
  mount = "kv"
  name  = "test-secret"
}
```

### Important Terraform Concept

```text
resource → create/manage something

data     → read/retrieve something that already exists
```

In this lab, Terraform does not create the Vault secret.

The secret already exists in Vault, and Terraform retrieves it.

---

# Using the Vault Secret with AWS

The AWS provider is responsible for creating the EC2 instance.

Example:

```hcl
provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "vault_demo" {
  ami           = "AMI_ID"
  instance_type = "t3.micro"

  subnet_id = "SUBNET_ID"

  key_name = "KEY_PAIR_NAME"

  tags = {
    Name = "terraform-vault-demo"

    # Retrieve the username from Vault
    VaultUsername = data.vault_kv_secret_v2.test_secret.data["username"]
  }
}
```

The important flow is:

```text
Vault
  ↓
username = terraform-user
  ↓
Terraform Data Source
  ↓
data.vault_kv_secret_v2.test_secret.data["username"]
  ↓
AWS EC2 Resource
  ↓
VaultUsername = terraform-user
```

---

# What Actually Creates the EC2?

Vault does **not** create the EC2.

The AWS provider creates the EC2.

```text
Terraform
   │
   ├── Vault Provider
   │       ↓
   │   Retrieves Secret
   │
   └── AWS Provider
           ↓
       Creates EC2
```

Therefore:

```text
Terraform + AWS Provider
        ↓
      EC2
```

works without Vault.

Vault becomes useful when Terraform or an application needs securely managed sensitive information.

---

# Production Use Case

In a real production environment, Vault could store:

* Database passwords
* API keys
* Application credentials
* Certificates
* Private keys
* Tokens
* Other sensitive configuration

For example:

```text
Vault
└── production/database
    ├── username
    └── password
```

An authorized application can retrieve the required secret instead of hardcoding it in application configuration or Terraform code.

---

# Important Production Note

The EC2 tag used in this lab is only a simple demonstration of the secret flowing from Vault → Terraform → AWS.

Real production secrets such as passwords, API keys, and private keys should **not** be stored in EC2 tags.

The production goal is:

```text
Secure Secret Store
        ↓
Authentication
        ↓
Authorization
        ↓
Secret Retrieval
        ↓
Application / Infrastructure
```

---

# Terraform Commands

## Initialize

```bash
terraform init
```

## Format

```bash
terraform fmt
```

## Validate

```bash
terraform validate
```

## Create Plan

```bash
terraform plan
```

## Apply Infrastructure

```bash
terraform apply
```

## Destroy Infrastructure

```bash
terraform destroy
```

---

# Troubleshooting

## 1. Vault CLI Uses HTTPS Instead of HTTP

Error:

```text
server gave HTTP response to HTTPS client
```

Fix:

```bash
export VAULT_ADDR="http://127.0.0.1:8200"
```

---

## 2. Terraform Cannot Reach Vault

Test Vault connectivity:

```bash
curl -v --connect-timeout 5 \
  http://VAULT_SERVER_IP:8200/v1/sys/health
```

A healthy development Vault should return information indicating:

```text
initialized: true
sealed: false
```

Also verify that the AWS security group allows TCP port `8200` from the current client IP.

---

## 3. Public IP Changed

The Vault security group in this lab was restricted to the user's current public IP.

If the public IP changes, access to port `8200` can stop working.

Check the current public IP:

```bash
curl -s https://checkip.amazonaws.com
```

Then update the security-group rule if required.

---

## 4. Terraform State Lock

If Terraform reports:

```text
Error acquiring the state lock
```

First check whether another Terraform process is running:

```bash
ps -ef | grep '[t]erraform'
```

Do not disable state locking unnecessarily.

---

## 5. Vault Development Server Restart

This lab uses:

```bash
vault server -dev
```

Development mode is intended for learning and demonstrations.

Restarting the development server can reset the Vault state, including:

* Secrets
* Policies
* Authentication configuration
* AppRole configuration

Therefore, the lab configuration may need to be recreated after a restart.

---

# Security Considerations

Never commit:

```text
terraform.tfvars
terraform.tfstate
terraform.tfstate.backup
Role ID
Secret ID
Real passwords
API keys
Private keys
```

The project `.gitignore` excludes sensitive Terraform files.

Example:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
*.tfvars.json
crash.log
crash.*.log
```

The `.terraform.lock.hcl` file should be committed because it locks Terraform provider versions.

---

# Project Structure

```text
01-HashiCorp-Vault-Integration/
│
├── main.tf
├── variables.tf
├── README.md
├── .gitignore
└── .terraform.lock.hcl
```

Sensitive local files are intentionally excluded:

```text
terraform.tfvars
terraform.tfstate
terraform.tfstate.backup
.terraform/
```

---

# Key Learnings

1. HashiCorp Vault is a secret-management solution.
2. Vault does not provision AWS infrastructure.
3. Terraform can create EC2 instances without Vault.
4. Vault is useful when sensitive information needs secure management.
5. AppRole provides an authentication mechanism for Terraform.
6. Vault policies control what an authenticated client can access.
7. Terraform `data` blocks retrieve existing information.
8. Terraform `resource` blocks create/manage infrastructure.
9. The AWS provider creates the EC2 instance.
10. Secrets should not be hardcoded in Terraform configuration.
11. Sensitive Terraform files must not be committed to GitHub.
12. EC2 tags are not a secure place for production secrets.
13. Vault + Terraform provides a pattern for integrating secret management with infrastructure automation.

---

# Cleanup

After completing the lab:

```bash
terraform destroy
```

Stop or terminate the temporary Vault EC2 after the lab.

Remove temporary security-group rules created specifically for the Vault lab.

---

## Learning Reference

This project was completed as part of hands-on Terraform learning focused on HashiCorp Vault secrets management and Terraform integration.

```
