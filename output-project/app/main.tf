provider "aws" {
  region = "ap-south-1"
}
 
# Read state from network folder
data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "../network/terraform.tfstate"
  }
}
 
# Create a security group that allows SSH only from the EC2 instance created in network/
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow SSH only from network EC2"
 
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${data.terraform_remote_state.network.outputs.instance_public_ip}/32"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
