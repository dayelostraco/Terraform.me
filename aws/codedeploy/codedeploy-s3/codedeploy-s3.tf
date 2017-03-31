# S3 Bucket for codedeploy artifacts
module "codedeploy-bucket" {
  source = "git::ssh://git@terraform-automation/qonceptual/terraform-modules//aws/storage/s3"

  project            = "${var.project}"
  environment        = "${var.environment}"
  bucket_name        = "${coalesce(var.bucket_name_override, format("%s.%s.codedeploy", replace(lower(var.project), "/[^a-z0-9-.]/", "-"), replace(lower(var.environment), "/[^a-z0-9-.]/", "-")))}"
  versioning_enabled = "true"
  policy             = "${var.policy_override}"
}
