# Define the AWS provider required by Terraform.
# Tells Terraform which provider/plugin to use
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Configure the AWS region for this project.
provider "aws" {
  region = "eu-north-1"
}

# Secondary AWS provider for another region.
provider "aws" {
  alias  = "secondary"
  region = "us-east-1"
}