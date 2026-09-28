terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.0"
    }
  }
}

# ---------------------------------------------------------
# AWS Provider
# ---------------------------------------------------------

provider "aws" {
  region = "eu-north-1"
}

# ---------------------------------------------------------
# HashiCorp Vault Provider
# ---------------------------------------------------------

provider "vault" {
  # Vault is running in HTTP mode for this lab
  address = "http://51.20.134.53:8200"

  # Prevent Vault from creating a child token
  skip_child_token = true

  # Authenticate Terraform using Vault AppRole
  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = var.vault_role_id
      secret_id = var.vault_secret_id
    }
  }
}

# ---------------------------------------------------------
# Read Secret from Vault
# ---------------------------------------------------------

# Read the existing KV v2 secret from Vault.
# This does NOT create a secret.
data "vault_kv_secret_v2" "test_secret" {
  mount = "kv"
  name  = "test-secret"
}

# ---------------------------------------------------------
# AWS EC2 Instance
# ---------------------------------------------------------

# Create an EC2 instance and use the value retrieved
# from HashiCorp Vault as an EC2 tag.
resource "aws_instance" "vault_demo" {
  ami           = "ami-035c8a091035e710a"
  instance_type = "t3.micro"

  subnet_id = "subnet-06fd8657f4a7f6722"

  key_name = "test1234"

  tags = {
    Name = "terraform-vault-demo"

    # Value comes from HashiCorp Vault
    # rather than being hardcoded in Terraform.
    VaultUsername = data.vault_kv_secret_v2.test_secret.data["username"]
  }
}

# ---------------------------------------------------------
# Output
# ---------------------------------------------------------

output "instance_id" {
  description = "ID of the EC2 instance created using Terraform"
  value       = aws_instance.vault_demo.id
}

output "vault_username" {
  description = "Username retrieved from HashiCorp Vault"
  value       = data.vault_kv_secret_v2.test_secret.data["username"]
  sensitive   = true
}