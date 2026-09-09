# Create an EC2 instance using input variables.
resource "aws_instance" "terraform_ec2" {
  ami = var.ami
  # Select instance size based on the environment.
  instance_type = var.environment == "prod" ? "t3.small" : var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  # used Built-in functions lower() and length()
  tags = {
    Name        = "terraform-EC2-config-${lower(var.environment)}"
    Environment = lower(var.environment)
  }
}