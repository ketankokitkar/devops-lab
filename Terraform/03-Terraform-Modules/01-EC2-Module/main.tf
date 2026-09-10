# Call the reusable EC2 module.
module "ec2_instance" {
  source = "./modules/ec2-instance"

  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  name          = var.name
  environment   = var.environment
}