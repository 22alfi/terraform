provider "aws" {
  region = "ap-south-1"
}
module "dev_server" {
  source        = "./modules/ec2"
  ami           = var.ami
  instance_type = "t2.micro"
  name          = "dev-ec2"
  environment   = "dev"
}
module "test_server" {
  source        = "./modules/ec2"
  ami           = var.ami
  instance_type = "t2.micro"
  name          = "test-ec2"
  environment   = "test"
}
module "prod_server" {
  source        = "./modules/ec2"
  ami           = var.ami
  instance_type = "t2.medium" # bigger instance for production
  name          = "prod-ec2"
  environment   = "prod"
}
output "dev_public_ip"  { value = module.dev_server.public_ip }

output "test_public_ip" { value = module.test_server.public_ip }

output "prod_public_ip" { value = module.prod_server.public_ip }
 
