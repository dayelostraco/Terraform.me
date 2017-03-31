/* Security group for the web */
resource "aws_security_group" "web-https" {
  name_prefix = "${format("%s_%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"), replace(var.name, "_", "-"))}_"
  description = "Security group for web that allows web traffic from internet and SSH"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${format("%s_%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"), replace(var.name, "_", "-"))}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    created_by  = "terraform"
  }
}
