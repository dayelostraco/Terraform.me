variable "project" {}

variable "environment" {}

variable "name" {}

variable "region" {}

variable "ami_id" {}

variable "instance_type" {}

variable "min_instance_count" {
  default = "1"
}

variable "max_instance_count" {
  default = "1"
}

variable "desired_instance_count" {
  default = "1"
}

variable "ssh_key_name" {}

variable "vpc_id" {}

variable "subnet_ids" {
  type = "list"
}

variable "lb_security_group_ids" {
  type = "list"
}

variable "lb_is_internal" {
  description = "If true, ELB will be an internal ELB"
}

variable "instance_security_group_ids" {
  type = "list"
}

variable "instance_http_listener_port" {
  default = ""
}

variable "instance_https_listener_port" {
  default = ""
}

variable "health_check_target" {
  default = "TCP:80"
}

variable "asg_health_check_grace_period" {
  default = "300"
}

variable "ssl_certificate_arn" {
  default = ""
}

variable "include_ruxit" {
  default = false
}
