resource "aws_elb" "load_balancer" {
  # Set count to 0 if ssl_certificate_arn is not passed in
  count = "${signum(length(trimspace(var.ssl_certificate_arn))) + 1 % 2}"

  #count = "${1 - var.ssl_enabled}"

  name                        = "${format("%s-%s-%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"), replace(var.name, "_", "-"))}"
  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 300
  subnets                     = ["${var.subnet_ids}"]
  security_groups             = ["${var.security_group_ids}"]
  internal                    = "${var.is_internal}"
  instances                   = ["${var.instance_ids}"]
  lifecycle {
    create_before_destroy = false
  }
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${coalesce(var.instance_http_listener_port, var.instance_http_listener_port_default)}"
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 30
    target              = "${var.health_check_target}"
  }
  tags {
    Name        = "${format("%s_%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"), replace(var.name, "_", "-"))}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    created_by  = "terraform"
  }
}

resource "aws_elb" "load_balancer_ssl" {
  count = "${signum(length(trimspace(var.ssl_certificate_arn)))}"

  #count = "${var.ssl_enabled}"

  name                        = "${format("%s-%s-%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"), replace(var.name, "_", "-"))}-ssl"
  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 300
  subnets                     = ["${var.subnet_ids}"]
  security_groups             = ["${var.security_group_ids}"]
  internal                    = "${var.is_internal}"
  instances                   = ["${var.instance_ids}"]
  lifecycle {
    create_before_destroy = false
  }
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${coalesce(var.instance_http_listener_port, var.instance_http_listener_port_default)}"
    instance_protocol = "http"
  }
  listener {
    lb_port            = 443
    lb_protocol        = "https"
    instance_port      = "${coalesce(var.instance_https_listener_port, var.instance_https_listener_port_default)}"
    instance_protocol  = "http"
    ssl_certificate_id = "${var.ssl_certificate_arn}"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 30
    target              = "${var.health_check_target}"
  }
  tags {
    Name        = "${format("%s_%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"), replace(var.name, "_", "-"))}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    created_by  = "terraform"
  }
}
