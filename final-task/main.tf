	terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
    tls = { source = "hashicorp/tls" }
    local = { source = "hashicorp/local" }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

# Generate SSH key
resource "tls_private_key" "k8s_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "k8s_key" {
  key_name   = "k8s-key"
  public_key = tls_private_key.k8s_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.k8s_key.private_key_pem
  filename        = "${path.module}/k8s-key.pem"
  file_permission = "0600"
}

# Security group for SSH and Kubernetes API
resource "aws_security_group" "k8s_sg" {
  name   = "k8s_sg-new"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
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

# Master node
resource "aws_instance" "master" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.k8s_key.key_name
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  associate_public_ip_address = true
  tags = { Name = "k8s-master" }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apt-transport-https ca-certificates curl
              curl -fsSL https://get.docker.com | bash
              systemctl enable docker
              systemctl start docker
              curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
              cat <<EOT >/etc/apt/sources.list.d/kubernetes.list
              deb https://apt.kubernetes.io/ kubernetes-xenial main
              EOT
              apt-get update -y
              apt-get install -y kubelet kubeadm kubectl
              apt-mark hold kubelet kubeadm kubectl
              swapoff -a
              sed -i '/ swap / s/^/#/' /etc/fstab
              kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$(hostname -I | awk '{print $1}')
              mkdir -p /home/ubuntu/.kube
              cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
              chown ubuntu:ubuntu /home/ubuntu/.kube/config
              su - ubuntu -c "kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml"
              EOF
}

# Worker node
resource "aws_instance" "worker" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.k8s_key.key_name
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  associate_public_ip_address = true
  tags = { Name = "k8s-worker" }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apt-transport-https ca-certificates curl
              curl -fsSL https://get.docker.com | bash
              systemctl enable docker
              systemctl start docker
              curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
              cat <<EOT >/etc/apt/sources.list.d/kubernetes.list
              deb https://apt.kubernetes.io/ kubernetes-xenial main
              EOT
              apt-get update -y
              apt-get install -y kubelet kubeadm kubectl
              apt-mark hold kubelet kubeadm kubectl
              swapoff -a
              sed -i '/ swap / s/^/#/' /etc/fstab
              EOF
}
