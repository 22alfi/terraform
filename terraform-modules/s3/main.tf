provider "aws" {
  region = "ap-south-1"
}

module "dev_server" {
 source        = "/home/ubuntu/terraform/terraform-module/modules/s3"
 bucket_name          = "dev-server-alfi-bucket"
}

module "dev_test" {
 source        = "/home/ubuntu/terraform/terraform-module/modules/s3"
bucket_name          = "dev-test-alfi-bucket"
}

module "dev_prod" {
 source        = "/home/ubuntu/terraform/terraform-module/modules/s3"
 bucket_name          = "dev-prod-alfi-bucket"
}


output "dev_bucket_name" {
  value = module.dev_server.bucket_name
}

output "test_bucket_name" {
  value = module.dev_test.bucket_name
}

output "prod_bucket_name" {
  value = module.dev_prod.bucket_name
}
