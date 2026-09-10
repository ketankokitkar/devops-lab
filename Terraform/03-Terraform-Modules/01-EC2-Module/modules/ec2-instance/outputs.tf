# Return the EC2 instance ID.
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

# Return the public IP of the EC2 instance.
output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}