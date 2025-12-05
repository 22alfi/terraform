

terraform {

  backend "s3" {

    bucket         = "alfida-terraform-state-2025" # This will be created in main.tf

    key            = "ec2/terraform.tfstate"

    region         = "ap-south-1"

    
  }

}


