variable "project" {}

variable "environment" {}

variable "service_role_arn" {}

variable "autoscaling_group_ids" {
  description = "AutoScaling Groups which match up 1-1 with the deployment modules"
}

variable "deployment_modules" {
  description = "The names of individual deployments. Ex: API, Notifications, Stripe"
}

variable "deployment_config_name" {
  default = "CodeDeployDefault.OneAtATime"
}
