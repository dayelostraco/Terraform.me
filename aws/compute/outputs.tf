output "elb_id" {
  value = "${module.load_balancer.id}"
}

output "elb_name" {
  value = "${module.load_balancer.name}"
}

output "elb_dns_name" {
  value = "${module.load_balancer.dns_name}"
}

output "lc_id" {
  value = "${module.launch_configuration.id}"
}

output "lc_name" {
  value = "${module.launch_configuration.name}"
}

output "asg_id" {
  value = "${module.asg.id}"
}

output "asg_name" {
  value = "${module.asg.name}"
}
