# AMI used to launch the EC2 instance.
variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

# EC2 instance size.
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

# Subnet where the EC2 instance will be created.
variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

# AWS key pair name used for SSH access.
variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

# Deployment environment such as dev or prod.
variable "environment" {
  description = "Deployment environment"
  type        = string
}