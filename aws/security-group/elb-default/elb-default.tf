/* Security group for the web */
resource "aws_security_group" "elb-default" {
  name_prefix = "${format("%s_%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"), replace(var.name, "_", "-"))}_"
  description = "ELB Security Group"
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

resource "aws_security_group_rule" "ingress-all" {
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.elb-default.id}"
  cidr_blocks       = "${var.ingress_cidr_blocks}"

  depends_on = ["aws_security_group.elb-default"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress-all-https" {
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.elb-default.id}"
  cidr_blocks       = "${var.ingress_cidr_blocks}"

  depends_on = ["aws_security_group.elb-default"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "instance-egress" {
  count = "${var.instance_security_groups_length}"

  type                     = "egress"
  from_port                = "${var.instance_listener_port}"
  to_port                  = "${var.instance_listener_port}"
  protocol                 = "${var.instance_listener_protocol}"
  security_group_id        = "${aws_security_group.elb-default.id}"
  source_security_group_id = "${element(var.instance_security_group_ids, count.index)}"

  depends_on = ["aws_security_group.elb-default"]

  lifecycle {
    create_before_destroy = true
  }
}
