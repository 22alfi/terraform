variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "ami" {
  default = "ami-0d176f79571d18a8f"  # Ubuntu 22.04 in ap-south-1
}
