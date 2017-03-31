variable "project" {}

variable "environment" {}

variable "vpc_id" {}

variable "vpc_cidr_block" {}

variable "allocated_storage" {
  default = "20"
}

variable "engine_version" {
  default = ""
}

variable "instance_type" {
  default = "db.t2.micro"
}

variable "storage_type" {
  default = "gp2"
}

variable "database_name" {}

variable "database_password" {}

variable "database_username" {}

variable "existing_parameter_group_name" {
  default = ""
}

variable "create_db_parameter_group" {
  default = true
}

variable "publicly_accessible" {
  default = "false"
}

variable "backup_retention_period" {
  default = "30"
}

variable "backup_window" {
  # 12:00AM-12:30AM ET
  default = "04:00-04:30"
}

variable "maintenance_window" {
  # SUN 12:30AM-01:30AM ET
  default = "sun:04:30-sun:05:30"
}

variable "auto_minor_version_upgrade" {
  default = true
}

variable "multi_availability_zone" {
  default = false
}

variable "storage_encrypted" {
  default = false
}

variable "subnet_ids" {
  type = "list"
}

variable "parameter_group_family" {
  default = "mysql5.7"
}

variable "alarm_actions" {}

variable "apply_immediately" {
  default = false
}
