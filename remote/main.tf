provider "aws" {

  region = "ap-south-1"

}
 
# Create S3 bucket for remote state

resource "aws_s3_bucket" "terraform_state" {

  bucket = "alfida-terraform-state-2025"

  acl    = "private"
 
  versioning {

    enabled = true

  }
 
  tags = {

    Name = "Terraform State Bucket"

  }

}
 
resource "aws_instance" "web" {

  ami           = "ami-0d176f79571d18a8f"  

  instance_type = "t2.micro"
 
  tags = {

    Name = "WebServer"

  }

}
 
