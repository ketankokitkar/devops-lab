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
  # AWS region where the EC2 instance will be created
  region = "eu-north-1"
}

# Create an EC2 instance for the Terraform State practical
resource "aws_instance" "state_demo" {
  # Ubuntu AMI used for this lab
  ami = "ami-035c8a091035e710a"

  # EC2 instance type used for the lab
  instance_type = "t3.micro"

  # Subnet where the EC2 instance will be created
  subnet_id = "subnet-06fd8657f4a7f6722"

  # Existing AWS key pair used for SSH access
  key_name = "test1234"

  # Add a meaningful name tag to identify the instance
  tags = {
    Name = "terraform-state-demo"
  }
}