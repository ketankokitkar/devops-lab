# AMI for the EC2 instance.
variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

# EC2 instance size.
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

# Subnet for the EC2 instance.
variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

# AWS key pair for SSH access.
variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

# Name assigned to the EC2 instance.
variable "name" {
  description = "Name of the EC2 instance"
  type        = string
}

# Deployment environment.
variable "environment" {
  description = "Deployment environment"
  type        = string
}