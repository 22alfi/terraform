terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Generate SSH key pair
resource "tls_private_key" "demo_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create AWS key pair
resource "aws_key_pair" "demo" {
  key_name   = "demo-key"
  public_key = tls_private_key.demo_key.public_key_openssh
}

# Optional: save private key locally
resource "local_file" "private_key" {
  content        = tls_private_key.demo_key.private_key_pem
  filename       = "${path.module}/demo-key.pem"
  file_permission = "0600"
}

# Security group for SSH and HTTP
resource "aws_security_group" "ssh_http" {
  name        = "allow-ssh-http"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = "ami-02b8269d5e85954ef"  # Ubuntu 22.04 in ap-south-1
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.demo.key_name
  vpc_security_group_ids = [aws_security_group.ssh_http.id]

  tags = {
    Name = "file-transfer"
  }

  provisioner "file" {
    source      = "/home/ubuntu/terraform/copy/message.txt"
    destination = "/home/ubuntu/message.txt"

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = tls_private_key.demo_key.private_key_pem
      timeout     = "5m"
    }
  }
}

# Output public IP
output "web_public_ip" {
  value = aws_instance.web.public_ip
}
