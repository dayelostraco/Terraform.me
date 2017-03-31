/* Security group for the web */
resource "aws_security_group" "web-default" {
  name_prefix = "${format("%s_%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"), replace(var.name, "_", "-"))}_"
  description = "Security group for Web instance behind an ELB"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s_%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"), replace(var.name, "_", "-"))}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    created_by  = "terraform"
  }
}

resource "aws_security_group_rule" "elb-ingress" {
  type      = "ingress"
  from_port = "${var.instance_listener_port}"
  to_port   = "${var.instance_listener_port}"
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.web-default.id}"
  source_security_group_id = "${var.elb_security_group_id}"

  depends_on = ["aws_security_group.web-default"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "qonceptual-web-ingress" {
  type        = "ingress"
  from_port   = "${var.instance_listener_port}"
  to_port     = "${var.instance_listener_port}"
  protocol    = "tcp"
  cidr_blocks = ["73.131.165.218/32"]

  security_group_id = "${aws_security_group.web-default.id}"

  depends_on = ["aws_security_group.web-default"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "qonceptual-ssh-ingress" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["73.131.165.218/32"]

  security_group_id = "${aws_security_group.web-default.id}"

  depends_on = ["aws_security_group.web-default"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "all-egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.web-default.id}"

  depends_on = ["aws_security_group.web-default"]

  lifecycle {
    create_before_destroy = true
  }
}
