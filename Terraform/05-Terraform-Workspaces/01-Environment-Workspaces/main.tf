# Declare the Terraform providers required by this project
terraform {
  required_providers {
    # AWS provider used to create and manage AWS resources
    aws = {
      # Download the AWS provider from HashiCorp
      source = "hashicorp/aws"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  # AWS region used for this practical
  region = "eu-north-1"
}

# Create an EC2 instance for the active Terraform workspace
resource "aws_instance" "workspace_demo" {
  # Ubuntu AMI used for all environments
  ami = var.ami

  # Select the instance type based on the active workspace
  # Example: dev = t3.micro, stage = t3.small, prod = t3.small
  instance_type = lookup(
    var.instance_types,
    terraform.workspace,
    "t3.micro"
  )

  # Use the existing subnet from our AWS lab environment
  subnet_id = var.subnet_id

  # Use the existing AWS key pair
  key_name = var.key_name

  # Add tags that identify the Terraform workspace
  tags = {
    Name        = "terraform-workspace-${terraform.workspace}"
    Environment = terraform.workspace
  }
}