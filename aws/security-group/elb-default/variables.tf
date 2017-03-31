variable "project" {}

variable "environment" {}

variable "name" {
  default = "web"
}

variable "vpc_id" {}

variable "instance_listener_port" {
  default = "80"
}

variable "instance_listener_protocol" {
  default = "TCP"
}

variable "instance_security_groups_length" {}

variable "instance_security_group_ids" {
  type = "list"
}

variable "ingress_cidr_blocks" {
  type    = "list"
  default = ["0.0.0.0/0"]
}
