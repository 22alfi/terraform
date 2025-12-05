output "public_ip" {
  description = "Public IP of EC2"
  value       = aws_instance.demo.public_ip
}
 
output "instance_id" {
  description = "The ID of the created instance"
  value       = aws_instance.demo.id
}
