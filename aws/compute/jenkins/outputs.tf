output "instance_id" {
  value = "${aws_instance.jenkins.id}"
}

output "instance_public_dns" {
  value = "${aws_instance.jenkins.public_dns}"
}

output "instance_public_ip" {
  value = "${aws_instance.jenkins.public_ip}"
}

output "iam_role_arn" {
  value = "${aws_iam_role.jenkins.arn}"
}

output "iam_role_id" {
  value = "${aws_iam_role.jenkins.id}"
}

output "iam_role_unique_id" {
  value = "${aws_iam_role.jenkins.unique_id}"
}
