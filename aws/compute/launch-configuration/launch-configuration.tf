resource "aws_iam_instance_profile" "instance-profile" {
  name       = "${format("%s_%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"), replace(var.name, "_", "-"))}_InstanceRoleInstanceProfile"
  roles      = ["${aws_iam_role.role.name}"]
  depends_on = ["aws_iam_role.role"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "role" {
  name = "${format("%s_%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"), replace(var.name, "_", "-"))}_InstanceRole"
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

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "s3-readonly-policy" {
  name = "AmazonS3ReadOnlyAccess"
  role = "${aws_iam_role.role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
        "s3:List*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "bootstrap-template" {
  template = "${file("${path.module}/scripts/bootstrap.tpl")}"

  vars {
    include_ruxit = "${var.include_ruxit}"
  }
}

data "template_file" "codedeploy-template" {
  template = "${file("${path.module}/scripts/codedeploy-agent.tpl")}"

  vars {
    region = "${var.region}"
  }
}

data "template_cloudinit_config" "web" {
  # Make both turned off until https://github.com/hashicorp/terraform/issues/4794 is fixed
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.bootstrap-template.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.codedeploy-template.rendered}"
  }
}

resource "aws_launch_configuration" "launch_configuration" {
  name_prefix                 = "${format("%s_%s_%s", replace(var.project, "_", "-"), replace(var.environment, "_", "-"), replace(var.name, "_", "-"))}_"
  image_id                    = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = "${var.associate_public_ip}"
  key_name                    = "${var.ssh_key_name}"
  security_groups             = ["${var.security_group_ids}"]

  #iam_instance_profile        = "${var.iam_instance_profile_name}"
  iam_instance_profile = "${aws_iam_instance_profile.instance-profile.name}"
  user_data            = "${data.template_cloudinit_config.web.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}
