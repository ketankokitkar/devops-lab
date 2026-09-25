# AMI used for the EC2 instance
variable "ami" {
  description = "Ubuntu AMI used for the EC2 instance"
  type        = string
}

# Subnet where the EC2 instance will be created
variable "subnet_id" {
  description = "AWS subnet ID for the EC2 instance"
  type        = string
}

# Existing AWS key pair used for the EC2 instance
variable "key_name" {
  description = "AWS key pair name"
  type        = string
}

# EC2 instance types mapped to Terraform workspaces
variable "instance_types" {
  description = "EC2 instance type for each Terraform workspace"
  type        = map(string)

  # Define the instance type for each environment
  default = {
    dev   = "t3.micro"
    stage = "t3.small"
    prod  = "t3.small"
  }
}