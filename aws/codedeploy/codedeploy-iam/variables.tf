variable "project" {}

variable "environment" {}

variable "deployer_account_id" {}

variable "codedeploy_s3_bucket_arn" {}

variable "jenkins_iam_role_count" {
  default = 0
}

variable "jenkins_iam_role_id" {
  default = ""
}

variable "external_codedeploy_deployer_role_arns" {
  default = ""
}
