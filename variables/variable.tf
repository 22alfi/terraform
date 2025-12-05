variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
 
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}
 
variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}
