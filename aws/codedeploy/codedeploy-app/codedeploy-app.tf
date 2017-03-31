resource "aws_codedeploy_app" "codedeploy-app" {
  name = "${var.project}-${var.environment}"
}

resource "aws_codedeploy_deployment_group" "codedeploy-deployment-group" {
  count = "${length(split(",", var.deployment_modules))}"

  app_name              = "${aws_codedeploy_app.codedeploy-app.name}"
  deployment_group_name = "${element(split(",", var.deployment_modules), count.index)}"
  service_role_arn      = "${var.service_role_arn}"

  autoscaling_groups = ["${element(split(",", var.autoscaling_group_ids), count.index)}"]

  deployment_config_name = "${var.deployment_config_name}"

  /*trigger_configuration {
            trigger_events     = ["DeploymentFailure"]
            trigger_name       = "foo-trigger"
            trigger_target_arn = "foo-topic-arn"
          }*/
}
