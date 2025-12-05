terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 5.0"

    }

  }

}
 
provider "aws" {

  region     = "ap-south-1"

}
 
# Resource → EC2 Instance

resource "aws_instance" "demo" {

  ami           = "ami-0d176f79571d18a8f"  # Ubuntu - Mumbai Region

  instance_type = "t2.micro"
 
  tags = {

    Name = "TerraformDemo-Alfida"

  }

}
