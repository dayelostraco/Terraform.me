module "jenkins-sg" {
  source = "git::ssh://git@terraform-automation/qonceptual/terraform-modules//aws/security-group/web-default"

  project     = "${var.project}"
  environment = "${var.environment}"
  name        = "${var.name}"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_iam_instance_profile" "jenkins" {
  name  = "${var.project}_${var.environment}_${var.name}_instance_profile"
  roles = ["${aws_iam_role.jenkins.name}"]
}

resource "aws_iam_policy_attachment" "jenkins-role-AWSCodeCommitReadOnly-attach" {
  name       = "${aws_iam_role.jenkins.name}_managed_policies"
  roles      = ["${aws_iam_role.jenkins.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}

resource "aws_iam_policy_attachment" "jenkins-role-AWSCodeCommitPowerUser-attach" {
  name       = "${aws_iam_role.jenkins.name}_managed_policies"
  roles      = ["${aws_iam_role.jenkins.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

resource "aws_iam_role" "jenkins" {
  name = "${var.project}_${var.environment}_jenkins"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      }
    }
  ]
}
EOF
}

resource "template_file" "nginx" {
  template = "${file("${path.module}/scripts/nginx.sh.tpl")}"

  vars {
    nginx_conf = "${file("${path.module}/scripts/nginx.conf")}"
  }
}

resource "template_cloudinit_config" "web" {
  # Make both turned off until https://github.com/hashicorp/terraform/issues/4794 is fixed
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = "${file("${path.module}/scripts/bootstrap.sh")}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${template_file.nginx.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${file("${path.module}/scripts/jenkins.sh")}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "jenkins" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  iam_instance_profile   = "${aws_iam_instance_profile.jenkins.name}"
  key_name               = "${var.ssh_key_name}"
  subnet_id              = "${element(split(",", var.subnet_ids), 0)}"
  vpc_security_group_ids = ["${module.jenkins-sg.id}"]

  user_data = "${template_cloudinit_config.web.rendered}"

  root_block_device {
    volume_size = "${var.root_block_volume_size}"
  }

  tags {
    Name        = "${coalesce(var.instance_name_override, format("%s_%s_jenkins", var.project, var.environment))}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    created_by  = "terraform"
  }

  lifecycle {
    prevent_destroy = true
  }
}
