output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
 
output "instance_private_ip" {
  value = aws_instance.web.private_ip
}
 
output "vpc_id" {
  value = aws_vpc.main.id
}
 
output "subnet_id" {
  value = aws_subnet.main.id
}
