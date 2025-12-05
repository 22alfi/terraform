variable "instance_name" {

  type        = string

  description = "EC2 instance name"

}
 
variable "instance_type" {

  type        = string

  description = "EC2 instance type"

  default     = "t2.micro"

}
 
variable "ami_id" {

  type        = string

  description = "AMI ID to use"

}
 
