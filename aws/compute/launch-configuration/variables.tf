variable "project" {}

variable "environment" {}

variable "region" {}

variable "name" {}

variable "ami_id" {}

variable "instance_type" {}

variable "ssh_key_name" {}

variable "security_group_ids" {
  type = "list"
}

variable "iam_instance_profile_name" {
  default = ""
}

variable "associate_public_ip" {
  default = "true"
}

variable "include_ruxit" {
  default = false
}
