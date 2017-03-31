# S3 Bucket for codedeploy artifacts
resource "aws_s3_bucket" "bucket" {
  bucket = "${replace(lower(var.bucket_name), "/[^a-z0-9-.]/", "-")}"

  policy = "${var.policy}"

  versioning {
    enabled = "${var.versioning_enabled}"
  }

  force_destroy = true

  tags {
    Project     = "${var.project}"
    Environment = "${var.environment}"
    created_by  = "terraform"
  }
}
