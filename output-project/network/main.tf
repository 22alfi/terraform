provider "aws" {
  region = "ap-south-1"
}
 
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
 
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
   cidr_block = "10.0.1.0/24"
 map_public_ip_on_launch = true   # FIX → This enables auto public IP

}
 
resource "aws_instance" "web" {
  ami           = "ami-0d176f79571d18a8f"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
 associate_public_ip_address = true   # FIX → This forces a public IP

  tags = {
    Name = "network-ec2"
  }
}
