# Configure AWS as the cloud provider
provider "aws" {
  # AWS region where resources will be created
  region = "eu-north-1"
}

# Create an EC2 instance
resource "aws_instance" "terraform_ec2" {

  # Ubuntu AMI to use for the instance
  ami = "ami-035c8a091035e710a"

  # EC2 instance size
  instance_type = "t3.micro"

  # Subnet where the instance will be created
  subnet_id = "subnet-06fd8657f4a7f6722"

  # AWS key pair used for SSH access
  # This is the key-pair name, not the .pem file path
  key_name = "test1234"

  # Name tag for the EC2 instance
  tags = {
    Name = "terraform-ec2-instance-creation"
  }
}