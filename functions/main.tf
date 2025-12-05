variable "servers_string" {
  default = "web1,web2,web3"
}

variable "server_ips" {
  default = {
    web1 = "10.0.0.1"
    web2 = "10.0.0.2"
    web3 = "10.0.0.3"
  }
}

variable "project_name" {
  default = "myapp"
}

variable "env" {
  default = "dev"
}

locals {
  servers_list = split(",", var.servers_string)
  servers_csv  = join(" | ", local.servers_list)
}

output "servers_list" {
  value = local.servers_list
}

output "servers_csv" {
  value = local.servers_csv
}

output "web2_ip" {
  value = lookup(var.server_ips, "web2", "Not Found")
}

output "web4_ip" {
  value = lookup(var.server_ips, "web4", "Not Found")
}

output "number_of_servers" {
  value = length(local.servers_list)
}

output "bucket_name" {
  value = format("%s-%s-bucket", var.project_name, var.env)
}
