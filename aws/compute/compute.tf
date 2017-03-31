module "load_balancer" {
  source = "./load-balancer"

  project                      = "${var.project}"
  environment                  = "${var.environment}"
  name                         = "${var.name}"
  subnet_ids                   = "${var.subnet_ids}"
  security_group_ids           = "${var.lb_security_group_ids}"
  is_internal                  = "${var.lb_is_internal}"
  health_check_target          = "${var.health_check_target}"
  ssl_certificate_arn          = "${var.ssl_certificate_arn}"
  instance_http_listener_port  = "${var.instance_http_listener_port}"
  instance_https_listener_port = "${var.instance_https_listener_port}"
}

module "launch_configuration" {
  source = "./launch-configuration"

  project            = "${var.project}"
  environment        = "${var.environment}"
  name               = "${var.name}"
  region             = "${var.region}"
  instance_type      = "${var.instance_type}"
  ami_id             = "${var.ami_id}"
  ssh_key_name       = "${var.ssh_key_name}"
  security_group_ids = ["${var.instance_security_group_ids}"]
  include_ruxit      = "${var.include_ruxit}"
}

module "asg" {
  source = "./autoscaling-group"

  project                   = "${var.project}"
  environment               = "${var.environment}"
  name                      = "${var.name}"
  subnet_ids                = "${var.subnet_ids}"
  max_instance_count        = "${var.max_instance_count}"
  min_instance_count        = "${var.min_instance_count}"
  desired_instance_count    = "${var.desired_instance_count}"
  launch_configuration_name = "${module.launch_configuration.name}"
  load_balancers            = ["${module.load_balancer.name}"]
  health_check_type         = "ELB"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
}
