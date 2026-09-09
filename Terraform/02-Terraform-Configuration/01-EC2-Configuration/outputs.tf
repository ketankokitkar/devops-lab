# Display the EC2 instance ID.
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.terraform_ec2.id
}

# Display the public IP assigned to the EC2 instance.
# Return the number of characters in the environment name.
output "environment_name_length" {
  description = "Number of characters in the environment name"
  value       = length(var.environment)
}