variable "project" {}

variable "environment" {}

variable "name" {
  default = "asg"
}

variable "subnet_ids" {
  type = "list"
}

variable "max_instance_count" {
  default = "1"
}

variable "min_instance_count" {
  default = "1"
}

variable "desired_instance_count" {
  default = "1"
}

variable "health_check_grace_period" {
  default = "300"
}

variable "health_check_type" {
  default = "EC2"
}

variable "launch_configuration_name" {}

variable "load_balancers" {
  type    = "list"
  default = []
}
