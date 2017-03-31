variable "project" {}

variable "environment" {}

variable "name" {
  default = "jenkins"
}

variable "vpc_id" {}

variable "subnet_ids" {}

variable "ami" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "ssh_key_name" {}

variable "instance_name_override" {
  default = ""
}

variable "root_block_volume_size" {
  description = "Size in gigabytes"
  default     = ""
}
