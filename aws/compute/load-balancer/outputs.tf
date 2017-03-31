output "name" {
  value = ["${concat(aws_elb.load_balancer.*.name, aws_elb.load_balancer_ssl.*.name)}"]
}

output "id" {
  value = ["${concat(aws_elb.load_balancer.*.id,aws_elb.load_balancer_ssl.*.id)}"]
}

output "dns_name" {
  value = ["${concat(aws_elb.load_balancer.*.dns_name,aws_elb.load_balancer_ssl.*.dns_name)}"]
}

/*output "name" {
  value = ["${concat(aws_elb.load_balancer_ssl.*.name)}"]
}

output "id" {
  value = ["${concat(aws_elb.load_balancer_ssl.*.id)}"]
}

output "dns_name" {
  value = ["${concat(aws_elb.load_balancer_ssl.*.dns_name)}"]
}*/

