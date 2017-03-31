variable "project" {}

variable "environment" {}

variable "name" {
  default = "default-lb"
}

variable "subnet_ids" {
  type = "list"
}

variable "security_group_ids" {
  type = "list"
}

#variable "ssl_enabled" {}

variable "ssl_certificate_arn" {
  default = ""
}

variable "is_internal" {}

variable "health_check_target" {
  default = "TCP:80"
}

variable "instance_http_listener_port" {
  default = ""
}

variable "instance_http_listener_port_default" {
  default = "80"
}

variable "instance_https_listener_port" {
  default = ""
}

variable "instance_https_listener_port_default" {
  default = "80"
}

variable "instance_ids" {
  type    = "list"
  default = []
}
