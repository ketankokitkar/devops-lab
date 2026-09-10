# Create an EC2 instance as a reusable module.
resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}