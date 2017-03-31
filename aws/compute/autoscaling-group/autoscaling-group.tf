resource "aws_autoscaling_group" "asg" {
  name                      = "${format("%s_%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"), replace(var.name, "_", "-"))}"
  vpc_zone_identifier       = ["${var.subnet_ids}"]
  max_size                  = "${var.max_instance_count}"
  min_size                  = "${var.min_instance_count}"
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"
  desired_capacity          = "${var.desired_instance_count}"
  force_delete              = false
  launch_configuration      = "${var.launch_configuration_name}"
  load_balancers            = ["${var.load_balancers}"]

  tag {
    key                 = "Name"
    value               = "${format("%s_%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"), replace(var.name, "_", "-"))}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "${var.project}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "created_by"
    value               = "terraform"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
