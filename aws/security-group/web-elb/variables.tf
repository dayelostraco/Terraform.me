variable "project" {}

variable "environment" {}

variable "name" {
  default = "web"
}

variable "vpc_id" {}

variable "elb_security_group_id" {}

variable "instance_listener_port" {
  default = "80"
}
