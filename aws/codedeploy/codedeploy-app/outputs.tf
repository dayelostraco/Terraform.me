output "app_id" {
  value = "${aws_codedeploy_app.codedeploy-app.id}"
}

output "app_name" {
  value = "${aws_codedeploy_app.codedeploy-app.name}"
}

output "deployment_group_ids" {
  value = "${join(",", aws_codedeploy_deployment_group.codedeploy-deployment-group.*.id)}"
}

output "deployment_group_names" {
  value = "${join(",", aws_codedeploy_deployment_group.codedeploy-deployment-group.*.deployment_group_name)}"
}
