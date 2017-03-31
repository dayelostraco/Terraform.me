output "service_role_arn" {
  value = "${aws_iam_role.codedeploy-service-role.arn}"
}

output "codedeploy_deployer_role_arn" {
  value = "${aws_iam_role.codedeploy-role.arn}"
}
