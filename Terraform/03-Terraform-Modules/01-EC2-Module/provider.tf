# Define the AWS provider required by this project.
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Configure the AWS region for the module project.
provider "aws" {
  region = "eu-north-1"
}