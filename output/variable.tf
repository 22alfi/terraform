variable "ami_id" {

  description = "AMI ID for EC2 instance"

  type        = string

}
 
variable "instance_type" {

  description = "Type of EC2 instance"

  type        = string

  default     = "t2.micro"

}
 
variable "instance_name" {

  description = "Tag name for EC2"

  type        = string

}
 

