output "hostname" {
  value = "${aws_db_instance.mysql.address}"
}

output "port" {
  value = "${aws_db_instance.mysql.port}"
}

output "endpoint" {
  value = "${aws_db_instance.mysql.endpoint}"
}

output "id" {
  value = "${aws_db_instance.mysql.id}"
}
